-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}
  
local loger = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua");
local words = dofile(getScriptPath() .. "\\langs\\words.lua");


init.create = false;

local word = {
	['status'] = "Status",
	['buy'] = "Buy",
	['Buyplus'] = "Buy",
	['sell'] = "",
	['close_positions'] = "",
	['profit_range'] = "Profit range:",
	['start'] = "           BABLO",
	['current_limit'] = "Current limit:",
	['Use_contract_limit'] = "Use contract:",
	['current_limit_minus'] = "          Minus",
	['current_limit_plus'] = "          Add", 
	['finish'] = "           PAUSE",
	['pause'] = "          CONTINUE",
	['pause2'] = "           PAUSE",
	['emulation'] = "     Emulation",
	['buy_by_hand'] = "        BUY (now)",
	['sell_by_hand'] = "        MODE",
	['take_profit_offset'] = "take profit offset:",
	['take_profit_spread'] = "take profit spread:",
	['on'] = "          ON      ",

	['on'] = "          ON      ",
	['off'] = "          OFF     ",
	['Trading_Bot_Control_Panel'] = "Trading Bot Control Panel (free 0.0.1)",
	
	['block_buy'] = "buy / block",
	['SPRED_LONG_TREND_DOWN'] = "trend down", -- рынок падает, увеличиваем растояние между покупками
	['SPRED_LONG_TREND_DOWN_SPRED'] = "down market range", -- на сколько увеличиваем растояние
	['not_buy_high'] = "not buy high", -- условия; Выше какого диапазона не покупать(на хаях)
	 
	 
};
  
-- OFFSET SPREAD
 
local function show()  
	CreateNewTable(); 
	for i = 1, 35 do
		InsertRow(t_id, -1);
	 end;
	for i = 0, 3 do
		Blue(t_id,4, i);
		Gray(t_id,10, i);
		Gray(t_id,12, i);
		Gray(t_id,14, i);
		Gray(t_id,16, i);
		Gray(t_id,18, i);
		Gray(t_id,20, i);
		Gray(t_id,22, i);
		Gray(t_id,24, i);
		
	 end; 
		 
	  


	SetCell(t_id, 1, 0,  '')
	SetCell(t_id, 1, 1, '')
	SetCell(t_id, 1, 2, '')
	SetCell(t_id, 2, 1, word.on) 

	SetCell(t_id, 3, 0,  '')
	SetCell(t_id, 3, 1, '')
	SetCell(t_id, 3, 2, '')
	SetCell(t_id, 4, 0,  '')
	SetCell(t_id, 4, 1, '')
	SetCell(t_id, 4, 2, '') 

	button_finish();
	buy_process();


	mode_emulation_on();

	
	current_limit();
	current_limit_plus();
	current_limit_minus();
end
 
-- ['profit_size'] = "profit size:",
-- ['profit_range'] = "profit range:",

function current_limit() 
	SetCell(t_id, 11, 0,  word.current_limit); 
	SetCell(t_id, 13, 0,  word.Use_contract_limit); 

	SetCell(t_id, 17, 0,  word.profit_range); 
	SetCell(t_id, 19, 0,  word.take_profit_offset); 
	SetCell(t_id, 21, 0,  word.take_profit_spread); 
	SetCell(t_id, 25, 0,  words.word('buy_block')); 
	SetCell(t_id, 26, 0,  word.SPRED_LONG_TREND_DOWN); 
	SetCell(t_id, 27, 0,  word.SPRED_LONG_TREND_DOWN_SPRED); 
	SetCell(t_id, 28, 0,  words.word('not_buy_high')); 
 
