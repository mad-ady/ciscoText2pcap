# ciscoText2pcap
Convert cisco Monitor Capture dump to wireshark text2pcap format

If you've used Cisco's "Monitor Capture" feature you've seen that you can capture packets and dump them in hex format on your console/syslog server. The output looks roughly like this (for one packet):

```
87526540:                            45C0004C              E@.L
87526550: 00000000 FD11C63E 0A303001 AC1F1052  ....}.F&gt;.00.,..R
87526560: 007B007B 00385EBF 24040AEE 00000DEA  .{.{.8^?$..n...j
87526570: 000028A4 C1E767CD D8E48CD6 519D50B0  ..($AggMXd.VQ.P0
87526580: D8E48CD9 A9855D94 D8E48CD9 C161FAF9  Xd.Y).].Xd.YAazy
87526590: 00 
```
It's a bit difficult to read, but you can see that it's an IP packet (the first 4 is the IPv4 version nibble). If you want to decode this packet in Wireshark, you can technically use wireshark's text2pcap converter. The problem is text2pcap expects input in a specific format.

The following script will do the format conversion between Cisco's dump format and what text2pcap expects.

Usage:

 * Place the capture dump in a text file (or pipe it from a different command)
 * Run ciscoText2pcap.pl to convert STDIN to Wireshark text2pcap output
 * Use Wireshark's text2pcap to convert it to pcap file
 * profit!
 
Example:
```
 $ cat input.txt | ./ciscoText2pcap.pl > output.txt 
 $ text2pcap -d -e 0x800  output.txt output.pcap 
```

You need to tell text2pcap what kind of fake layer2 to create and what higher level protocol to expect (0x800 is the EtherType of IPv4).
 
You can convert multiple packets at the same time. Simply include them in the input file. If the input file contains lines that don't look like "monitor capture" format, they will be ignored (e.g. if you have other logs in the output they will be ignored).
 
Enjoy!
