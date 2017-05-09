# Container Network Performance Tool

## Purpose
The tool is intended to educate and facilitate decision-making of which type of network (i.e. network driver) to deploy in a container cluster (a multi-host environment), whether container orchestration is present or not. 

The tool facilitates comparison of the performance (via throughput test) of various container network plugins, producing a shareable throughput report. And assists in highlighting mishaps to avoid in your container network setup:
 1. Awareness of the convenience cost of overlays.
 2. Mindfulness of avoiding MAC address overload in underlays.

The tool provides real-time visibility of container network flow size and direction.

## Functions
1. Cluster visibility -
  * See container network flows (current bandwidth and direction) across Kubernetes and Docker Swarm nodes.
2. Bandwidth test -
  * Test throughput (performance) of each type of container network (compare network drivers).

## Deployment
Contact maintainer(s) for early access.

### Deployment Models

The Agent container should be deployed on each host running docker.   Run the following command on each docker host:

`docker run -d --name agent --privileged --net=host --restart always -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro solarwinds/container-agent:1.1`

The UI container runs on one docker host in the cluster.  To run the container image:

`docker run -d --name ui -p 30080:80 -t solarwinds/container-ui:1.1`

Once the container starts up, connect to URL http://ip-of-ui-host:30080/ 

To connect the agents with the UI:

1. Navigate to the hosts page
2. Click the add button
3. In the dialog, enter in the address of each docker host on a seperate line
4. Click add
