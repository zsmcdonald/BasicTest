\c 35 250

/ Using .Q.def and .Q.opt will allow user to input amount of random data to generate, usage flag will be added soon

param:.Q.def[(enlist `custs)!enlist 50] .Q.opt .z.x   

/ origcodes:(`AP`BC`BD`BP`CG`CN`CQ`CR`CW`DC`DW`IC`MT`NC`SO`TP`UB`UD`US`WD`XF)!("FlexAccount linked Access Payment";"Bank Credit";"Direct Debit";"Bill Payment";"Charitable Giving";"Correction";"Credit by Cheque";"Credit by Cash";"Personal Cheque Withdrawal";"FlexAccount Payment Card Purchase/Credit Voucher";"FlexAccount Payment Card Visa Cash Withdrawal";"Interest/Charges";"Telephone Top-up";"Non cash";"Standing Order";"Credit/Debit (processed today)";"Unpaid Bill Payment";"Unpaid Direct Debit";"Unpaid Standing Order";"Withdrawal";"Transfer to/from another account")
coded:(`BC`BD`BP`CG`CN`CW`IC`SO`WD`XF)!("Bank Credit";"Direct Debit";"Bill Payment";"Charitable Giving";"Correction";"Personal Cheque Withdrawal";"Interest Charge";"Standing Order";"Withdrawal";"Transfer to/from another account")
codes:(key coded) where 5 20 7 1 2 2 1 5 7 5  
/Bank products are currency account, credit, savings, internet banking, mobile banking, SMS, standing orders, etc


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
accounts1:([accountNum:(neg m-n)?1+ til (m-n);customerID:(acIDs)]bank:(n*2)?enlist `Danske;accountType:(n*2)?enlist `Current;currentBalance:(n*2)?800+ til 7000)
accounts2:([accountNum:(neg n)?(m-n)+ til n;customerID:a]bank:n?enlist `Other;accountType:n?enlist `Current;currentBalance:n?800+ til 7000)
accounts:`accountNum xasc accounts1,accounts2
/update salary:?[1=deltas[customerID];1;0] from `customerID xasc `accounts;

/ Create transaction table, 
k:80*param`custs
transID:1+ til k
sdate:2018.03.01
dates:sdate-k?120
times:k?.z.t
transactions:([transactionID:transID]accountNumber:k?1+ til m;date:dates;time:times;transactionAmount:k?5+til 2500;typeCode:k?codes)

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
eom1:select by accountNumber from update eom:sum transactionAmount by accountNumber from month1
eom2:select by accountNumber from update eom:sum transactionAmount by accountNumber from month2
eom3:select by accountNumber from update eom:sum transactionAmount by accountNumber from month3
eom4:select by accountNumber from update eom:sum transactionAmount by accountNumber from month4

/ Usage case 1 - Salary payment moves to non Dankse account
salary:([accountNum:1+ til m;customerID:(custIDs)]Dec:1+ til m;Jan:1+ til m;Feb:1+ til m)
update Dec:?[1=deltas[customerID];1;0],Jan:?[1=deltas[customerID];1;0],Feb:?[1=deltas[customerID];1;0] from `customerID xasc `salary;
update Jan:0,Feb:0 from `salary where customerID in 8;
update flag:?[2<=sum[Dec,Jan,Feb];`;`alert] by customerID from salary;


/ Usage case 3 - EOM reduction of 20% over consecutive months
eomchange:([accountNum:1+ til m]Dec:(m?-15 + til 40);Jan:(m?-15 + til 40);Feb:(m?-15 + til 40);March:(m?-15 + til 30))
update Feb:-21,March:-20 from `eomchange where accountNum=13;







