# CSC-645 Project 2: TCP/UDP Server

I wrote this in Go, because why not. Install Go from their
[website](https://go.dev/doc/install).

## Structure

- `project2`
  - `client`
    - Options:
    - `-u, --udp` | `-t, --tcp` (required)
    - `-a, --addr` (default: localhost)
    - `-p, --port`
    - `<message>` (required)
  - `server`
    - Options:
    - `-u, --udp` | `-t, --tcp` (required)
    - `-a, --addr` (default: localhost)
    - `-p, --port` (default: 8080)

## Example Runs

### Server

- TCP :: `go run . --tcp -p 6969`
- UDP :: `go run . --udp -p 6969`

Ctrl+C will shut down the server.

### Client

- TCP :: `go run . --tcp -p 6969 "Goodbye, cruel world."`
- UDP :: `go run . --udp -p 6969 "Goodbye, cruel world."`

The command will exit immediately after a response is received.
