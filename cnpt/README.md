# Container Network Performance Tool

## Functions*
* Network type capacity check
* Education and decision facilitation
## Network type capacity comparison
* Comparative “netdex” report
* Performance report - as an industry standard reference
## Visibility of container network flow size and direction

The UI container runs on one docker host in the cluster and connects to each agent via the CLUSTER_NODES environment variable
To run the container image:
docker run -d --name ui -p 30080:8080 -e CLUSTER_NODES="host1,host2,host3,host4" -t solarwinds/container-ui:1.0

`CLUSTER_NODES` should be a , seperated list of hosts running the agent container.
Once the container starts up URL http://host:30080/ui/inventory will show container dependencies.
