#import "@preview/lovelace:0.3.0": *
#import "@preview/unify:0.7.0": num, qty

#set page(numbering: "1", paper: "a4")

#let init(title, author, student_id) = {
  set document(title: title, author: author)

  align(top)[
    #author
    #h(1fr)
    Prof. Qun Wang
  ]
  align(top)[
    ID: #student_id
    #h(1fr)
    CSC645 Computer Networks
  ]

  align(center)[= #title]
}

#init("Homework 1", "Varun Narravula", "923-287-037")

==== 1. Give three examples of network end systems.

- Student laptop
- Mobile phone
- Smart TV

==== 2. What is a network protocol?

A network protocol is a specification of a set of rules for how two or more
devices can communicate (aka send/receive data) to each other over a network.

==== 3. #text("What are the five layers in the Internet protocol stack? What "+
"are the principal responsibilities of each of these five layers?")

The five layers in the Internet protocol stack are (from top to bottom):

- Application Layer
- Transport Layer
- Network Layer
- Link Layer
- Physical Layer

The physical layer is the actual infrastructure, such as Ethernet cables, WiFi
radios, fiber-optic ONTs, and other similar devices that facilitate physical
transmission of data across a network. This layer has no knowledge of what
upper-level protocols are used to transmit data.

The link layer is one level above the physical layer, and manages logical
communication between immediately connected devices such as switches and other
computers. Link layer protocols can differ depending on the type of devices that
is sending or receiving data.

The network layer is one level above the link layer, and is responsible for
transferring data between devices in a given network. Network layer protocols
should be the same between devices in the network despite the fact that the
link layer protocols for transferring network layer data may be different.
The network layer also takes care of figuring out routing and optimal paths
between devices on the same network.

The transport layer is one level above the network layer, is responsible for
transferring data in a meaningful form between the network layer where things
will eventually be routed to and from the application layer where data is
interpreted in some way.

The application layer is the top-most layer, and is the layer where user-level
protocols such as HTTP exist. They take the data that has been transferred and
process it in some meaningful way depending on the application context (hence
the name "application layer").

==== 4. #text("How long does it take a packet of length 1,000 bytes to "+
"propagate over a link of distance 2,500 km, propagation speed "+ $2.5×10^8$ +
" m/s, and transmission rate 2 Mbps?")

The length of the packet does not affect the propagation speed, so take
$"speed" / "distance"$.

$2,500 "km" = 2.5*10^6 m$

$qty("2.5e6", "m") / qty("2.5e8", "m/s") = qty("0.01", "s")$

==== 5. #text("Consider a packet of length L which begins at end system A and "+
"travels over three links to a destination end system. These three links are "+
"connected by two packet switches. Let "+$d_i$+", "+$s_i$+", and "+$R_i$+
" denote the length, propagation speed, and the transmission rate of link "+
$i$+", for "+$i = 1, 2, 3$+". The packet switch delays each packet by "+
$d_"proc"$+ ". Assuming no queuing delays, what is the total end-to-end delay "+
"for the packet?")

Since we are ignoring queuing delays, the total end-to-end delay is the sum of
transmission time, propgation time, and processing delay for each
link.

Each link needs to be processed on each side, so there are three of
$2 * d_"proc"$, one for each link. Then, each propagation time is a result of
length ($d_i$) divided by propagation speed ($s_i$), so add a for each link too.
Finally, we have to add the transmission time, which is packet length ($L$)
divided by transmission rate ($R_i$), so add $L / R_i$ to the final sum.

The total expression for the sum would be as follows:

$ sum_(i = 1, 2, 3) 2 * d_"proc" + d_i / s_i + L_i / R_i $

==== #text(
  "Suppose now the packet is 1,500 bytes, the propagation speed on "
    + "all three links is 2.5×108 m/s, the transmission rates of all three links "
    + "are 2 Mbps, the packet switch processing delay is 3 msec, the length of the "
    + "first link is 5,000 km, the length of the second link is 4,000 km, and the "
    + "length of the last link is 1,000 km. For these values, what is the "
    + "end-to-end delay?",
)

Substitute the terms from the summation above, and we get:

Total propagation time: $(qty("5e6", "m") + qty("4e6", "m") + qty("1e6", "m"))
/ qty("2.5e8", "m/s") = qty("0.04", "s")$

Total transmission time: $3 * (12000 "bits"/ num("2e6") "bps") = qty("0.018", "s")$

Total processing delay: $3 * 2 * qty("3e-3", "s") = qty("0.018", "s")$

$0.04 + 0.018 + 0.018 = qty("0.076", "s") = qty("76", "ms")$

==== 6. #text("Suppose Host A wants to send a large file to Host B. The path "+
"from Host A to Host B has three links, of rates "+$R_1 = 1 "Mbps"$+", "+
$R_2 = 2 "Mbps"$+", and " +$R_3 = 4 "Mbps"$+".")

===== a. Assuming no other traffic in the network, what is the throughput for the file transfer?

Total throughput will be bottlenecked by the slowest link, which $R_1 = 1 "Mbps"$

===== b. #text("Suppose the file is 4 million bytes. Dividing the file size "+
"by the throughput, roughly how long will it take to transfer the file to "+
"Host B?")

$(num("32e6") "bits") / (num("1e6") "bps") = qty("32", "s")$

==== 7. #text("Suppose you would like to urgently deliver 40 terabytes (1 "+
"terabyte = "+$10^12$+" bytes) data from Boston to Los Angeles. You have "+
"available a 100 Mbps dedicated link for data transfer. Would you prefer to "+
"transmit the data via this link or instead save the data in a hard drive and "+
"send using FedEx overnight delivery? Explain.")

$num("1e12") "bytes" * 8 "bits" = num("8e12") "bits"$

$num("100") "Mbps" * num("1e6") "bps" / "Mbps" = num("1e8") "bps"$

$(num("8e12") "bits") / (num("1e8") "bps") = qty("8e4", "s")$

$qty("8e4", "s") / qty("3600", "s/h")= qty("22.2", "h")$

$qty("22.2", "h") < qty("24", "h")$, so it is better to transmit it over the network rather than with
overnight shipping.
