sso() {
  local profile
  if (( $# == 0 )); then
    profile="sso"
  elif (( $# > 1 )); then
    echo "usage: sso [prod-customer | stg-customer | profile]" >&2; return 1
  elif [[ $1 =~ ^(prod|stg)-(.+)$ ]]; then
    profile="wh-${match[1]}-${match[2]}-owner"
  else
    profile="$1"   # passthrough
  fi

  # Device-code flow when there's no local browser (SSH or headless Linux).
  # Override with SSO_DEVICE_CODE=1 (force) or SSO_DEVICE_CODE=0 (never).
  local -a flags=()
  if [[ ${SSO_DEVICE_CODE:-auto} == 1 ]]; then
    flags=(--use-device-code)
  elif [[ ${SSO_DEVICE_CODE:-auto} == auto ]]; then
    if [[ -n $SSH_CONNECTION || -n $SSH_TTY ]] \
       || [[ $OSTYPE == linux* && -z $DISPLAY && -z $WAYLAND_DISPLAY ]]; then
      flags=(--use-device-code)
    fi
  fi

  echo "→ aws sso login --profile $profile ${flags[*]}"
  aws sso login --profile "$profile" "${flags[@]}"
}

_sso() {
  local -a targets
  targets=( ${(f)"$(aws configure list-profiles 2>/dev/null | sed -E 's/^wh-(stg|prod)-(.+)-owner$/\1-\2/')"} )
  _describe 'profile' targets
}
(( $+functions[compdef] )) && compdef _sso sso
