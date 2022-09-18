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

echoWarn "\"$(basename $0)\" is the dummy script. You are able to remove this if you don't want to use Terraform."
