`x xdesc select count i,"n"$avg d,max d by sym,src,status from (`d xdesc `d xcols update d:resptime-time from {[x]req lj delete time from `src`rid`oid`side`sym xkey update rid:reqid,resptime:time from resp}[])

htimes:{[x];
   resp:delete time from `src`rid`oid`side`sym xkey update rid:reqid,resptime:time from resp;
   tab:req lj resp;
   tab:`d xdesc `d xcols update d:resptime-time from tab;
   :`x xdesc select count i,"n"$avg d,max d by sym,src,status from tab;
   }
