

-- ЗДесь принимается решение о покупке или продаже в зависимости от текущего состояния счёта

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");
local bidTable = dofile(getScriptPath() .. "\\bidTable.lua");
local transaction = dofile(getScriptPath() .. "\\shop\\transaction.lua");
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");
local statsPanel = dofile(getScriptPath() .. "\\interface\\stats.lua");

local contitionMarket = dofile(getScriptPath() .. "\\shop\\contition_shop.lua");
 
 

M = {};
 
-- SHORT  = FALSE
-- LONG = true
 
local DIRECT = 'LONG'; 
-- local LIMIT = 1; -- limit order
 

local function setDirect(localDirect) -- решение
    DIRECT = localDirect;
    bidTable.create();
end

local function setLitmitBid(_limit) -- решение
    LIMIT = _limit;
end
-- price текущая цена
-- levelLocal  сила сигнала
-- event -- продажа или покупка

local function decision(event, price, datetime, levelLocal) -- решение
    long(price, datetime, levelLocal , event);
end

local level = 1;
  
function getSetting()
    if setting_scalp then
        SPRED_LONG_BUY = 0.03; -- покупаем если в этом диапозоне небыло покупок
    end   
end   




function long(price, dt, levelLocal , event) -- решение 
    getSetting();
    getfractal(price);


        -- подсчитаем скольк заявок у нас на продажу

        if  LIMIT >= setting.limit_count_buy  then
            
            
 
            -- проверём, покупали здесь или нет, в этом промежутке
            checkRangeBuy = contitionMarket.getRandBuy(price, setting.sellTable);
            -- проверём, стоит ли продажа в этом промежутке
            checkRangeSell = contitionMarket.getRandSell(price, setting.sellTable);



            if checkRangeBuy == true and checkRangeSell == true then
                      -- SPRED_LONG_BUY
                        -- мы покупаем, если в определённом диапозоне небыло покупок
               --  loger.save( 'callBUY  '  .. price  );
                            -- мы не покупаем, если только что продали по текуще цене setting.profit
             --       if(SPRED_LONG_LOST_SELL - SPRED_LONG_PRICE_DOWN > price or  price > SPRED_LONG_LOST_SELL + setting.profit or SPRED_LONG_LOST_SELL == 0 ) then  

                    if(SPRED_LONG_LOST_SELL + setting.profit_range >= price or  price >= SPRED_LONG_LOST_SELL - setting.profit_range or SPRED_LONG_LOST_SELL == 0 ) then  
                        
                        
                                --    local SPRED_LONG_TREND_DOWN = 0.01; -- рынок падает, увеличиваем растояние между покупками
                                --    local SPRED_LONG_TREND_DOWN_SPRED = 0.01; -- на сколько увеличиваем растояние
                                --    local SPRED_LONG_TREND_DOWN_LAST_PRICE= 0; -- последняя покупка

                                    if SPRED_LONG_TREND_DOWN_LAST_PRICE == 0  or  
                                    SPRED_LONG_TREND_DOWN_LAST_PRICE - SPRED_LONG_TREND_DOWN > price  
                                    or SPRED_LONG_TREND_DOWN_LAST_PRICE  < price  then


                                        SPRED_LONG_TREND_DOWN  = SPRED_LONG_TREND_DOWN + SPRED_LONG_TREND_DOWN_SPRED;
                                        SPRED_LONG_TREND_DOWN_LAST_PRICE = price; -- записываем последнюю покупку
                                        callBUY(price,  dt); 
                                        -- SPRED_LONG_TREND_DOWN

                                        signalShowLog.addSignal(dt, 10, false, price);

                                    else
                                        signalShowLog.addSignal(dt, 3, true, price);
                                    
                                    end;
    
                    else
                        signalShowLog.addSignal(dt, 2, true, price);
                    end;  
            else
                signalShowLog.addSignal(dt, 1, true, price);
            end;  
             
      --  end;  
    end;  
end






function getfractal(price)  

    if #setting.fractals_collection > 0 then 
        for k,v in setting.fractals_collection do 
        --    print(k,v) 
        
            label.set("k " , k);

            
        end
    end;

end;


