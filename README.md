MrBen stands for Map Reduce BenchMarking, its name is complex like that and tied to the MapReduce platform but its existing goal is more far simple and basic. I need to have a program to read scenario file, in that scenario, a test plan is described which tell the program that how many nodes will involve, how we want to test the network, the connection between nodes, the kind of i/o workload that we want to run on the nodes, etc<br>

<h2>Structure </h2>
<ul>
<li>scenarios: scenarios describing the test </li>
<li>setup: scripts to prepare machine before the test </li>
<li>network: scripts to benchmark the network </li>
<li>networkconf: config files for network benchmark </li>
<li>disk: scripts to benchmark the storage </li>
<li>diskconf: config files for storage benchmark </li>
<li>customscript: scripts to run before the test start </li>
</ul>
<h2>Goals </h2>
The tool is use to benchmark a distributed system. We use Flexible IO (FIO) to measure the disk performance and Iperf to measure network performance. <br>
<b>Why we use FIO?</b> <br>
The two primary features in a good benchmark are being able to run the workload that you want and getting the desired units of output. Being flexible was (and continues to be) the main focus of fio. It supports workload options not found in other benchmarks along with rigorously detailed IO statistics. Any sort of random and sequential IO mix, or read/write mix, is easy to define. The internal design of fio is flexible as well. Defining a workload is completely separate from the IO engine (a term fio uses to signify how IO is delivered to the kernel). For instance, if you want to run a workload with native async on Linux and then compare the same workload on Windows, just change the single IO engine line to the native version on Windows. Or, if you want more detailed latency percentile statistics at the tail of the distribution, that's easy too. Just specify the exact percentiles in which you are interested and fio will track that for you.<br>
Fio also supports three different types of output formats. The “classic” output is the default which dumps workload statistics at the end of the workload. There's also support for a CSV format, though that's slowly diminishing in favor of a JSON-based output format. The latter is far more flexible and has the advantage of being simple to parse for people and computers.<br>


Why we use iperf? <br>

