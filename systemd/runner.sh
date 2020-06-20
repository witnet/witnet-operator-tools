#!/bin/bash
set -e
set -u
#set -x
VERSION="latest"
COMPONENT="node"
MODE="server"

if [[ "$VERSION" == "latest" ]]; then
    VERSION=`curl https://github.com/witnet/witnet-rust/releases/latest --cacert /etc/ssl/certs/ca-certificates.crt 2>/dev/null | egrep -o "[0-9|\.]{5}(-\w+)?"`
fi

TRIPLET=`bash --version | head -1 | sed -En 's/^.*\ \((.+)-(.+)-(.+)\)$/\1-\2-\3/p'`

if [[ "$TRIPLET" == *"linux"* ]]; then
    TRIPLET=`echo $TRIPLET | sed 's/pc/unknown/g'`
fi

URL="https://github.com/witnet/witnet-rust/releases/download/$VERSION/witnet-$VERSION-$TRIPLET.tar.gz"

FILENAME="$VERSION.tar.gz"
FOLDERNAME="/home/witnet/$COMPONENT"
mkdir -p ${FOLDERNAME}/.witnet/config
touch ${FOLDERNAME}/witnet.toml

echo "Downloading 'witnet-$VERSION-$TRIPLET.tar.gz'. It may take a few seconds..."
curl -L $URL -o /tmp/${FILENAME} --cacert /etc/ssl/certs/ca-certificates.crt
echo "Finished download of witnet-rust $COMPONENT on version $VERSION for $TRIPLET"

echo "Saving current configuration in ${FOLDERNAME}.old only during the install"
mv ${FOLDERNAME} ${FOLDERNAME}.old

echo "Extracting $COMPONENT version $VERSION for $TRIPLET in ${FOLDERNAME}..."
mkdir ${FOLDERNAME}
tar -zxf /tmp/${FILENAME} --directory ${FOLDERNAME}
chmod +x $FOLDERNAME/witnet
echo "Finished extraction of $COMPONENT version $VERSION for $TRIPLET in ${FOLDERNAME}"

echo "Restoring saved configuration in ${FOLDERNAME}..."
mv ${FOLDERNAME}.old/.witnet ${FOLDERNAME}/
mv ${FOLDERNAME}.old/witnet.toml ${FOLDERNAME}/witnet.toml.old
rm -rf ${FOLDERNAME}.old
mv ${FOLDERNAME}/genesis_block.json ${FOLDERNAME}/.witnet/config/genesis_block.json
./ipconfig.sh
echo "Finished restore of saved configuration in ${FOLDERNAME}"

echo "Your newly installed version is :"
${FOLDERNAME}/witnet ${COMPONENT} ${MODE} --version
echo "to see differences between old and new configurations run: diff ${FOLDERNAME}/witnet.toml*"
echo "to start it run as privileged user: sudo systemctl start witnet"
echo "Finished installing a witnet-rust $COMPONENT on version $VERSION for $TRIPLET"
