FROM python:2.7

ARG OC_CLIENT_URL=http://test.url/occlient-3.3.17.gz

ENV OC_CLIENT_URL ${OC_CLIENT_URL}

USER root

RUN yum -y install ksh gcc yum-utils libffi-devel python-devel openssl-devel; \
  yum-config-manager --enable rhel-server-rhscl-7-rpms; \
  scl enable python27 "pip install requests pkiutils pyopenssl cryptography"; \
  yum clean all;

RUN mkdir -p /opt/watcher/pod && mkdir -p /apollo && chmod 777 /apollo && chown -R 1001:1001 /apollo

RUN curl ${OC_CLIENT_URL} | tar xvzf - -C /usr/bin

COPY OpenShiftWatcher /opt/watcher/OpenShiftWatcher

COPY pod /opt/watcher/pod

RUN chown -R 1001:1001 /opt/watcher/ && chmod u+x /opt/watcher/pod/pod_watch.sh && chmod u+x /opt/watcher/pod/get_pods.sh

USER 1001

ENTRYPOINT "/opt/watcher/pod/pod_watch.sh"