function callSELL(result)

    local statusRange = true;

 

    if setting.sell == false  then return; end;

    if #setting.sellTable > 0 then
        
        for sellT = 1 ,  #setting.sellTable do  
            if statusRange then


                --    loger.save('object.price  ' .. result.close  );

            if  setting.sellTable[sellT].type == 'sell' and result.close >= setting.sellTable[sellT].price  then 

                 local price = result.close;
                setting.count_buyin_a_row = 0; 
       

              --   loger.save('profit:' ..setting.profit..' SELL: ' .. result.close ..' contracts left: '.. #setting.sellTable   );

                 SPRED_LONG_LOST_SELL = price;

                 setting.count_sell =  setting.count_sell + 1; 
                 setting.profit =  setting.sellTable[sellT].price - setting.sellTable[sellT].buy_contract + setting.profit;

                -- надо удалить контракт по которому мы покупали
                local buy_contract = setting.sellTable[sellT].buy_contract;
                table.remove (setting.sellTable, sellT);


                for searchBuy = 1 ,  #setting.sellTable do 

                    if setting.sellTable[searchBuy].buy_contract == buy_contract  then 
                        -- удаляем только 1 элемент
                        setting.limit_count_buy = setting.limit_count_buy - 1;
                        table.remove (setting.sellTable, sellT);
                        
                      --  loger.save('table.remove  :'    );
                   
                        signalShowLog.addSignal(result.datetime, 8, false, price);
            
                        statusRange = false;
                        break;
                    end;
                end;

            end;

        end;

   --  transaction.send("SELL", price, setting.use_contract);
        --setting.current_price 
         end;

    end;
 
end




function callBUY(price ,dt)
    local priceLocal = price;
  if setting.buy == false  then 
    signalShowLog.addSignal(dt, 4, true, price);
    return; end;

    -- ставим заявку на покупку выше на 0.01

   price  = price + 0.01; -- и надо снять заявку если не отработала
--  price  = price + 0.01; -- и надо снять заявку если не отработала

    -- покупаем по дороже (
 
    label.set("BUY" , price, dt, 0);
    bidTable.show(bid);

    setting.count_buy = setting.count_buy + 1;

    local trans_id = getRand()
 

    -- текущаая свеча
    setting.candles_buy_last = setting.number_of_candles;

    setting.count_buyin_a_row = setting.count_buyin_a_row + 1; -- сколько раз подряд купили и не продали

    setting.limit_count_buy = setting.limit_count_buy + 1; -- отметка для лимита

    if setting.emulation == false then
       local trans_id =  transaction.send("BUY", price, setting.use_contract);
    end;
   
    sellTransaction(priceLocal,dt);
   -- else
   --     sellview(price,dt);
  --  end;

 
        for j=1,  setting.use_contract  do 

            --signalShowLog.addSignal(dt, 6, true, price);
            signalShowLog.addSignal(dt, 7, false, price);
            
            setting.sellTable[(#setting.sellTable+1)] = {
                ['price'] = price,
                ['dt']= dt, 
                ['trans_id']= getRand(), 
                ['type']= 'buy',
                ['emulation']=  setting.emulation,
                ['contract']=  setting.use_contract,
                ['buy_contract']= price, -- стоимость продажи
                
            };
        end;
end 





function sellTransaction(priceLocal,dt)
    local p = 0;
    
    signalShowLog.addSignal(dt, 9, false, priceLocal);

    priceLocal = priceLocal + 0.01;
    if(setting.use_contract > 1 ) then
        for j=1,  setting.use_contract  do 
            local  trans_id_sell =  getRand();
             p =  priceLocal + (setting.profit_range * j);

          --  trans_id_sell = transaction.send("SELL", p, setting.use_contract );

            if setting.emulation == false then
                 trans_id_sell =  transaction.send("SELL", p, setting.use_contract );
            end

            label.set('red', p , dt, 1, 'sell contract '.. 1);
            signalShowLog.addSignal(dt, 9, false, p);
            setting.sellTable[(#setting.sellTable+1)] = {
                                                            ['price'] = p,
                                                            ['dt']= dt, 
                                                            ['trans_id']= trans_id_sell, 
                                                            ['type']= 'sell',
                                                            ['emulation']= setting.emulation,
                                                            ['contract']=  1,
                                                            ['buy_contract']= priceLocal, -- стоимость продажи
                                                        };
           
        end;
    else 
        --------------###########################################---------------------
            p = setting.profit_range + priceLocal;
            local  trans_id_sell =  getRand();

            if setting.emulation == false then
                trans_id_sell =  transaction.send("SELL", p, setting.use_contract );
            end;

            signalShowLog.addSignal(dt, 9, false, p);
             label.set('red', p , dt, 1, 'sell contract ');
             
            setting.sellTable[(#setting.sellTable+1)] = {
                                                            ['price'] = p,
                                                            ['dt']= dt, 
                                                            ['trans_id']= trans_id_sell, 
                                                            ['type']= 'sell',
                                                            ['emulation']= setting.emulation,
                                                            ['contract']=  1,
                                                            ['buy_contract']= priceLocal, -- стоимость продажи
                                                        };
    end 
end;

 

function getRand()
    return tostring(math.random(2000000000));
end;

 
 
M.callSELL   = callSELL;
M.bid   = bid ;
M.decision = decision;
M.setDirect = setDirect;
M.setLitmitBid = setLitmitBid;
 
return M