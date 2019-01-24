defmodule Block do

    defstruct [:index, :data, :nonce, :timestamp, :prev_hash, :hash]
  
    def new(data, index, nonce, prev_hash) do
      %Block{
        data: data,
        index: index,
        nonce: nonce,
        prev_hash: prev_hash,
        timestamp: NaiveDateTime.utc_now,
      }
    end
  
    def zero(data, nonce) do
      %Block{
        index: 0,
        data: data,
        nonce: nonce,
        prev_hash: "0",
        timestamp: NaiveDateTime.utc_now,
      }
    end
  
  end