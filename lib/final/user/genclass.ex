defmodule Genclass do
    use GenServer

    def start_link(:user) do
        GenServer.start_link(__MODULE__, :user, [])
    end

    def init(:user) do
        :gproc.reg(gproc_key(:user))
        {:ok, {0, 0, 0, 100, [], "", [], [], []}}  #{id, sk, pk, amount, adjli, message, transactionli, blockchain}
    end

    defp gproc_key(:user) do
        {:p, :l, :user}
    end

    def start_link2({:user, :minor}) do
        GenServer.start_link(__MODULE__, {:user, :minor}, [])
    end

    def init({:user, :minor}) do
        :gproc.reg(gproc_key(:user))
        :gproc.reg(gproc_key(:minor))
        {:ok, {0, 0, 0, 100, [], "", [], [] ,[]}}  #{id, sk, pk, amount, adjli, message, transactionli, blockchain, datablock}
    end

    defp gproc_key(:minor) do
        {:p, :l, :minor}
    end

    def getProcId(pid) do
        GenServer.call(pid, {:getId})
    end

    def handle_call({:getId}, _from, state) do
        id= elem(state, 0)
        {:reply, id, state}
    end

    def getPublicKey(pid) do
        GenServer.call(pid, {:getPK})
    end

    def handle_call({:getPK}, _from, state) do
        pk= elem(state, 2)
        {:reply, pk, state}
    end

    def getPrivateKey(pid) do
        GenServer.call(pid, {:getSK})
    end

    def handle_call({:getSK}, _from, state) do
        sk= elem(state, 1)
        {:reply, sk, state}
    end

    def setAmount(pid, balance) do
        GenServer.cast(pid, {:updateBal, balance})
    end

    def handle_cast({:updateBal, balance}, state) do
        {procid, privateKey, publicKey, amount, networkLi, msg, tranLi, blockli, datablock} = state
        state = {procid, privateKey, publicKey, balance, networkLi, msg, tranLi, blockli, datablock}
        {:noreply, state}
    end

    def getAmount(pid) do
        GenServer.call(pid, {:getBal})
    end

    def handle_call({:getBal}, _from, state) do
        bal= elem(state, 3)
        {:reply, bal, state}
    end

    def processKeys(pid, id, x, y) do
        GenServer.cast(pid, {:processKey, id, x, y})
    end

    def handle_cast({:processKey, id, x, y}, state) do
        #IO.puts " inside cast "
        {procid, privateKey, publicKey, amount, networkLi, msg, tranLi, blockli, datablock} = state
        state={id, x, y, amount, networkLi, msg, tranLi, blockli, datablock}
        #IO.puts x
        {:noreply, state}
    end

    def fullNetLi(pid, adjList) do
        GenServer.cast(pid, {:fullNetList, adjList})
    end

    def handle_cast({:fullNetList, adjList}, state) do
        {procid, privateKey, publicKey, amount, networkLi, msg, tranLi, blockli, datablock} = state
        state = {procid, privateKey, publicKey, amount, adjList, msg, tranLi, blockli, datablock}
        #IO.inspect adjList
        {:noreply, state}
    end

    def nodeNetList(pid) do
        GenServer.call(pid, {:nodeAdjLi})
    end

    def handle_call({:nodeAdjLi}, _from, state) do
        lis= elem(state, 4)
        {:reply, lis, state}
    end

    # def broadCast(pid, msg) do
    #     GenServer.cast(pid, {:msgCast, msg})
    # end

    # def handle_cast({:msgCast, msg}, state) do
    #     lis= elem(state, 4)
    #     Enum.each(lis, fn(x)->
    #         nodeMsg=curMsg(x)
    #         #IO.puts nodeMsg
    #         str=msg <> " " <> nodeMsg
    #         updateMsg(x, str)
    #     end)
    #     {:noreply, state}
    # end

    def verifyFun?(message, pk, signature) do
        :crypto.verify(:ecdsa, :sha256, message, signature, [pk, :secp256k1])
    end

    def broadCastTransactions(topic, message, pk, signature) do
        #GenServer.cast(pid, {:tranCast, tranToUpdate})
        flag = verifyFun?(message, pk, signature)
        #IO.inspect flag
        if flag do
            GenServer.cast({:via, :gproc, gproc_key(:user)}, {:userComm, message})
        end
    end

    def handle_cast({:userComm, message}, state) do
        {procid, privateKey, publicKey, amount, networkLi, msg, tranLi, blockli, datablock} = state
        state={procid, privateKey, publicKey, amount, networkLi, msg, tranLi++[message], blockli, datablock}
        {:noreply, state}
    end

    def getTranLi(pid) do
        GenServer.call(pid, {:gettranli})
    end

    def handle_call({:gettranli}, _from, state) do
        tranli= elem(state, 6)
        {:reply, tranli, state}
    end

    def updateMsg(pid, message) do
        #IO.puts message
        GenServer.cast(pid, {:msgToUpdate, message})
    end

    def handle_cast({:msgToUpdate, message}, state) do
        {procid, privateKey, publicKey, amount, networkLi, msg, tranLi, blockli, datablock} = state
        state={procid, privateKey, publicKey, amount, networkLi, message, tranLi, blockli, datablock}
        {:noreply, state}
    end

    def curMsg(pid) do
        GenServer.call(pid, {:currentMsg})
    end

    def handle_call({:currentMsg}, _from, state) do
        msg= elem(state, 5)
        {:reply, msg, state}
    end

    def broadCastBlock(topic, chain, curChain) do
        #GenServer.cast(pid, {:tranCast, tranToUpdate})
        block = Enum.at(chain, 0)
        if Bitcoin.valid_block?(block)&&Bitcoin.validate_chain?(curChain, block) do
            GenServer.cast({:via, :gproc, gproc_key(:user)}, {:blockComm, chain}) 
        end
    end

    def handle_cast({:blockComm, chain}, state) do
        {procid, privateKey, publicKey, amount, networkLi, msg, tranLi, blockli, datablock} = state
        #blockli = blockli |> Blockchain.insert_block(chain)
        state={procid, privateKey, publicKey, amount, networkLi, msg, tranLi, chain++blockli, datablock}
        {:noreply, state}
    end

    def broadCastToMiner(topic, minordata, chain) do
        #GenServer.cast(pid, {:tranCast, tranToUpdate})
        GenServer.cast({:via, :gproc, gproc_key(:minor)}, {:minorComm, minordata, chain})
        #IO.puts "after minor cast"
        chain = Transaction.mineFun(minordata, chain)
        #a=[1,2,3]
        chain
    end

    def handle_cast({:minorComm, minordata, chain}, state) do
        {procid, privateKey, publicKey, amount, networkLi, msg, tranLi, blockli, datablock} = state
        state={procid, privateKey, publicKey, amount, networkLi, msg, tranLi, chain, minordata}
        {:noreply, state}
    end

    def getBlockLi(pid) do
        GenServer.call(pid, {:getBlockli})
    end

    def handle_call({:getBlockli}, _from, state) do
        blockli= elem(state, 7)
        {:reply, blockli, state}
    end

    def getMinorDataLi(pid) do
        GenServer.call(pid, {:getminordatali})
    end

    def handle_call({:getminordatali}, _from, state) do
        minorData= elem(state, 8)
        {:reply, minorData, state}
    end

end