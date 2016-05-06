#!/bin/bash

node_count="$1"

version=cassandra-2.1
if [ -n "$2" ]; then version="$2" ; fi

echo Node Count: $node_count
echo Building: $version

if ! [ -e ~/.finished-startup ]; then
	mkdir ~/.finished-startup
elif ! [ -d ~/.finished-startup ]; then
	rm ~/.finished-startup && mkdir ~/.finished-startup
fi
rm -f ~/.finished-startup/*

name=`hostname -s`
number=`echo $name | perl -pe 's/node-//'`
ip=`bash /proj/comp150/cassandra/ip-addr -private`

sudo apt-get -y update
sudo apt-get -y install sendmail
sudo apt-get -y install ant
sudo apt-get -y install maven2
sudo apt-get -y install openjdk-7-jre
sudo apt-get -y install openjdk-7-jdk
sudo apt-get -y install vim htop screen

export JAVA_TOOL_OPTIONS='-Dfile.encoding=UTF8'

pushd /usr/local
	if ! [[ -e cassandra ]] ; then
	#	sudo wget https://www.cs.tufts.edu/~ccasey01/cassandra.zip
	#	sudo unzip cassandra.zip ; sudo mv cassandra cassandra.git
	#	sudo git clone cassandra.git ; sudo rm -rf cassandra.zip cassandra.git
		sudo git clone https://github.com/CarterCasey/cassandra.git
		cd cassandra ; sudo git checkout $version
		sudo mkdir logs ; sudo chmod g+xrw logs
		sudo mkdir data ; sudo chmod g+xrw data
		sudo mkdir data/data ; sudo chmod g+xrw data/data
		sudo mkdir data/commitlog ; sudo chmod g+xrw data/commitlog
		sudo mkdir data/saved_caches ; sudo chmod g+xrw data/saved_caches
		
	#	sudo mkdir /var/log/cassandra ; sudo chmod g+xrw /var/log/cassandra
	#	sudo mkdir /var/lib/cassandra ; sudo chmod g+xrw /var/lib/cassandra

		sudo ln -s /usr/local/cassandra/bin/cassandra /usr/local/bin
		sudo ln -s /usr/local/cassandra/bin/cqlsh /usr/local/bin
		sudo ln -s /usr/local/cassandra/bin/cassandra-cli /usr/local/bin
		sudo ln -s /usr/local/cassandra/bin/nodetool /usr/local/bin
	fi

	. ~/.bashrc

	sudo ant -Dfile.encoding=UTF8 ; sudo ant -Dfile.encoding=UTF8 stress-build
	sudo chmod g+w conf/cassandra.yaml
	sudo cat /proj/comp150/cassandra/conf-$version.yaml | sudo perl -pe "s/localhost/$ip/" > conf/cassandra.yaml
#	sudo cp /proj/comp150/cassandra/conf-single.yaml /usr/local/cassandra/conf/cassandra.yaml
popd

let "prev = number - 1"

case $name in
	node-1) cassandra ; starting_cassandra=1 ;;
	*) while ! [ -e ~/.finished-startup/node-$prev ]; do
		echo Waiting for node-$prev
		sleep 10
	   done
	   cassandra
	   starting_cassandra=1
	;;
esac

if [ -z "$starting_cassandra" ] ; then cassandra ; fi

# While Cassandra isn't up - timeout after 10 minutes
attempt=0
while ! nodetool status > /dev/null 2> /dev/null; do
	sleep 10
	if [ $attempt -gt 60 ]; then
		echo "Timing out..."
		touch ~/.finished-startup/$name
		exit 1
	fi

	let "attempt++"
done

while ! [ "`nodetool status | grep $ip | perl -pe 's/\s.*//'`" = "UN" ]; do
	sleep 5
done

# For good measure, wait before signaling
sleep 30 ; touch ~/.finished-startup/$name

echo "Done processing: " `ls ~/.finished-startup`

if [ `ls ~/.finished-startup | wc -l` = "$node_count" ]; then
	# mail -s "Finished Emulab Startup" YOUR.EMAIL@WHEREVER.COM < /tmp/startup.log
fi

