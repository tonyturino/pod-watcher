#!/usr/bin/env python

import os
import requests
import json
import logging
from subprocess import call
from OpenShiftWatcher import OpenShiftWatcher

need_cert_annotation = os.getenv('NEED_CERT_ANNOTATION', 'openshift.io/managed.cert')
logging.basicConfig(format="%(asctime)s %(message)s")
logger = logging.getLogger('podwatcher')
logger.setLevel(logging.DEBUG)
logger.debug(json.dumps(dict(os.environ), indent=2, sort_keys=True))
k8s_resource=os.environ['OS_RESOURCE']
k8s_token=os.environ['OS_TOKEN']
k8s_namespace=os.environ['OS_NAMESPACE']
k8s_endpoint=os.environ['KUBERNETES_SERVICE_HOST']
app_name=os.environ['APP_NAME']
project_name=os.environ['PROJECT_NAME']
apollo_conf = os.environ['APOLLO_CONF']

def watch_pods():

    watcher = OpenShiftWatcher(os_api_endpoint=k8s_endpoint,
                               os_resource=k8s_resource,
                               os_namespace=k8s_namespace,
                               os_auth_token=k8s_token)

    for event in watcher.stream():

        if type(event) is dict and 'type' in event:
            pod_ip = ""

            status = event['object']['status']
            name = event['object']['metadata']['name']
            phase = event['object']['status']['phase']

            if phase == 'Running' and  name.startswith(app_name):
 
                 if event['type'] == 'DELETED':
                     call(["get_pods.sh", "-d", app_name, "-n", project_name,  "-f", "/tmp"])
                     logger.info("Event Type: {0}".format(event['type']))
                     logger.info("--------------------------------------------------------------")
                 else:
                     
                    for item in status['conditions']:
                        if item['type'] == 'Ready' and item['status'] == 'True':
                
                            logger.info(name)
                            statusprint = json.dumps(status, indent=2, sort_keys=True)
                            logger.info(statusprint)
                
                            if 'podIP' in status:
                                pod_ip = event['object']['status']['podIP']

    
                            logger.info("Event Type: {0}".format(event['type']))
                            logger.info("Pod IP: {0}".format(pod_ip))
                            logger.info("Phase: {0}".format(phase))
                            logger.info("--------------------------------------------------------------")
    
                            call(["get_pods.sh", "-d", app_name, "-n", project_name,  "-f", apollo_conf])
                    

            else:
                logger.info("Not relevant {0} {1} {2}".format(pod_ip, phase, name))





def main():
    watch_pods()

if __name__ == '__main__':
    main()