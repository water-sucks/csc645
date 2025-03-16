package reverser

import (
	"slices"
	"strings"
)

func ReverseWords(buf []byte) []byte {
	tmp := strings.Split(string(buf), " ")
	slices.Reverse(tmp)
	return []byte(strings.Join(tmp, " "))
}
