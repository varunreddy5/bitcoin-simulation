defmodule Blockchain do

    def new(chain, data, nonce, curHash) do
        block = data |> Block.zero(nonce)
      [Sha.insert_hash(block, curHash)]
    end
  
    def insert_block(chain, block) do
      # %Block{index: ind, hash: prev} = hd(chain)
      # block = data |> Block.new(ind+1, nonce, prev) |> Sha.insert_hash(curHash)
      [block | chain]
  
    end
  end