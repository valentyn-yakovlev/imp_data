#!/bin/sh
#exec 2> /tmp/j.log
#set -x

MYSQL_USER=fnp
MYSQL_PSWD=fnp
MYSQL_DB=fnp_new
FROM_DATE=$(date +'%Y-%m-%d %H:%m:%S' --date='90  minutes ago')
TO_DATE=$(date +'%Y-%m-%d %H:%m:%S' --date='30  minutes ago')
TMP_FILE=$(mktemp)
FAILED_ORDERS=$(mktemp)
MYSQL_CONNECT="mysql --socket=/tmp/mysql.sock --skip-column-names -u $MYSQL_USER -p$MYSQL_PSWD -D $MYSQL_DB"

#$MYSQL_CONNECT -e "select p.potrfnum,p.potpayamt from ISMPOT p, ISMPST s where s.pstpotrfnum=p.potrfnum  and p.potpmtrfnum=50013 and p.potordate between '$FROM_DATE' and '$TO_DATE' and p.potrfnum in (700310854) order by p.potordate desc" > $TMP_FILE

$MYSQL_CONNECT -e "select p.potrfnum,p.potpayamt from ISMPOT p, ISMPST s where s.pstpotrfnum=p.potrfnum and s.pstsmtstatus=2136 and p.potpmtrfnum=50013 and p.potordate between '$FROM_DATE' and '$TO_DATE' order by p.potordate desc" > $TMP_FILE

eval `/bin/awk '{print "ORDER_NO_[" NR "]=" $1, "ORDER_AMT_[" NR "]=" $2}END{print "NO_REC=" NR}' $TMP_FILE`

let i=1
while let "i<=$NO_REC"
do
	unset TMPXML order_no order_amt Checksum Merchant_param affiliate amount quantity ru custname custlastname billmobile shipcountry shipstate shipcity shipzip shipaddress shipmobile shipphone shipemail receivername receiverlastname date checksum prefdate giftmessage shipzip_cnd shipstate_cnd shipcountry_cnd update_pot_query update_pst_query
	TMPXML=$(mktemp)
	order_no="${ORDER_NO_[$i]}"
	order_amt="${ORDER_AMT_[$i]}"
	Checksum=$(/octashop_local/scripts/justdial_checksum.sh $order_no $order_amt)
	# curl -s --output $TMPXML "http://beta.justdial.com:83/check_order_status.php?orderid=$order_no&checksum=$Checksum"
        curl -s --output $TMPXML "http://www.justdial.in/transactions/flowers/check_order_status.php?orderid=$order_no&checksum=$Checksum"
	Status="$(head -1 $TMPXML | sed 's/.*status>\(.*\)<\/status.*/\1/g')"
	if test "$Status" == "failure"
	then
		echo -e "$order_no still a failure\n" >> $FAILED_ORDERS
	elif test "$Status" == "success"
	then
		affiliate="$(head -1 $TMPXML | sed 's/.*affiliate>\(.*\)<\/affiliate.*/\1/g' )"
		amount="$(head -1 $TMPXML | sed 's/.*amount>\(.*\)<\/amount.*/\1/g' )"
		quantity="$(head -1 $TMPXML | sed 's/.*quantity>\(.*\)<\/quantity.*/\1/g' )"
		ru="$(head -1 $TMPXML | sed 's/.*ru>\(.*\)<\/ru.*/\1/g' )"
		custname="$(head -1 $TMPXML | sed 's/.*custname>\(.*\)<\/custname.*/\1/g' )"
		custlastname="$(head -1 $TMPXML | sed 's/.*custlastname>\(.*\)<\/custlastname.*/\1/g' )"
		billmobile="$(head -1 $TMPXML | sed 's/.*billmobile>\(.*\)<\/billmobile.*/\1/g' )"
		billemail="$(head -1 $TMPXML | sed 's/.*billemail>\(.*\)<\/billemail.*/\1/g' )"
		shipcountry="$(head -1 $TMPXML | sed 's/.*shipcountry>\(.*\)<\/shipcountry.*/\1/g' )"
		shipstate="$(head -1 $TMPXML | sed 's/.*shipstate>\(.*\)<\/shipstate.*/\1/g' )"
		shipcity="$(head -1 $TMPXML | sed 's/.*shipcity>\(.*\)<\/shipcity.*/\1/g' )"
		shipzip="$(head -1 $TMPXML | sed 's/.*shipzip>\(.*\)<\/shipzip.*/\1/g' )"
		shipaddress="$(head -1 $TMPXML | sed 's/.*shipaddress>\(.*\)<\/shipaddress.*/\1/g' )"
		shipmobile="$(head -1 $TMPXML | sed 's/.*shipmobile>\(.*\)<\/shipmobile.*/\1/g' )"
		shipphone="$(head -1 $TMPXML | sed 's/.*shipphone>\(.*\)<\/shipphone.*/\1/g' )"
		shipemail="$(head -1 $TMPXML | sed 's/.*shipemail>\(.*\)<\/shipemail.*/\1/g' )"
		receivername="$(head -1 $TMPXML | sed 's/.*receivername>\(.*\)<\/receivername.*/\1/g' )"
		receiverlastname="$(head -1 $TMPXML | sed 's/.*receiverlastname>\(.*\)<\/receiverlastname.*/\1/g' )"
		date="$(head -1 $TMPXML | sed 's/.*date>\(.*\)<\/date.*/\1/g' )"
		checksum="$(head -1 $TMPXML | sed 's/.*checksum>\(.*\)<\/checksum.*/\1/g' )"
		prefdate="$(head -1 $TMPXML | sed 's/.*prefdate>\(.*\)<\/prefdate.*/\1/g' )"
#		giftmessage="$(sed 's/.*giftmessage>\(.*\)<\/giftmessage.*/\1/g' $TMPXML)"
		giftmessage="test order ANM"

		shipzip_cnd=$($MYSQL_CONNECT -e "select cndrfnum from ISMCND where cnddesc='$shipcity' and cndgroup='City'")
		shipstate_cnd=$($MYSQL_CONNECT -e "select cndrfnum from ISMCND where cnddesc='$shipstate' and cndgroup='State'")
		shipcountry_cnd=$($MYSQL_CONNECT -e "select cndrfnum from ISMCND where cnddesc='$shipcountry' and cndgroup='Country'")

		update_pot_query="update ISMPOT set potbuyerfname='$custname',potbuyerlname='$custlastname',potbillmobile='$billmobile',potbilladdr1='$shipaddress',potbillzip='$shipzip',potcndbillcity='$shipzip_cnd',potcndbillstate='$shipstate_cnd',potcndbillcountry='$shipcountry_cnd',potsmtstatus=2101 where potrfnum=$order_no"
		update_pst_query="update ISMPST set pstsmtstatus=2101,pststatusdate=current_date(),pstlastupdate=current_date(),pstrecvaddr1='$shipaddr',pstrecvfname='$receivername',pstrecvlname='$receiverlastname',pstcndrecvcity='$shipzip_cnd',pstcndrecvstate='$shipstate_cnd',pstcndrecvcountry='$shipcountry_cnd',pstrecemail='$shipemail',pstrecvzip='$shipzip',pstqty='$quantity',pstgiftmsg='$giftmessage',pstpctrfnum=1001,pstprefdate='$prefdate',pstrecmobile='$shipmobile' where pstpotrfnum=$order_no"

		$MYSQL_CONNECT -e "$update_pot_query"
		$MYSQL_CONNECT -e "$update_pst_query"
	else
		echo -e "an error occured existing for order no $order_no \n"
		#exit 1
	fi
	echo $Checksum
	let i=$i+1
done
