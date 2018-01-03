![CNPT Logo](https://raw.githubusercontent.com/solarwinds/containers/master/cnpt/cnpt%20logo.png) 
# Container Network Performance Tool
A container monitoring tool that works on individual Docker hosts or clusters running Kubernetes or Docker Swarm.
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
This tool deploys as two types of containers - one that acts as an agent (per host) and as a user interface.

### Deployment without a container orchestrator
The Agent container should be deployed on each host running docker. Run the following command on each docker host:

```
docker run -d --name swi-agent --privileged --net=host --restart always -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro solarwinds/container-agent
```

The UI container runs on one docker host in the cluster.  To run the container image:

```
docker run -d --name swi-ui -p 80:80 -t solarwinds/container-ui
```
### Deployment with Docker Swarm
*Option 1: Compose* - copy the compose deployment yaml from the [deployment](deployment) folder and execute:
 
```
 docker stack deploy --compose-file docker-compose.yml
 ```
*Option 2: Service* - create a cluster service
```
docker service create --name swi-ui --replicas 1 --publish 30080:80 solarwinds/container-ui
```

### Deployment with Kubernetes
Copy the spec files from the [deployment](deployment) folder and execute:
```
kubectl apply -f ui-rc.yaml
kubectl apply -f ui-service.yaml
kubectl apply -f agent-daemonset.yaml
```

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

### Viewing container topology and flows
<img src="https://github.com/solarwinds/containers/blob/master/cnpt/cmon-topology.png" width="800" />

### Running a network performance test
<img src="https://github.com/solarwinds/containers/blob/master/cnpt/network-performance-test.png" width="800" />
Test throughput (performance) of each type of container network (compare network drivers).

### Interpreting observations
This tool measures the size of flow and latency between containers. It calculates optimal adjacencies of communicating containers based on these two figures as well as accounts for latency between hosts themselves. Observations aim to minimize the amount of latency each byte of traffic has on the network by moving containers with higher communication loads closer to each other.

# Questions/Comments?
Please [open an issue](https://github.com/solarwinds/containers/issues/new), we'd love to hear from you. As a SolarWinds Innovation Project, this project is supported in a best-effort fashion.
