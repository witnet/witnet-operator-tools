## Usage

#### Creating instance of witnet
```
./witnet.sh create -s 1 -e 5
```
This will create `witnet1` to `witnet5` in the home directory and also start all of them.



#### Viewing logs
Viewing journalctl of  witnet`n`.service
```
./witnet.sh status -s 1 -e 5
```
Similarily for any n instance number.

#### Starting service
Starting witnet`n`.service
```
./witnet.sh start -s 1 -e 5
```

#### Stopping service
Stopping witnet`n`.service
```
./witnet.sh stop -s 1 -e 5
```

#### For checking the reputation of every witnet instance.
Querying the node witnet`n`.service
```
./witnet.sh run -c "node reputation"
```

#### For checking the version of every witnet instance.
Querying the node witnet`n`.service
```
./witnet.sh run -c "node --version"
```

#### Upgrading service to latest version
Upgrading witnet`n`.service
```
./witnet.sh upgrade -s 1 -e 5
```

#### Options
```
    -h (print this message)
    -s is the start number # if not provided deault value is 1
    -e is the end number # if not provided default value is same as start valuee
    -c command to run # only works with run mode 
```

```
./witnet.sh -h # or ./witnet.sh help
```
