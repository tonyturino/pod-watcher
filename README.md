# Pod Watcher

 An application to watch Kubernetes pods through OpenShift.


 This application is intended to watch Kubernetes pods in an OpenShift environment. It will call the Kubernetes API to get pod create/modified/delete events. The application will monitor a specified namespace and application and based on the application being scaled up or down (or a pod being deleted/recreated) call a script that will update a property file with the urls of the pods being watched.


This is an example of an application being created
```oc new-app https://github.com/mcanoy/pod-watcher.git --name=pod-watcher -l app=pod-watcher -n myDeployedNamespace -e PROERTIES_FILE=/tmp.properties -e PROJECT_NAME=myWatchedNamespace -e APP_NAME=myWatchedApplication```

It may also be necessary to give this pod permission to view the list of pods
`oc policy add-role-to-user view system:serviceaccounts:myDeployedNamespace:default -n myWatchedNamespace`
