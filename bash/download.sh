#!/bin/bash
echo "This script will continue running until stopped - CRTL+C can be used to stop this in the console"
read -p "Enter a number (with an s suffix for seconds) to loop the script at set time intervals:" slp 
slp=${slp:-60}
echo "Sleep interval set as $slp second(s)"

while [ 1 ]
do
wget -O FDdownload.txt -q  "https://uk.finance.yahoo.com/quote/FDP.L?p=FDP.L" 
#echo $data
grep -ozP '(?s)<!-- react-text: 36 -->\K.*?(?=<!-- /react-text -)' FDdownload.txt | tr -cd  '[0987654321.,]' >> FDprice.txt
echo "       Time: $(date)" >> FDprice.txt
echo "" >> FDprice.txt
sleep $slp
done



#Alternative is to use w3m -dump to make the grep section easier as the data is more human readable
