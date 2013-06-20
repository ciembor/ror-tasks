require 'spec_helper'
require 'wallet'

describe Wallet do
  
  let (:wallet)         { Wallet.new }
  let (:assets) do
    {
      money: {
        pln: 100, 
        usd: 50
      },
      stocks: {
        lunar: 20,
        github: 100
      }
    }
  end

  it "should supply money and allow user to see them" do
    wallet.supply_money(assets[:money])
    wallet.money.should == assets[:money]
  end

  it "should allow user to see stocks" do
    wallet.supply_stocks(assets[:stocks])
    wallet.stocks.should == assets[:stocks]
  end

  it "should allow to take money" do
    wallet.supply_money(assets[:money])
    wallet.take_money({pln: 50})
    wallet.money.should == {pln: 50, usd: 50} 
  end

end