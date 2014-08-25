<h2>Introduction </h2>
MrBen stands for Map Reduce BenchMarking, its name is complex like that and tied to the MapReduce platform but its existing goal is more far simple and basic. I need to have a program to read scenario file, in that scenario, a test plan is described which tell the program that how many nodes will involve, how we want to test the network, the connection between nodes, the kind of i/o workload that we want to run on the nodes, etc <br>
This program is mixed of Python and Bash script, because I only know those two :'( <br>

<h2>Structure </h2>
<ul>
<li>Scenarios: scenarios describing the test. You can read the sample scenario to understand how we can describe the test</li>
<li>Setup: scripts to prepare machine before the test. We may need to create a VM to run the tests on, or we may need to install some program on the host before the host start </li>
<li>Network: scripts to benchmark the network. This script is use to start the iperf server on the tested host, it then based on the configuration of the next to initiate the network connection with iperf client. We may have many kinds of network pattern: one-to-one, broadcast, shuffle (hadoop), aggregate, parallel</li>
<li>disk: scripts to benchmark the storage. The script is very simple, its upload the config file to the host, run the benchmark on it, then copy it back to your workstation</li>
<li>diskconf: config files for storage benchmark, depended on the kind of workload that we want to simulate that we different config file. For example, I need config file Hadoop pattern, you may need different config file for your program </li>
<li>customscript: scripts to run before the test start. We can insert some script using OpenStack, EC2 API to create the nodes and ask the program to run the benchmark on them</li>
</ul>
<h2>Goals </h2>
The tool is use to benchmark a distributed system. We use Flexible IO (FIO) to measure the disk performance and Iperf to measure network performance. <br>
<b>Why we use FIO?</b> <br>
The two primary features in a good benchmark are being able to run the workload that you want and getting the desired units of output. Being flexible was (and continues to be) the main focus of fio. It supports workload options not found in other benchmarks along with rigorously detailed IO statistics. Any sort of random and sequential IO mix, or read/write mix, is easy to define. The internal design of fio is flexible as well. Defining a workload is completely separate from the IO engine (a term fio uses to signify how IO is delivered to the kernel). For instance, if you want to run a workload with native async on Linux and then compare the same workload on Windows, just change the single IO engine line to the native version on Windows. Or, if you want more detailed latency percentile statistics at the tail of the distribution, that's easy too. Just specify the exact percentiles in which you are interested and fio will track that for you.<br>
Fio also supports three different types of output formats. The “classic” output is the default which dumps workload statistics at the end of the workload. There's also support for a CSV format, though that's slowly diminishing in favor of a JSON-based output format. The latter is far more flexible and has the advantage of being simple to parse for people and computers.<br>
<b>Why we use iperf?</b> <br>

<h2>Progress </h2>
<ul>
<li>disk test: done</li>
<li>network test: not yet</li>
<li>parse output: not yet</li>
<li>parse scenario: not yet</li>
<li>main program: not yet</li>
<li>scripts support OpenStack: not yet</li>
<li>scripts support EC2: not yet</li>
<li>scripts support drawing output figures: not yet</li>
</ul>