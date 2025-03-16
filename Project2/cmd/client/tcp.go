package client

import (
	"fmt"
	"net"
)

func tcpClient(message string, addr string, port uint) error {
	addrStr := fmt.Sprintf("%s:%d", addr, port)

	raddr, err := net.ResolveTCPAddr("tcp", addrStr)
	if err != nil {
		return fmt.Errorf("failed to resolve TCP address: %w", err)
	}

	sock, err := net.DialTCP("tcp", nil, raddr)
	if err != nil {
		return fmt.Errorf("failed to dial TCP address: %w", err)
	}
	defer sock.Close()

	if _, err := sock.Write([]byte(message)); err != nil {
		return fmt.Errorf("failed to write to socket: %w", err)
	}

	buffer := make([]byte, 1024)

	n, err := sock.Read(buffer)
	if err != nil {
		return fmt.Errorf("failed to read from socket: %w", err)
	}

	fmt.Println(string(buffer[:n]))
	return nil
}
