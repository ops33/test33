// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.26.0
// 	protoc        v3.9.1
// source: paraconsensus.proto

package types

import (
	reflect "reflect"
	sync "sync"

	types "github.com/33cn/chain33/types"
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type ParaLocalDbBlock struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Height         int64                `protobuf:"varint,1,opt,name=height,proto3" json:"height,omitempty"`
	MainHash       []byte               `protobuf:"bytes,2,opt,name=mainHash,proto3" json:"mainHash,omitempty"`
	MainHeight     int64                `protobuf:"varint,3,opt,name=mainHeight,proto3" json:"mainHeight,omitempty"`
	ParentMainHash []byte               `protobuf:"bytes,4,opt,name=parentMainHash,proto3" json:"parentMainHash,omitempty"`
	BlockTime      int64                `protobuf:"varint,5,opt,name=blockTime,proto3" json:"blockTime,omitempty"`
	Txs            []*types.Transaction `protobuf:"bytes,6,rep,name=txs,proto3" json:"txs,omitempty"`
}

func (x *ParaLocalDbBlock) Reset() {
	*x = ParaLocalDbBlock{}
	if protoimpl.UnsafeEnabled {
		mi := &file_paraconsensus_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *ParaLocalDbBlock) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*ParaLocalDbBlock) ProtoMessage() {}

func (x *ParaLocalDbBlock) ProtoReflect() protoreflect.Message {
	mi := &file_paraconsensus_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use ParaLocalDbBlock.ProtoReflect.Descriptor instead.
func (*ParaLocalDbBlock) Descriptor() ([]byte, []int) {
	return file_paraconsensus_proto_rawDescGZIP(), []int{0}
}

func (x *ParaLocalDbBlock) GetHeight() int64 {
	if x != nil {
		return x.Height
	}
	return 0
}

func (x *ParaLocalDbBlock) GetMainHash() []byte {
	if x != nil {
		return x.MainHash
	}
	return nil
}

func (x *ParaLocalDbBlock) GetMainHeight() int64 {
	if x != nil {
		return x.MainHeight
	}
	return 0
}

func (x *ParaLocalDbBlock) GetParentMainHash() []byte {
	if x != nil {
		return x.ParentMainHash
	}
	return nil
}

func (x *ParaLocalDbBlock) GetBlockTime() int64 {
	if x != nil {
		return x.BlockTime
	}
	return 0
}

func (x *ParaLocalDbBlock) GetTxs() []*types.Transaction {
	if x != nil {
		return x.Txs
	}
	return nil
}

type ParaLocalDbBlockInfo struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Height         int64    `protobuf:"varint,1,opt,name=height,proto3" json:"height,omitempty"`
	MainHash       string   `protobuf:"bytes,2,opt,name=mainHash,proto3" json:"mainHash,omitempty"`
	MainHeight     int64    `protobuf:"varint,3,opt,name=mainHeight,proto3" json:"mainHeight,omitempty"`
	ParentMainHash string   `protobuf:"bytes,4,opt,name=parentMainHash,proto3" json:"parentMainHash,omitempty"`
	BlockTime      int64    `protobuf:"varint,5,opt,name=blockTime,proto3" json:"blockTime,omitempty"`
	Txs            []string `protobuf:"bytes,6,rep,name=txs,proto3" json:"txs,omitempty"`
}

func (x *ParaLocalDbBlockInfo) Reset() {
	*x = ParaLocalDbBlockInfo{}
	if protoimpl.UnsafeEnabled {
		mi := &file_paraconsensus_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *ParaLocalDbBlockInfo) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*ParaLocalDbBlockInfo) ProtoMessage() {}

