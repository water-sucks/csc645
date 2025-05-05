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

#init("Homework 3", "Varun Narravula", "923-287-037")

== 1. Network Layer Functions

_What are the two most important network-layer functions in a computer network?
What is the difference between them?_

The two functions are *routing* and *forwarding*. Routing is algorithmically
determining what path a potential piece of data should take between networks,
while forwarding is the actual process of sending data between nodes in a
network.

== 2. Finding Subnets

_Find all subnets in the following network. Write the IP address of those
subnets in the subnet notation (i.e. a.b.c.d/x notation)_

The addresses (in order) are:

Subnet A has the following addresses:

- 223.1.1.1
- 223.1.1.2
- 223.1.1.3 (Gateway)
- 223.1.1.4

Since this is a class C network (starts with 223), we can just assume the
common /24 subnet for the last octet to represent a host address. So the
address of subnet A would be #underline("223.1.1.0/24").

Subnet B has the following addresses:

- 223.1.2.1
- 223.1.2.2
- 223.1.2.6 (Gateway)

This seems to also represent a host address, so using the same process, we
end up with #underline("223.1.2.0/24") for subnet B.

Subnet C has the following addresses:

- 223.1.3.1
- 223.1.3.2
- 223.1.3.27 (Gateway)

Using the same process, we end up with #underline("223.1.3.0/24") for subnet C.

It's also fair to assume that since each network subnet has two outgoing
addresses towards each other in a triangle shape, these are probably
point-to-point links, which would require four addresses: two hosts, one
network, and one broadcast. This means a /30 subnet for each of these.

As such, for the following addresses:

Network A-C interconnect:
- 223.1.7.0
- 223.1.7.1

Network B-C interconnect:
- 223.1.8.0
- 223.1.8.1

Network A-B interconnect:
- 223.1.9.1
- 223.1.9.2

We can assume the following subnets for these, given the four address
assumption given:

- #underline("223.1.7.0/30")
- #underline("223.1.8.0/30")
- #underline("223.1.9.0/30")

== 3. Dijkstra's Algorithm

_Consider the following network. With the indicated link costs, use Dijkstra’s shortest-path
algorithm to compute the shortest path from x to all network nodes. Show how the
algorithm works by computing a table similar to what we use in the lecture notes. Also
draw the resulting shortest-path tree from x to all nodes and the resulting forwarding
table in x._

#table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Node*],
    [*Distance*],
  ),

  "x", "0",
  "y", "6",
  "z", "8",
  "v", "3",
  "t", "7",
  "u", "6",
  "w", "6",
)

== 4. Distance Vector Routing

_Consider the network in the figure. Distance vector routing is used, and the
following vectors have just come in for router C:
from B: *(5, 0, 8, 3, 6, 2)*
from D: *(6, 7, 6, 0, 9, 10)*
from E: *(7, 6, 3, 2, 0, 4)*
The cost of the links from C to B, D, and E, are *6*, *3*, and *5*, respectively.
What is C’s new routing table? Give both the outgoing line to use and the cost._

Let's assume that the routing vector is in order from networks A-F.

$C #sym.arrow B = 6$

$C #sym.arrow D = 3$

$C #sym.arrow E = 5$

Now, let's calculate each cost:

$C #sym.arrow A$:

- through $B: (C #sym.arrow B) + (B #sym.arrow A) = 6 + 5 = 11$
- through $D: (C #sym.arrow D) + (D #sym.arrow A) = 3 + 6 = 9$
- through $E: (C #sym.arrow E) + (E #sym.arrow A) = 5 + 7 = 12$

$C #sym.arrow A = 9$, via D.

$C #sym.arrow B$:

- through $B (C #sym.arrow B) + (B #sym.arrow B) = 6 + 0 = 6$
- through $D: (C #sym.arrow D) + (D #sym.arrow B) = 3 + 7 = 10$
- through $E: (C #sym.arrow E) + (E #sym.arrow B) = 5 + 6 = 11$

$C #sym.arrow A = 6$, via B.

$C #sym.arrow C = 0$, via the local interface.

$C #sym.arrow D$:

- through $B: (C #sym.arrow B) + (B #sym.arrow D) = 6 + 3 = 9$
- through $D: (C #sym.arrow D) + (D #sym.arrow D) = 3 + 0 = 3$
- through $E: (C #sym.arrow E) + (E #sym.arrow D) = 5 + 2 = 7$

$C #sym.arrow D = 3$, via D.

$C #sym.arrow E$:

- through $B: (C #sym.arrow B) + (B #sym.arrow E) = 6 + 6 = 12$
- through $D: (C #sym.arrow D) + (D #sym.arrow E) = 3 + 9 = 12$
- through $E: (C #sym.arrow E) + (E #sym.arrow E) = 5 + 0 = 5$

$C #sym.arrow E = 5$, via E.

$C #sym.arrow F$:

- through $B: (C #sym.arrow B) + (B #sym.arrow F) = 6 + 2 = 8$
- through $D: (C #sym.arrow D) + (D #sym.arrow F) = 3 + 10 = 13$
- through $E: (C #sym.arrow E) + (E #sym.arrow F) = 5 + 4 = 9$

$C #sym.arrow E = 8$, via B.

This is the routing table for these minimum distances:

#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Destination*],
    [*Outgoing Node*],
    [*Cost*],
  ),

  "C", "n/a", "0",
  "A", "D", "9",
  "B", "B", "6",
  "D", "D", "3",
  "E", "E", "5",
  "F", "B", "8",
)
