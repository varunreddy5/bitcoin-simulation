# Final

## Team Members:
Sai Tarun Damacharla(UFID: 4174-0254)
Varun Reddy Regalla(UFID: 4143-6018)

# To run the project:

Go to config -> dev.exs and replace the username and password to connect to the database

Next start phoenix server by running: mix phx.server

After that go to http://localhost:4000/transactions

Click on New transactions

In the input box enter the number of users. Once we enter the users, transactions are created for the specified number of users and is displayed in a new page.

## Unit test cases:
1. "creating users" : Tests the creation of all the required users
2. "creating minors" : Tests creation of all the required minors who also acts as users
3. "user wallet generation" : Tests generation of individual user wallets
4. "gensis block's transaction data": Tests the transaction data required for creating Gensis block
5. "Block data hashing" : Hashes the data sent for block creation
6. "Generating Nonce as per the transaction data" : Tests the generation of nonce that helps in reaching the specified target for the given block of data combined with previous block hash and curent block index values
7. "Block Hash generation" : Generates hash value for newly created block
8. "Finding Nonce for random string" : Tests the nonce generated for string or data given as input
9. "Creating dummy block" : Test to check for creation of block that gets appended as block chain
10. "Block creation" : Tests the creation of Gensis block
11. "Complete functionality with user transactions and block chain creation" : Main function that starts with user transactions and block chain creation
12. "Generating message signature" : Test the message signature that gets generated for transaction provided and the private key of the sender involved in the transaction
13. "Broadcasting transactiondata only to minors for block construction" : Broadcasts the transaction data that need to be sent to minors for new block creation
14. "Transaction data sent to minors for block construction" : Tests the data block sent to minors for block creation
15. "Balance check" : Tests the sender's remaining balance before initating the transaction
16. "Generating Proof of Work" : Tests the generated proof of work value for the given data block and make sure the the value reaches the required target.

## Functions Description:

## Module Name: Block

### Function - zero(data, nonce):

This function generates the genesis block. It takes the
data - the transactions of the block
Nonce -  random number generated to find the hash below the target and is passed here as an argument
It also has previous hash as zero, index as zero and timestamp as the time when the block was created

###Function - new(data, index, nonce, prev_hash):

This function is used to generate a new block which in-turn gets appended to the blockchain. The arguments are:
 index - which we increment the previous block’s index number and pass as argument
data - the transactions for the block
nonce - random number generated to find the hash below the target value and passed here
prev_hash - hash of the previous block

## Module Name: Sha

### Function: hash(block):

This function is used to find the hash of the given block. It takes a block to which hash has to be calculated.
	For the given block, it takes the index, nonce, timestamp, data, previous hash and passes them to sha256 function, which in-turn returns the hash

### Function - insert_hash(block, hash):

This function is used to insert the given hash into the block. It takes block, hash as the arguments.

### Function - sha256(value):

This function is used to calculate the hash based on the given string. It takes the string or binary value as the argument. It calculates the hash using elixir built-in function :crypto.hash and the result is encoded using Base.encode16 which converts it into a 64 bit hexadecimal hash

## Module Name: Blockchain

### Function - new(chain, data, nonce, hash):

This is used to create a new blockchain. The arguments passed here are:
Chain - which is initially empty
Data - the transactions which are passed to the genesis block to create the block
Nonce - which is generated based on the target hash
Hash - calculated hash based on the parameters of the block

### Function - insert_block(chain, block):

This function is used to append the newly generated block into the blockchain. It takes chain and the block - which has to be appended into the blockchain, as the arguments.

## Module Name: Transaction

### Function - transaction(list, count, chain):

This function is used generated the required number of blocks for the blockchain which is specified as count value in the function. The arguments are:
List: The list of the users given
Count: The number of blocks which has to be created based on the transaction
Chain: It is the blockchain till that moment and to which the new blocks are appended

### Function - balance_check?(sender balance, amount):

This function is used to validate whether the sender balance is greater than the amount he is sending in a transaction. It takes sender balance and the amount as the arguments and returns either true or false

### Function - signatureFun?(message string, sender):    [Bonus]

This function validates the signature of the transaction. It takes message string which is the transaction and the sender. For generating the signature encrypts the transaction with the private key of the sender.

### Function - recFun(list, n, blockli):

This function adds all the transactions to the block after performing the above two validations i.e., Balance check of the sender and signature of the sender. If the transaction is valid then it is broadcasted to all the users. The arguments passed are:
List: The list of the users given
n:It is the number of transactions that has to be present in the block   
Blockli: The transactions data which has to be present in the data field

### Function - mineFun(minordata, chain):

This function creates the block with transactions data and other required fields and broadcasts the block to all the users by the miner who first finds the hash below the target. The arguments are:
Minordata: It contains all the fields which has to be sent to the miner in-order to find the hash below the target hash
Chain: The blockchain which has the blocks created till then

### Function - findNonce(datahash):

This function is used to find the nonce with the help of a random value generated and passes it the getTarget function. It is done iteratively until it finds the nonce where the generated hash is below the target value.

### Function - getTarget(datahash, nonce value):
[Bonus]

This function validates whether the nonce value passed has generated a hash value below the target else it calls the findNonce function and gets another value. This process is repeated iteratively until the hash value generated with the help of the nonce value is below the target hash

### Function - findCurHash(datahash, nonce):

This function generates hash with the help of the nonce and the hash of all the fields in the block except nonce and hash. It takes hash of all the fields in the block and nonce as it arguments



## Module Name: Bitcoin:

### Function name: users(num):

This function creates the number of users that has to be created based on the argument. It then creates the block and the blockchain based on the functions mentioned above.

### Function name: wallet:

This function generated the public key and private key that has to be present for each and every user.

### Function name: valid_block?(block): 	
[Bonus]

This function validates the block created by the user before it is appended on to the blockchain.

### Function name: validate_chain?(chain, block):     
[Bonus]

This function validates the block and the complete blockchain.




To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`
