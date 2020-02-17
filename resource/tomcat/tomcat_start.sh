#!/bin/sh
#chkconfig:235 80 20
#description:Start the tomcat servlet engine

#set environment variables
export SOL_HOME=/usr/local/7thonline
export JAVA_HOME=$SOL_HOME/Java/jdk1.8.0_121
export CATALINA_HOME=$SOL_HOME/apache-tomcat-8.5.12
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/bin
export PATH=$PATH:$JAVA_HOME/lib:$CLASSPATH:$CATALINA_HOME
export LANG=zh_CN.UTF-8
export JAVA_OPTS="-Dsystem.rootLocation=$SOL_HOME/7thOnline -Xms1000m -Xmx2000m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=1024m -Dfile.encoding=UTF-8 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9004 -Dcom.sun.management.jmxremote.ssl=false  -Dcom.sun.management.jmxremote.authenticate=false"

#set up for SQL loader
ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=$ORACLE_BASE/product/11.2.0/client_1
ORACLE_SID=7thonline
ORACLE_UNQNAME=7thonline
LD_LIBRARY_PATH=$ORACLE_HOME/lib
PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_BASE ORACLE_HOME LD_LIBRARY_PATH PATH

#tomcat start/stop/restart script
TOMCAT_USER=7thonline
start() 
	{
	PID=`ps -ef | grep "java" | grep -v "grep" | awk '{print $2}'`
	if [ -n "$PID" ];then
		echo "Tomcat is running..."
	else
		echo "Tomcat is starting..."
		/bin/su $TOMCAT_USER -c $CATALINA_HOME/bin/startup.sh
		echo "Tomcat is started."
	fi
	}
stop() 
	{
	echo "Tomcat is stopping..."
	$CATALINA_HOME/bin/shutdown.sh
	PID=`ps -ef | grep "java" | grep -v "grep" | awk '{print $2}'`
	if [ -n "$PID" ];then
		kill -9 $PID;
		echo "Tomcat is stopped."
	else
		echo "Tomcat is stopped."
	fi
	}

SLEEPTIME=3
case "$1" in
 start)
	start
	;;
 stop)
	stop
	;;
 restart)
	stop
	sleep $SLEEPTIME
	echo "Tomcat is starting..."
	$CATALINA_HOME/bin/startup.sh
	echo "Tomcat is started."
	;;
 *)
	echo "Usage tomcat.sh {start|stop|restart}"
	exit 1
	;;
esac
