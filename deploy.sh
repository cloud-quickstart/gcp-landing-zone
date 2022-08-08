#!/bin/bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This Script will perform the below actions
# 1) set 3 types of variables inside all tfvar content
# 2) unset variables above (to be able to obfuscate code changes and git commit without posting org/billing/folder ids


set -e

modify()
{

  array=( environments/bootstrap/bootstrap.auto.tfvars environments/bootstrap/organization-config.auto.tfvars environments/common/common.auto.tfvars environments/nonprod/nonp-network.auto.tfvars environments/common/perimeter-network.auto.tfvars environments/prod/prod-network.auto.tfvars )
  for i in "${array[@]}"
      do
	      echo "$i pass - fill:${FILL}"
        # OSX required empty arg after -i
        if [[ $FILL == true ]]
        then
            # OSX requires ''
            #sed -i '' "s/${BILLING_ID_SEARCH}/${BILLING_ID}/g" $i
            sed -i "s/${BILLING_ID_SEARCH}/${BILLING_ID}/g" $i
            sed -i "s/${ORGANIZATION_ID_SEARCH}/${ORGANIZATION_ID}/g" $i
            sed -i "s/${FOLDER_ID_SEARCH}/${FOLDER_ID}/g" $i
        else
            sed -i "s/${BILLING_ID}/${BILLING_ID_SEARCH}/g" $i
            sed -i "s/${ORGANIZATION_ID}/${ORGANIZATION_ID_SEARCH}/g" $i
            sed -i "s/${FOLDER_ID}/${FOLDER_ID_SEARCH}/g" $i
        fi
      done
}

usage()
{
    echo "usage: options:<c|o|b|f>"
    echo "example: ./writeids.sh -c fill|unfill -o org_id -b billing_id -f folder_id"
    echo "example: ./writeids.sh -c unfill -b 1111-2222-3333 -o 4444-5555-9999 -f 012345678901"
    echo "example: ./writeids.sh -c fill -b 1111-2222-3333 -o 4444-5555-9999 -f 012345678901"
    echo "example: project only (org/billing derived): ./writeids.sh -c fill -p michael-proj-id -f 012345678901"
    echo "example: no project (project/org/billing derived): ./writeids.sh -c fill -f 012345678901"
}

undeploy() 
{
   FILL=false
   echo "reverting IDs: billing: ${BILLING_ID} organization: ${ORGANIZATION_ID} folder: ${FOLDER_ID} to placeholders"
   #modify 
}

deploy() 
{
   FILL=true
   echo "replacing IDs: billing: ${BILLING_ID} organization: ${ORGANIZATION_ID} folder: ${FOLDER_ID} from placeholders"
   #modify
   export USER_EMAIL=michael
   export PROJ=$(gcloud config list --format 'value(core.project)') 
   export ORGANIZATION_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
   export BILLING_ID=$(gcloud alpha billing projects describe $PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
   # add iam role
   gcloud organizations add-iam-policy-binding $ORGANIZATION_ID --member=user:$USER_EMAIL --role=roles/resourcemanager.folderAdmin
   # create folder and save the id
   # https://cloud.google.com/resource-manager/docs/creating-managing-folders#gcloud
   export FOLDER_ROOT_0=$(gcloud resource-manager folders create --display-name=landingzone --organization=$ORGANIZATION_ID '--format=value(name)' | sed 's/.*\///')
   export FOLDER_ROOT_1=$(gcloud resource-manager folders create --display-name=Infrastructure --folder=$FOLDER_ROOT_0 '--format=value(name)' | sed 's/.*\///')
   export FOLDER_ROOT_2=$(gcloud resource-manager folders create --display-name=Networking --folder=$FOLDER_ROOT_1 '--format=value(name)' | sed 's/.*\///')
   export FOLDER_ROOT_3=$(gcloud resource-manager folders create --display-name=ProdNetworking --folder=$FOLDER_ROOT_2 '--format=value(name)' | sed 's/.*\///')
   export FOLDER_WORK_1=$(gcloud resource-manager folders create --display-name=Workloads --folder=$FOLDER_ROOT_0 '--format=value(name)' | sed 's/.*\///')
   export FOLDER_WORK_2=$(gcloud resource-manager folders create --display-name=Prod --folder=$FOLDER_WORK_1 '--format=value(name)' | sed 's/.*\///')

   export PROJECT_PERIMETER=odpe-obd-obdprd-obdpubper
   export PROJECT_PRODHOST=odpe-obd-obdprd-obdhostproj
   export PROJECT_PRODSERV1=odpe-obd-obdprd-obdservprj1
   gcloud projects create $PROJECT_PERIMETER --folder=$FOLDER_ROOT_3
   gcloud projects create $PROJECT_PRODHOST --folder=$FOLDER_ROOT_3
   gcloud projects create $PROJECT_PRODSERV1 --folder=$FOLDER_WORK_2
}

no_args="true"
PROJECT_ID=
COMMAND=fill
BILLING_ID_SEARCH=REPLACE_WITH_BILLING_ID 
ORGANIZATION_ID_SEARCH=REPLACE_ORGANIZATION_ID 
FOLDER_ID_SEARCH=REPLACE_FOLDER_ID 
BILLING_ID=
ORGANIZATION_ID= 
FOLDER_ID= 
FILL=true
#FILL=false

while getopts "p:c:o:b:f:v:" flag;
do
    case "${flag}" in
        c) COMMAND=${OPTARG};;
        p) PROJECT_ID=${OPTARG};;
        o) ORGANIZATION_ID=${OPTARG};;
        b) BILLING_ID=${OPTARG};;
        f) FOLDER_ID=${OPTARG};;
        *) usage
           exit 1
           ;;
    esac
    no_args="false"
done

  

  # get current project
  if [[ -z "$PROJECT_ID" ]]
  then
      PROJECT_ID=$(gcloud config list --format 'value(core.project)')
      if [[ -z "$PROJECT_ID" ]]
      then
          echo "Run the following before starting the script so we can derive the org/billing ids from the project:"
          echo "gcloud config set project <project_id>"
          exit 1
      fi
  else
      echo "project passed as: $PROJECT_ID"
  fi
  # get org and billing id based on project if required
  if [[ -z "$ORGANIZATION_ID" ]]
  then
      ORGANIZATION_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
      echo "Derived organization_id: $ORGANIZATION_ID"
  fi
    if [[ -z "$BILLING_ID" ]]
  then
      BILLING_ID=$(gcloud alpha billing projects describe $PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
      echo "Derived billing_id: $BILLING_ID"
  fi
  
# Exit script and print usage if no arguments are passed.
if [[ $no_args == true ]]; then
    usage
    exit 1
fi

if [[ $COMMAND == "unfill" ]]
then
    undeploy
else
    deploy
fi

