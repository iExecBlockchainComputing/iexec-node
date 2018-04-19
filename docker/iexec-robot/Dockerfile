FROM ubuntu:trusty
USER root
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qy python-pip groff-base
RUN pip install robotframework
RUN pip install robotframework-selenium2library
RUN pip install robotframework-databaselibrary
RUN pip install robotframework-archivelibrary
RUN pip install pymysql
RUN apt-get -y install curl zip unzip wget make ant gcc vim git
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs
# Setup volumes for input and output
VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests
ENTRYPOINT ["robot"]
