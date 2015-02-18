package main

import (
	"encoding/base64"
	"fmt"
	"hash/crc64"
	"io"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Printf("Syntax: %s <file>\n", os.Args[0])
		os.Exit(1)
	}
	p := os.Args[1]
	f, err := os.Open(p)
	if err != nil {
		panic(err)
	}
	h := crc64.New(crc64.MakeTable(crc64.ISO))
	b := make([]byte, 65536)
	for {
		n, err := f.Read(b)
		if n > 0 {
			_, err := h.Write(b[:n])
			if err != nil {
				panic(err)
			}
		}
		if err != nil {
			if err == io.EOF {
				break
			}
			panic(err)
		}
	}
	f.Close()
	fmt.Print(strings.TrimRight(base64.URLEncoding.EncodeToString(h.Sum(nil)), "="))
	x := filepath.Ext(p)
	if len(x) > 0 {
		fmt.Print(filepath.Ext(p))
	}
	fmt.Println()
}