end; 
function current_limit_plus()  
	SetCell(t_id, 11, 2,  word.current_limit_plus); 
	SetCell(t_id, 13, 2,  word.current_limit_plus); 

	SetCell(t_id, 17, 2,  word.current_limit_plus); 
	SetCell(t_id, 19, 2,  word.current_limit_plus); 
	SetCell(t_id, 21, 2,  word.current_limit_plus); 
	SetCell(t_id, 25, 2,  word.current_limit_plus); 
	SetCell(t_id, 26, 2,  word.current_limit_plus); 
	SetCell(t_id, 27, 2,  word.current_limit_plus); 
	SetCell(t_id, 28, 2,  word.current_limit_plus); 
	Green(t_id,11, 2);
	Green(t_id,13, 2);

	Green(t_id,17, 2);
	Green(t_id,19, 2);
	Green(t_id,21, 2);
	Green(t_id,25, 2);
	Green(t_id,26, 2);
	Green(t_id,27, 2);
	Green(t_id,28, 2);
 
 


end;
function current_limit_minus()  
	SetCell(t_id, 11, 3,  word.current_limit_minus); 
	SetCell(t_id, 13, 3,  word.current_limit_minus); 
 
	SetCell(t_id, 17, 3,  word.current_limit_minus); 
	SetCell(t_id, 19, 3,  word.current_limit_minus); 
	SetCell(t_id, 21, 3,  word.current_limit_minus); 
	SetCell(t_id, 25, 3,  word.current_limit_minus); 
	SetCell(t_id, 26, 3,  word.current_limit_minus); 
	SetCell(t_id, 27, 3,  word.current_limit_minus); 
	SetCell(t_id, 28, 3,  word.current_limit_minus); 
	Red(t_id,11, 3);
	Red(t_id,13, 3);

	Red(t_id,17, 3);
	Red(t_id,19, 3);
	Red(t_id,21, 3);
	Red(t_id,25, 3);
	Red(t_id,26, 3);
	Red(t_id,27, 3);
	Red(t_id,28, 3);
end;

 
function use_contract_limit()  
	SetCell(t_id, 11, 1,   tostring( setting.LIMIT_BID ) .. '/'.. setting.limit_count_buy .. '/'.. setting.use_contract ); 
	SetCell(t_id, 13, 1,   tostring(setting.use_contract)); 
 
	SetCell(t_id, 17, 1,   tostring(setting.profit_range)); 
	SetCell(t_id, 19, 1,   tostring(setting.take_profit_offset)); 
	SetCell(t_id, 21, 1,   tostring(setting.take_profit_spread)); 
-- потом только решение за человеком / сколько подряд раз уже купили
	SetCell(t_id, 25, 1,   tostring( setting.each_to_buy_to_block ) .. '/'.. setting.each_to_buy_step ); 
	SetCell(t_id, 26, 1,   tostring( setting.SPRED_LONG_TREND_DOWN )); 
	SetCell(t_id, 27, 1,   tostring( setting.SPRED_LONG_TREND_DOWN_SPRED )); 
	SetCell(t_id, 28, 1,   tostring( setting.not_buy_high .. ' (-'..setting.profit_range ..')' )); 
 
 
end;

 
 
function mode_emulation_on() 
	setting.emulation=true;
	SetCell(t_id, 2, 2,  word.emulation)
	SetCell(t_id, 3, 2,  word.on)
	Green(t_id,1, 2) 
	Green(t_id,2, 2) 
	Green(t_id,3, 2)
end;

function mode_emulation_off() 
	setting.emulation=false;  
	SetCell(t_id, 2, 2,  word.emulation)
	SetCell(t_id, 3, 2,  word.off)
	Gray(t_id,1, 2);
	Gray(t_id,2, 2);
	Gray(t_id,3, 2);
end;
 


function button_start()
	setting.status=true;
	SetCell(t_id, 2, 0,  word.finish)
	SetCell(t_id, 3, 1,  '')
	SetCell(t_id, 3, 2,  '')
	SetCell(t_id, 3, 3,  '')
	Green(t_id,1, 0) 
	Green(t_id,2, 0) 
	Green(t_id,3, 0)
