-- scriptTest.lua (in your scripts directory)
local M = {}
  
local init = {}

arrTableLog = {};

local showLabel = false;



local color = dofile(getScriptPath() .. "\\interface\\color.lua");
local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");



createTableLog = false;
local wordTitleTableLog = {
	['number'] = "�",
	['time'] = "Time",
	['event'] = "Event",
	['status'] = "Status",
	['price'] = "Price",
	['description'] = "Description",
	['log_signal'] = 'Log signals'
};
  

-- dt - current time
-- (int)  event
-- (bool) status
-- (string) price

function getEventLog(_event)
	arr = {
		[1] = 'There was a purchase in this range',  
		[2] = 'We sold at current price',  
		[3] = 'We do not buy where we bought before',  
		[4] = 'buy is off',  
		[5] = 'too high price',  
		[6] = 'mode emulation',  
		[7] = 'bye contract',  
		[8] = 'sell contract',  
		[9] = 'Set a order for to sale', 
		[10] = 'bye',  
		[11] = 'bye', 
		[11] = 'sell', 
	} 	
	
	arr = {
		[1] = '� ���� ���������� ����� ���� �������',  
		[2] = '�� ������� �� ������� ���� � ���� ����������',  
		[3] = '���� ������, ������� ������� �� ��������',  
		[4] = 'buy is off',  
		[5] = '����� ������� ����',  
		[6] = '����� ��������',  
		[7] = '������ ��������',  
		[8] = '������� ��������',  
		[9] = '��������� ������ �� �������',  
		[10] = '�� �������',  
		[11] = '�� �������� �� ������� ���� � ���� ����������', 
		[12] = '� ��� ����� ������ �� ������� �� ������� ����',   
	}
	 
	return arr[_event];
end;

local function addSignal(dt, event, status, price) 
	
	
	CreateNewTableLogEvent();

	loger.save('event :' .. event    ..' price '..price );
	
	local arr = {
		['dt'] =  dt,
		['dtime'] =  dt.hour..':'..dt.min..':'..dt.sec,
		['event'] = event,
		['status'] = status,
		['price'] = price,
		['description'] =  getEventLog(event),
		['number'] =  (#arrTableLog+1),
	};

	arrTableLog[#arrTableLog+1]  = arr; 
	updateLogSignal(arr);
	--table.insert(arrTableLog, (#arrTableLog+1),arr);   
end;


 
 
 function updateLogSignal(_arr)   
	if #arrTableLog == 0 then return; end; 

	itter = 1
	if #arrTableLog > 35 then
		itter = #arrTableLog-35
	end


	if(showLabel) then
		if(_arr.status) then
			label.set('green', _arr.price , _arr.dt, 1, _arr.description);
		else  
			label.set('red', _arr.price , _arr.dt, 1, _arr.description);
		end
	end


	for i = #arrTableLog+1 , itter, -1 do

		if i > 0 then 
			keys =  (#arrTableLog - i  );
		--	keys = 18 - (#arrTableLog - i );
		end 
		 
--	for key in arrTableLog do
		if(keys > 0) then 
				if arrTableLog[i].status then 
					White(t_id_TableLog, keys,0);
					White(t_id_TableLog, keys,1);
					White(t_id_TableLog, keys,2);
					White(t_id_TableLog, keys,3);
					White(t_id_TableLog, keys,4);
				else 
					Green(t_id_TableLog, keys,0);
					Green(t_id_TableLog, keys,1);
					Green(t_id_TableLog, keys,2);
					Green(t_id_TableLog, keys,3);
					Green(t_id_TableLog, keys,4);
				end;
				
			
			if arrTableLog[i].event == 8 or  arrTableLog[i].event == 9 then 

				Red(t_id_TableLog, keys,0);
				Red(t_id_TableLog, keys,1);
				Red(t_id_TableLog, keys,2);
				Red(t_id_TableLog, keys,3);
				Red(t_id_TableLog, keys,4);
			end;
 
			SetCell(t_id_TableLog, keys, 0, tostring(arrTableLog[i].number)); 
			SetCell(t_id_TableLog, keys, 1, tostring(arrTableLog[i].dtime)); 
			SetCell(t_id_TableLog, keys, 2, tostring(arrTableLog[i].event)); 
			SetCell(t_id_TableLog, keys, 3, tostring(arrTableLog[i].price));  
			SetCell(t_id_TableLog, keys, 4, tostring(arrTableLog[i].description));

	end 

	end 


	setLabelTableLog(_arr);
end;


 function setLabelTableLog(_arr)  
if createTableLog == false then return; end;
end;
   


--- simple create a table
function CreateNewTableLogEvent() 
	if createTableLog  then return; end;
	createTableLog = true; 
	
	t_id_TableLog = AllocTable();	 


	 

	-- local wordTitleTableLog = {
	-- 	['number'] = "�",
	-- 	['time'] = "Time",
	-- 	['event'] = "Event",
	-- 	['status'] = "Status",
	-- 	['price'] = "Price",
	-- 	['description'] = "Description",
	 
	-- };
	 


	AddColumn(t_id_TableLog, 0, wordTitleTableLog.number , true, QTABLE_STRING_TYPE, 5);
	AddColumn(t_id_TableLog, 1, wordTitleTableLog.time, true, QTABLE_STRING_TYPE, 10);
	AddColumn(t_id_TableLog, 2,  wordTitleTableLog.event, true, QTABLE_STRING_TYPE, 5); 
	AddColumn(t_id_TableLog, 3,  wordTitleTableLog.price, true,QTABLE_STRING_TYPE, 10); 
	AddColumn(t_id_TableLog, 4,  wordTitleTableLog.description, true,QTABLE_STRING_TYPE, 40); 
 
 


	t = CreateWindow(t_id_TableLog); 
	SetWindowCaption(t_id_TableLog, wordTitleTableLog.log_signal);  

   SetWindowPos(tt, 0, 70, 50, 140);


	for i = 1, 35 do
		InsertRow(t_id_TableLog, -1);
	end;
	for i = 0, 3 do
		Blue(4, i);
		Blue(8, i);
		Gray(10, i);
		Gray(12, i);
		Gray(14, i);
		Gray(16, i);
		Gray(18, i);
	end; 



end;

 
 

 function deleteTable(Line, Col)  -- �������
	DestroyTable(t_id_TableLog)
 end;
 
 
M.addSignal = addSignal;
M.stats = stats;
M.deleteTable = deleteTable;
M. CreateNewTableLogEvent =  CreateNewTableLogEvent;
M.show = show;

return M