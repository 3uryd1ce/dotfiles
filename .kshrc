# shellcheck disable=SC2034,SC1090
[ -r  "${HOME}/.local/bin/common.sh" ] \
  && . "${HOME}/.local/bin/common.sh"

# pywal
import_colors

# if tmux is installed and not inside a tmux session, then try to attach.
# if attachment fails, start a new session
command -v tmux >/dev/null 2>&1 \
  && [ -z "${TMUX}" ] \
  && (tmux attach || tmux) >/dev/null 2>&1

# ksh options
set -o vi vi-esccomplete

# ${KSH_VERSION} is read-only, so echo is safe
echo "${KSH_VERSION}" \
  | grep -qi 'pd' \
  && set -o vi-show8

for srcfile in aliases functions prompt vars; do
  [ -r "${HOME}/.config/ksh/${srcfile}" ] \
    && . "${HOME}/.config/ksh/${srcfile}"
done
