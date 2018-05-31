/ Initial random data generation tests
start:.z.p
\c 25 230
\p 16666
\S -25678


/ Load in market data - TEMPORARILY SHORTENED DATE RANGE FOR TESTING
\l deploy/fxhdb
tab:select from gainfx where date within (2017.02.01;2017.02.28)
update RateMid:0.5*RateAsk+RateBid from `tab;update upp:RateAsk-RateMid from `tab;update down:RateBid-RateMid from `tab;


/ Set variables for random data gen
exe:5000
nu:exe*count exec distinct date from tab
rng:(neg nu)?til nu
stnd:("j"$0.98*nu)#rng
low:(neg "j"$0.011*nu)_(neg "j"$0.02*nu)#rng
mid:(neg "j"$0.004*nu)_(neg "j"$0.011*nu)#rng
high:(neg "j"$0.005*nu)#rng
stndd:(0.00001*("j"$0.49*nu)?99995 + til 5),0.00001*("j"$0.49*nu)?100001 + til 5
lowd:(0.0001*("j"$0.004*nu)?10001+ til 12),0.00001*("j"$0.005*nu)?99989 + til 5
midd:(0.00001*("j"$0.003*nu)?100012+ til 12),0.00001*("j"$0.004*nu)?99983 + til 4
highd:(0.00001*("j"$0.002*nu)?100017+ til 10),0.00001*("j"$0.003*nu)?99974+ til 8


/ Variance table fields
reg:(7?enlist `AMS),(5?enlist `EUR),(4?enlist `APAC),(2?enlist `OTHER)
/ Alert Type - always variance
alertt:(8?enlist `Variance),(2?enlist`Washing),(2?enlist `Crossing),(1?enlist `HighOrderRates),(1?enlist `Spoofing) 


/ Trader details
trad:("Carisa Moone";"Alvaro Terhaar";"Lean Joly";"Thao Kissee";"Ling Craw"; "Joya Carrigan";"Marco Trombetta";"Rosalind Kleiber";"Domingo Grave"; "Lena Wimberley";"Robbyn Dibble";"Joanna Legree";"Fred Oropeza"; "Angelena Stocker";"Reggie Lainez";"Holly Faulkenberry";"Joan Boller"; "Bernadine Fife";"Son Gillette";"Gerardo Kerfoot")!(`mopwd0`ndnld5`ojcob7`jfudc5`oaaib6`aciol7`scngm0`bdpbp2`medek1`bfinl8`zmbna1`jnmed0`pgdji7`lmbio3`oojdn3`gycf6`jmffm8`hflnr2`plmgh3`oxbhk8)


