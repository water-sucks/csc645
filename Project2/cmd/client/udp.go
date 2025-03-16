package client

import (
	"fmt"
	"net"
)

func udpClient(message string, addr string, port uint) error {
	addrStr := fmt.Sprintf("%s:%d", addr, port)

	raddr, err := net.ResolveUDPAddr("udp", addrStr)
	if err != nil {
		return fmt.Errorf("failed to resolve UDP address: %w", err)
	}

	sock, err := net.DialUDP("udp", nil, raddr)
	if err != nil {
		return fmt.Errorf("failed to dial UDP address: %w", err)
	}
	defer sock.Close()

	if _, err := sock.Write([]byte(message)); err != nil {
		return fmt.Errorf("failed to write to UDP connection: %w", err)
	}

	buffer := make([]byte, 1024)

	n, _, err := sock.ReadFromUDP(buffer)
	if err != nil {
		return fmt.Errorf("failed to read from UDP connection: %w", err)
	}

	fmt.Println(string(buffer[:n]))
	return nil
}
