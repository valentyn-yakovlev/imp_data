#!/bin/sh

warn() {
    echo "${PROGNAME}: $*"
}

die() {
    warn $*
    exit 1
}


TMP_CLASSPATH=.:`echo *.jar|tr ' ' ':'`:`echo lib/*.jar|tr ' ' ':'`:$CLASSPATH

#echo "  CLASSPATH: $TMP_CLASSPATH"
#echo "  JAVA_HOME: $JAVA_HOME"
#java -Xms128m -Xmx128m -classpath $TMP_CLASSPATH com.anm.ism.integeration.api.JustdialOrderupdate $1 $2 $3
checksum=$(java -Xms128m -Xmx128m -classpath $TMP_CLASSPATH com.anm.ism.integeration.api.JustdialOrderupdate $1 $2)

echo "$checksum"
