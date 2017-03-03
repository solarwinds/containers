# Container Network Performance Tool

## Purpose
The tool is intended to educate and facilitate decision-making of which type of network (i.e. network driver) to deploy in a container cluster (a multi-host environment), whether container orchestration is present or not. 

The tool facilitates comparison of the performance (via throughput test) of various container network plugins, producing a shareable throughput report. And assists in highlighting mishaps to avoid in your container network setup:
 1. Awareness of the convenience cost of overlays.
 1. Mindfulness of avoiding MAC address overload in underlays.

The tool provides real-time visibility of container network flow size and direction.

## Functions
1. Cluster visibility -
 1. See container network flows (current bandwidth and direction) across Kubernetes and Docker Swarm nodes.
1. Bandwidth test -
 1. Test throughput (performance) of each type of container network (compare network drivers).

## Deployment
Contact maintainer(s) for early access.

### Deployment Models
The UI container runs on one docker host in the cluster and connects to each agent via the CLUSTER_NODES environment variable
To run the container image:
`docker run -d --name ui -p 30080:8080 -e CLUSTER_NODES="host1,host2,host3,host4" -t solarwinds/container-ui:1.0`

`CLUSTER_NODES` should be a , seperated list of hosts running the agent container.
Once the container starts up URL http://host:30080/ui/inventory will show container dependencies.
