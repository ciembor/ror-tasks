require 'spec_helper'
require 'exchanger'
require 'wallet'

describe Exchanger do 

  let (:exchanger)        { Exchanger.new }
  let (:currency_table) do
    {
      usd: {
        pln: 2.80
      },
      pln: {
        usd: 0.3
      }
    }
  end
  let (:stocks_table) do
    {
      usd: {
        buy: {
          base: 1.3,
          lunar: 1.6
        },
        sell: {
          base: 1.2,
          lunar: 1.4
        }
      }
    }
  end

  it "should take currency table" do
    exchanger.currency_table = currency_table
    exchanger.currency_table.should == currency_table
  end

  it "should take stocks table" do
    exchanger.stocks_table = stocks_table
    exchanger.stocks_table.should == stocks_table
  end

  it "should exchange money" do
    # TODO: mock wallet
    wallet = Wallet.new
    wallet.supply_money({pln: 10})
    exchanger.currency_table = currency_table
    exchanger.exchange_money(wallet, {pln: 10}, :usd)
    wallet.money.should == {usd: 3}
  end

end