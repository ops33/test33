package main

import (
	util "github.com/33cn/plugin/plugin/dapp/mix/cmd/gnark/circuit"
	"github.com/consensys/gnark/encoding/gob"
	"github.com/consensys/gnark/frontend"
	"github.com/consensys/gnark/gadgets/hash/mimc"
	"github.com/consensys/gurvy"
)

func main() {
	circuit := NewWithdraw()
	gob.Write("circuit_withdraw.r1cs", circuit, gurvy.BN256)
}

//withdraw commit hash the circuit implementing
/*
public:
	treeRootHash
	authorizeSpendHash
	nullifierHash
	amount

private:
	receiverPubKey
	returnPubKey
	authorizePubKey
	spendPriKey
	spendFlag
	authorizeFlag
	noteRandom
	noteHash

	path...
	helper...
	valid...
*/
func NewWithdraw() *frontend.R1CS {

	// create root constraint system
	circuit := frontend.New()

	spendValue := circuit.PUBLIC_INPUT("Amount")

	//spend pubkey
	receiverPubKey := circuit.SECRET_INPUT("ReceiverPubKey")
	returnPubkey := circuit.SECRET_INPUT("ReturnPubKey")
	authPubkey := circuit.SECRET_INPUT("AuthorizePubKey")
	spendPrikey := circuit.SECRET_INPUT("SpendPriKey")
	//spend_flag 0：return_pubkey, 1:  spend_pubkey
	spendFlag := circuit.SECRET_INPUT("SpendFlag")
	circuit.MUSTBE_BOOLEAN(spendFlag)
	//auth_check 0: not need auth check, 1:need check
	authFlag := circuit.SECRET_INPUT("AuthorizeFlag")
	circuit.MUSTBE_BOOLEAN(authFlag)

	// hash function
	mimc, _ := mimc.NewMiMCGadget("seed", gurvy.BN256)
	calcPubHash := mimc.Hash(&circuit, spendPrikey)
	targetPubHash := circuit.SELECT(spendFlag, receiverPubKey, returnPubkey)
	circuit.MUSTBE_EQ(targetPubHash, calcPubHash)

	//note hash random
	noteRandom := circuit.SECRET_INPUT("NoteRandom")

	//need check in database if not null
	authHash := circuit.PUBLIC_INPUT("AuthorizeSpendHash")

	nullValue := circuit.ALLOCATE(0)
	// specify auth hash constraint
	calcAuthHash := mimc.Hash(&circuit, targetPubHash, spendValue, noteRandom)
	targetAuthHash := circuit.SELECT(authFlag, calcAuthHash, nullValue)
	circuit.MUSTBE_EQ(authHash, targetAuthHash)

	//need check in database if not null
	nullifierHash := circuit.PUBLIC_INPUT("NullifierHash")
	calcNullifierHash := mimc.Hash(&circuit, noteRandom)
	circuit.MUSTBE_EQ(nullifierHash, calcNullifierHash)

	//通过merkle tree保证noteHash存在，即便return,auth都是null也是存在的，则可以不经过授权即可消费
	//preImage=hash(spendPubkey, returnPubkey,AuthPubkey,spendValue,noteRandom)
	noteHash := circuit.SECRET_INPUT("NoteHash")
	calcReturnPubkey := circuit.SELECT(authFlag, returnPubkey, nullValue)
	calcAuthPubkey := circuit.SELECT(authFlag, authPubkey, nullValue)
	// specify note hash constraint
	preImage := mimc.Hash(&circuit, receiverPubKey, calcReturnPubkey, calcAuthPubkey, spendValue, noteRandom)
	circuit.MUSTBE_EQ(noteHash, preImage)

	util.MerkelPathPart(&circuit, mimc, preImage)

	r1cs := circuit.ToR1CS()

	return r1cs
}