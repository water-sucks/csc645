package server

import (
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"

	"project2/internal/reverser"
)

func udpServer(addr string, port uint) error {
	addrStr := fmt.Sprintf("%s:%d", addr, port)

	raddr, err := net.ResolveUDPAddr("udp", addrStr)
	if err != nil {
		return fmt.Errorf("failed to resolve UDP address: %w", err)
	}

	sock, err := net.ListenUDP("udp", raddr)
	if err != nil {
		return fmt.Errorf("failed to listen on UDP address: %w", err)
	}
	defer sock.Close()

	buffer := make([]byte, 1024)

	shutdownSignal := make(chan os.Signal, 1)
	signal.Notify(shutdownSignal, syscall.SIGTERM, syscall.SIGINT)

	log.Printf("UDP server listening on %s...", sock.LocalAddr().String())

	go func() {
		<-shutdownSignal
		log.Println("shutting down...")

		sock.Close()
		// Let existing connections finish for a second before shutting down
		time.Sleep(1 * time.Second)
		log.Println("UDP server shut down successfully")
	}()

	for {
		n, clientAddr, err := sock.ReadFromUDP(buffer)
		if err != nil {
			if opErr, ok := err.(*net.OpError); ok && opErr.Op == "read" {
				return nil
			}

			fmt.Printf("failed to read from UDP: %v", err)
			continue
		}

		log.Printf("accepted connection from %s", clientAddr.String())

		response := reverser.ReverseWords(buffer[:n])

		if _, err := sock.WriteToUDP(response, clientAddr); err != nil {
			fmt.Printf("failed to write to UDP: %v", err)
			continue
		}
	}
}
