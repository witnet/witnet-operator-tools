# What we wish to monitor

Blocks:
- Last block number and hash
- Current block reward

Transactions:
- Count of transactions inside last block
- Count of transactions inside last block discriminated per type

Mining:
- Miner of the last block
- Total miner fee in last block
- ~~Newcomer mining probability~~
- ~~Halving countdown~~

Reputation:
- Reputation Set graph (x: identity by highest REP, y: reputation)
- Alpha clock:
    - current alpha clock height (total number of reveal transactions that ever existed)
    - witnessing acts in last block (count of reveal transactions inside last block)
- Number of lying witnessing acts in the last block
- ~~Total issued reputation~~

~~Collaterals:~~
- ~~Total collateralized now~~
- ~~Total collateralized history~~

Extras:
- Map with IP geo-location
- ~~Mempool (to be discussed if it makes sense)~~

**Main identity list** (sortable by any field):
- PKH (identity)
- Is Active (ARS membership)
- Current reputation
- Count of mined blocks
- ~~Current collateralized value~~
- ~~Timestamp of last data request reveal~~

~~**Node list (more similar to ethstats)**~~
- ~~IP address~~
- ~~Witnet agent~~
- ~~Reported NTP time~~
- ~~Capabilities (full-node)~~
- ~~Blockchain height~~
- ~~Last block hash~~
- ~~Network latency (ping from cli to server)~~

~~If we adopt BLS+GRANDPA:~~
- ~~Fork visualizer~~
