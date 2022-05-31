#!/bin/bash


app_image=$1
cloudrun_east1=$2
cloudrun_east1_vpc_connector=$3
cloudsql_master=$4
cloudrun_west1=$5
cloudrun_west1_vpc_connector=$6
cloudsql_replica=$7

gcloud run deploy $cloudrun_east1 \
	--region=us-east1 \
	--image=$app_image \
	--port=8080 \
	--env-vars-file=env_vars_us_east1.yaml \
	--add-cloudsql-instances=$cloudsql_master \
	--vpc-connector=$cloudrun_east1_vpc_connector \
	--allow-unauthenticated

gcloud run deploy $cloudrun_west1 \
	--region=us-west1 \
        --image=$app_image \
        --port=8080 \
        --env-vars-file=env_vars_us_west1.yaml \
        --add-cloudsql-instances=$cloudsql_replica \
        --vpc-connector=$cloudrun_west1_vpc_connector \
        --allow-unauthenticated


