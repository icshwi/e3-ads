
e3-ads  
======
ESS Site-specific EPICS IOC Application : ads

## Beckhoff ADS

We treat this Library as the Vendor library within e3. So this module has two git submodule links for twincat-ads and Beckhoff ADS. We only test this module within host `linux-x86_64` only. 


## Commands

* Change the four variables in `configure/CONFIG_MODULE` according to what you want to. 

```
EPICS_MODULE_TAG:=master
E3_MODULE_VERSION:=master
ADS_MODULE_TAG:=7df1d60
ADS_MODULE_VERSION:=7df1d60
```
* Patch is needed to compile ADS into shared lib.

```
make adsinit
make adspatch
make adsbuild
```



```
$ make init
$ make build
$ make install
```