/ Create executions with percent weighting
execu:raze {exe?select date,CurrencyPair,RateDateTime,RateMid,upp,down from tab where date in x}'[exec distinct date from tab];
update doh:highd from `execu where i in high;update doh:midd from `execu where i in mid;update doh:lowd from `execu where i in low;update doh:stndd from `execu where i in stnd;
update nprice:doh*RateMid from `execu;
execu:`date`CurrencyPair`time`RateMid xcol execu;
update time:00:00:00.100000000+time from `execu;
execu:`time xasc execu;
execu:`date`CurrencyPair`time`RateMid xcols execu;


/ Join executions to nearest market data time
data:select RateDateTime,CurrencyPair,RateAsk,RateBid,RateMid,upp,down from tab;
data:`time`CurrencyPair`RateAsk`RateBid xcol data;data:`time xasc data;
test:aj[`CurrencyPair`time;data;select time,CurrencyPair,nprice from (update `g#CurrencyPair from execu)];
testt:update dprice:nprice from (update cond:{ceiling[x]&differ x}nprice by CurrencyPair from test)where cond=1;
c:count select from testt where not null dprice;
update exID:til c from `testt where not null dprice;
/ Find zero reference data
update newval:dprice-RateMid from `testt where not null dprice;
delete nprice,cond from `testt;


/ Generate alerts table
ltt:(10?enlist `Closed),(3?enlist `InProgress),(2?enlist `Open),(1?enlist `Escalated)
rm:exec RateMid from testt where dprice>0
dp:exec dprice from testt where dprice>0
update perc:100*(dp-rm)%rm from `testt where dprice>0;
szal:(4?enlist 1000000),(3?enlist 2000000),(2?enlist 3500000),(1?enlist 5000000),(1?enlist 6500000)
update orsize:c?szal from `testt where not null dprice;
update score:floor abs (perc*orsize)%150 from `testt where not null dprice;
update desk:`EUR from `testt where CurrencyPair like "EUR*";update desk:`USD from `testt where CurrencyPair like "USD*";update desk:`GBP from `testt where CurrencyPair like "GBP*";

alts:select exID,time,CurrencyPair,desk,dprice,perc,score from testt where not null dprice,score>=220;update alID:i from `alts;
cla:count alts;
/jid:(neg cla)?"SA-",/:string 1+ til cla
jid:"S"$("SA-",/:string 1+ til cla)
update TraderName:cla?key trad,size:cla?szal from `alts;update TraderID:trad[TraderName] from `alts;update status:cla?ltt from `alts;update region:cla?reg from `alts;update alerttype:cla?alertt from `alts;update JID:jid from `alts;


/alerts:select from alts where alerttype in `Variance
/alerts:`alID`exID`status`time`TraderName`TraderID`region`alerttype`CurrencyPair`desk`dprice`perc`size xcols alerts;
alts:`alID`exID`status`time`TraderName`TraderID`region`alerttype`CurrencyPair`desk`dprice`perc`size xcols alts;
/update comm:("Trader ",/:TraderName,'" was responsible for this ",/:(string upper [alerttype]),'" error on ",/:string[time.date],'".",'" At time ",/:string[time.time],'", CurrencyPair ",/:string[CurrencyPair],'" was traded at ",/:string[perc],\:" percent from the mid.") from `alerts;
update comm:("Trader ",/:TraderName,'" was responsible for this ",/:(string upper [alerttype]),'" error on ",/:string[time.date],'".",'" At time ",/:string[time.time],'", CurrencyPair ",/:string[CurrencyPair],'" was traded at ",/:string[perc],\:" percent from the mid.") from `alts;
/a7:select count exID by 30 xbar time.minute from alts
/ Breakdown of alerttype type count by day. Lower alert count on Sundays, no data on Saturdays
timebrk:0!select IDcnt:count exID by time.date,alerttype from alts;update IDcnt:floor 0.6*IDcnt from `timebrk where 6=date mod 7;


/ Table for trader monitoring
/ Number of alerts per day
numal:35*count exec distinct date from tab
talert:((1?enlist "Creation of a Floor/Ceiling"),(1?enlist "Smoking"),(1?enlist "Pinging"),(1?enlist "Pump and Dump"),(1?enlist "Marking the Close"),(1?enlist "Pre-arranged Trade"),(1?enlist "Wash Trading"),(4?enlist "Variance"))
calert:(1?enlist`Insider;1?enlist`BadLanguage;1?enlist`Collusive;1?enlist`Emotion;1?enlist`FrontRunning;1?enlist`Apologetic;1?enlist`Controls;1?enlist`Anger;1?enlist`Fear;1?enlist`Racist;1?enlist`Sexist;1?enlist`Illegal;1?enlist`Pressure;1?enlist`VolumeSpike;1?enlist`RadioSilence;1?enlist`SwapChannel)
/alerthistory:([]date:asc (neg numal)?(exec time from testt);TraderName:numal?key trad;TradeAlert:numal?talert)
alerthistory:([]date:asc numal?(exec distinct date from tab);TraderName:numal?key trad;TradeAlert:numal?talert)
update TraderID:trad[TraderName] from `alerthistory;update ID:i from `alerthistory;

numcom:8*count exec distinct date from tab
talcom:(1?enlist"Creation of a Floor/Ceiling";1?enlist"Smoking";1?enlist"Pinging";1?enlist"Pump and Dump";1?enlist"Marking the Close";1?enlist"Pre-arranged Trade";1?enlist"Wash Trading";1?enlist"Abnormal Spread")
/commsalert:([]date:asc (neg numcom)?(exec time from testt);TraderName:numcom?key trad;TradeAlert:numcom?calert)
commsalert:([]date:asc numcom?(exec distinct date from tab);TraderName:numcom?key trad;TradeAlert:numcom?calert)
update TraderID:trad[TraderName] from `commsalert;update ID:i from `commsalert;

/update JID:`$"SA-14" from `alerts where exID = 5954;update JID:`$"SA-212" from `alerts where exID = 317;update JID:`$"SA-15" from `alerts where exID = 24789;update JID:`$"SA-44" from `alerts where exID = 336;update JID:`$"SA-17" from `alerts where exID = 2528;update JID:`$"SA-86" from `alerts where exID = 406;
update JID:`$"SA-14" from `alts where exID = 5954;update JID:`$"SA-212" from `alts where exID = 317;update JID:`$"SA-15" from `alts where exID = 24789;update JID:`$"SA-44" from `alts where exID = 336;update JID:`$"SA-17" from `alts where exID = 2528;update JID:`$"SA-86" from `alts where exID = 406;


.z.p-start
