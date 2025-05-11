import sys

from scapy.all import sniff, Ether, IP
from binascii import hexlify

packet_counter = 1


def process_packet(packet):
    global packet_counter
    print(f"Packet {packet_counter}")
    if Ether in packet:
        ether_layer = packet[Ether]
        print(f"Source MAC: {ether_layer.src}")
        print(f"Destination MAC: {ether_layer.dst}")

        if IP in packet:
            ip_layer = packet[IP]
            print(f"IP Version: {ip_layer.version}")
            print(f"Source IP: {ip_layer.src}")
            print(f"Destination IP: {ip_layer.dst}")
        else:
            print("No IP layer found in this frame.")

        raw_bytes = bytes(packet)[:42]
        hex_bytes = hexlify(raw_bytes).decode("utf-8")

        print("First 42 bytes (hex):")
        for i in range(0, len(hex_bytes), 16):
            line = hex_bytes[i : i + 16]
            formatted_line = " ".join([line[j : j + 2] for j in range(0, len(line), 2)])
            print(formatted_line)

        print("-" * 30)
    packet_counter += 1


if len(sys.argv) < 2:
    print("error: missing required argument <INTERFACE>")
    sys.exit(1)

sniff(iface=sys.argv[1], count=15, prn=process_packet)
