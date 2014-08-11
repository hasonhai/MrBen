Okay. Here are some explanation for MrBen.

Structure
-scenarios: scenarios describing the test
-setup: scripts to prepare machine before the test
-network: scripts to benchmark the network
-networkconf: config files for network benchmark
-disk: scripts to benchmark the storage
-diskconf: config files for storage benchmark
-customscript: scripts to run before the test start

Goals
The tool is use to benchmark a distributed system. We use Flexible IO (FIO) to measure the disk performance and Iperf to measure network performance.