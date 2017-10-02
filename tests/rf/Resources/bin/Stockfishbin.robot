*** Settings ***
Library  Process

*** Variables ***

${STOCKFISH_GIT_URL} =  https://github.com/iExecBlockchainComputing/Stockfish.git
${STOCKFISH_GIT_BRANCH} =  master
${STOCKFISH_FORCE_GIT_CLONE} =  false
${BIN_PATH} =  /home/vagrant/iexecdev/iexec-node/Stockfish/src/stockfish


*** Keywords ***

Git Clone Stockfish
    Remove Directory  Stockfish  recursive=true
    ${git_result} =  Run Process  git clone -b ${STOCKFISH_GIT_BRANCH} ${STOCKFISH_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Compile Stockfish
    Git Clone Stockfish
    ${result} =  Run Process  cd Stockfish/src && make -e EXTRALDFLAGS\="-static-libgcc -static-libstdc++" ARCH\=x86-64 build  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0

Get Stockfish Bin Path
    [Return]  ${BIN_PATH}


