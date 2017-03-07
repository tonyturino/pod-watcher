#!/usr/bin/ksh
#
set -x
[ $# -eq 0 ] && { echo "Usage: $0 -d <dc> -n <project>" ; exit 1; }

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -n)
    PROJECT="$2"
    shift # past argument
    ;;
    -d)
    DC="$2"
    shift # past argument
    ;;
    *)
            # unknown option
   ;;
esac
shift # past argument or value
done

IPS=""

# Gets a list of list of pods in the project namespace (ex. apollo) filtering for application (ex. searcher)
# and creates a comma separated list of application URLs 
# TODO this port should be parameterized
oc get pods -l app=${DC} -o jsonpath='{range .items[*]}{.metadata.name} {.status.podIP} {.status.phase}
{end}' -n ${PROJECT} | egrep "^${DC}-.*-..... .*Running$" | \
while read POD IP PHASE ; do
   IPS="$IPS,\"$IP\""
done

IPS=${IPS#?}

echo $IPS

curl -H "Content-Type: application/json" -X PUT -d "[$IPS]" $SPRING_APP_URL
