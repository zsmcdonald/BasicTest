\c 25 250
st:.z.p

// Display log to standard out
lg:{-1(string .z.p)," ",x}

// Set directory to save to and where to read from
hdb:`:splaytab
dir:`:data

// Find full file paths, recursive search through folders
isFolder:{[folder]
    :(not ()~fc) & not folder~fc:key folder;
 }

tree:{[root]
    rc:` sv/:root,/:key root;
    folders:isFolder each rc;
    filelist:raze (rc where not folders),.z.s each rc where folders;
    :filelist:filelist where filelist like "*.csv";
  }

// String paths after search
lg"Finding full file paths";
f:{string x}'[tree[dir]]
a:f[]

// Group lists of files by schema
lg"Grouping files by schema";
file1:a where not a like "*State.csv"
file1:file1 where not file1 like "*rainfall*"
file2:a where a like "*State.csv"
file3:a where a like "*rainfall_*"
file4:a where a like "*rainfall.*"

// List of file names only
lg"Format file names";
list1:-4_'ssr[;" ";""] each last each 3 cut raze "/" vs ' file1
list2:-4_'ssr[;" ";""] each last each 3 cut raze "/" vs ' file2
list3:-4_'ssr[;" ";""] each last each 3 cut raze "/" vs ' file3
list4:-4_'ssr[;" ";""] each last each 3 cut raze "/" vs ' file4

// Load in first schema dataset
lg"Loading in first schema data set";
tab1:{[x;y]update sym:y from ("*ISSSSS"; enlist ",") 0:x}'[`$file1;`$list1];
lg"Concatenating data";
tab1:uj/[tab1];
delete x,x1 from `tab1;
lg"Changing time to kdb format";
/update Time:ssr[;"  ";" "]each Time from `tab1;
/indexes:exec i from `tab1 where Time like "* 0:00";
/update Time:"p"$"D"$-5_'Time from `tab1 where i in indexes;
/update Time:"P"$Time from `tab1 where not i in indexes;
\z 1
update Time:"P"$Time from `tab1;
lg"Reformating for typical kdb use";
tab1:`time`value`state`quality`reason`status`suppressiontype`sym xcol tab1;
`sym`time xasc `tab1;

// Load in second schema dataset
lg"Loading in second schema data set";
tab2:{[x;y]update sym:y from ("S**SSSS";enlist ",") 0:x}'[`$file2;`$list2];
lg"Concatenating data";
tab2:uj/[tab2];
delete x,x1,x2,x3 from `tab2;
lg"Changing time to kdb format";
update Time:ssr[;"  ";" "]each Time from `tab2;
update Time:"P"$Time from `tab2;
lg"Reformating for typica kdb use";
tab2:`time`severity xcols `severity`time`message`user`category`areaofinterest`userlocation`sym xcol tab2;
`sym`time xasc `tab2;

// Load in third schema dataset
lg"Loading in third schema data set";
tab3:{[x;y]update sym:y from ("*F";enlist ",") 0:first x}[first `$file3;first `$list3];
lg"Reformating tables";
tab3:`time`rainfalldepth`sym xcol tab3;
update time:"P"$time from `tab3;

// Load in fourth schema dataset
lg"Loading in fourth schema data set";
tab4:{[x;y]update sym:y from ("*F";enlist ",") 0:first x}[first `$file4;first `$list4];
lg"Reformating tables";
tab4:`time`value`sym xcol tab4;
update time:"P"$time from `tab4;

// Save down tables splayed in dir
lg"Saving down tables";
`:splaytab/tab1/ set .Q.en[`:splaytab]tab1;
`:splaytab/tab2/ set .Q.en[`:splaytab]tab2;
`:splaytab/tab3/ set .Q.en[`:splaytab]tab3;
`:splaytab/tab4/ set .Q.en[`:splaytab]tab4;
lg"Loader complete";

.z.p-st
