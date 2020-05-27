FROM centos:7

MAINTAINER SoftwareAG

RUN set -x && \
    curl -s -S https://github.com/pnl09y9r/webMethods_Container_Image.git/ | tar xvz -C /opt && \

COPY ./jvm/jvm/ /sag/jvm/jvm/
ENV JAVA_HOME /sag/jvm/jvm

COPY ./install/jars/ /sag/install/jars/

#Comment the line below for 9.7 version of Integration Server
COPY ./install/profile/ /sag/install/profile/

COPY ./install/products/ /sag/install/products/

COPY ./Licenses/ /sag/Licenses/sagosch

COPY ./common/bin/ /sag/common/bin/
COPY ./common/conf/ /sag/common/conf/
COPY ./common/lib/ /sag/common/lib/
COPY ./common/runtime/ /sag/common/runtime/

COPY ./WS-Stack/ /sag/WS-Stack/

COPY ./IntegrationServer/bin/ /sag/IntegrationServer/bin/
COPY ./IntegrationServer/lib/ /sag/IntegrationServer/lib/
COPY ./IntegrationServer/sdk/ /sag/IntegrationServer/sdk/
COPY ./IntegrationServer/updates/ /sag/IntegrationServer/updates/
COPY ./IntegrationServer/web/ /sag/IntegrationServer/web/
COPY ./IntegrationServer/.tc.dev.log4j.properties /sag/IntegrationServer/.tc.dev.log4j.properties

COPY ./IntegrationServer/instances/default/ /sag/IntegrationServer/instances/default/
COPY ./IntegrationServer/instances/lib/ /sag/IntegrationServer/instances/lib/

COPY ./IntegrationServer/instances/is_instance.xml /sag/IntegrationServer/instances/is_instance.xml
COPY ./IntegrationServer/instances/is_instance.sh /sag/IntegrationServer/instances/is_instance.sh
COPY ./profiles/IS_default/configuration/custom_wrapper.conf /sag/IntegrationServer/instances/custom_wrapper.conf.template

RUN cd /sag/IntegrationServer/instances; ./is_instance.sh updateServerCnfFile -Dinstance.name=default
RUN cd /sag/IntegrationServer/instances; ./is_instance.sh create-osgi-profile -Dinstance.name=default

CMD cd /sag/profiles/IS_default/bin && ./console.sh

EXPOSE 5555
EXPOSE 9999
