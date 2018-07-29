#!/bin/bash

# Usage: bash_cat <file>
# Usage: command | bash_cat
bash_cat () {
  local _fname=${1:-/dev/stdin}
  printf "%s" "$(<"${_fname}")"
}

# Usage: bash_seq N M
bash_seq () {
  eval "printf \"%d\\n\" {$1..$2}"
}

# Usage: bash_touch filename
bash_touch () {
  :>>"$1"
}

# Usage: bash_head N filename
bash_head () {
  local _num=${1:-10} ; shift
  local _fname=${1:-/dev/stdin}
  local i=0
  while read -r line ; do
    i=$(( i + 1 ))
    printf "%s\\n" "${line}"
    if [[ "$_num" == "$i" ]];then
      return 0
    fi
  done < "$_fname"
}

# Usage: bash_tail N filename
bash_tail () {
  local _fname=${1:-/dev/stdin}
}

# Usage: echo <hext string> | bash_xxd_r
# Alternative of `xxd -r`
bash_xxd_r() {
  read -r _key
  local _pat='..'
  while [[ $_key =~ $_pat ]]; do
    # shellcheck disable=SC2059
    printf "\\x${BASH_REMATCH[0]}"
    _key="${_key#${BASH_REMATCH[0]}}"
  done
}

# [URL] https://github.com/dylanaraps/pure-bash-bible#get-the-directory-name-of-a-file-path
bash_dirname() {
  printf '%s\n' "${1%/*}/"
}

# Usage: basename "path"
# [URL] https://github.com/dylanaraps/pure-bash-bible#get-the-base-name-of-a-file-path
bash_basename() {
  : "${1%/}"
  printf '%s\n' "${_##*/}"
}

# Usage: date "format"
# See: 'man strftime' for format.
# bash 4+
# [URL] https://github.com/dylanaraps/pure-bash-bible#get-the-current-date-using-strftime
bash4_date() {
    printf "%($1)T\\n" "-1"
}