end;
function button_finish() 
	setting.status=false;  
	SetCell(t_id, 2, 0,  word.start)
	Gray(t_id,1, 0);
	Gray(t_id,2, 0);
	Gray(t_id,3, 0);
end;






function button_pause() 
	setting.status=false;  
	SetCell(t_id, 2, 0,  word.pause)
	SetCell(t_id, 3, 1,  word.pause2)
	SetCell(t_id, 3, 2,  word.pause2)
	 
	Red(t_id,1, 0);
	Red(t_id,2, 0);
	Red(t_id,3, 0);
end;


 


function buy_process()
	setting.buy = true;
	-- при падении рынка обнуляем продажы
	setting.each_to_buy_step = 0;
	SetCell(t_id, 2, 1,  word.on)
	Green(t_id,1, 1) 
	Green(t_id,2, 1) 
	Green(t_id,3, 1)
end;
function buy_stop()  
	setting.buy = false;  
	SetCell(t_id, 2, 1,  word.off)
	Red(t_id,1, 1);
	Red(t_id,2, 1);
	Red(t_id,3,1);
end;
 
local function stats()  
end;



--- simple create a table
function CreateNewTable() 
if createTable  then return; end;

init.create = true; 
	t_id = AllocTable();	 


	AddColumn(t_id, 0, word.status , true, QTABLE_STRING_TYPE, 30);
	AddColumn(t_id, 1, word.buy, true, QTABLE_STRING_TYPE, 20);
	AddColumn(t_id, 2, word.sell, true, QTABLE_STRING_TYPE, 20); 
	AddColumn(t_id, 3, word.close_positions, true,QTABLE_STRING_TYPE, 20); 
 
	t = CreateWindow(t_id); 
	SetWindowCaption(t_id, word.Trading_Bot_Control_Panel); 
   SetTableNotificationCallback(t_id, event_callback_message);  
   SetWindowPos(tt, 0, 70, 292, 140)
end;


