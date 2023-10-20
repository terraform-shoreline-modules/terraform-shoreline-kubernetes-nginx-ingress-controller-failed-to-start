

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