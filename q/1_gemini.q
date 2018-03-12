param:.Q.def[`symlink`datalink`time!("https://api.gemini.com/v1/symbols";"https://api.gemini.com/v1/trades/";"30000")] .Q.opt .z.x      / Define paramaters with command line arguments optional

trades:([tid:`long$()];timestamp:`timestamp$();syms:`$();side:`$();price:`float$();amount:`float$());

getsyms:{.j.k .Q.hg `$param`symlink}                                                                                                     / Pull list of syms

getdata:{data:.j.k .Q.hg `$(param`datalink),x;dataformat [data;x]}
      
dataformat:{[x;y]`tid`timestamp`syms`side`price`amount xcols update `$side from `tid`price`amount`side xcol delete timestampms from update `long$tid, timestamp:`timestamp$1970.01.01D+1000000*timestampms, syms:`$y, "F"$price,"F"$amount from delete exchange,timestamp from x}

upsertdata:{upsert[`trades;x]}

tableform:{upsertdata each getdata each getsyms[]}

.z.ts:tableform
\t 30000


