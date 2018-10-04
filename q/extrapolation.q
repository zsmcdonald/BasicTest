// Query for extrapolating data from kdb side, taking into account UTC vs BTS timezones. This is to be run on the hdb of PowerOn TorQ system
select (sum consumptionw*{((00:00+d+1)-x)^next deltas[00:00+d:`date$first x;x]}[time])%0D00:01 from select time,consumptionw from battery_status where date=2018.09.05,sym=`50007
