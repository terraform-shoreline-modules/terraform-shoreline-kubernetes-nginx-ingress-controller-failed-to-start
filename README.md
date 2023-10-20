
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Failure to start Nginx Ingress Controller on Kubernetes.
---

This incident type refers to the failure of starting Nginx Ingress Controller on Kubernetes. The incident may be caused by various factors such as resource constraints on the node, affinity rules, image pull issues, misconfigured RBAC, missing default server TLS Secret, missing or invalid annotations, and invalid values of ConfigMap keys. Troubleshooting these possible reasons involves checking the ingress-controller logs and events to identify the exact cause of the startup issue.

### Parameters
```shell
export NODE_NAME="PLACEHOLDER"

export INGRESS_CONTROLLER_POD_NAME="PLACEHOLDER"

export INGRESS_CONTROLLER_DEPLOYMENT_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export INGRESS_CONTROLLER_SERVICE_ACCOUNT_NAME="PLACEHOLDER"

export INGRESS_RESOURCE_NAME="PLACEHOLDER"

export CONFIGMAP_NAME="PLACEHOLDER"

export CPU_REQUEST="PLACEHOLDER"

export MEMORY_REQUEST="PLACEHOLDER"
```

## Debug

### List all nodes in the cluster
```shell
kubectl get nodes
```

### Check the status of the node where the ingress-controller is scheduled to run
```shell
kubectl describe node ${NODE_NAME}
```

### View the resource requests and limits for the ingress-controller pod
```shell
kubectl describe pod ${INGRESS_CONTROLLER_POD_NAME}
```

### Check the available resources on the node
```shell
kubectl describe node ${NODE_NAME}
```

### Check the affinity rules for the ingress-controller deployment
```shell
kubectl describe deployment ${INGRESS_CONTROLLER_DEPLOYMENT_NAME}
```

### Check the image pull status for the ingress-controller container
```shell
kubectl describe pod ${INGRESS_CONTROLLER_POD_NAME}
```

### Check the ingress-controller logs for any errors during startup
```shell
kubectl logs ${INGRESS_CONTROLLER_POD_NAME}
```

### Check the ingress-controller events for any errors during startup
```shell
kubectl describe events ${INGRESS_CONTROLLER_POD_NAME}
```

### Check the RBAC configuration for the ingress-controller service account
```shell
kubectl describe serviceaccount -n ${NAMESPACE} ${INGRESS_CONTROLLER_SERVICE_ACCOUNT_NAME}
```

### Check the annotations for the ingress resource
```shell
kubectl describe ingress ${INGRESS_RESOURCE_NAME}
```

### Check the values of the ConfigMap keys used by the ingress-controller
```shell
kubectl describe configmap ${CONFIGMAP_NAME} -o yaml
```

## Repair

### Check if there are resource constraints on the node where the Nginx Ingress Controller is deployed. Move the deployment to a node with more resources.
```shell


#!/bin/bash



# Set variables

NODE=${NODE_NAME}

CPU_REQUEST=${CPU_REQUEST}

MEMORY_REQUEST=${MEMORY_REQUEST}



# Move the deployment to a node with more resources

if kubectl top node | grep -q $NODE; then

  # Check if the node has enough resources

  CPU_AVAILABLE=$(kubectl describe node $NODE | grep "cpu" | awk '{print $2}')

  MEMORY_AVAILABLE=$(kubectl describe node $NODE | grep "memory" | awk '{print $2}')

  if [ "$CPU_AVAILABLE" -lt "$CPU_REQUEST" ] || [ "$MEMORY_AVAILABLE" -lt "$MEMORY_REQUEST" ]; then

    # Find a node with more resources

    NEW_NODE=$(kubectl top nodes | awk 'NR>1 {print $1, $3, $5}' | sort -k2 -h -k3 -h | awk '{print $1}' | head -n 1)

    # Move the deployment to the new node

    kubectl patch deployment ${INGRESS_CONTROLLER_DEPLOYMENT_NAME} -p '{"spec": {"template": {"spec": {"nodeSelector": {"kubernetes.io/hostname": "'$NEW_NODE'"}}}}}'

  fi

fi


```