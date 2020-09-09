# witnet-operator-tools
## Upgrading Docker-compose operated node(s)
### Go inside the operator directory you have used to start
- for only one node :
```
cd witnet-operator-tools/docker/compose/bertux-operator-stable
```
- for 5 nodes :
```
cd witnet-operator-tools/docker/compose/bertux-operator-5
```
### Shutdown the node(s)
- by running :
```
docker-compose down
```
- you should see :
```
Stopping bertuxoperatorstable_node_1 ... done
Removing bertuxoperatorstable_node_1 ... done
```
### Upgrade the node image
- by running :
```
docker-compose pull
```
- you should see :
```
Pulling node ... done
```
### Start the node(s)
- by running :
```
docker-compose up -d
```
- you should see at least :
```
Creating bertux-operator-stable_node_1 ... done
```
### Check the current version running
- by running :
```
./getVersion.sh
```
- you should see the latest version number :
```
witnet-node 0.8.1
```
### Check the peers of your node(s)
- by running :
```
./getPeers.sh
```
- you should see at least this table and you should have nearly 8 `outbound` lines and many `inbound` lines :
```
Loading config from: /witnet.toml
Setting log level to: DEBUG, source: Config
 Address               | Type
-----------------------+----------
[2020-05-21T13:33:51Z DEBUG witnet_data_structures] Set environment to testnet
[2020-05-21T13:33:51Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
```
### Check the stats of your node(s)
- by running :
```
./nodeStats.sh
```
- you should see :
```
Loading config from: /witnet.toml
Setting log level to: DEBUG, source: Config
Block mining stats:
- Proposed blocks: 144
- Blocks included in the block chain: 17
Data Request mining stats:
- Times with eligibility to mine a data request: 0
- Proposed commits: 0
- Accepted commits: 0
- Slashed commits: 0
[2020-05-21T13:37:20Z DEBUG witnet_data_structures] Set environment to testnet
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
```
### Export the private keys of your node(s) in an archive (procedure for 5 nodes docker-compose file)
- by running :
```
cd witnet-operator-tools/docker/compose/bertux-operator-5
./masterKeyExport.sh
```
- you should see :
```
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
```
- an archive will be created as `master_keys_20200521133720.tar.gz` (the last part is the current date)
- it will contain all the private keys, as per this structure :
```bash
.
├── node
│   └── private_key_twit1xxxxxxx.txt
├── node2
│   └── private_key_twit1xxxxxxx.txt
├── node3
│   └── private_key_twit1xxxxxxx.txt
├── node4
│   └── private_key_twit1xxxxxxx.txt
└── node5
    └── private_key_twit1xxxxxxx.txt
```
### Export the signed claim of your node(s) in an archive (procedure for 5 nodes docker-compose file)
- by running :
```
cd witnet-operator-tools/docker/compose/bertux-operator-5
./claimExport.sh WIT_ID
```
- you should see :
```
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
[2020-05-21T13:37:20Z INFO  witnet::cli::node::json_rpc_client] Connecting to JSON-RPC server at 127.0.0.1:21338
```
- an archive will be created as `claim-WIT_ID.tar.gz` (the last part is the current date)
- it will contain all the claims, as per this structure :
```bash
.
├── node
│   └── claim-WIT_ID-twit1xxxxxxx.txt
├── node2
│   └── claim-WIT_ID-twit1xxxxxxx.txt
├── node3
│   └── claim-WIT_ID-twit1xxxxxxx.txt
├── node4
│   └── claim-WIT_ID-twit1xxxxxxx.txt
└── node5
    └── claim-WIT_ID-twit1xxxxxxx.txt
```
