Okay. Here are some explanation for MrBen. </b>

Structure </b>
-scenarios: scenarios describing the test </b>
-setup: scripts to prepare machine before the test </b>
-network: scripts to benchmark the network </b>
-networkconf: config files for network benchmark </b>
-disk: scripts to benchmark the storage </b>
-diskconf: config files for storage benchmark </b>
-customscript: scripts to run before the test start </b>

Goals </b>
The tool is use to benchmark a distributed system. We use Flexible IO (FIO) to measure the disk performance and Iperf to measure network performance. </b>