func (x *ParaLocalDbBlockInfo) ProtoReflect() protoreflect.Message {
	mi := &file_paraconsensus_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use ParaLocalDbBlockInfo.ProtoReflect.Descriptor instead.
func (*ParaLocalDbBlockInfo) Descriptor() ([]byte, []int) {
	return file_paraconsensus_proto_rawDescGZIP(), []int{1}
}

func (x *ParaLocalDbBlockInfo) GetHeight() int64 {
	if x != nil {
		return x.Height
	}
	return 0
}

func (x *ParaLocalDbBlockInfo) GetMainHash() string {
	if x != nil {
		return x.MainHash
	}
	return ""
}

func (x *ParaLocalDbBlockInfo) GetMainHeight() int64 {
	if x != nil {
		return x.MainHeight
	}
	return 0
}

func (x *ParaLocalDbBlockInfo) GetParentMainHash() string {
	if x != nil {
		return x.ParentMainHash
	}
	return ""
}

func (x *ParaLocalDbBlockInfo) GetBlockTime() int64 {
	if x != nil {
		return x.BlockTime
	}
	return 0
}

func (x *ParaLocalDbBlockInfo) GetTxs() []string {
	if x != nil {
		return x.Txs
	}
	return nil
}

var File_paraconsensus_proto protoreflect.FileDescriptor

var file_paraconsensus_proto_rawDesc = []byte{
	0x0a, 0x13, 0x70, 0x61, 0x72, 0x61, 0x63, 0x6f, 0x6e, 0x73, 0x65, 0x6e, 0x73, 0x75, 0x73, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x05, 0x74, 0x79, 0x70, 0x65, 0x73, 0x1a, 0x11, 0x74, 0x72,
	0x61, 0x6e, 0x73, 0x61, 0x63, 0x74, 0x69, 0x6f, 0x6e, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22,
	0xd2, 0x01, 0x0a, 0x10, 0x50, 0x61, 0x72, 0x61, 0x4c, 0x6f, 0x63, 0x61, 0x6c, 0x44, 0x62, 0x42,
	0x6c, 0x6f, 0x63, 0x6b, 0x12, 0x16, 0x0a, 0x06, 0x68, 0x65, 0x69, 0x67, 0x68, 0x74, 0x18, 0x01,
	0x20, 0x01, 0x28, 0x03, 0x52, 0x06, 0x68, 0x65, 0x69, 0x67, 0x68, 0x74, 0x12, 0x1a, 0x0a, 0x08,
	0x6d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x73, 0x68, 0x18, 0x02, 0x20, 0x01, 0x28, 0x0c, 0x52, 0x08,
	0x6d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x73, 0x68, 0x12, 0x1e, 0x0a, 0x0a, 0x6d, 0x61, 0x69, 0x6e,
	0x48, 0x65, 0x69, 0x67, 0x68, 0x74, 0x18, 0x03, 0x20, 0x01, 0x28, 0x03, 0x52, 0x0a, 0x6d, 0x61,
	0x69, 0x6e, 0x48, 0x65, 0x69, 0x67, 0x68, 0x74, 0x12, 0x26, 0x0a, 0x0e, 0x70, 0x61, 0x72, 0x65,
	0x6e, 0x74, 0x4d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x73, 0x68, 0x18, 0x04, 0x20, 0x01, 0x28, 0x0c,
	0x52, 0x0e, 0x70, 0x61, 0x72, 0x65, 0x6e, 0x74, 0x4d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x73, 0x68,
	0x12, 0x1c, 0x0a, 0x09, 0x62, 0x6c, 0x6f, 0x63, 0x6b, 0x54, 0x69, 0x6d, 0x65, 0x18, 0x05, 0x20,
	0x01, 0x28, 0x03, 0x52, 0x09, 0x62, 0x6c, 0x6f, 0x63, 0x6b, 0x54, 0x69, 0x6d, 0x65, 0x12, 0x24,
	0x0a, 0x03, 0x74, 0x78, 0x73, 0x18, 0x06, 0x20, 0x03, 0x28, 0x0b, 0x32, 0x12, 0x2e, 0x74, 0x79,
	0x70, 0x65, 0x73, 0x2e, 0x54, 0x72, 0x61, 0x6e, 0x73, 0x61, 0x63, 0x74, 0x69, 0x6f, 0x6e, 0x52,
	0x03, 0x74, 0x78, 0x73, 0x22, 0xc2, 0x01, 0x0a, 0x14, 0x50, 0x61, 0x72, 0x61, 0x4c, 0x6f, 0x63,
	0x61, 0x6c, 0x44, 0x62, 0x42, 0x6c, 0x6f, 0x63, 0x6b, 0x49, 0x6e, 0x66, 0x6f, 0x12, 0x16, 0x0a,
	0x06, 0x68, 0x65, 0x69, 0x67, 0x68, 0x74, 0x18, 0x01, 0x20, 0x01, 0x28, 0x03, 0x52, 0x06, 0x68,
	0x65, 0x69, 0x67, 0x68, 0x74, 0x12, 0x1a, 0x0a, 0x08, 0x6d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x73,
	0x68, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x08, 0x6d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x73,
	0x68, 0x12, 0x1e, 0x0a, 0x0a, 0x6d, 0x61, 0x69, 0x6e, 0x48, 0x65, 0x69, 0x67, 0x68, 0x74, 0x18,
	0x03, 0x20, 0x01, 0x28, 0x03, 0x52, 0x0a, 0x6d, 0x61, 0x69, 0x6e, 0x48, 0x65, 0x69, 0x67, 0x68,
	0x74, 0x12, 0x26, 0x0a, 0x0e, 0x70, 0x61, 0x72, 0x65, 0x6e, 0x74, 0x4d, 0x61, 0x69, 0x6e, 0x48,
	0x61, 0x73, 0x68, 0x18, 0x04, 0x20, 0x01, 0x28, 0x09, 0x52, 0x0e, 0x70, 0x61, 0x72, 0x65, 0x6e,
	0x74, 0x4d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x73, 0x68, 0x12, 0x1c, 0x0a, 0x09, 0x62, 0x6c, 0x6f,
	0x63, 0x6b, 0x54, 0x69, 0x6d, 0x65, 0x18, 0x05, 0x20, 0x01, 0x28, 0x03, 0x52, 0x09, 0x62, 0x6c,
	0x6f, 0x63, 0x6b, 0x54, 0x69, 0x6d, 0x65, 0x12, 0x10, 0x0a, 0x03, 0x74, 0x78, 0x73, 0x18, 0x06,
	0x20, 0x03, 0x28, 0x09, 0x52, 0x03, 0x74, 0x78, 0x73, 0x42, 0x0a, 0x5a, 0x08, 0x2e, 0x2e, 0x2f,
	0x74, 0x79, 0x70, 0x65, 0x73, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_paraconsensus_proto_rawDescOnce sync.Once
	file_paraconsensus_proto_rawDescData = file_paraconsensus_proto_rawDesc
)

func file_paraconsensus_proto_rawDescGZIP() []byte {
	file_paraconsensus_proto_rawDescOnce.Do(func() {
		file_paraconsensus_proto_rawDescData = protoimpl.X.CompressGZIP(file_paraconsensus_proto_rawDescData)
	})
	return file_paraconsensus_proto_rawDescData
}

var file_paraconsensus_proto_msgTypes = make([]protoimpl.MessageInfo, 2)
var file_paraconsensus_proto_goTypes = []interface{}{
	(*ParaLocalDbBlock)(nil),     // 0: types.ParaLocalDbBlock
	(*ParaLocalDbBlockInfo)(nil), // 1: types.ParaLocalDbBlockInfo
	(*types.Transaction)(nil),    // 2: types.Transaction
}
var file_paraconsensus_proto_depIdxs = []int32{
	2, // 0: types.ParaLocalDbBlock.txs:type_name -> types.Transaction
	1, // [1:1] is the sub-list for method output_type
	1, // [1:1] is the sub-list for method input_type
	1, // [1:1] is the sub-list for extension type_name
	1, // [1:1] is the sub-list for extension extendee
	0, // [0:1] is the sub-list for field type_name
}

func init() { file_paraconsensus_proto_init() }
func file_paraconsensus_proto_init() {
	if File_paraconsensus_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_paraconsensus_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*ParaLocalDbBlock); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_paraconsensus_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*ParaLocalDbBlockInfo); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_paraconsensus_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   2,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_paraconsensus_proto_goTypes,
		DependencyIndexes: file_paraconsensus_proto_depIdxs,
		MessageInfos:      file_paraconsensus_proto_msgTypes,
	}.Build()
	File_paraconsensus_proto = out.File
	file_paraconsensus_proto_rawDesc = nil
	file_paraconsensus_proto_goTypes = nil
	file_paraconsensus_proto_depIdxs = nil
}
