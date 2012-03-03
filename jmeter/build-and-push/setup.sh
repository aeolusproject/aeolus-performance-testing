#!/bin/bash

#   Copyright 2011 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

usage()
{
cat << EOF
Cleans and configures aeolus and adds a set number of user accounts

USAGE:
setup.sh [-u] [-p]

OPTIONS:
   -u | Number of users to create.
   -p | Name of profile(s) to use.
EOF
}

while getopts ":u:p:" opt; do 
    case "$opt" in
	u)
	    NUMUSERS=$OPTARG
	    ;;
        p)
	    PROFILE=$OPTARG
	    ;;
	\?)
	    usage
	    exit 1
	    ;;
    esac
done

aeolus-cleanup
aeolus-configure -p $PROFILE
PWD=`pwd`
export RAILS_ENV=production
cd /usr/share/aeolus-conductor


for (( i = 1 ; i <= $NUMUSERS; i++ ))
do
    echo $NUMUSER
    rake dc:create_user[user${i},user${i},user${i}@test.com,user,${i}]
    rake dc:site_admin[user${i}]
done

cd $PWD