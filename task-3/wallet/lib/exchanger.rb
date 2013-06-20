class Exchanger

  def exchange_money(wallet, money_tuple, to_currency)
    from_currency = money_tuple.first[0]
    value = money_tuple.first[1]
    ratio = currency_table[from_currency][to_currency]
    money = wallet.money
    if (money and money[from_currency] >= value)
      wallet.take_money(money_tuple)
      exchanged = {to_currency => ratio * value}
      wallet.supply_money(exchanged)
      return exchanged
    else
      raise "You are too poor..."
    end
  end

  attr_accessor :currency_table, :stocks_table
end