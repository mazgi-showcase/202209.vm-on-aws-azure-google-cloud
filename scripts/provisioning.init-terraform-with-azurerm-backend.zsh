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

readonly RESOURCE_GROUP_FOR_PROVISIONING="rg-${PROJECT_UNIQUE_ID}-provisioning"
readonly STORAGE_ACCOUNT_FOR_PROVISIONING="$(echo ${PROJECT_UNIQUE_ID} | tr --complement --delete '0-9a-z' | cut -c-24)"
readonly CONTAINER_NAME_FOR_PROVISIONING="provisioning"

# Auth Azure with Service Principal
az login --service-principal\
 --username ${ARM_CLIENT_ID}\
 --password "${ARM_CLIENT_SECRET}"\
 --tenant ${ARM_TENANT_ID}\
 --output none
az account set\
 --subscription ${ARM_SUBSCRIPTION_ID}
az account list\
 --query "[?isDefault]"

# Create the 
az group create\
 --name ${RESOURCE_GROUP_FOR_PROVISIONING}\
 --location "${AZURE_DEFAULT_LOCATION}"

az storage account create\
 --name ${STORAGE_ACCOUNT_FOR_PROVISIONING}\
 --resource-group ${RESOURCE_GROUP_FOR_PROVISIONING}

az storage account blob-service-properties update\
 --resource-group ${RESOURCE_GROUP_FOR_PROVISIONING}\
 --account-name ${STORAGE_ACCOUNT_FOR_PROVISIONING}\
 --enable-versioning true

az storage container create\
 --name ${CONTAINER_NAME_FOR_PROVISIONING}\
 --account-name ${STORAGE_ACCOUNT_FOR_PROVISIONING}\
 --auth-mode login

# Detect terraform version
rm -f .terraform-version
sudo tfenv install min-required
sudo tfenv use min-required
terraform version -json | jq -r '.terraform_version' | tee -a /tmp/.terraform-version
mv /tmp/.terraform-version .
# Init terraform
mkdir -p ${TF_DATA_DIR}
sudo chmod a+rwx ${TF_DATA_DIR}
terraform init\
 -backend-config="resource_group_name=${RESOURCE_GROUP_FOR_PROVISIONING}"\
 -backend-config="storage_account_name=${STORAGE_ACCOUNT_FOR_PROVISIONING}"
