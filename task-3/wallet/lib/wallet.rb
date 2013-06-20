class Wallet

  def supply_money(money)
    @money = money
  end

  def supply_stocks(stocks)
    @stocks = stocks
  end

  def take_money(money_tuple)
    currency = money_tuple.first[0]
    value = money_tuple.first[1]
    if @money[currency] >= value
      @money[currency] -= value
      return value
    else
      raise "You are too poor..."
    end
  end

  attr_reader :money, :stocks

end