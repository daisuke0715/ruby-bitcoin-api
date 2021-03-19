require './method' 

asset_status = get_my_money("JPY")["amount"]


while(1)
    current_price =  get_price
    puts current_price
    
    buy_price = 4900000
    sell_price = 5170000
    
    if (current_price > sell_price) && (asset_status > 0.001)
        puts '売ります'
        
    elsif (current_price < buy_price) && (asset_status > 0.001)
        puts '買います'
        order("BUY", buy_price, 0.001)
    else
        puts '何もしません'
    end
    
    sleep(1)
end




