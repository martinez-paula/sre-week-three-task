#!/bin/bash

namespace="sre"
deployment_name="swype-app"
max_restarts=1

while [ 1 ]; 
do
    num_restarts=$(kubectl get pods -l app=${deployment_name} -n ${namespace} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
    echo number of restarts: $num_restarts
    if [[ $num_restarts > $max_restarts ]]; then
        echo Number of restarts \($num_restarts\) is greater than maximum allowed \($max_restarts\). Scaling $deployment_name to zero replicas.
        kubectl scale --replicas=0 deployment/$deployment_name -n $namespace
        exit 0
    fi
    sleep 60
done

