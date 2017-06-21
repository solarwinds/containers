# Container Network Performance Tool

## Purpose
The tool is intended to educate and facilitate decision-making of which type of network (i.e. network driver) to deploy in a container cluster (a multi-host environment), whether container orchestration is present or not. 

The tool facilitates comparison of the performance (via throughput test) of various container network plugins, producing a shareable throughput report. And assists in highlighting mishaps to avoid in your container network setup:
 1. Awareness of the convenience cost of overlays.
 2. Mindfulness of avoiding MAC address overload in underlays.
 3. Insight as to which containers have the highest network flow between them.

The tool provides real-time visibility of container network flow size and direction.

## Functions
1. _Cluster visibility_ - See container network flows (current bandwidth and direction) across Kubernetes and Docker Swarm nodes.
2. _Bandwidth test_ - Test throughput (performance) of each type of container network (compare network drivers).
3. _Flow observations_ - Receive insight on application consumption of network paths between containers.

## Deployment
This two deploys as two types of containers - one that acts as an agent (per host) and as a user interface.

### Deployment Models
#### Without a container orchestrator
The Agent container should be deployed on each host running docker. Run the following command on each docker host:

```
docker run -d --name swi-agent --privileged --net=host --restart always -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro solarwinds/container-agent
```

The UI container runs on one docker host in the cluster.  To run the container image:

```
docker run -d --name swi-ui -p 80:80 -t solarwinds/container-ui
```
#### With a container orchestrator
See the deployment yaml files in the [deployment]|(deployment) folder.

### Required Ports
Be sure to allow TCP traffic on port 9090 between your hosts. 
* 9090/tcp - used to provide communication between agent and UI.

Deploying on CentOS 7:
```
sudo firewall-cmd --zone=public --add-port=9090/tcp --permanent
sudo firewall-cmd --reload
```

## Using the tool
Once the UI starts up, connect to URL http://ip-of-ui-host 

To connect the agents with the UI:

1. Navigate to the hosts page
2. Click the add button
3. In the dialog, enter in the address of each docker host on a seperate line
4. Click add

