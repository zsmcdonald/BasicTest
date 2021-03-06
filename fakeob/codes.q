\c 35 250

/ Using .Q.def and .Q.opt will allow user to input amount of random data to generate, usage flag will be added soon

param:.Q.def[(enlist `custs)!enlist 50] .Q.opt .z.x   

/ origcodes:(`AP`BC`BD`BP`CG`CN`CQ`CR`CW`DC`DW`IC`MT`NC`SO`TP`UB`UD`US`WD`XF)!("FlexAccount linked Access Payment";"Bank Credit";"Direct Debit";"Bill Payment";"Charitable Giving";"Correction";"Credit by Cheque";"Credit by Cash";"Personal Cheque Withdrawal";"FlexAccount Payment Card Purchase/Credit Voucher";"FlexAccount Payment Card Visa Cash Withdrawal";"Interest/Charges";"Telephone Top-up";"Non cash";"Standing Order";"Credit/Debit (processed today)";"Unpaid Bill Payment";"Unpaid Direct Debit";"Unpaid Standing Order";"Withdrawal";"Transfer to/from another account")
coded:(`BC`BD`BP`CG`CN`CW`IC`SO`WD`XF)!("Bank Credit";"Direct Debit";"Bill Payment";"Charitable Giving";"Correction";"Personal Cheque Withdrawal";"Interest Charge";"Standing Order";"Withdrawal";"Transfer to/from another account")
codes:(key coded) where 5 20 7 1 2 2 1 5 7 5  
/ reftranstype: enlist codes

/ Semi-random data input to create table of customerID and addresses
n:param`custs
num:string each 1+((neg n)?3*n)
prefix:n?(" Church ";" Station ";" Victoria ";" Main ";" Queens ";" New ";" York ";" West ";" North ";" Alexander ")
suffix:n?("Street";"Road";"Lane";"Path";"Drive";"Avenue";"Road";"Drive";"Lane";"Street")
addr:num,'prefix,'suffix
city:(n?enlist "Belfast")
pstcd:(n?("BT4 4RS";"BT9 6UW";"BT4 2FA";"BT5 5YY"))
cnty:(n?(enlist "Antrim"))
cntry:(n?enlist "NI")
addcust:([addressID:1+ til n;customerID:((neg n)?1+til n)]line1:(addr);townCity:(city);postcode:(pstcd);county:(cnty);country:(cntry))

/ Create accounts table with 3 accounts per customerID
m:3*n
a:((neg n)?1+til n)
dID:(neg n*2)?(a,a)
acIDs:{x,a[]}/[1;a[]]
custIDs:{x,a[]}/[2;a[]]
accounts1:([accountNum:(neg m-n)? til (m-n);customerID:(acIDs)]bank:(n*2)?enlist `Danske;accountType:(n*2)?enlist `Current;currentBalance:(n*2)?800+ til 7000)
accounts2:([accountNum:(neg n)?(m-n)+ til n;customerID:a]bank:n?enlist `Other;accountType:n?enlist `Current;currentBalance:n?800+ til 7000)
accounts:`accountNum xasc accounts1,accounts2

/ Create transaction table, 
k:80*param`custs
transID:1+ til k
sdate:2018.02.28
dates:sdate-k?120
times:k?.z.t
transactions:([transactionID:transID]accountNum:k?til m;date:dates;time:times;transactionAmount:k?5+til 2500;typeCode:k?codes)
cnt:select counts:count transactionID by accountNum from transactions;
cnt:0!cnt lj 1!0!accounts;
cnt:`accountNum`customerID`bank`accountType`currentBalance`counts xcols cnt;
cnt:select sum counts by customerID from cnt;

/ Create ratio of negative transactions for specific typeCodes
boo:(count select from transactions where typeCode in `BC`BD`SO`XF)?00000011b
tab:select from transactions where typeCode in `BC`BD`SO`XF
newtab:update transactionAmount:neg transactionAmount from tab where boo
transactions:lj[transactions;newtab];

/ Update some typeCodes to only be negative if necessary
update transactionAmount:neg transactionAmount from `transactions where typeCode in `BP`CG`CW`WD;

/ Select all transactions for separate months
month1:select from transactions where date within (2018.02.01;2018.02.28)
month2:select from transactions where date within (2018.01.01;2018.01.31)
month3:select from transactions where date within (2017.12.01;2017.12.31)
month4:select from transactions where date within (2017.11.01;2017.11.30)

/ Select all debit tranasctions for each month
debit1:select from month1 where typeCode in `BD
debit2:select from month2 where typeCode in `BD
debit3:select from month3 where typeCode in `BD
debit4:select from month3 where typeCode in `BD

/ Select all credit transactions for each month
credit1:select from month1 where typeCode in `BC
credit2:select from month2 where typeCode in `BC
credit3:select from month3 where typeCode in `BC
credit4:select from month3 where typeCode in `BC

/ End of month summaries 
eom1:select by accountNum from update eom:sum transactionAmount by accountNum from month1
eom2:select by accountNum from update eom:sum transactionAmount by accountNum from month2
eom3:select by accountNum from update eom:sum transactionAmount by accountNum from month3
eom4:select by accountNum from update eom:sum transactionAmount by accountNum from month4

/ Usage case 1 - Salary payment moves to non Dankse account
/ update Dec:?[1=deltas[customerID];1;0],Jan:?[1=deltas[customerID];1;0],Feb:?[1=deltas[customerID];1;0] from `customerID xasc `salary;
nu:(neg ceiling n*0.05)?n
salary:2!(`customerID xasc select customerID,accountNum from accounts) uj flip  .Q.id'[+[til 12;"m"$2016.03.05]]!12#()
{![`salary;();0b;(enlist x)!enlist (?;(=;1;(-':;`customerID));1;0)]}'[.Q.id'[+[til 12;"m"$2016.03.05]]];
{update 1 rotate a201702,1 rotate a201701 by customerID from `salary where customerID in x}'[nu];

/ Usage case 2 - Total transaction count falls by 20% over consecutive months
totalcnt:1!(`customerID xasc select distinct customerID from accounts) uj flip  .Q.id'[+[til 12;"m"$2016.03.05]]!12#()
update a201603:(exec counts from cnt) from `totalcnt;
rnd:0.01*n?92+ til 18
rnd2:0.01*n?90+ til 20
rnd3:0.01*n?87+ til 23
{[x;y]![`totalcnt;();0b;(enlist x)!enlist(?;`totalcnt;();();enlist(*;y;`rnd))]}'[2_cols totalcnt;-1_1_cols totalcnt];
{![`totalcnt;();0b;(enlist x)!enlist ($;"i";x)]}'[1_cols totalcnt];

/ Usage case 3 - EOM reduction of 20% over consecutive months
eomchange:([accountNum:1+ til m]Dec:(m?-15 + til 40);Jan:(m?-15 + til 40);Feb:(m?-15 + til 40);March:(m?-15 + til 30))
update Feb:-21,March:-20 from `eomchange where accountNum=13;
