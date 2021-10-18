// Code generated by protoc-gen-go. DO NOT EDIT.
// source: node.proto

package mpt

import (
	fmt "fmt"

	proto "github.com/golang/protobuf/proto"

	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion2 // please upgrade the proto package

// Node mpt涉及到的node类型由四种基本类型
type Node struct {
	// Types that are valid to be assigned to Value:
	//	*Node_Full
	//	*Node_Short
	//	*Node_Hash
	//	*Node_Val
	Value                isNode_Value `protobuf_oneof:"value"`
	Ty                   int32        `protobuf:"varint,1,opt,name=Ty,proto3" json:"Ty,omitempty"`
	Index                int32        `protobuf:"varint,6,opt,name=index,proto3" json:"index,omitempty"`
	XXX_NoUnkeyedLiteral struct{}     `json:"-"`
	XXX_unrecognized     []byte       `json:"-"`
	XXX_sizecache        int32        `json:"-"`
}

func (m *Node) Reset()         { *m = Node{} }
func (m *Node) String() string { return proto.CompactTextString(m) }
func (*Node) ProtoMessage()    {}
func (*Node) Descriptor() ([]byte, []int) {
	return fileDescriptor_node_001a9bd628f8d256, []int{0}
}
func (m *Node) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_Node.Unmarshal(m, b)
}
func (m *Node) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_Node.Marshal(b, m, deterministic)
}
func (dst *Node) XXX_Merge(src proto.Message) {
	xxx_messageInfo_Node.Merge(dst, src)
}
func (m *Node) XXX_Size() int {
	return xxx_messageInfo_Node.Size(m)
}
func (m *Node) XXX_DiscardUnknown() {
	xxx_messageInfo_Node.DiscardUnknown(m)
}

var xxx_messageInfo_Node proto.InternalMessageInfo

type isNode_Value interface {
	isNode_Value()
}

type Node_Full struct {
	Full *FullNode `protobuf:"bytes,2,opt,name=full,proto3,oneof"`
}

type Node_Short struct {
	Short *ShortNode `protobuf:"bytes,3,opt,name=short,proto3,oneof"`
}

type Node_Hash struct {
	Hash *HashNode `protobuf:"bytes,4,opt,name=hash,proto3,oneof"`
}

type Node_Val struct {
	Val *ValueNode `protobuf:"bytes,5,opt,name=val,proto3,oneof"`
}

func (*Node_Full) isNode_Value() {}

func (*Node_Short) isNode_Value() {}

func (*Node_Hash) isNode_Value() {}

func (*Node_Val) isNode_Value() {}

func (m *Node) GetValue() isNode_Value {
	if m != nil {
		return m.Value
	}
	return nil
}

func (m *Node) GetFull() *FullNode {
	if x, ok := m.GetValue().(*Node_Full); ok {
		return x.Full
	}
	return nil
}

func (m *Node) GetShort() *ShortNode {
	if x, ok := m.GetValue().(*Node_Short); ok {
		return x.Short
	}
	return nil
}

func (m *Node) GetHash() *HashNode {
	if x, ok := m.GetValue().(*Node_Hash); ok {
		return x.Hash
	}
	return nil
}

func (m *Node) GetVal() *ValueNode {
	if x, ok := m.GetValue().(*Node_Val); ok {
		return x.Val
	}
	return nil
}

func (m *Node) GetTy() int32 {
	if m != nil {
		return m.Ty
	}
	return 0
}

func (m *Node) GetIndex() int32 {
	if m != nil {
		return m.Index
	}
	return 0
}

// XXX_OneofFuncs is for the internal use of the proto package.
func (*Node) XXX_OneofFuncs() (func(msg proto.Message, b *proto.Buffer) error, func(msg proto.Message, tag, wire int, b *proto.Buffer) (bool, error), func(msg proto.Message) (n int), []interface{}) {
	return _Node_OneofMarshaler, _Node_OneofUnmarshaler, _Node_OneofSizer, []interface{}{
		(*Node_Full)(nil),
		(*Node_Short)(nil),
		(*Node_Hash)(nil),
		(*Node_Val)(nil),
	}
}

