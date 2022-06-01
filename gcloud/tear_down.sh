#!/bin/bash


# Remove HTTP load balancer
gcloud compute forwarding-rules delete $http_content_rule --global --quiet
gcloud compute target-http-proxies delete $http_lb_proxy --quiet
gcloud compute url-maps delete $url_map --global --quiet
gcloud compute addresses delete $lb_ipv4 --global --quiet


# Remove backend services
gcloud compute backend-services remove-backend $backend_svc \
        --network-endpoint-group=$neg_west \
        --network-endpoint-group-region=us-west1 \
        --global \
        --quiet
gcloud compute backend-services remove-backend $backend_svc \
        --network-endpoint-group=$neg_east \
        --network-endpoint-group-region=us-east1 \
        --global \
        --quiet
gcloud compute backend-services delete $backend_svc --global -q


# Remove network endpoint groups
gcloud compute network-endpoint-groups delete $neg_east \
        --region=us-east1 --quiet
gcloud compute network-endpoint-groups delete $neg_west \
        --region=us-west1 --quiet


# Remove Cloud Run services
gcloud run services delete $cloudrun_east \
        --region=us-east1 --quiet
gcloud run services delete $cloudrun_west \
        --region=us-west1 --quiet


# Remove Cloud SQL Master/Replica
gcloud sql instances delete $cloudsql_replica --quiet
gcloud sql instances delete $cloudsql_master --quiet


# Remove VPC Peering for private service access to Cloud SQL and the associated allocated IP range
gcloud services vpc-peerings delete --network=$vpc_network \
        --service=servicenetworking.googleapis.com
gcloud compute addresses delete google-managed-services-$vpc_network \
        --global \
        --quiet


# Remove VPC connectors
gcloud compute networks vpc-access connectors delete $vpc_connector_east \
        --region us-east1 --quiet
gcloud compute networks vpc-access connectors delete $vpc_connector_west \
        --region us-west1 --quiet


# Remove VPC subnets
gcloud compute networks subnets delete $vpc_subnet_east \
        --region=us-east1 --quiet
gcloud compute networks subnets delete $vpc_subnet_west \
        --region=us-west1 --quiet


# Remove VPC Peering connections
vpc_peerings=(`gcloud compute networks peerings list --network=$vpc_network | awk 'NR>1 {print $1}'`)
for item in $vpc_peerings
do
        gcloud compute networks peerings delete $item --network=$vpc_network
done

#routes=(`gcloud compute routes list --filter="'$vpc_network'" | awk 'NR>1 {print $1}'`)
#for item in $routes
#do
#        gcloud compute routes delete $item --quiet
#done

# Remove VPC network
gcloud compute networks delete $vpc_network --quiet


