
## Robotframework tests

### Prerequisite 

ubuntu with :

```
apt-get -y install openjdk-8-jdk
apt-get install -y -qy python-pip groff-base
apt-get -y install uuid-runtime
apt-get install -y mysql-client
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
apt-get install -y mysql-server
pip install robotframework
pip install robotframework-selenium2library
pip install robotframework-databaselibrary
pip install pymysql

```
The above dependency are already in your local vagrant

### Launch xtremweb robotframework tests
```

cd ~/iexecdev/iexec-node/tests/rf
pybot -d Results ./Tests/
```

Open report.html to see results :
```
Output:  /home/vagrant/iexecdev/iexec-node/tests/rf/Results/output.xml
Log:     /home/vagrant/iexecdev/iexec-node/tests/rf/Results/log.html
Report:  /home/vagrant/iexecdev/iexec-node/tests/rf/Results/report.html
```
