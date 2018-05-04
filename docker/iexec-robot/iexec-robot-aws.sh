apt-get update

apt-get install -y software-properties-common curl zip unzip wget make ant gcc vim git apt-transport-https
add-apt-repository -y ppa:openjdk-r/ppa

add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

curl -L https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu

apt-get install -y -qy python-pip groff-base
pip install robotframework
pip install robotframework-selenium2library
pip install robotframework-databaselibrary
pip install robotframework-archivelibrary
pip install pymysql


curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs

# install gradle
apt-get -y install openjdk-8-jdk

cd /usr/local
curl -L https://services.gradle.org/distributions/gradle-4.7-bin.zip -o gradle-4.7-bin.zip
unzip gradle-4.7-bin.zip
rm gradle-4.7-bin.zip


export GRADLE_HOME=/usr/local/gradle-4.7
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export PATH=$PATH:$GRADLE_HOME/bin