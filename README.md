# Testing Duplicate Aware Cassandra

The code here, primarily scripts and a few configuration files, makes up the
heart of my testing "framework" for the duplicate aware cassandra project. As a
disclaimer, these are meant as examples, as they were not originally written for
external use and will not be intuitive for you to use directly.  

## Emulab Setup

The experiments I ran were all on Emulab. The file setup.ns contains the node
configuration that I used in my experiments - updating the node_count variable
at the top of the file will adjust how many nodes are connected to the central
LAN.  

The most important detail from setup.ns is the OS - UBUNTU14-64-STD can handle
the dependencies that Cassandra requires in order to run.  

The bashrc file in this repo is the file I used in Emulab. It sets up the
environment variables necessary for Cassandra.

## Deploying Cassandra

I've limited the process of starting up an experiment to two pieces. The first
is simply swapping in the experiment. The second is running emu-startup, a
bash function I've defined to run the remote script startup.sh. It turned
out to be necessary for me to do this, rather than asking Emulab to run the
script on swapin, which is what I originally intended. It's also often necessary
to wait a minute or two before running emu-startup. Why are those things true?
If I knew, I've long since forgotten. Emulab and Cassandra are both very
finicky, and sometimes I found something that worked and stuck with it.

The file startup-local contains a piece of my local .bashrc file, defining
functions that I used to run startup.sh, which is found in startup-remote. The
files in startup-remote were located at /proj/comp150/cassandra when I ran the
experiment, which is where emu-startup expects them to be.

The remaining files in startup-local are also necessary for the startup - each
config file corresponds to a branch in the
[github repo](https://github.com/CarterCasey/cassandra) where I implemented
duplicate aware Cassandra. Note that all branches of interest are based on
version 2.1 of Cassandra. Again I'll refer to finickiness, though this time
YCSB is also to blame.  

## Testing Cassandra

The files in testing are mostly all that you need to run the YCSB tests I ran
in my experiments, with one exception: YCSB. I used version 0.5.0, and simply
dropped the directory ycsb into the testing directory. The script run-ycsb.sh
will do the extra legwork that YCSB doesn't, instantiating the appropriate table
in Cassandra and running YCSB in load mode *before* actually running the test
we care about.  

## Maintenance

There may be more to know, and I could certainly clean all this up. I may do so,
but I think it's in good enough condition that it won't be too terrible to
figure out. Usually it takes a trial run to see whether or not that's true.  
