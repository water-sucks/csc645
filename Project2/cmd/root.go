package cmd

import (
	"os"

	"project2/cmd/client"
	"project2/cmd/server"

	"github.com/spf13/cobra"
)

func MainCommand() *cobra.Command {
	cmd := cobra.Command{
		Use:   "project2 {command} [flags]",
		Short: "CSC-645 Project 2 TCP/UDP Server and Client",
		Long:  "CSC-645 Project 2 TCP/UDP Server and Client",
	}

	cmd.AddCommand(client.ClientCommand())
	cmd.AddCommand(server.ServerCommand())

	cmd.SetErrPrefix("error:")

	cmd.Flags().BoolP("help", "h", false, "Show this help menu")

	cmd.SetHelpCommand(&cobra.Command{Hidden: true})
	cmd.CompletionOptions.HiddenDefaultCmd = true

	return &cmd
}

func Execute() {
	cmd := MainCommand()

	if err := cmd.Execute(); err != nil {
		os.Exit(1)
	}
}
