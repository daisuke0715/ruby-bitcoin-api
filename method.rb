# ライブラリ（誰かによって作られたプログラムの塊）を指定
# 誰かが作ったhttp, uriに関わるプログラムが使えるようになる
require 'net/http'
require 'uri'
require 'json'
require './key'
require "openssl"

def get_price
    # このurlにアクセスしたらいろんなデータを取れるようになりますよ
    # https://api.bitflyer.com => エンドポイント
    # Web API におけるエンドポイントは、API に アクセスするための URI
    # 基本的には、URI が「リソース」を指すものであり、URI と HTTP メソッドの組み合わせで処理の内容を表すのが良い設計であるとされています。
    # これは、HTTP の URI がリソースを指すことで「名詞」として考え、それに HTTP メソッドを「動詞」として組み合わせることで、シンプルに行いたいことを表現することができるから
    uri = URI.parse("https://api.bitflyer.com")
    # 行いたい処理に関するURIを追加するメソッドを実行
    uri.path = '/v1/getboard'
    
    # httpのインスタンスをhttpsという変数に格納
    https = Net::HTTP.new(uri.host, uri.port)
    # httpインスタンスの中にあるセキュリティに関するメソッドを実行
    https.use_ssl = true
    response = https.get uri.request_uri
    response_hash = JSON.parse(response.body)
    puts response_hash["mid_price"]
end


def order(side, price, size)
    key = API_KEY
    secret = API_SECRET
    
    # リアルタイムの時間を文字列で格納する
    timestamp = Time.now.to_i.to_s
    
    # リクエストのメソッドをPOSTに指定する
    method = "POST"
    
    # このurlにアクセスしたらいろんなデータを取れるようになりますよ
    # https://api.bitflyer.com => エンドポイント
    # Web API におけるエンドポイントは、API に アクセスするための URI
    # 基本的には、URI が「リソース」を指すものであり、URI と HTTP メソッドの組み合わせで処理の内容を表すのが良い設計であるとされています。
    # これは、HTTP の URI がリソースを指すことで「名詞」として考え、それに HTTP メソッドを「動詞」として組み合わせることで、シンプルに行いたいことを表現することができるから
    uri = URI.parse("https://api.bitflyer.com")
    # 行いたい処理に関するURIを追加するメソッドを実行
    uri.path = "/v1/me/sendchildorder"
    
    # 購入の際の情報を入れておくための変数
    body = '{
        "product_code": "BTC_JPY",
          "child_order_type": "LIMIT",
          "side": "' + side + '",
          "price":' +  price + ',
          "size":' +  size+ ',
          "minute_to_expire": 10000,
          "time_in_force": "GTC"
    }'
    
    text = timestamp + method + uri.request_uri + body
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
    
    options = Net::HTTP::Post.new(uri.request_uri, initheader = {
      "ACCESS-KEY" => key,
      "ACCESS-TIMESTAMP" => timestamp,
      "ACCESS-SIGN" => sign,
      "Content-Type" => "application/json"
    });
    options.body = body
    
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)
    puts response.body
end


def get_my_money(coin_name)
    key = API_KEY
    secret = API_SECRET
    
    timestamp = Time.now.to_i.to_s
    method = "GET"
    uri = URI.parse("https://api.bitflyer.com")
    uri.path = "/v1/me/getbalance"
    
    
    text = timestamp + method + uri.request_uri
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
    
    options = Net::HTTP::Get.new(uri.request_uri, initheader = {
      "ACCESS-KEY" => key,
      "ACCESS-TIMESTAMP" => timestamp,
      "ACCESS-SIGN" => sign,
    });
    
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)
    response_hash = JSON.parse(response.body)
    response_hash.find{|n| n["currency_code"] == coin_name }
    
end



def ifdoneOCO
    
    key = API_KEY
    secret = API_SECRET
    
    timestamp = Time.now.to_i.to_s
    method = "POST"
    uri = URI.parse("https://api.bitflyer.com")
    uri.path = "/v1/me/sendparentorder"
    body = '{
      "order_method": "IFDOCO",
      "minute_to_expire": 10000,
      "time_in_force": "GTC",
      "parameters": [{
        "product_code": "BTC_JPY",
        "condition_type": "LIMIT",
        "side": "BUY",
        "price": 5000000,
        "size": 0.001
      },
      {
        "product_code": "BTC_JPY",
        "condition_type": "LIMIT",
        "side": "SELL",
        "price": 5170000,
        "size" 0.001
      },
      {
        "product_code": "BTC_JPY",
        "condition_type": "STOP_LIMIT",
        "side": "SELL",
        "price": 28800,
        "trigger_price": 4900000,
        "size": 0.001
      }]
    }'
    
    text = timestamp + method + uri.request_uri + body
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
    
    options = Net::HTTP::Post.new(uri.request_uri, initheader = {
      "ACCESS-KEY" => key,
      "ACCESS-TIMESTAMP" => timestamp,
      "ACCESS-SIGN" => sign,
      "Content-Type" => "application/json"
    });
    options.body = body
    
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)
    puts response.body
        
    
end
