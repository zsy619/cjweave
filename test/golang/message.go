package main

type Message struct {
	MsgId  uint32
	MsgLen uint32
	Data   []byte
}

func (msg *Message) getMsgId() uint32 {
	return msg.MsgId
}

func (msg *Message) getMsgLen() uint32 {
	return msg.MsgLen
}

func (msg *Message) getData() []byte {
	return msg.Data
}

func (msg *Message) setMsgId(id uint32) {
	msg.MsgId = id
}

func (msg *Message) setMsgLen(len uint32) {
	msg.MsgLen = len
}
