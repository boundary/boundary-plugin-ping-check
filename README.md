# Boundary Ping Check Plugin

Pings a set of hosts and reports on the response time. The plugin allows multiple hosts to be ping'd and each of those hosts to set their own Poll interval. See video [walkthrough](https://help.boundary.com/hc/articles/201383932).
Note: Currently does not support SmartOS.

### Prerequisites

#### Supported OS

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |    v    |    -    |  v   |

#### Boundary Meter versions v4.2 or greater

- To install new meter go to Settings->Installation or [see instructons](https://help.boundary.com/hc/en-us/sections/200634331-Installation).
- To upgrade the meter to the latest version - [see instructons](https://help.boundary.com/hc/en-us/articles/201573102-Upgrading-the-Boundary-Meter).

#### Boundary Meter versions less than v4.2

|  Runtime | node.js | Python | Java |
|:---------|:-------:|:------:|:----:|
| Required |    +    |        |      |

- [How to install node.js?](https://help.boundary.com/hc/articles/202360701)

### Plugin Setup

None

### Plugin Configuration Fields

|Field Name     |Description                                                                       |
|:--------------|:---------------------------------------------------------------------------------|
|Source         |The source to display in the legend for the host. Ex. google                      |
|Host           |The Hostname or IP Address to ping.  For example, www.google.com or 173.194.33.112|
|Poll Time (sec)|The Poll Interval to send a ping to the host in seconds. Ex. 5                    |

### Metrics Collected

|Metric Name       |Description                            |
|:-----------------|:--------------------------------------|
|Ping Response Time|The response time from the ping command|

### Dashboards

None

### References

None

