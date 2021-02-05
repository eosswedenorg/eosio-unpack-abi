/**
 * MIT License
 *
 * Copyright (c) 2021 EOS Sw/eden
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package main

import (
	"io"
	"os"
	"flag"
	"log"
	"fmt"
	"bufio"
	"encoding/hex"
	"encoding/json"
	eos "github.com/eoscanada/eos-go"
)

var flag_input_file string
var flag_decode_hex bool

func init() {
	flag.StringVar(&flag_input_file, "file", "", "Input file (if omitted, stdin is used)")
	flag.BoolVar(&flag_decode_hex, "hex", false, "Will consider the input as hex and decode before unpacking the data")

	flag.Parse()
}

// Decode Binary ABI to JSON.
func binToJson(data []byte) ([]byte, error){

	var abi eos.ABI

	err := eos.UnmarshalBinary(data, &abi)
	if err != nil {
		return nil, err
	}
	return json.Marshal(abi)
}

// Read all data from file.
func readFile(fd *os.File) []byte {
	var out []byte
	in := bufio.NewReader(fd)
	for {
		c, err := in.ReadByte()
		if err == io.EOF {
			break;
		}
		out = append(out, c)
	}
	return out
}

func main() {

	var err error
	var fd *os.File

	if len(flag_input_file) > 0 {
		fd, err = os.Open(flag_input_file)
		if err != nil {
			log.Fatal("Failed to open file: ", err)
		}
	} else {
		fd = os.Stdin
	}

	bin := readFile(fd)

	if flag_decode_hex {
		hex.Decode(bin, bin)
	}

	abi, err := binToJson(bin)
	if err != nil {
		log.Fatal(err)

	}

	fmt.Print(string(abi))
}
