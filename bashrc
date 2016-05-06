# Set a useful prompt
PS1="\h:\w > "

alias ls="ls -v --color"

# Cassandra Environment
export CASSANDRA_HOME="/usr/local/cassandra"
export CASSANDRA_INCLUDE="$CASSANDRA_HOME/bin/cassandra.in.sh"
if [ -e $CASSANDRA_HOME/conf/cassandra-env.sh ]; then sudo bash $CASSANDRA_HOME/conf/cassandra-env.sh ; fi

PROJ=/proj/comp150/cassandra

