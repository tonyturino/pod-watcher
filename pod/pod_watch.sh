set -x 

export OS_TOKEN=`oc whoami -t`
export OS_API=`oc status | head -n1 | cut -d'/' -f3`
export OS_NAMESPACE=`oc whoami | cut -d :  -f 3`
export OS_RESOURCE="pods"


export APP_NAME="searcher"
export PROJECT_NAME="macys-apollo"
export APOLLO_CONF="/tmp.properties"