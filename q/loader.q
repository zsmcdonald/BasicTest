\c 25 250

st:.z.p
// Set directory to save to and where to read from
hdb:`:hdb
dir:`:data

//files:{[dir]
//   filelist:raze key each ` sv' dir,'filelist:key dir:hsym dir;
//   filelist:` sv' dir,'filelist;
//   :filelist:filelist where filelist like "*.csv";
//  :filelist::string each filelist;
//  }

// Find full file paths, recursive search through folders
isFolder:{[folder]
    :(not ()~fc) & not folder~fc:key folder;
 }

tree:{[root]
    rc:` sv/:root,/:key root;
    folders:isFolder each rc;
    filelist:raze (rc where not folders),.z.s each rc where folders;
    :filelist:filelist where filelist like "*.xlsx.csv";
  }

// String paths after search
f:{string x}'[tree[dir]]
a:f[]

// List of file names only
list1:last each 3 cut raze "/" vs ' a

// Group lists of files by schema
file1:a where not a like "*State.xlsx.csv"
file1:file1 where not file1 like "*rainfall*"
file2:a where a like "*State.xlsx.csv"
file3:a where a like "*rainfall*"

// List of file names only
list1:last each 3 cut raze "/" vs ' file1
list2:last each 3 cut raze "/" vs ' file2
list3:last each 3 cut raze "/" vs ' file3

/{x insert (y;enlist ",") 0:z}'[(table names);("schema of tables");(hsym'ed file paths )]

lg:{-1(string .z.p)," ",x}

lg"Loading in first schema data set";
tab:{[x;y]update file:`$y from ("*CCSSSS"; enlist ",") 0:x}'[`$file1;list1];
lg"Formatting data";
tab:uj/[tab];
delete x,x1 from `tab;
lg"Changing time to kdb format";
indexes:exec i from `tab where Time like "*0:00";
update Time:"p"$"D"$-5_'Time from `tab where i in indexes;
update Time:"P"$Time from `tab where not i in indexes;

.z.p-st
