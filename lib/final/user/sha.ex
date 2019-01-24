defmodule Sha do
    #@hash_fields [:index, :data, :nonce, :prev_hash]
  
    def hash(%{} = block) do
      # block |> Map.take(@hash_fields)
      #       |> Poison.encode!
      #       |> sha256
      datahash= :crypto.hash(:sha256, block.data++[block.prev_hash]++[block.index]) |> Base.encode16
      datahash = datahash<>to_string(block.nonce)
      expectedHash= :crypto.hash(:sha256, datahash) |> Base.encode16
      expectedHash
    end
  
    def insert_hash(%{} = block, curHash) do
      %{block | hash: curHash}
    end
  
    def sha256(binary) do
      :crypto.hash(:sha256, binary) |> Base.encode16
    end
  
  end