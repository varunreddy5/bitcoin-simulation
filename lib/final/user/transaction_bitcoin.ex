defmodule Transaction do
    def transaction(li, count, chain) do
        if(count<3) do
            blockli = recFun(li, 10, [])
            #IO.puts length(blockli)
            #IO.inspect blockli
            chain = Genclass.broadCastToMiner(:minor, blockli, chain)
            #chain = mineFun(chain, blockli)
            #IO.inspect chain
            :timer.sleep(5)
            transaction(li, count+1, chain)
        else
            :ok
        end
    end

    # def transaction(li, 0) do

    # end

    def recFun(li, 0, blockli) do
        blockli
    end

    def recFun(li, n, blockli) do
        #IO.puts n
        blockli = if n > 0 do
            sender=Enum.random(li)
            receiver = Enum.random(li--[sender])
            amount = Enum.random(1..50)
            senderBal = Genclass.getAmount(sender)
            receiverBal = Genclass.getAmount(receiver)
            if balance_Check?(senderBal, amount) do
                Genclass.setAmount(sender, senderBal-amount)
                Genclass.setAmount(receiver, receiverBal+amount)
                #tranli = [Genclass.getProcId(sender), Genclass.getProcId(receiver), amount]
                messageStr = Integer.to_string(Genclass.getProcId(sender))<>" to "<>Integer.to_string(Genclass.getProcId(receiver))<>" amount of "<>Integer.to_string(amount)
                signature = signatureFun(messageStr, sender)
                Genclass.broadCastTransactions(:user, messageStr, Genclass.getPublicKey(sender), signature)
                #IO.inspect tranli
                #IO.inspect blockli
                recFun(li, n-1, blockli++[messageStr])
            else
                #IO.puts "comes to else"
                recFun(li, n, blockli)
            end
        end
        blockli
    end

    def balance_Check?(senderBal, amount) do
        senderBal >= amount
    end

    def signatureFun(messageStr, sender) do
        :crypto.sign(:ecdsa, :sha256, messageStr, [Genclass.getPrivateKey(sender), :secp256k1])
    end

    def mineFun(minordata, chain) do
        #IO.puts "---------------------------------------------------------"
        prevBlock = hd(chain)
        datahash = Bitcoin.dataHasing(minordata, [prevBlock.hash], [prevBlock.index+1])
        #datahash= :crypto.hash(:sha256, minordata++[prevBlock.hash]++[prevBlock.index+1]) |> Base.encode16
        curNonce = findNonce(datahash)
        curHash = findCurHash(datahash, curNonce)
        block = minordata |> Block.new(prevBlock.index+1, curNonce, prevBlock.hash) |> Sha.insert_hash(curHash)
        Genclass.broadCastBlock(:user, [block], chain)
        chain =  chain |> Blockchain.insert_block(block)
        #IO.inspect chain
        chain
    end

    def findNonce(datahash) do
        #IO.puts "in find Nonce"
        finalNonce = getTarget(datahash, Enum.random(1..4294967296))
        #IO.inspect finalNonce
        finalNonce
    end

    def getTarget(datahash, nonceValue) do
        #IO.puts nonceValue
        str = datahash<>to_string(nonceValue)
        curHash= :crypto.hash(:sha256, str) |> Base.encode16
        finalNonce = if String.slice(curHash, 0..3)=="0000" do
                        nonceValue
                    else
                        getTarget(datahash, Enum.random(1..2147483647))
                    end
        finalNonce
    end

    def findCurHash(datahash, nonce) do
        str = datahash<>to_string(nonce)
        curHash= :crypto.hash(:sha256, str) |> Base.encode16
        curHash
    end
end
