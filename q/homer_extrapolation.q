// Set \z 1 for given csv date format
\z 1 

// Load in DataWattage csv and rename columns
datawatt:("IPIIII"; enlist ",") 0: 1_read0 `:/data/shared/DataWattage.csv;
datawatt: `unixts`time`discharge`charge`production`consumption xcol datawatt;
delete from `datawatt where null unixts;


// Load in YearsData csv and rename columns
datayear:("IPFFFFFFI"; enlist ",") 0: 2_read0 `:/data/shared/YearsData.csv;
datayear: `unixts`time`discharge`production`consumption`feed`grid`charge xcol datayear
update consumption:60*consumption,production:60*production from `datayear;


// Open connection to kdb HDB
h1::hopen `:54.194.1.54:7003:rdb:pass

// Create empty table
contab:([date:()]consumptionCSV:();consumptionHDB:());
prodtab:([date:()]productionCSV:();productionHDB:());


// If using dates from <2018.08.26 then change concsv to take from datawatt. If taking from after 2018.08.26 then use datayear.
// This has been kept general as future formats are unknown.
// First half extracts consumption data from csv sources. Second half takes from hdb
// Querying the kdb data currently takes into account csv data being UTC and kdb data being BST - this will not always be necessary.
// Example usage con'[2018.09.01+ til 25] - this will push the data to contab
con:{[sdate]
 fdate:sdate+1;
 sdatetime:01:00+"p"$sdate;
 fdatetime:01:00+"p"$fdate;
 concsv:"f"$exec sum consumption from datawatt where time.date within (sdate;fdate), time within (sdatetime;fdatetime);

 conhdb:h1"exec (sum consumptionw*{((00:00+d+1)-x)^next deltas[00:00+d:`date$first x;x]}[time])%0D00:01 from select time,consumptionw from battery_status where date=",string [sdate],",sym=`50007";
 `contab upsert ([]date:enlist [sdate];consumptionCSV:concsv;consumptionHDB:conhdb);
  update diff:((consumptionHDB-consumptionCSV)%consumptionCSV)*100 from `contab;
 }

prod:{[sdate]
 fdate:sdate+1;
 sdatetime:01:00+"p"$sdate;
 fdatetime:01:00+"p"$fdate;
 prodcsv:"f"$exec sum production from datawatt where time.date within (sdate;fdate), time within (sdatetime;fdatetime);

 prodhdb:h1"exec (sum productionw*{((00:00+d+1)-x)^next deltas[00:00+d:`date$first x;x]}[time])%0D00:01 from select time,productionw from battery_status where date=",string [sdate],",sym=`50007";
 `prodtab upsert ([]date:enlist [sdate];productionCSV:prodcsv;productionHDB:prodhdb);
  update diff:((productionHDB-productionCSV)%productionCSV)*100 from `prodtab;
 }