function event_callback_message (t_id, msg, par1, par2)




	if par1 == 1 and par2 == 2 or  par1 == 2 and par2 == 2 or par1 == 3 and par2 == 2 then
		if  msg == 1 and setting.emulation == false then
			mode_emulation_on(); 
			return; 
		end;
		if  msg == 1 and setting.emulation == true then
			mode_emulation_off();
			return;
		end;
	end;




	



	if par1 == 1 and par2 == 0 or  par1 == 2 and par2 == 0 or par1 == 3 and par2 == 0 then
		if  msg == 1 and setting.status == false then
				button_start(); 
				return;
		end;

		if  msg == 1 and setting.status == true then
			--button_finish();
			button_pause();
			return;
		end;
	end;

	    
	if par1 == 1 and par2 == 1 or  par1 == 2 and par2 == 1 or par1 == 3 and par2 == 1 then
		if  msg == 1 and setting.buy == false then
				buy_process(); 
				return;
		end;

		if  msg == 1 and setting.buy == true then
				buy_stop();
			return;
		end;
	end;



 


	
 
	if par1 == 11 and par2 == 2  and  msg == 1 then
		
		setting.LIMIT_BID = setting.LIMIT_BID + 1;
		
		use_contract_limit();
		return;
	end;
	if par1 == 11 and par2 == 3  and  msg == 1 then
		
		if(setting.LIMIT_BID > 0) then
				setting.LIMIT_BID = setting.LIMIT_BID - 1;
				use_contract_limit();
			end; 
		return;
	end;



	
 
	if par1 == 13 and par2 == 2  and  msg == 1 then
		
		setting.use_contract = setting.use_contract + 1; 
		use_contract_limit();
		return;
	end;

	if par1 == 13 and par2 == 3  and  msg == 1 then
		
		if(setting.use_contract > 1) then
				setting.use_contract = setting.use_contract - 1;
				use_contract_limit();
			end; 
		return;
	end;



 


	if par1 == 17 and par2 == 2  and  msg == 1 then
		setting.profit_range = setting.profit_range + 0.01; 
		use_contract_limit();
		return;
	end;

	if par1 == 17 and par2 == 3  and  msg == 1 then
		if setting.profit_range > 0.01 then
			setting.profit_range = setting.profit_range - 0.01;
			use_contract_limit();
			end; 
		return;
	end;


	if par1 == 19 and par2 == 2  and  msg == 1 then
		setting.take_profit_offset = setting.take_profit_offset + 0.01; 
		use_contract_limit();
		return;
	end;

	if par1 == 19 and par2 == 3  and  msg == 1 then
		if setting.take_profit_offset > 0.01 then
			setting.take_profit_offset = setting.take_profit_offset - 0.01;
			use_contract_limit();
			end; 
		return;
	end;




	if par1 == 21 and par2 == 2  and  msg == 1 then
		setting.take_profit_spread = setting.take_profit_spread + 0.01; 
		use_contract_limit();
		return;
	end;

	if par1 == 21 and par2 == 3  and  msg == 1 then
		if setting.take_profit_spread > 0.01 then
			setting.take_profit_spread = setting.take_profit_spread - 0.01;
			use_contract_limit();
			end; 
		return;
	end;


	
	-- блокировка лимита при падении
	if par1 == 25 and par2 == 2  and  msg == 1 then
		setting.each_to_buy_to_block = setting.each_to_buy_to_block + 1; 
		use_contract_limit();
		return;
	end;
	if par1 == 25 and par2 == 3  and  msg == 1 then
		if setting.each_to_buy_to_block > 1 then
			setting.each_to_buy_to_block = setting.each_to_buy_to_block - 1;
			use_contract_limit();
			end; 
		return;
	end;
	 
	
	
	-- рынок падает, увеличиваем растояние между покупками
	if par1 == 26 and par2 == 2  and  msg == 1 then
		setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN + 0.01; 
		use_contract_limit();
		return;
	end;
	if par1 == 26 and par2 == 3  and  msg == 1 then
		if setting.SPRED_LONG_TREND_DOWN > 0.01 then
			setting.SPRED_LONG_TREND_DOWN = setting.SPRED_LONG_TREND_DOWN - 0.01;
			use_contract_limit();
			end; 
		return;
	end;
	 
	
	
	-- на сколько увеличиваем растояние при падении рынка между покупками
	if par1 == 27 and par2 == 2  and  msg == 1 then
		setting.SPRED_LONG_TREND_DOWN_SPRED = setting.SPRED_LONG_TREND_DOWN_SPRED + 0.01; 
		use_contract_limit();
		return;
	end;
	if par1 == 27 and par2 == 3  and  msg == 1 then
		if setting.SPRED_LONG_TREND_DOWN_SPRED > 1 then
			setting.SPRED_LONG_TREND_DOWN_SPRED = setting.SPRED_LONG_TREND_DOWN_SPRED - 0.01;
			use_contract_limit();
			end; 
		return;
	end;
	 
	-- на сколько увеличиваем растояние при падении рынка между покупками
	if par1 == 28 and par2 == 2  and  msg == 1 then
		setting.not_buy_high = setting.not_buy_high + 0.05; 
		use_contract_limit();
		return;
	end;
	if par1 == 28 and par2 == 3  and  msg == 1 then
		if setting.not_buy_high > 0.05 then
			setting.not_buy_high = setting.not_buy_high - 0.05;
			use_contract_limit();
			end; 
		return;
	end;
	 



	 

 
	 
end;

 

function deleteTable()
	DestroyTable(t_id)
end;

 
M.buy_stop =  buy_stop;
M.use_contract_limit =  use_contract_limit;
M.stats =  stats;
M.deleteTable = deleteTable;
M.CreateTable = CreateTable;
M.show = show;

return M