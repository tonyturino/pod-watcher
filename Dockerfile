FROM rhscl/python-27-rhel7

USER root

RUN yum -y install ksh gcc yum-utils libffi-devel python-devel openssl-devel; \
  yum-config-manager --enable rhel-server-rhscl-7-rpms; \
  scl enable python27 "pip install requests pkiutils pyopenssl cryptography"; \
  yum clean all;

RUN mkdir -p /opt/watcher/pod

RUN curl http://nexus-repository.rhel-cdk.10.1.2.2.xip.io/nexus/content/repositories/releases/com/redhat/occlient/3.3.17/occlient-3.3.17.gz | tar xf -C /usr/bin

COPY OpenShiftWatcher /opt/watcher/pod/OpenShiftWatcher

COPY pod /opt/watcher/pod

RUN chown -R 1001:1001 /opt/watcher/ && chmod u+x /opt/watcher/pod/pod_watch.sh && chmod u+x /opt/watcher/pod/get_pods.sh

USER 1001

ENTRYPOINT "/opt/watcher/pod/pod_watch.sh"