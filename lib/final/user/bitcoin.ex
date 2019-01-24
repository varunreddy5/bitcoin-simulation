defmodule Bitcoin do
  def users(num) do
    mlen = if(num<=10) do
              1
           else
              div(num, 10)
           end
    userLen = Enum.map(1..num,&(&1))
    minorLen = Enum.take_random(userLen, mlen)
    userLen = userLen -- minorLen
    userli=userlist(userLen)

    minorli=minorList(minorLen)

    totalUsers = userli ++ minorli
    [mainSK, mainPK] = wallet
    tarnsactionList = genblockTransLi(totalUsers, mainSK, mainPK)
    # IO.inspect totalUsers
    datahash = dataHasing(tarnsactionList, ["0"], [0])
    #datahash= :crypto.hash(:sha256, transactionList++["0"]++[0]) |> Base.encode16
    #IO.inspect datahash
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], tarnsactionList, genNonce, curHash)
    #IO.inspect chain

    Genclass.broadCastBlock(:user, chain, [])

    # Enum.each(totalUsers, fn(x) ->
    #             Genclass.broadCastTransactions(x, transactionList)
    #           end)
    #Genclass.broadCastTransactions(:user, transactionList)
    blockVar = hd(chain)
    #IO.inspect blockVar.timestamp
    # Enum.each(transactionList, fn(x) ->
    #       #bal=Genclass.getAmount(x)
    #       IO.inspect x
    #     end)
    # fullNet(li)

    Transaction.transaction(totalUsers, 0, chain)

    # IO.puts "Final block chain present at each user"
    # Enum.each(totalUsers, fn(x) ->
    #   temp = Genclass.getBlockLi(x)
    #   #IO.puts "*******************************************************************************"
    #   IO.inspect temp
    # end)

    tempBlockli = Genclass.getBlockLi(Enum.at(totalUsers, 0))
    #tempBlock = Enum.at(tempBlockli, 0)
    #IO.inspect tempBlockli
    #flag =  valid_block?(tempBlock)
    #IO.inspect flag
    # Enum.each(li, fn(x) ->
    #     bal=Genclass.getAmount(x)
    #     IO.inspect bal
    #   end)

    # Enum.each(totalUsers, fn(x) ->
    #   IO.puts "*****************************************************************************"
    #   temp = Genclass.getTranLi(x)
    #   IO.inspect temp
    #   IO.inspect length(temp)
    # end)

    # Enum.map(0..num-1, fn(x) ->
    #   id=Enum.at(li, x)
    #   #IO.inspect id
    #   netli=Genclass.nodeNetList(id)
    #   #IO.inspect netli
    #   str="message"<>Integer.to_string(x)
    #   Genclass.broadCast(id, str)
    #   :timer.sleep(1)
    # end)

    # #:timer.sleep(10)
    # Enum.each(li, fn(x) ->
    #   msg=Genclass.curMsg(x)
    #   IO.inspect msg
    # end)

    #loopfun(1)
  end

  def wallet do
    private_key = :crypto.strong_rand_bytes(32)
    public_key = :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)
                    |> elem(0)
    [private_key, public_key]
  end

  def userlist(userLen) do
    Enum.map(userLen, fn(x) ->
      {:ok, pid}= Genclass.start_link(:user)
      [sk, pk] = wallet
      # private_key = :crypto.strong_rand_bytes(32)
      # public_key = :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)
      #               |> elem(0)
      Genclass.processKeys(pid, x, sk, pk)
      pid
      end)
  end

  def minorList(minorLen) do
    Enum.map(minorLen, fn(x) ->
      {:ok, pid}= Genclass.start_link2({:user, :minor})
      [sk, pk] = wallet
      # private_key = :crypto.strong_rand_bytes(32)
      # public_key = :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key) |> elem(0)
      Genclass.processKeys(pid, x, sk, pk)
      pid
      end)
  end

  def dataHasing(transactionList, prev_hash, index) do
    datahash= :crypto.hash(:sha256, transactionList++prev_hash++index) |> Base.encode16
    datahash
  end

  def genblockTransLi(totalUsers, mainSK, mainPK) do
    Enum.map(totalUsers, fn(x) ->
      #tli = [0, Genclass.getProcId(x), 100]
      messageStr = "Main process to "<>Integer.to_string(Genclass.getProcId(x))<>" amount of 100"
      signature = :crypto.sign(:ecdsa, :sha256, messageStr, [mainSK, :secp256k1])
      Genclass.broadCastTransactions(:user, messageStr, mainPK, signature)
      messageStr
    end)
  end

  def valid_block?(%Block{} = tempBlock) do
    Sha.hash(tempBlock) == tempBlock.hash
  end

  def validate_chain?(chain, %Block{} = block) do
    if block.prev_hash != "0" do
      head = hd(chain)
      head.hash == block.prev_hash
    else
      true
    end
  end

  def loopfun(1) do
    loopfun(1)
  end

  def main(args\\[]) do
    #{i,""}=Integer.parse(Enum.at(args,0))
    i = elem(Integer.parse(args["user"]), 0)
    #{j,""}=Integer.parse(Enum.at(args,1))
    #j=Enum.at(args,1)
    #k=Enum.at(args,2)
    #pid=spawn(Dosproj, :pmap, [i, j])
    blockchain = users(i)
  end

  def fullNet(li) do
    Enum.each(li, fn(x) ->
        adjLi=li--[x]
        #IO.inspect adjLi
        Genclass.fullNetLi(x, adjLi)
    end)
  end

end
