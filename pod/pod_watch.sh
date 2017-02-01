set -x 

export OS_TOKEN=`oc whoami -t`
export OS_API=`oc status | head -n1 | cut -d'/' -f3`
export OS_NAMESPACE=`oc whoami | cut -d :  -f 3`
export OS_RESOURCE="pods"

scl enable python27 /opt/watcher/pod/pod_watch.py

