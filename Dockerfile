FROM jboss/base-jdk:7

MAINTAINER "Robert Greathouse" "robert@opensourcearchitect.co"

USER root

RUN mkdir -p /Users/robertgreathouse/Downloads/jboss-eap-6.4/standalone/log && \
    chown -R jboss:jboss /Users/robertgreathouse/Downloads/jboss-eap-6.4/standalone/log

USER jboss

### Install EAP 6.4. Already patched to 6.4.4
ADD installs/jboss-eap-6.4.zip /tmp/jboss-eap-6.4.zip
ADD installs/self-install-script-bpm-6.2-eap-6.4.4.xml /tmp/self-install-script-bpm-6.2-eap-6.4.4.xml
ADD installs/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar /tmp/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar
ADD installs/repositories.zip /tmp/repositories.zip

### Set Environment
ENV JBOSS_HOME /opt/jboss/jboss-eap-6.4.4

RUN unzip /tmp/jboss-eap-6.4.zip -d /opt/jboss && \
    echo "Adding admin user." && \
    $JBOSS_HOME/bin/add-user.sh admin admin123! --silent && \
    echo "Setting bind address in $JBOSS_HOME/bin/standalone.conf" && \
    echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf && \
    echo "Installing jBPM." && \
    java -jar /tmp/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar /tmp/self-install-script-bpm-6.2-eap-6.4.4.xml && \
    unzip -uo /tmp/repositories.zip -d /opt/jboss

### Open Ports
EXPOSE 8080 9990 9999

### Start EAP
CMD $JBOSS_HOME/bin/standalone.sh