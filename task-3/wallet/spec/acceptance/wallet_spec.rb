require_relative './acceptance_helper.rb'

feature "Transfering money", %q{
  As a user
  I can supply arbitrary amount of many in any of the defined currencies
} do

  background do
    setup_bank_account(money: {
      pln: 50,
      usd: 100
    })
  end

  scenario "1 PLN when it's available" do
    download_money_from_bank(pln: 1)
    money_in_wallet.should == {pln: 1}
    bank_account_status.should == {pln: 49, usd: 100}
  end

  scenario "100 PLN when there is not so much in bank" do
    expect { download_money_from_bank(pln: 100) }.to raise_error
    money_in_wallet.should == {}
    bank_account_status.should == {pln: 50, usd: 100}
  end

  scenario "40 PLN and 60 USD" do
    download_money_from_bank({pln: 40, usd: 60})
    money_in_wallet.should == {pln: 40, usd: 60}
    bank_account_status.should == {pln: 10, usd: 40}
  end

end

feature "Exchanging money", %q{
  As a user
  I can convert available money from one currency to another according to a currency exchange table
} do

  background do
    setup_bank_account(money: {
      pln: 50,
      usd: 100,
    })
    setup_currency_exchange_table({
      usd: {
        pln: 2.80
      },
      pln: {
        usd: 0.3
      }
    })
  end

  scenario "All USD to PLN" do
    download_money_from_bank(usd: 66)
    exchange_money(:usd, :pln)
    money_in_wallet.should == {usd: 0, pln: 220}
  end

  scenario "All PLN to USD" do
    download_money_from_bank(pln: 66)
    exchange_money(:pln, :usd)
    money_in_wallet.should == {pln: 0, usd: 23.57}
  end

end

feature "Stocks exchange", %q{
  As a user
  I can buy and sell stocks according to stock exchange rates
} do

  background do
    setup_bank_account(money: {
      usd: 100
    })
    setup_stock_exchange_table({
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
    })
  end

  scenario "Buy 10 Lunar stocks for USD" do
    download_money_from_bank(usd: 100)
    buy_stocks({lunar: 10}, :usd)
    money_in_wallet.should == {usd: 84}
    stocks_in_wallet.should == {lunar: 10}
  end

  scenario "Buy 20 Lunar stocks for USD and then sell 10 for USD" do
    download_money_from_bank(usd: 100)
    buy_stocks({lunar: 20}, :usd)
    sell_stocks({lunar: 10}, :usd)
    money_in_wallet.should == {usd: 82}
    stocks_in_wallet.should == {lunar: 10}
  end

end

feature "Transfering money", %q{
  As a user
  I can demand money to be transfered back to my bank account
} do

  background do
    setup_bank_account(money: {
      pln: 50,
      usd: 100
    })
    download_money_from_bank({pln: 20, usd: 50})
  end

  scenario "Upload some money" do
    upload_money_to_the_bank({pln: 10, usd: 25})
    bank_account_status.should == {pln: 40, usd: 75}
    money_in_wallet.should == {pln: 10, usd: 25}
  end

  scenario "Try to upload too much money" do
    expect { upload_money_to_the_bank({pln: 10000}) }.to raise_error
    bank_account_status.should == {pln: 30, usd: 50}
    money_in_wallet.should == {pln: 20, usd: 50}
  end

end