# SolarWinds Web Help Desk 12.6.0

> **Note**: The setup and configuration for this container version is different to prior versions. In the `old` subdirectory, you can find older versions. Most notably, the WHD container is not configurable to run with the embedded Postgres instance anymore, aligning it with Docker best practices (one container = one service).

## Setup 

Open the configuration file `scripts/config.json`. Change the default configuration to your desired state. At minimum, change these settings:

- `admin.firstName`
- `admin.lastName`
- `admin.email`

Choose a secure password for `admin.password`. You can use `openssl` to generate a random password:

```bash
$ openssl rand -base64 12
qoOlLNlJ6P/+dZtw

# You can use jq generate JSON
$ openssl rand -base64 12 | jq -aR '{password: .}'
{
  "password": "Q6KGcSEhxrHufFFb"
}
```

At this point, you can also configure `incomingEmail` and `outgoingEmail`, though that's also possible in the Web UI later.

## Start

The included `docker-compose.yml` is a bare-bones stack containing the WHD image built from the current context and a Postgres database. This is strictly meant for local testing.

###### Starting

```bash
cd containers/whd
docker-compose up --build
```

Watch the logs and wait for the service to start up. You might see warnings from Postgres, which you can safely ignore. If successful, you should see something like this:

```text
whd_1  | [/usr/local/webhelpdesk/scripts/entrypoint.sh - 14:29] Startup in progress: STARTING
whd_1  | [/usr/local/webhelpdesk/scripts/entrypoint.sh - 14:29] Startup in progress: STARTING
whd_1  | [/usr/local/webhelpdesk/scripts/entrypoint.sh - 14:29] Setup complete, you can now use the application.
whd_1  | [/usr/local/webhelpdesk/scripts/entrypoint.sh - 14:29] After a few seconds, you'll be able to login to your new WHD instance:
whd_1  | URL:      http://localhost:8081/helpdesk
whd_1  | User:     admin (joe@example.com)
whd_1  | Password: see config
whd_1  | [/usr/local/webhelpdesk/scripts/entrypoint.sh - 14:29] Done.
...
whd_1  | 2019-02-11 14:29:54,782 INFO success: whd entered RUNNING state, process has stayed up for > than 0 seconds (startsecs)
whd_1  | 2019-02-11 14:30:05,111 INFO exited: whd (exit status 0; expected)
```

In production,

- run `docker built -t YOUR_REGISTRY/YOUR_NAME/whd .` to build the image and then
- `docker push YOUR_REGISTRY/YOUR_NAME/whd` to push it to your registry
- Change `build: .` to `image: YOUR_REGISTRY/YOUR_NAME/whd` in the compose file
- Create a volume for the Postgres service, to store data persistently outside of the running stack.

You should use your Docker ingress controller for SSL termination in a Docker Swarm deployment. As an example, the following Traefik configuration deploys the container at `https://whd.example.com` (remove exposed ports from the service):

```yaml
deploy:
  mode: global
  labels:
    - traefik.frontend.rule=Host:whd.example.com
    - traefik.docker.network=traefik
    - traefik.port=8081
```
