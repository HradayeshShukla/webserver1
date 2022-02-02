FROM registry.redhat.io/openshift4/ose-jenkins-agent-base:v4.6

USER root

# Copy entitlements
RUN sleep 5  
COPY ./etc-pki-entitlement /etc/pki/entitlement
COPY ./yum.repos.d /etc/yum.repos.d

# Disabling subscription manager plugin in yum since using Satellite 
RUN sed -i".org" -e "s#^enabled=1#enabled=0#g" /etc/yum/pluginconf.d/subscription-manager.conf 

# yum repository info provided by Satellite


# Delete /etc/rhsm-host to use entitlements from the build container
RUN rm /etc/rhsm-host && rm /etc/pki/entitlement-host 
RUN yum repolist --verbose && cat /etc/redhat-release && cat /etc/yum.repos.d/redhat.repo && sleep 80 && yum repolist


### Disable RHEL7 repositories 
RUN yum -y install --disablerepo='rhel-7*' vulkan redhat-lsb libXScrnSaver \
&& curl -o google-chrome-stable_current_x86_64.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
&& yum -y localinstall google-chrome-stable_current_x86_64.rpm 

# Remove entitlements
rm -rf /etc/pki/entitlement


