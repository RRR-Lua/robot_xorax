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

 
 
M.wSignal = wSignal; 
return M