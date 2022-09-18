#!/usr/bin/env -S zsh -eu
setopt extended_glob

# see: http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#index-funcstack
if [[ ${#funcstack[@]} -ne 0 ]]; then
  echo 'the script is being sourced.'
  echo "please run it is as a subshell such as \"sh $0\""
  return 0
fi

if [[ ! -v PROJECT_UNIQUE_ID ]]; then
  echo 'the $PROJECT_UNIQUE_ID variable is not set.'
  echo 'it was canceled.'
  exit 0
fi

termColorClear='\033[0m'
termColorWarn='\033[1;33m'
echoWarn() {
    echo -e "${termColorWarn}$1${termColorClear}"
}

readonly TFSTATE_BACKEND_TYPE=$(echo $0 | sed -e 's/.*init-terraform-with-\([a-z0-9]*\)-backend\.zsh$/\1/')
for unnecessary_tf in $(ls -1 backend.*.tf~*${TFSTATE_BACKEND_TYPE}*)
do
  echoWarn "WARN: The backend config ${unnecessary_tf} will be renamed to disable."
  echoWarn "$(mv --verbose ${unnecessary_tf}{,.disabled.txt})"
done

readonly BUCKET_NAME_FOR_PROVISIONING="${PROJECT_UNIQUE_ID}-provisioning"

# Create the S3 bucket to save tfstate
aws s3 mb s3://${BUCKET_NAME_FOR_PROVISIONING}
aws s3api put-public-access-block\
 --bucket ${BUCKET_NAME_FOR_PROVISIONING}\
 --public-access-block-configuration 'BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true' 
aws s3api get-public-access-block\
 --bucket ${BUCKET_NAME_FOR_PROVISIONING}
aws s3api put-bucket-versioning\
 --bucket ${BUCKET_NAME_FOR_PROVISIONING}\
 --versioning-configuration Status=Enabled
aws s3api get-bucket-versioning\
 --bucket ${BUCKET_NAME_FOR_PROVISIONING}

# Detect terraform version
rm -f .terraform-version
sudo tfenv install min-required
sudo tfenv use min-required
terraform version -json | jq -r '.terraform_version' | tee -a /tmp/.terraform-version
mv /tmp/.terraform-version .
# Init terraform
mkdir -p ${TF_DATA_DIR}
sudo chmod a+rwx ${TF_DATA_DIR}
echoWarn 'WARN: The s3 backend currently does not support state locking!'
echoWarn 'Please read https://www.terraform.io/language/settings/backends/s3 and https://github.com/hashicorp/terraform/issues/27070'
terraform init -backend-config="bucket=${BUCKET_NAME_FOR_PROVISIONING}"
