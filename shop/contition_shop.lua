

-- ЗДесь определённые условия для магазина

-- https://open-broker.ru/pricing-plans/universal/
-- 751,97 ₽
-- 7,5  = 0.01

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua"); 
local signalShowLog = dofile(getScriptPath() .. "\\interface\\signalShowLog.lua");

M = {};
  
--    ['price'] = price,
--    ['dt']= dt, 
--    ['trans_id']= getRand(), 
--    ['type']= 'buy',
--    ['emulation']=  setting.emulation,
--    ['contract']=  setting.use_contract,
--    ['buy_contract']= price, -- стоимость продажи

-- не покупаем если купили в текущем состоянии

function getRandBuy(price)
          
    -- ['SPRED_LONG_BUY_UP'] = 0.02, -- условия, не покупаем если здесь ранее мы купили | вверх диапозон,
    -- ['SPRED_LONG_BUY_down'] = 0.00, -- условия, не покупаем если здесь ранее мы купили | вниз диапозон
     local checkRange = true;
                if #setting.sellTable > 0  then
                        for j_checkRangBuy=1, #setting.sellTable  do
                                if setting.sellTable[j_checkRangBuy].type == 'buy' then
                                -- здесь узнаю, была ли покупка в этом диапозоне
                                --   if   setting.profit_range + setting.sellTable[j_checkRangBuy].price >= price + setting.profit_infelicity  and 
                                        if   setting.profit_range + setting.sellTable[j_checkRangBuy].price >= price + setting.profit_infelicity  and 
                                        price >= setting.sellTable[j_checkRangBuy].price - setting.SPRED_LONG_BUY_down   then
                                        signalShowLog.addSignal(setting.sellTable[j_checkRangBuy].datetime, 11, false, price);
                                        checkRange = false;
                                        end; 
                                end; 
                        end;  
                end;  
     return checkRange;
 end;
 
 
 -- пвисит ли заявка на продажу в этом промежутке
function getRandSell(price)

        local checkRange = true;
           if #setting.sellTable > 0  then
                   for j_checkRange=1, #setting.sellTable  do
                           if setting.sellTable[j_checkRange].type == 'sell' then
                                   -- здесь узнаю, была ли покупка в этом диапозоне
                                   if   setting.profit_range + setting.sellTable[j_checkRange].price >= price and price >= setting.sellTable[j_checkRange].price - setting.profit_range   then
                                           checkRange = false; 
                                           signalShowLog.addSignal(setting.sellTable[j_checkRange].datetime, 12, false, price);
                           end; 
                   end; 
                   end;  
           end;  
        return checkRange;
    end;
 



 -- Лимит заявок на покупку
function getLimitBuy(dt)

        local checkRange = true;
           if setting.LIMIT_BID <= setting.limit_count_buy  then

                signalShowLog.addSignal(dt, 16, false, setting.limit_count_buy);
                checkRange = false; 
        end;  
        return checkRange;
end;
       

 
 -- Не покупаем если промежуток на свече соответствуют высокой цене
 function getRandCandle(price, datetime)

       -- local Gap = setting.profit_range - 0.02
        local Gap = setting.profit_range ;


        local range_candle = setting.candle_current_high - setting.candle_current_low;


        local checkRange = true;
                if range_candle < Gap  then 
                        -- свечка меньше текущего профита 
	                --	[13] = 'Текущая свеча меньше преполагаемого профита, низкая волатильность',   
                        checkRange = false;
                        signalShowLog.addSignal(datetime, 13, false, range_candle);
                end;  

                local priceMinimum =  setting.candle_current_high - Gap  ;

                if checkRange == true and priceMinimum > price + setting.profit_infelicity    then
                 
                else
                                -- свечка меньше текущего профита  
                                --	[14] = 'Цена на свече выше профита, покупка на верху невозможна',   
                        checkRange = false;
                        signalShowLog.addSignal(datetime, 14, false, priceMinimum );
                end; 
        return checkRange;
end;
    
     
 


 -- Падение рынка
 function getFailMarket(price, datetime) 
 
local checkRange = true;

if setting.SPRED_LONG_TREND_DOWN_LAST_PRICE == 0  or  
        setting.SPRED_LONG_TREND_DOWN_LAST_PRICE - setting.SPRED_LONG_TREND_DOWN  > price  - setting.profit_infelicity  or 
        setting.SPRED_LONG_TREND_DOWN_LAST_PRICE  < price  then
 
else
        checkRange = false;
        signalShowLog.addSignal(datetime, 3, true, setting.SPRED_LONG_TREND_DOWN_LAST_PRICE - setting.SPRED_LONG_TREND_DOWN);

end;
return checkRange;
end;


 -- Запрет на покупку
 function getFailBuy(price, datetime) 

        local checkRange = true;
        if setting.buy == false  then
                signalShowLog.addSignal(dt, 4, true, price);
                checkRange = false; 
        end;
        return checkRange;
end;


M.getFailBuy = getFailBuy;
M.getLimitBuy = getLimitBuy;
M.getFailMarket = getFailMarket;
M.getRandCandle = getRandCandle;
M.getRandSell = getRandSell;
M.getRandBuy = getRandBuy;
 
return M