package client

import (
	"fmt"

	"github.com/spf13/cobra"
)

type ClientOpts struct {
	Addr    string
	Port    uint
	UseTCP  bool
	UseUDP  bool
	Message string
}

func ClientCommand() *cobra.Command {
	opts := ClientOpts{}

	cmd := cobra.Command{
		Use:          "client <MESSAGE>",
		Short:        "Send tcp/udp message to server to reverse message",
		Long:         "Send tcp/udp message to server to reverse message",
		SilenceUsage: true,
		Args: func(cmd *cobra.Command, args []string) error {
			if len(args) != 1 {
				return fmt.Errorf("requires exactly one argument")
			}

			opts.Message = args[0]
			return nil
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			return clientMain(&opts)
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

func clientMain(opts *ClientOpts) error {
	if opts.UseTCP {
		return tcpClient(opts.Message, opts.Addr, opts.Port)
	} else if opts.UseUDP {
		return udpClient(opts.Message, opts.Addr, opts.Port)
	}

	return nil
}
