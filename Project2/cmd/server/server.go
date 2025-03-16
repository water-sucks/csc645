package server

import (
	"encoding/json"
	"fmt"

	"github.com/spf13/cobra"
)

type ServerOpts struct {
	Addr   string
	Port   uint
	UseTCP bool
	UseUDP bool
}

func ServerCommand() *cobra.Command {
	opts := ServerOpts{}

	cmd := cobra.Command{
		Use:   "server",
		Short: "Run TCP/UDP server for reversing sentence",
		Long:  "Run TCP/UDP server for reversing sentence",
		RunE: func(cmd *cobra.Command, args []string) error {
			return serverMain(&opts)
		},
	}

	cmd.Flags().StringVarP(&opts.Addr, "addr", "a", "localhost", "Address to bind to")
	cmd.Flags().UintVarP(&opts.Port, "port", "p", 8080, "Port to bind to")
	cmd.Flags().BoolVarP(&opts.UseTCP, "tcp", "t", false, "Use TCP as the protocol")
	cmd.Flags().BoolVarP(&opts.UseUDP, "udp", "u", false, "Use UDP as the protocol")
	cmd.Flags().BoolP("help", "h", false, "Show this help menu")

	cmd.MarkFlagsOneRequired("tcp", "udp")
	cmd.MarkFlagsMutuallyExclusive("tcp", "udp")

	return &cmd
}

func serverMain(opts *ServerOpts) error {
	strOutput, _ := json.Marshal(opts)
	fmt.Println(string(strOutput))
	return nil
}
