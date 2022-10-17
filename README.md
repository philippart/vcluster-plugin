## Vcluster Plugin for Custom Resources

This plugin syncs custom resources `cars` from a virtual cluster to the host cluster. 
It expects the CRD was already installed in the host cluster.

This code is based on [vcluster SDK example](https://github.com/loft-sh/vcluster-sdk/tree/main/examples/crd-sync).

## Using the Plugin in vcluster

To use the plugin, create a new vcluster with the `plugin.yaml`:

```
# Apply cars crd in host cluster
kubectl apply -f https://raw.githubusercontent.com/philippart/vcluster-plugin/manifests/crds.yaml

# Create vcluster with plugin
vcluster create my-vcluster -n my-vcluster -f https://raw.githubusercontent.com/philippart/vcluster-plugin/plugin.yaml
```

This will create a new vcluster with the plugin installed. Then test the plugin with:

```
# Apply audi car to vcluster
vcluster connect my-vcluster -n my-vcluster -- kubectl apply -f https://raw.githubusercontent.com/philippart/vcluster-plugin/manifests/audi.yaml

# Check if car got correctly synced
kubectl get cars -n my-vcluster
```

## Building the Plugin
To just build the plugin image and push it to the registry, run (docker or podman):
```
# Build
docker build . -t my-repo/my-plugin:0.0.1

# Push
docker push my-repo/my-plugin:0.0.1
```

Then exchange the image in the `plugin.yaml`

## Development

vcluster plugin project structure:
```
.
├── go.mod              # Go module definition
├── go.sum
├── devspace.yaml       # Development environment definition
├── devspace_start.sh   # Development entrypoint script
├── Dockerfile          # Production Dockerfile 
├── Dockerfile.dev      # Development Dockerfile
├── main.go             # Go Entrypoint
├── plugin.yaml         # Plugin Helm Values
├── syncers/            # Plugin Syncers
├── apis/               # Go types
├── gen/                # CRD and types deepcopy generator
└── manifests/          # Additional plugin resources
```

Before starting to develop, make sure you have installed the following tools on your computer:
- [docker](https://docs.docker.com/) or [podman](https://podman.io/getting-started/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) with a valid kube context configured
- [helm](https://helm.sh/docs/intro/install/), which is used to deploy vcluster and the plugin
- [vcluster CLI](https://www.vcluster.com/docs/getting-started/setup) v0.6.0 or higher
- [DevSpace](https://devspace.sh/cli/docs/quickstart), which is used to spin up a development environment

If you want to develop within a remote Kubernetes cluster (as opposed to kind, k3s, minikube...), make sure to exchange `PLUGIN_IMAGE` in the `devspace.yaml` with a valid registry path you can push to.

After successfully setting up the tools, start the development environment with:
```
devspace dev -n vcluster
```

After a while a terminal should show up with additional instructions. Enter the following command to start the plugin:
```
go run -mod vendor main.go
```

The output should look something like this:
```
I0124 11:20:14.702799    4185 logr.go:249] plugin: Try creating context...
I0124 11:20:14.730044    4185 logr.go:249] plugin: Waiting for vcluster to become leader...
I0124 11:20:14.731097    4185 logr.go:249] plugin: Starting syncers...
[...]
I0124 11:20:15.957331    4185 logr.go:249] plugin: Successfully started plugin.
```

You can now change a file locally in your IDE and then restart the command in the terminal to apply the changes to the plugin.

Delete the development environment with:
```
devspace purge -n vcluster
```
