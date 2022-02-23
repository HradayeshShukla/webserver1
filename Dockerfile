FROM registry.redhat.io/ubi8:latest
USER root
RUN cat /etc/rhsm/rhsm.conf | grep repo_ca_cert && rm /etc/rhsm-host
COPY ./etc-pki-entitlement /etc/pki/entitlement
RUN sed -i 's/.*repo_ca_cert.*/repo_ca_cert = \/etc\/rhsm\/ca\/redhat-uep.pem/g' /etc/rhsm/rhsm.conf
RUN cat /etc/rhsm/rhsm.conf | grep repo_ca_cert 
RUN dnf repolist --verbose && dnf -y update 
RUN dnf -y install flex 
