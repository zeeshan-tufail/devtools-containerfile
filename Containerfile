# Container sepecification for development tools

#ARG MAVEN_VERSION=3.8.8

FROM registry.access.redhat.com/ubi8/openjdk-11:1.17

# labels
LABEL description="This is a custom container image for dev tools" \ 
	  io.k8s.display-name="Openshift Github Runner - Tool - maven" \
	  io.k8s.description="This is a custom container image for dev tools" \
	  io.openshift.tags="self-hosted,openshift,jdk-11,maven"

MAINTAINER Zeeshan M Tufail <zeeshan.tufail@kfh.com>	

ENV LANGUAGE='en_US:en'
#ENV MAVEN_OPTS="-Duser.home=$HOME"
#ADD info.sh /tmp

#root user use to install packages like git,curl,less,iputils,nmap-ncat 
#nmap-ncat: installing nmap-ncat rpm and using "netcat" (ie. ncat, nc etc.) eg, nc -vz 127.0.0.1 22
#iputils: installing iputils rpm and using "ping"

USER root

#RUN microdnf --setopt=install_weak_deps=0  install yum ca-certificates -y
#RUN yum install -y less dig ping iputils && yum clean all
RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install nmap-ncat git iputils &&\
	microdnf update --nodocs -y &&\	
	microdnf clean all 

#   chgrp -R 0 /tmp &&\
#	chmod -R g=u /tmp &&\	
#	chown 1001 /tmp/info.sh && chmod 540 /tmp/info.sh	

# install maven
# NOTE: installing from upstream because version shipped in UBI repos is ancient (3.5) as of 7/23/21
#RUN curl -L https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
#      -o /usr/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
#    tar -xvf /usr/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr && \
#    rm -rf /usr/apache-maven-${MAVEN_VERSION}-bin.tar.gz	
#RUN mkdir -p $HOME/.m2

#ENV PATH "/usr/apache-maven-${MAVEN_VERSION}/bin:$PATH"

ADD m2.tar $HOME/.m2/	
#COPY settings.xml $HOME/.m2/


#RUN chown -R 1001:0 $HOME && \
#    chmod -R g+rw $HOME
	
#Add a USER instruction for an unprivileged user. 
#The Red Hat convention is to use userid 1001:
USER 1001

#CMD sh /tmp/info.sh
