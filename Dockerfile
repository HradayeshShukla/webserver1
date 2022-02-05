#FROM registry.redhat.io/jboss-webserver-3/webserver31-tomcat8-openshift@sha256:b22c3fea4374e776366d2363184a854b8ba47539df0d02b6907f1e7816d4587f
#FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
FROM registry.access.redhat.com/ubi8/ubi:8.2

USER root

# Copy entitlements
COPY ./etc-pki-entitlement /etc/pki/entitlement
COPY ./yum.repos.d /etc/yum.repos.d

# Disabling subscription manager plugin in yum since using Satellite 
#RUN sed -i".org" -e "s#^enabled=1#enabled=0#g" /etc/yum/pluginconf.d/subscription-manager.conf 


# Delete /etc/rhsm-host to use entitlements from the build container
RUN rm /etc/rhsm-host && rm /etc/pki/entitlement-host 

RUN yum repolist -v && subscription-manager repos --enable rhel-7-server-rpms   

RUN yum install  tcpdump traceroute telnet iputils-ping snmp openssh-server -y


RUN ls /etc/pki/entitlement/single && subscription-manager repos 

RUN yum -y --disablerepo="*" --enablerepo=rhel-7-server-rpms     install krb5-workstation

### Disable RHEL7 repositories 
RUN yum -y install --enablerepo='rhel-7-server-rpms' krb5-workstation 

# Remove entitlements
rm -rf /etc/pki/entitlement


