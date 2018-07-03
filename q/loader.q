\c 25 250
b:(125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 1023 1081)


st:.z.p
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
file3:a where a like "*rainfall_*"
file4:a where a like "*rainfall.*"

// List of file names only
list1:last each 3 cut raze "/" vs ' file1
list2:last each 3 cut raze "/" vs ' file2
list3:last each 3 cut raze "/" vs ' file3
list4:last each 3 cut raze "/" vs ' file4

// Display log to standard out
lg:{-1(string .z.p)," ",x}

// Load in first schema dataset
lg"Loading in first schema data set";
tab1:{[x;y]update sym:y from ("*ISSSSS"; enlist ",") 0:x}'[`$file1;`$list1];
lg"Concatenating data";
tab1:uj/[tab1];
delete x,x1 from `tab1;
lg"Changing time to kdb format";
/update Time:ssr[;"  ";" "]each Time from `tab1;
indexes:exec i from `tab1 where Time like "* 0:00";
\z 1
update Time:"P"$Time from `tab1 where i in b;
\z 0
update Time:"p"$"D"$-5_'Time from `tab1 where i in indexes;
update Time:"P"$Time from `tab1 where not i in indexes;
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
\z 1
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
\z 1
update time:"P"$time from `tab4;
\z 0

// Save down tables splayed in dir
lg"Saving down tables";
`:splaytab/tab1/ set .Q.en[`:splaytab]tab1;
`:splaytab/tab2/ set .Q.en[`:splaytab]tab2;
`:splaytab/tab3/ set .Q.en[`:splaytab]tab3;
`:splaytab/tab4/ set .Q.en[`:splaytab]tab4;
lg"Loader complete";



.z.p-st
