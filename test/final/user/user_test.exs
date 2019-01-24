defmodule Final.UserTest do
  use Final.DataCase

  alias Final.User

  describe "transactions" do
    alias Final.User.Transaction

    @valid_attrs %{user: 42}
    @update_attrs %{user: 43}
    @invalid_attrs %{user: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> User.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert User.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert User.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = User.create_transaction(@valid_attrs)
      assert transaction.user == 42
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = User.update_transaction(transaction, @update_attrs)
      assert transaction.user == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_transaction(transaction, @invalid_attrs)
      assert transaction == User.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = User.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> User.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = User.change_transaction(transaction)
    end

    test "creating users" do
    assert Bitcoin.userlist([1,2,4,7])
  end

  test "creating minors" do
    assert Bitcoin.minorList([3,5,6])
  end

  test "user wallet generation" do
    assert Bitcoin.wallet
  end

  test "genicess block's transaction data" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    assert Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
  end

  test "Block data hashing" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    assert Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
  end

  test "Generating Nonce as per the transaction data" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    assert Transaction.findNonce(datahash)
  end

  test "Block Hash generation" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    assert Transaction.findCurHash(datahash, genNonce)
  end

  test "Finding Nonce for random string" do
    assert Transaction.findNonce("datahash")
  end

  test "Creating dummy block" do
    assert Blockchain.new([], ["tarnsactionList","khdkhgsdh"], 4987600, "khheghjgsljgshg")
  end

  test "Block creation" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    assert Blockchain.new([], tarnsactionList, genNonce, curHash)
  end

  test "Broadcasting Block to all the users" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], tarnsactionList, genNonce, curHash)
    assert Genclass.broadCastBlock(:user, chain, [])
  end

  test "Complete functionality with user transactions and block chain creation" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], tarnsactionList, genNonce, curHash)
    #Genclass.broadCastBlock(:user, chain, [])
    assert Transaction.transaction(totalUsers, 0, chain)
  end

  test "Generating message signature" do
    sk = private_key = :crypto.strong_rand_bytes(32)
    assert :crypto.sign(:ecdsa, :sha256, "messageStr", [sk, :secp256k1])
  end

  test "Broadcasting transactiondata only to minors for block construction" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], tarnsactionList, genNonce, curHash)
    assert Genclass.broadCastToMiner(:minor, ["1st transaction", "2nd transaction", "3rd transaction"], chain)
  end

  test "Transaction data sent to minors for block construction" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], tarnsactionList, genNonce, curHash)
    #Genclass.broadCastBlock(:user, chain, [])
    #Transaction.transaction(totalUsers, 0, chain)
    assert Transaction.recFun(totalUsers, 10, [])
  end

  test "Balance check" do
    userli = Bitcoin.userlist([1,2,4,7])
    sender = Enum.random(userli)
    senderBal = Genclass.getAmount(sender)
    assert Transaction.balance_Check?(senderBal, 50) == true
  end

  test "Generating Proof of Work" do
    str = "CF4A23E77942AE157A2BA9486C274322F23961CA2753F592383EB5B928FD44751198144752"
    assert String.slice(:crypto.hash(:sha256, str) |> Base.encode16, 0..3)=="0000"
  end

  end
end