func _Node_OneofMarshaler(msg proto.Message, b *proto.Buffer) error {
	m := msg.(*Node)
	// value
	switch x := m.Value.(type) {
	case *Node_Full:
		b.EncodeVarint(2<<3 | proto.WireBytes)
		if err := b.EncodeMessage(x.Full); err != nil {
			return err
		}
	case *Node_Short:
		b.EncodeVarint(3<<3 | proto.WireBytes)
		if err := b.EncodeMessage(x.Short); err != nil {
			return err
		}
	case *Node_Hash:
		b.EncodeVarint(4<<3 | proto.WireBytes)
		if err := b.EncodeMessage(x.Hash); err != nil {
			return err
		}
	case *Node_Val:
		b.EncodeVarint(5<<3 | proto.WireBytes)
		if err := b.EncodeMessage(x.Val); err != nil {
			return err
		}
	case nil:
	default:
		return fmt.Errorf("Node.Value has unexpected type %T", x)
	}
	return nil
}

func _Node_OneofUnmarshaler(msg proto.Message, tag, wire int, b *proto.Buffer) (bool, error) {
	m := msg.(*Node)
	switch tag {
	case 2: // value.full
		if wire != proto.WireBytes {
			return true, proto.ErrInternalBadWireType
		}
		msg := new(FullNode)
		err := b.DecodeMessage(msg)
		m.Value = &Node_Full{msg}
		return true, err
	case 3: // value.short
		if wire != proto.WireBytes {
			return true, proto.ErrInternalBadWireType
		}
		msg := new(ShortNode)
		err := b.DecodeMessage(msg)
		m.Value = &Node_Short{msg}
		return true, err
	case 4: // value.hash
		if wire != proto.WireBytes {
			return true, proto.ErrInternalBadWireType
		}
		msg := new(HashNode)
		err := b.DecodeMessage(msg)
		m.Value = &Node_Hash{msg}
		return true, err
	case 5: // value.val
		if wire != proto.WireBytes {
			return true, proto.ErrInternalBadWireType
		}
		msg := new(ValueNode)
		err := b.DecodeMessage(msg)
		m.Value = &Node_Val{msg}
		return true, err
	default:
		return false, nil
	}
}

func _Node_OneofSizer(msg proto.Message) (n int) {
	m := msg.(*Node)
	// value
	switch x := m.Value.(type) {
	case *Node_Full:
		s := proto.Size(x.Full)
		n += 1 // tag and wire
		n += proto.SizeVarint(uint64(s))
		n += s
	case *Node_Short:
		s := proto.Size(x.Short)
		n += 1 // tag and wire
		n += proto.SizeVarint(uint64(s))
		n += s
	case *Node_Hash:
		s := proto.Size(x.Hash)
		n += 1 // tag and wire
		n += proto.SizeVarint(uint64(s))
		n += s
	case *Node_Val:
		s := proto.Size(x.Val)
		n += 1 // tag and wire
		n += proto.SizeVarint(uint64(s))
		n += s
	case nil:
	default:
		panic(fmt.Sprintf("proto: unexpected type %T in oneof", x))
	}
	return n
}

