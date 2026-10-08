#
# NOTICE sample environment
#

ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:latest-em
FROM $IMAGE

USER root

# create directories for testing environment
RUN mkdir -p /opt/notice/app /opt/notice/db

# copy source code
WORKDIR /opt/notice
COPY . app

# change ownership
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/notice
USER ${ISC_PACKAGE_MGRUSER}

# download latest zpm version
#RUN wget https://pm.community.intersystems.com/packages/zpm/latest/installer -O /tmp/zpm.xml

# run iris.script
WORKDIR /opt/notice/app
RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly