#!/bin/bash
# Copyright (C) 2018 Yasuhiro Yamada
# MIT License is applied to this script

# Usage: bash_cat <file>
# Usage: command | bash_cat
bash_cat () {
  local _fname=${1:-/dev/stdin}
  printf "%s" "$(<"${_fname}")"
}

bash_pwd () {
  printf "%s\\n" "$PWD"
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
  local _num=${1:-10} ; shift
  local _fname=${1:-/dev/stdin}
  IFS=$'\n' read -d "" -ra _file_data < "$_fname"
  local i=0
  local begin end
  begin=$(( ${#_file_data[@]} - _num ))
  end=$(( ${#_file_data[@]} ))
  for ((i=begin;i<end;i++)); do
      printf '%s\n' "${_file_data[$i]}"
  done
}

# Usage: bash_tac filename
bash_tac () {
  local _fname=${1:-/dev/stdin}
  IFS=$'\n' read -d "" -ra _file_data < "$_fname"
  shopt -s extdebug
  f()(printf '%s\n' "${BASH_ARGV[@]}"); f "${_file_data[@]}"
  shopt -u extdebug
}

# Usage: bash_grep <pattern> filename
bash_grep () {
  local _pat="$1" ;shift
  local _fname=${1:-/dev/stdin}
  while read -r line ; do
    if [[ "${line}" =~ $_pat ]];then
      printf "%s\\n" "${line}"
    fi
  done < "$_fname"
}

# Usage: bash_sed <before> <after> filename
# s command + global option (s///g) only.
bash_sed () {
  local _pat="$1" ;shift
  local _pat_update="$1" ;shift
  local _fname=${1:-/dev/stdin}
  while read -r line ; do
    if [[ "${line}" =~ $_pat ]];then
      printf "%s\\n" "${line//$_pat/$_pat_update}"
    else
      printf "%s\\n" "${line}"
    fi
  done < "$_fname"
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

# --------------------
# Following commands are distributed in MIT license
# [LICENSE] https://github.com/dylanaraps/pure-bash-bible/blob/master/LICENSE.md
# --------------------

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
