
e3-ads  
======
ESS Site-specific EPICS IOC Application : ads

## Beckhoff ADS

We treat this Library as the Vendor library within e3. So this module has two git submodule links for twincat-ads and Beckhoff ADS. 

##

* Change the four variables in `configure/CONFIG_MODULE` according to what you want to. 

```
EPICS_MODULE_TAG:=master
E3_MODULE_VERSION:=master
ADS_MODULE_TAG:=7df1d60
ADS_MODULE_VERSION:=7df1d60
```



`````
$ make init
$ make adsinit
```


```
$ make build
$ make install
```
