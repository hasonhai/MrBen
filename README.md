Okay. Here are some explanation for MrBen. <br>

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
