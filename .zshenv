export _ZO_DOCTOR=0

source "/Users/mrtrom/.rover/env"
. "$HOME/.cargo/env"

alias assume=". assume"

# Open AWS console in a new tab in the current Chrome Canary window
console() {
  local url
  url=$(assume "$1" --console --url 2>/dev/null | grep -o 'https://[^ ]*')
  if [[ -n "$url" ]]; then
    open -a "Google Chrome Canary" "$url"
  else
    assume "$@" --console
  fi
}
