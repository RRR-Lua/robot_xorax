-- scriptTest.lua (in your scripts directory)
local M = {}
   
function wSignal(_event)
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
		[18] = '������� �����, ��������� ��������������� ���������� �������',  
		[19] = '������� ���������, ������ �������� �������',   
	}
	 
	return arr[_event];
end;

    
function word(key)

	arr = {	
		['buy_block'] = "���������� �������",
		['not_buy_high'] = "����� �������� �������",
		['not_found_tag'] = "� �������� ������� ���������� �������� \"" .. setting.tag .."\".  �������� ������ � � ������� Price ��������� � ������� �������������, � ����� ���� ���� ���� '�������������', ���� � �������� " .. setting.tag ..". ����� ������� ��������� � ������������� ������" ,  
	}
	 
	return arr[key];
end;
 
M.word = word; 
M.wSignal = wSignal; 
return M