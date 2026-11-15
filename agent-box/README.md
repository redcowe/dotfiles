# agent-box

`agent-box` runs project commands inside the local development sandbox. The
launcher publishes ports when creating a container with `--port`; the
host-side helper can also forward ports from containers that are already
running.

## Install

From this directory in WSL 2, run:

~~~bash
./install.sh
~~~

The installer places `agent-box` and `agent-box-port-forward` in
`$HOME/.local/bin`, copies the Dockerfile to `$HOME/.agent-sandbox`, and loads
the bundled image if present. If the image archive is absent, it builds the
image when needed. Python 3 and Docker access from WSL are required.

## Publish a port when starting a sandbox

~~~bash
cd ~/src/my-project
agent-box --port 3000 npm run dev
~~~

The host listener is bound to `127.0.0.1:3000`. The service inside the
container must listen on `0.0.0.0:3000`.

## Forward a port from a running container

Run these on the WSL host, not inside the container. From the project
directory, `expose` selects its running `agent-box` container automatically
when exactly one matches:

~~~bash
agent-box expose 3000
agent-box forwards
agent-box unexpose 3000
~~~

To target a named container or choose a different host port:

~~~bash
agent-box expose 8080 --container my-database
agent-box expose 5432 --host-port 15432 --container my-database
~~~

`expose` starts a small host-side TCP relay bound to `127.0.0.1`; it forwards
to the container's bridge-network IP and stops when that container stops.
This works for HTTP and other TCP services. The service must listen on
`0.0.0.0` inside its container. The relay does not add a mount or Docker socket
to the sandbox. The selected container must be running and have a bridge
network IP reachable from the WSL host.

Use `agent-box forwards` to list listeners and `agent-box unexpose HOST_PORT`
to stop one. The host port defaults to the container port. When multiple
`agent-box` containers match the current project, pass `--container NAME_OR_ID`.
