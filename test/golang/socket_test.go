package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"net"
	"os"
	"testing"
	"time"
)

func Test_Message(t *testing.T) {
	data := "我爱你中国！"
	msg := &Message{
		MsgId:  1528963,
		MsgLen: uint32(len(data)),
		Data:   []byte(data),
	}
	dataBuff := bytes.NewBuffer([]byte{})
	binary.Write(dataBuff, binary.LittleEndian, msg.getMsgLen())
	binary.Write(dataBuff, binary.LittleEndian, msg.getMsgId())
	binary.Write(dataBuff, binary.LittleEndian, msg.getData())
	fmt.Println(dataBuff.Bytes())
	fmt.Println([]byte("00080001000234567890"))
	// [18 0 0 0 131 84 23 0 230 136 145 231 136 177 228 189 160 228 184 173 229 155 189 239 188 129]
}

func Test_MessageSocket(t *testing.T) {
	ipAddress := "0.0.0.0:9090"
	client, err := net.ResolveTCPAddr("tcp4", ipAddress)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Fatal error: %s", err.Error())
		os.Exit(1)
	}

	conn, err := net.DialTCP("tcp", nil, client)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Fatal error: %s", err.Error())
		os.Exit(1)
	}

	fmt.Println("connect success")
	for {
		var msgId uint32
		for i := 10000; i < 10020; i++ {
			go sender(msgId, conn)
			if msgId == 0 {
				msgId++
			} else {
				msgId = 0
			}
		}
		time.Sleep(time.Millisecond * 1000)
		// break
	}
}

func sender(msgId uint32, conn net.Conn) {
	dataBuff1 := bytes.NewBuffer([]byte{})
	{
		data := fmt.Sprintf("我爱你中国！%d", msgId)
		msg := &Message{
			MsgId:  msgId,
			MsgLen: uint32(len(data)),
			Data:   []byte(data),
		}
		binary.Write(dataBuff1, binary.LittleEndian, msg.getMsgLen())
		binary.Write(dataBuff1, binary.LittleEndian, msg.getMsgId())
		binary.Write(dataBuff1, binary.LittleEndian, msg.getData())
	}
	dataBuff2 := bytes.NewBuffer([]byte{})
	{
		data := fmt.Sprintf("我爱你中国！%d", msgId+100000)
		msg := &Message{
			MsgId:  msgId,
			MsgLen: uint32(len(data)),
			Data:   []byte(data),
		}
		binary.Write(dataBuff2, binary.LittleEndian, msg.getMsgLen())
		binary.Write(dataBuff2, binary.LittleEndian, msg.getMsgId())
		binary.Write(dataBuff2, binary.LittleEndian, msg.getData())
	}
	// dataBuff3 := bytes.NewBuffer([]byte{})
	// {
	// 	data := fmt.Sprintf("我爱你中国！%d", msgId+100000)
	// 	msg := &Message{
	// 		MsgId:  100000,
	// 		MsgLen: uint32(len(data)) - 6,
	// 		Data:   []byte(data),
	// 	}
	// 	binary.Write(dataBuff2, binary.LittleEndian, msg.getMsgLen())
	// 	binary.Write(dataBuff3, binary.LittleEndian, msg.getMsgId())
	// 	binary.Write(dataBuff3, binary.LittleEndian, msg.getData())
	// }
	var data []byte
	data = append(data, dataBuff1.Bytes()...)
	data = append(data, dataBuff2.Bytes()...)
	// data = append(data, dataBuff3.Bytes()...)
	if _, err := conn.Write(data); err != nil {
		fmt.Println(err.Error())
	} else {
		fmt.Println("send over-->", data)
	}
}
