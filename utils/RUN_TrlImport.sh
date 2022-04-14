#!/bin/sh
#
# $Id: RUN_TrlImport.sh,v 1.3 2005/01/22 21:59:15 jjanke Exp $
#
# Name:			RUN_TrlImport.sh
# Description:	Script to update the database to the next seed.
#
# XML files are expected to be found in the $ADEMPIERE_HOME/ folder

# exit codes:
errorSuccess=0			# successful execution
errorGeneral=1			# general unspecified error
errorNoEnvironment=10	# environment settings could not be loaded
errorNoSeedFile=11		# data seed file could not be loaded

# identify this script
echo "==================================="
echo " Import Translated ADempiere "
echo "==================================="
echo


# change to directory in which this script resides
DIR_SAV=$(pwd)
cd $(dirname $0)

# load environment
if [ -r "myEnvironment.sh" ]
then
	. ./myEnvironment.sh nosave &> /dev/null
fi

sanityCheck=$errorSuccess

# make sure environment is properly defined
if [[ -z $ADEMPIERE_HOME || -z $JAVA_HOME ]]
then
	cat <<-EOF
	Please make sure that the environment variables are set correctly:
	  ADEMPIERE_HOME	e.g. "/Adempiere"
	  JAVA_HOME			e.g. "/usr/java/jdk11"
	When in doubt, please run RUN_Setup.sh
	EOF
	sanityCheck=$errorNoEnvironment
fi

if [ $ADEMPIERE_HOME ]; then
  cd $ADEMPIERE_HOME/utils
fi

echo	Import Adempiere Translation - $ADEMPIERE_HOME \($ADEMPIERE_DB_NAME\)

# need to change this to reflect your language
export AD_Language=$1
export DIRECTORY=$2

echo	This Procedure imports language $AD_LANGUAGE from directory $DIRECTORY

$JAVA_HOME/bin/java -cp $CLASSPATH org.compiere.install.Translation $DIRECTORY $AD_LANGUAGE import



# change back to calling directory
if [ -n $DIR_SAV ]
then
	cd $DIR_SAV
fi

# end of script
echo
if [ $result -eq 0 ]
then
	echo "Done."
else
	echo "Terminated abnormally"
fi
exit $result
