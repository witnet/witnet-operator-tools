#!/bin/bash
set -e

VERSION="latest"
COMPONENT="node"
MODE="server"
RED='\x1B[1;31m'
INFO='\x1B[1;36m'
OKGREEN='\x1B[1;32m'
ENDC='\x1B[0m'
BOLD="\x1B[1m"

SUDO=""
if [ "$EUID" -ne 0 ]
then
  SUDO=sudo
fi

function PassPrint() {
    echo -e "$OKGREEN$@$ENDC"
}
function InfoPrint() {
    echo -e "$INFO$@$ENDC"
}
function FailPrint() {
    echo -e "$RED$@$ENDC"
}
function BPrint() {
    echo -e "$BOLD$@$ENDC"
}

function prerequisites {
  #Prerequisites function
  DISTRO=$(cat /etc/*-release | grep -w "ID")
  if [[ $DISTRO == *"linuxmint"* ]] || [[ $DISTRO == *"ubuntu"* ]] || [[ $DISTRO == *"debian"* ]] || [[ $DISTRO == *"elementary"* ]]; then
        $SUDO apt update -qq 
        $SUDO apt install -y ca-certificates
        $SUDO update-ca-certificates
  else
    FailPrint "Unsupported DISTRO..."
    exit
   fi
}

printHelp() {
  PassPrint "Usage: "
  echo "  ctb.sh <mode>"
  echo "    <mode> - one of 'create', 'status', 'start', 'stop' or 'run'"
  echo "      - `BPrint create` - create intances of witnet"
  echo "      - `BPrint status` - status of witnet instance"
  echo "      - `BPrint start` - start witnet instance"
  echo "      - `BPrint stop` - stop witnet instance"
  echo "      - `BPrint run` - query witnet instance"
  echo
  echo "    -h (print this message)"
  echo "    -s is the start number # if not provided default value is 1"
  echo "    -e is the end number # if not provided default value is same as start valuee"
  echo "    -c command to run # only works with `BPrint run` mode "
}

RUN=$1
shift
while getopts "s:e:c:" opt; do
  case "$opt" in
  h | \?)
    printHelp
    exit 0
    ;;
    s)  START=$OPTARG
    ;;
    e)  END=$OPTARG
    ;;
    c)  CMD=$OPTARG
    ;;
  esac
done
START=${START:-1}
END=${END:-$START}

startNode (){
    n=$1
    PORT=$(( 21336 + $n*2 ))
    RPCPORT=$(( 21337 +$n*2 ))
    FOLDERNAME="$HOME/witnet$n"
    echo "Extracting $COMPONENT version $VERSION for $TRIPLET in ${FOLDERNAME}..."
    set +e ; mkdir ${FOLDERNAME} ; set -e
    tar -zxf /tmp/${FILENAME} --directory ${FOLDERNAME}
    chmod +x $FOLDERNAME/witnet
    echo "Finished extraction of $COMPONENT version $VERSION for $TRIPLET in ${FOLDERNAME}"
    echo "Restoring saved configuration in ${FOLDERNAME}..."
    set +e; mkdir -p ${FOLDERNAME}/.witnet ; set -e
    sed -i "s#127.0.0.1:21338#127.0.0.1:$RPCPORT#g" ${FOLDERNAME}/witnet.toml
    sed -i "s#0.0.0.0:21337#0.0.0.0:$PORT#g" ${FOLDERNAME}/witnet.toml
    echo "Finished restore of saved configuration in ${FOLDERNAME}"

    PassPrint "Your newly installed version is :"
    ${FOLDERNAME}/witnet ${COMPONENT} ${MODE} --version
    echo "Finished installing a witnet-rust $COMPONENT on version $VERSION for $TRIPLET"
    echo "
    [Unit]
    Description=Witnet Node
    After=network.target auditd.service
    Wants=network.target
    [Service]
    WorkingDirectory=$FOLDERNAME
    ExecStart=$FOLDERNAME/witnet node server
    User=$USER
    Group=$USER
    Restart=always
    RestartSec=5s
    LimitNOFILE=4096

    [Install]
    WantedBy=multi-user.target
    Alias=witnet$n.service
    " > /tmp/witnet$n.service
    $SUDO mv /tmp/witnet$n.service /etc/systemd/system/witnet$n.service
    $SUDO systemctl daemon-reload
    $SUDO systemctl start witnet$n.service
}

setup(){
  # check distro and instal ca-certificates
  prerequisites

  if [ "$VERSION" == "latest" ]; then
    VERSION=`curl https://github.com/witnet/witnet-rust/releases/latest --cacert /etc/ssl/certs/ca-certificates.crt 2>/dev/null | egrep -o "[0-9|\.]{5}(-rc[0-9]+)?"`
  fi
  
  TRIPLET=`bash --version | head -1 | sed -En 's/^.*\ \((.+)-(.+)-(.+)\)$/\1-\2-\3/p'`
  
  if [[ "$TRIPLET" == *"linux"* ]]; then
      TRIPLET=`echo $TRIPLET | awk -F'-' '{printf $1"-unknown-"$3"-"$4}'`
  fi
  URL="https://github.com/witnet/witnet-rust/releases/download/$VERSION/witnet-$VERSION-$TRIPLET.tar.gz"
  InfoPrint "Downloading 'witnet-$VERSION-$TRIPLET.tar.gz'. It may take a few seconds..."
  FILENAME="$VERSION.tar.gz"
  curl -L $URL --cacert /etc/ssl/certs/ca-certificates.crt -o /tmp/${FILENAME} 
  echo "Finished download of witnet-rust $COMPONENT on version $VERSION for $TRIPLET"
  for i in $(seq $START $END)
  do
      PassPrint "creating witnet$i in $HOME/witnet$i"
      startNode $i
  done
}

if [[ $RUN == "create" ]] 
then 
    setup
elif [[ $RUN == "stop" ]] 
then
    for i in $(seq $START $END)
    do
        PassPrint "stopping witnet$i.service"
        $SUDO systemctl stop witnet$i.service
    done
elif [[ $RUN == "start" ]] 
then
    for i in $(seq $START $END)
    do
        PassPrint "starting witnet$i.service"
        $SUDO systemctl start witnet$i.service
    done
elif [[ $RUN == "run" ]] 
then
    if [[ -z "$CMD" ]] ; then 
        FailPrint "command not provided use -c for specifying one"
        exit 0
    fi
    for i in $(seq $START $END)
    do
        PassPrint "Fetching $CMD for witnet$i"
        cd ~/witnet$i
        set +e
        ./witnet $CMD
        set -e
    done
elif [[ $RUN == "status" ]] 
then
    for i in $(seq $START $END)
    do
        PassPrint "Status of witnet$i.service"
        $SUDO systemctl status witnet$i.service | cat
    done
elif [[ $RUN == "upgrade" ]] 
then
    for i in $(seq $START $END)
    do
        PassPrint "stopping witnet$i.service"
        $SUDO systemctl stop witnet$i.service
    done
    setup
else
    printHelp
fi