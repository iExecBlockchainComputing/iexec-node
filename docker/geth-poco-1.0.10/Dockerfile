FROM ubuntu:trusty

COPY node1 /node1
COPY premine.sh /premine.sh
COPY devnet.json /devnet.json
COPY giveRlc.js /giveRlc.js

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update -q
RUN apt-get install -y ethereum
RUN apt-get install -y build-essential

RUN apt-get install -y curl
RUN apt-get install -y git

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN git clone https://jeremyjams:<TOKEN_HERE>@github.com/iExecBlockchainComputing/PoCo.git

RUN chmod +x premine.sh
RUN ./premine.sh

ENTRYPOINT nohup geth --datadir node1/ --rpc --rpcvhosts '*' --rpcaddr '0.0.0.0' --rpcport 8545 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --networkid 1337 --gasprice '1' --unlock '1fa8602668d4bda4f45a25c8def0a619499457db,8bd535d49b095ef648cd85ea827867d358872809,70a1bebd73aef241154ea353d6c8c52d420d4f5b, 55b541c70252aa3eb1581b8e74ce1ec17126b33a' --password node1/password.txt --mine & bash

EXPOSE 8545
