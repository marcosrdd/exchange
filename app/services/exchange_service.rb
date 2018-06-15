require 'rest-client'
require 'json'
 
class ExchangeService

  BTC_CURRENCY = "BTC";

  def initialize(source_currency, target_currency, amount)
    @source_currency = source_currency
    @target_currency = target_currency
    @amount = amount.to_f
  end

  def bitcoin?
    @source_currency == BTC_CURRENCY || @target_currency == BTC_CURRENCY
  end
  
  def target_bitcoin
    if @source_currency == BTC_CURRENCY
      @target_currency
    else            
      @source_currency
    end
  end
 
  def perform
    begin
      value = bitcoin? ? perform_btc : perform_default
      value * @amount
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  def perform_default
    exchange_api_url = Rails.application.credentials[Rails.env.to_sym][:currency_api_url]
    exchange_api_key = Rails.application.credentials[Rails.env.to_sym][:currency_api_key]
    url = "#{exchange_api_url}?token=#{exchange_api_key}&currency=#{@source_currency}/#{@target_currency}"
    res = RestClient.get url
    value = JSON.parse(res.body)['currency'][0]['value'].to_f
    value
  end

  def perform_btc
    
    exchange_api_url = Rails.application.credentials[Rails.env.to_sym][:btc_api_url]
    url = "#{exchange_api_url}#{target_bitcoin}.json"
    res = RestClient.get url
    value = JSON.parse(res.body)['bpi'][target_bitcoin]['rate_float'].to_f
    
    if value > 0
      value = 1 / value if @target_currency == BTC_CURRENCY 
    end
    
    value
  end
end