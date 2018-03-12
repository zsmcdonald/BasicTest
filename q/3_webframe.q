/ Script to load messages upon connecting to port via web browser
\p 16666i
.bob.date:{(raze "The current time and date is ", string .z.P;
           "The current day is ",string `Saturday`Sunday`Monday`Tuesday`Wednesday`Thursday`Friday .z.D mod 7)}


.z.ph:{[x]
 x:.h.uh $[type x;x;first x];
 $[not count x; //1
 .h.hy[`htm;.h.hta[`link;(`rel;`href)!("A quack favicon";"http://www.aquaq.co.uk/favicon.ico")],.h.htc[`main].h.htc[`title;"This is the best title"],.h.htac[`frameset;(enlist `cols)!enlist"5%,95%"](.h.hta[`frame;(enlist `src)!enlist"?"],.h.htac[`frameset;(enlist `rows)!enlist "35%,65%"](.h.hta[`frame;(enlist `src)!(enlist(.h.code["?.bob.date[]"]))],.h.hta[`frame;enlist[`src]!(enlist (first string system"v"))]))]; 
 x~enlist "?"; //2
 .h.hp[{.h.hb["?",x; x]}each string system"v"];
 "?["~2#x; //3
 .h.hp[.h.jx["J"$2_x; .h.R]];
 "?"=first x; //4
 @[{.h.hp[.h.jx[0j;.h.R::1_x]]};x;.h.he];
 "?" in x; //5
 @[{.h.ht[t;] ` sv .h.tx[t:`$-3#n#x;value
 ( 1+n:x?"?")_x]};x;.h.he];
 count r:@[1:;`$":",p:.h.HOME,"/",x;""]; //6
 .h.hy[`$(1+x?".")_x; string r];
 .h.hn["404 Not Found";`txt;p,": not found"]]};

/.z.ph:{.h.hp (.h.html "<head><title>This is not a good webpage</title></head>";"<body><img src=https://www.aquaq.co.uk/wp-content/uploads/2014/05/rsz_1aquaq_logo1.png alt=AquaQ height=175 width=400></body>";"The current time and date is ",string .z.p;"The current day is ",string `Saturday`Sunday`Monday`Tuesday`Wednesday`Thursday`Friday .z.d mod 7) }




