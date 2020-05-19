-- scriptTest.lua (in your scripts directory)
local M = {}
   
function wSignal(_event)
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
		[12] = 'sell', 
		[13] = 'the current candle is less than the expected profit, low volatility', 
		[14] = 'the price of the candle is higher than the profit; buying at the top is impossible', 
		[15] = 'Error logging',   
		[16] = 'We do not have free purchase contracts, high limit',
		[17] = 'We sold a lot of contracts in a row, went into the sales limit',
	} 	
	
	
	arr = {
		[1] = '� ���� ���������� ����� ���� �������',  
		[2] = '������� �� ������� ���� � ���� ����������',  
		[3] = '���� ������, ������� �� ��������',  
		[4] = 'buy is off',  
		[5] = '����� ������� ����',  
		[6] = '����� ��������',  
		[7] = '������ ��������',  
		[8] = '������� ��������',  
		[9] = '��������� ������ �� �������',  
		[10] = '�� �������',  
		[11] = '������ �� �������(�������) ���� �� ���������', 
		[12] = '� ��� ����� ������ �� ������� �� ������� ����',   
		[13] = '������� ����� ������ �������������� �������, ������ �������������',  
		[14] = '���� �� ����� ���� �������, ������� �� ����� ����������',   
		[15] = '����������� ������',   
		[16] = '��� ��������� ���������� �� �������, ���� ������� ������',   
		[17] = '�� ������� ����� ���������� ������, ���� � ����� �������',   
	}
	 
	return arr[_event];
end;

    
function word(key)
 
	
	arr = {
		['not_found_tag'] = "� �������� ������� ���������� �������� \"" .. setting.tag .."\".  �������� ������ � � ������� Price ��������� � ������� �������������, � ����� ���� ���� ���� '�������������', ���� � �������� " .. setting.tag ..". ����� ������� ��������� � ������������� ������" ,  
	}
	 
	return arr[key];
end;
 
M.word = word; 
M.wSignal = wSignal; 
return M