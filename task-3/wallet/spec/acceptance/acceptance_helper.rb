require_relative '../spec_helper.rb'
require 'capybara/rspec'
require 'wallet'
require 'exchanger'


@wallet = Wallet.new
@exchanger = Exchanger.new

def setup_bank_account(options)
  @bank_account = options # TODO stub or real class
end

def setup_currency_exchange_table(hash_table)
  @exchanger.currency_table = hash_table
end

def setup_stock_exchange_table(hash_table)
  @exchanger.stocks_table = hash_table
end

def bank_account_status
  @bank_account.money
end

def download_money_from_bank(money_tuple)
  @wallet.supply(
    @bank_account.download_money(money_tuple)
  )
end

def money_in_wallet
  @wallet.money
end

def exchange_money(money_tuple, to_currency)
  @exchanger.exchange_money(
    @wallet,
    money_tuple, 
    to_currency
  )
end

def stocks_in_wallet
  @wallet.stocks
end

def buy_stocks(stocks_tuple, currency)
  @exchanger.buy_stocks(
    @wallet,
    stocks_tuple,
    currency
  )
end

def sell_stocks(stocks_tuple, currency)
  @exchanger.sell_stocks(
    @wallet,
    stocks_tuple,
    currency
  )
end