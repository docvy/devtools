#
# Prepares environment for developing Docvy components
#
# The MIT License (MIT)
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# utilities
source utils.sh


# a listing of github shorthands to the app components
COMPONENTS_GITHUB=(
  "GochoMugo/docvy-app"
  "GochoMugo/docvy-plugin-installer"
  "GochoMugo/docvy-server"
  "GochoMugo/docvy-utils"
  "GochoMugo/docvy-viewer"
)

# title of logging in this script
LOG_TITLE="prepare"


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
