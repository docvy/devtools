#
# Prepares environment for developing Docvy components
#
# The MIT License (MIT)
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# a listing of github shorthands to the app components
COMPONENTS_GITHUB=(
  "GochoMugo/docvy-app"
  "GochoMugo/docvy-plugin-installer"
  "GochoMugo/docvy-server"
  "GochoMugo/docvy-utils"
  "GochoMugo/docvy-viewer"
)


# Colors for Bash
COLOR_BLUE="\033[0;34m"
COLOR_GREEN="\033[0;32m"
COLOR_RED="\033[0;31m"
COLOR_RESET="\e[0m"
COLOR_WHITE="\033[1;37m"


# logs to console
#
# ${1}  message to write to console
# ${2} what color to use. 0 - info(blue), 1- success(green), 2 - error(red)
log() {
  [ ${2} -eq 0 ] && local color=${COLOR_BLUE}
  [ ${2} -eq 1 ] && local color=${COLOR_GREEN}
  [ ${2} -eq 2 ] && local color=${COLOR_RED}
  echo -e "${COLOR_WHITE}prepare: ${color}${1}${COLOR_RESET}"
}


# clones all the repos for the components
get_components() {
  for component in ${COMPONENTS_GITHUB[@]} ; do
    log "getting ${component}" 0
    git clone "https://github.com/${component}.git" > /dev/null
  done
}


# creates and moves us into a new workspace
# ${1} -- directory name
make_new_workspace() {
  local name=${1:-"docvy"}
  if [ -e ${name} ]  ; then
    mkdir -p "${name}.old"
    mv ${name} "${name}.old"
    log "existing directory moved to ${name}.old" 0
  fi
  log "creating workspace" 0
  mkdir ${name}
  log "changing directory into workspace" 0
  cd ${name}
}


# loops into each directory
# ${1} -- command to run
each_dir() {
  local dirs="$(ls)"
  for dir in ${dirs[@]} ; do
    [ ! -d ${dir} ] && continue
    cd ${dir}
    ${1}
    cd ..
  done
}


# creates links in all components
make_links() {
  log "making links" 0
  each_dir "make links >/dev/null 2>1"
}


#
# STARTING PREPARATION
#
make_new_workspace ${1}
get_components
make_links
