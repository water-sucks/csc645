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

func tcpServer(addr string, port uint) error {
	addrStr := fmt.Sprintf("%s:%d", addr, port)

	raddr, err := net.ResolveTCPAddr("tcp", addrStr)
	if err != nil {
		return fmt.Errorf("failed to resolve TCP address: %w", err)
	}

	listener, err := net.ListenTCP("tcp", raddr)
	if err != nil {
		return fmt.Errorf("failed to listen on TCP address: %w", err)
	}
	defer listener.Close()

	log.Printf("TCP server listening on %s", listener.Addr().String())

	buffer := make([]byte, 1024)

	shutdownSignal := make(chan os.Signal, 1)
	signal.Notify(shutdownSignal, syscall.SIGTERM)
	signal.Notify(shutdownSignal, syscall.SIGINT)

	go func() {
		<-shutdownSignal
		log.Println("shutting down...")

		listener.Close()
		// Let existing connections finish for a second before shutting down
		time.Sleep(1 * time.Second)
		log.Println("TCP server shut down successfully")
	}()

	for {
		conn, err := listener.Accept()
		if err != nil {
			if opErr, ok := err.(*net.OpError); ok && opErr.Op == "accept" {
				return nil
			}

			log.Printf("failed to accept connection: %v", err)
			continue
		}

		log.Printf("accepted connection from %s", conn.RemoteAddr().String())

		go handleConnection(conn, buffer)
	}
}

func handleConnection(conn net.Conn, buffer []byte) {
	defer conn.Close()

	n, err := conn.Read(buffer)
	if err != nil {
		log.Printf("failed to read from connection: %v\n", err)
		return
	}

	response := reverser.ReverseWords(buffer[:n])
	if _, err := conn.Write(response); err != nil {
		log.Printf("failed to write to connection: %v", err)
		return
	}
}
