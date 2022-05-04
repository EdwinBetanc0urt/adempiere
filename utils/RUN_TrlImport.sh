#!/bin/sh
#
# $Id: RUN_TrlImport.sh,v 1.3 2005/01/22 21:59:15 jjanke Exp $
#
# Name:			RUN_TrlImport.sh
# Description:	Script to import translations to the database.

# exit codes:
errorSuccess=0			# successful execution
errorNoEnvironment=10	# environment settings could not be loaded

# identify this script
echo "==================================="
echo " Import Translated ADempiere "
echo "==================================="
echo

# change to directory in which this script resides
DIR_SAV=$(pwd)
cd $(dirname $0)

# load environment
if [ -r "myEnvironment.sh" ]; then
	. ./myEnvironment.sh
fi

# need to change this to reflect your language
export AD_LANGUAGE="ca_ES"
export DIRECTORY="$ADEMPIERE_HOME/data/$AD_LANGUAGE"

sanityCheck=$errorSuccess

# make sure environment is properly defined
if [ -z $ADEMPIERE_HOME ] || [ -z $JAVA_HOME ]; then
	cat <<-EOF
	Please make sure that the environment variables are set correctly:
	  ADEMPIERE_HOME	e.g. "/Adempiere"
	  JAVA_HOME			e.g. "/usr/java/jdk11"
	When in doubt, please run RUN_Setup.sh
	EOF
	sanityCheck=$errorNoEnvironment
fi


# call database dependent import script
if [ $sanityCheck -eq 0 ]; then
	# change language
	if [ ! -z $1 ]; then
		export AD_LANGUAGE=$1
	fi
	# change language directory
	if [ ! -z $2 ]; then
		export DIRECTORY=$2
	fi

	echo
	echo "This Procedure Adempitere Translation "
	echo " import language: $AD_LANGUAGE "
	echo " from directory: $DIRECTORY"
	echo " on data base: $ADEMPIERE_DB_NAME"
	echo
	echo "WARNING: If the database is not a fresh import of the seed, make sure "
	echo "you have a backup!"
	echo
	echo "Press enter to continue ..."
	echo
	read in

	$JAVA_HOME/bin/java -classpath $CLASSPATH \
		-DADEMPIERE_HOME=$ADEMPIERE_HOME \
		-DPropertyFile=$ADEMPIERE_HOME/AdempiereEnv.properties \
		org.compiere.install.Translation $DIRECTORY $AD_LANGUAGE "import"

	result=$?
else
	result=$sanityCheck
fi


# change back to calling directory
if [ -n $DIR_SAV ]; then
	cd $DIR_SAV
fi

# end of script
echo
if [ $result -eq 0 ]; then
	echo "Done."
else
	echo "Terminated abnormally"
fi
exit $result
