#!/usr/bin/ksh

#SCHEMA=db_inv
#PASSW=felaket2bin
#INVENTORY=griddb

sqlcall()
{
	$DEBUG
	SQLCOMMAND="$1"
	USER=db_inv #"$2"
	PASSWORD=felaket2bin #"$3"
	DB=GRIDDB #"$4"
#	. orause $DB

	sqlplus -s "${USER}/${PASSWORD}@${DB}" << SQLSTOP
	set pagesize 0
	set feedback off
	set termout off
	set echo off
	set trimspool on
	set trimout off
	set flush off
	$SQLCOMMAND
	exit
SQLSTOP
}

echo "DB Name: "
read DB_NAME
#echo "DB Ver: "
#read DB_VER
echo "Host Name: "
read HOST_NAME
echo "Type (DG, S.A, or H.A.Cluster): "
read TYPE1
echo "System (TEST, VER or PROD): "
read SYSTYPE
echo "App name: "
read APPNAME
echo "Owner (Lanid name): "
read OWNER
echo "Owner type (eg. TO, FO): "
read OWNTYPE
DB_NAME=`echo $DB_NAME|tr '[a-z]' '[A-Z]'`
SYSTYPE=`echo $SYSTYPE|tr '[a-z]' '[A-Z]'`
OWNER=`echo $OWNER|tr '[a-z]' '[A-Z]'`
APPNAME=`echo $APPNAME|tr '[a-z]' '[A-Z]'`
OWNTYPE=`echo $OWNTYPE|tr '[a-z]' '[A-Z]'`
HOST_NAME=`echo $HOST_NAME|tr '[A-Z]' '[a-z]'`
SQL1="select count(*) from DB where dbname='$DB_NAME' and hostname='$HOST_NAME';"
#SQL2="INSERT into DB (DBNAME,HOSTNAME,VERSION,TYPE,SYSTEM,STATUS) values('$DB_NAME','$HOST_NAME','$DB_VER','$TYPE1','$SYSTYPE','ACTIVE');
#commit;"
SQL2="update DB set TYPE='$TYPE1', SYSTEM='$SYSTYPE' where dbname='$DB_NAME' and hostname='$HOST_NAME';
commit;"
SQL3="INSERT into APP (DBNAME,HOSTNAME,APPNAME,APPID) values('$DB_NAME','$HOST_NAME','$APPNAME','0');
commit;"
SQL4="INSERT into CONTACT (DBNAME,HOSTNAME,LANID,TYPE) values('$DB_NAME','$HOST_NAME','$OWNER','$OWNTYPE');
commit;"
CHECK1=`sqlcall "$SQL1"`
if [ "$CHECK1" -eq "0" ]
then
	echo "$DB_NAME on $HOST_NAME has not been auto added by grid in inventory database."
	exit 1
fi
RETVAL1=`sqlcall "$SQL2"`
if [ "$RETVAL1" -ne "" ]
then
	echo $RETVAL1
	exit 1
fi
RETVAL2=`sqlcall "$SQL3"`
if [ "$RETVAL2" -ne "" ]
then
	echo $RETVAL2
	exit 1
fi
RETVAL3=`sqlcall "$SQL4"`
if [ "$RETVAL3" -ne "" ]
then
	echo $RETVAL3
	exit 1
fi

echo "Database $DB_NAME on $HOST_NAME updated in repository!"
