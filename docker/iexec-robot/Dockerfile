FROM ubuntu:trusty
USER root
RUN apt-get update
RUN apt-get install -y software-properties-common curl zip unzip wget make ant gcc vim git apt-transport-https
# install java repo
RUN add-apt-repository -y ppa:openjdk-r/ppa
# install docker repo
RUN add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# install docker compose
RUN curl -L https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN apt-get update
# install docker
RUN apt-get install -y docker-ce

#install python and robot lib
RUN apt-get install -y -qy python-pip groff-base
RUN pip install robotframework
RUN pip install robotframework-selenium2library
RUN pip install robotframework-databaselibrary
RUN pip install robotframework-archivelibrary
RUN pip install pymysql

#install node
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

# install gradle
RUN apt-get -y install openjdk-8-jdk
RUN \
    cd /usr/local && \
    curl -L https://services.gradle.org/distributions/gradle-4.7-bin.zip -o gradle-4.7-bin.zip && \
    unzip gradle-4.7-bin.zip && \
    rm gradle-4.7-bin.zip

# Export some environment variables
ENV GRADLE_HOME=/usr/local/gradle-4.7
ENV PATH=$PATH:$GRADLE_HOME/bin JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ENTRYPOINT ["robot"]