// FullNode 分支节点
type FullNode struct {
	Nodes                []*Node  `protobuf:"bytes,1,rep,name=nodes,proto3" json:"nodes,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *FullNode) Reset()         { *m = FullNode{} }
func (m *FullNode) String() string { return proto.CompactTextString(m) }
func (*FullNode) ProtoMessage()    {}
func (*FullNode) Descriptor() ([]byte, []int) {
	return fileDescriptor_node_001a9bd628f8d256, []int{1}
}
func (m *FullNode) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_FullNode.Unmarshal(m, b)
}
func (m *FullNode) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_FullNode.Marshal(b, m, deterministic)
}
func (dst *FullNode) XXX_Merge(src proto.Message) {
	xxx_messageInfo_FullNode.Merge(dst, src)
}
func (m *FullNode) XXX_Size() int {
	return xxx_messageInfo_FullNode.Size(m)
}
func (m *FullNode) XXX_DiscardUnknown() {
	xxx_messageInfo_FullNode.DiscardUnknown(m)
}

var xxx_messageInfo_FullNode proto.InternalMessageInfo

func (m *FullNode) GetNodes() []*Node {
	if m != nil {
		return m.Nodes
	}
	return nil
}

// ShortNode  扩展/叶子节点
type ShortNode struct {
	Key                  []byte   `protobuf:"bytes,1,opt,name=key,proto3" json:"key,omitempty"`
	Val                  *Node    `protobuf:"bytes,2,opt,name=val,proto3" json:"val,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *ShortNode) Reset()         { *m = ShortNode{} }
func (m *ShortNode) String() string { return proto.CompactTextString(m) }
func (*ShortNode) ProtoMessage()    {}
func (*ShortNode) Descriptor() ([]byte, []int) {
	return fileDescriptor_node_001a9bd628f8d256, []int{2}
}
func (m *ShortNode) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_ShortNode.Unmarshal(m, b)
}
func (m *ShortNode) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_ShortNode.Marshal(b, m, deterministic)
}
func (dst *ShortNode) XXX_Merge(src proto.Message) {
	xxx_messageInfo_ShortNode.Merge(dst, src)
}
func (m *ShortNode) XXX_Size() int {
	return xxx_messageInfo_ShortNode.Size(m)
}
func (m *ShortNode) XXX_DiscardUnknown() {
	xxx_messageInfo_ShortNode.DiscardUnknown(m)
}

var xxx_messageInfo_ShortNode proto.InternalMessageInfo

func (m *ShortNode) GetKey() []byte {
	if m != nil {
		return m.Key
	}
	return nil
}

func (m *ShortNode) GetVal() *Node {
	if m != nil {
		return m.Val
	}
	return nil
}

// HashNode hash节点
type HashNode struct {
	Hash                 []byte   `protobuf:"bytes,1,opt,name=hash,proto3" json:"hash,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *HashNode) Reset()         { *m = HashNode{} }
func (m *HashNode) String() string { return proto.CompactTextString(m) }
func (*HashNode) ProtoMessage()    {}
func (*HashNode) Descriptor() ([]byte, []int) {
	return fileDescriptor_node_001a9bd628f8d256, []int{3}
}
func (m *HashNode) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_HashNode.Unmarshal(m, b)
}
func (m *HashNode) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_HashNode.Marshal(b, m, deterministic)
}
func (dst *HashNode) XXX_Merge(src proto.Message) {
	xxx_messageInfo_HashNode.Merge(dst, src)
}
func (m *HashNode) XXX_Size() int {
	return xxx_messageInfo_HashNode.Size(m)
}
func (m *HashNode) XXX_DiscardUnknown() {
	xxx_messageInfo_HashNode.DiscardUnknown(m)
}

var xxx_messageInfo_HashNode proto.InternalMessageInfo

func (m *HashNode) GetHash() []byte {
	if m != nil {
		return m.Hash
	}
	return nil
}

// ValueNode value节点
type ValueNode struct {
	Value                []byte   `protobuf:"bytes,1,opt,name=value,proto3" json:"value,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *ValueNode) Reset()         { *m = ValueNode{} }
func (m *ValueNode) String() string { return proto.CompactTextString(m) }
func (*ValueNode) ProtoMessage()    {}
func (*ValueNode) Descriptor() ([]byte, []int) {
	return fileDescriptor_node_001a9bd628f8d256, []int{4}
}
func (m *ValueNode) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_ValueNode.Unmarshal(m, b)
}
func (m *ValueNode) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_ValueNode.Marshal(b, m, deterministic)
}
func (dst *ValueNode) XXX_Merge(src proto.Message) {
	xxx_messageInfo_ValueNode.Merge(dst, src)
}
func (m *ValueNode) XXX_Size() int {
	return xxx_messageInfo_ValueNode.Size(m)
}
func (m *ValueNode) XXX_DiscardUnknown() {
	xxx_messageInfo_ValueNode.DiscardUnknown(m)
}

var xxx_messageInfo_ValueNode proto.InternalMessageInfo

func (m *ValueNode) GetValue() []byte {
	if m != nil {
		return m.Value
	}
	return nil
}

func init() {
	proto.RegisterType((*Node)(nil), "mpt.Node")
	proto.RegisterType((*FullNode)(nil), "mpt.FullNode")
	proto.RegisterType((*ShortNode)(nil), "mpt.ShortNode")
	proto.RegisterType((*HashNode)(nil), "mpt.HashNode")
	proto.RegisterType((*ValueNode)(nil), "mpt.ValueNode")
}

func init() { proto.RegisterFile("node.proto", fileDescriptor_node_001a9bd628f8d256) }

var fileDescriptor_node_001a9bd628f8d256 = []byte{
	// 264 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0x4c, 0x51, 0xc1, 0x4a, 0xc3, 0x40,
	0x10, 0x75, 0xb3, 0xd9, 0xda, 0x4c, 0xb5, 0xc8, 0xe0, 0x61, 0x41, 0xd0, 0xb8, 0x82, 0x04, 0x84,
	0x1c, 0xea, 0xcd, 0xa3, 0x07, 0xe9, 0xc9, 0x43, 0x2c, 0xde, 0x23, 0x59, 0x89, 0xb8, 0xed, 0x86,
	0x26, 0x29, 0xf6, 0x1b, 0xfd, 0xa9, 0x32, 0xbb, 0x9b, 0x90, 0xdb, 0xce, 0x7b, 0x6f, 0xde, 0xbc,
	0x97, 0x00, 0xec, 0x6c, 0xa5, 0xf3, 0x66, 0x6f, 0x3b, 0x8b, 0x7c, 0xdb, 0x74, 0xea, 0x9f, 0x41,
	0xfc, 0x6e, 0x2b, 0x8d, 0x0f, 0x10, 0x7f, 0xf7, 0xc6, 0xc8, 0x28, 0x65, 0xd9, 0x62, 0x75, 0x99,
	0x6f, 0x9b, 0x2e, 0x7f, 0xeb, 0x8d, 0x21, 0x72, 0x7d, 0x56, 0x38, 0x12, 0x1f, 0x41, 0xb4, 0xb5,
	0xdd, 0x77, 0x92, 0x3b, 0xd5, 0xd2, 0xa9, 0x3e, 0x08, 0x09, 0x32, 0x4f, 0x93, 0x59, 0x5d, 0xb6,
	0xb5, 0x8c, 0x27, 0x66, 0xeb, 0xb2, 0xad, 0x07, 0x33, 0x22, 0x51, 0x01, 0x3f, 0x94, 0x46, 0x8a,
	0x89, 0xd5, 0x67, 0x69, 0x7a, 0x1d, 0x44, 0x44, 0xe2, 0x12, 0xa2, 0xcd, 0x51, 0xb2, 0x94, 0x65,
	0xa2, 0x88, 0x36, 0x47, 0xbc, 0x06, 0xf1, 0xb3, 0xab, 0xf4, 0x9f, 0x9c, 0x39, 0xc8, 0x0f, 0xaf,
	0xe7, 0x20, 0x0e, 0xb4, 0xa9, 0x9e, 0x60, 0x3e, 0x64, 0xc6, 0x3b, 0x10, 0x54, 0xb6, 0x95, 0x2c,
	0xe5, 0xd9, 0x62, 0x95, 0xb8, 0x03, 0xc4, 0x14, 0x1e, 0x57, 0x2f, 0x90, 0x8c, 0xd1, 0xf1, 0x0a,
	0xf8, 0xaf, 0xf6, 0x97, 0x2e, 0x0a, 0x7a, 0xe2, 0x8d, 0x8f, 0xe7, 0xbf, 0xc7, 0x64, 0x9b, 0x50,
	0x75, 0x0b, 0xf3, 0xa1, 0x0f, 0x62, 0x28, 0xeb, 0x77, 0xdd, 0x5b, 0xdd, 0x43, 0x32, 0x76, 0xa1,
	0xd0, 0x2e, 0x5e, 0x50, 0xf8, 0xe1, 0x6b, 0xe6, 0xfe, 0xc2, 0xf3, 0x29, 0x00, 0x00, 0xff, 0xff,
	0x42, 0x0c, 0x0a, 0xa4, 0x93, 0x01, 0x00, 0x00,
}
