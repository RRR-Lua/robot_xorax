Settings={}
Settings['������������� ������� *'] = '';          -- ��� �������
Settings['����'] = '����';                         -- �������� ����
Account = '����';                        
Settings['����� � �������������'] = '';            -- ����� ������ ('' ��� ������)
NumberInTriangles = -1;
Settings.Name = '��������� (c)quikluacsharp.ru';   -- ��� ����������
Settings['���������� ������ max'] = '20';          -- ������������ ���������� ������������ �������� ������ 
OpenedTradesMAX = 0;
LinesWidth = 2; -- ������� �����, ����������� ������
-- ���������� � ��������� ����� (�������� - ��������� �����)
CloseProfitLine = {};
CloseLossLine = {};

-- ������ �������� ���� ����� �� ���� ������
LineValue = {};

TradesFile = nil; -- ���� ������� ������ �� ������� �����������

Labels = {};      -- ������ ������� ������������� �����
Trades = {};      -- ������ ������

SEC_CODE = "";    -- ���������� �������
DSInfo = nil;     -- ���������� �� ��������� ������ (�������)

FirstDrawComlete = false; -- ����, ��� ��� ���������� �� ���������� ������� (����� �������� ���������� �� ������)
NewTrade = false; -- ����, ��������� ����� ������

TradesFilePath = ''; -- ������ ���� � ����� "������(c)quikluacsharp.ru"

InitComplete = true;

LastSecond = 0;

function Init()    
   -- ��������� ����������
   OpenedTradesMAX = tonumber(Settings['���������� ������ max']);
   -- ���������, ����� ���������� ����� ���� ������
   if type(OpenedTradesMAX) ~= 'number' then OpenedTradesMAX = 20; message('��������� "��� ������": �������� ��������� "���������� ������ max" ������ ���� ������, �� ����� ���� ���������� �� ����� 20.'); end;
   -- ���������, ����� ���������� ����� ���� ������������� ������, ������ ����
   if OpenedTradesMAX <= 0 then OpenedTradesMAX = 20; message('��������� "��� ������": �������� ��������� "���������� ������ max" ������ ���� ������������� ������, ������ ����, �� ����� ���� ���������� �� ����� 20.'); end;
   -- ���������, ����� ���������� ����� ���� ������
   if OpenedTradesMAX%2 > 0 then OpenedTradesMAX = OpenedTradesMAX/2 - OpenedTradesMAX%2 + 1;  message('��������� "��� ������": �������� ��������� "���������� ������ max" ������ ���� ������ ������, �� ����� ���� ���������� �� ����� '..OpenedTradesMAX..'.');end;
   
   -- ������� ������ �����
   Settings.line = {};
   for i=0,OpenedTradesMAX/2-1,1 do
      -- ����� ���������� ������
      Settings.line[i*2+1] = {}
      Settings.line[i*2+1].Name = "�������� ���������� "..tostring(i+1);
      Settings.line[i*2+1].Color = RGB(0, 220, 0);
      Settings.line[i*2+1].Width = LinesWidth;
      Settings.line[i*2+1].Type = TYPE_POINT;
      -- ����� ��������� ������
      Settings.line[i*2+2] = {}
      Settings.line[i*2+2].Name = "�������� ��������� "..tostring(i+1);
      Settings.line[i*2+2].Color = RGB(255, 0, 0);
      Settings.line[i*2+2].Width = LinesWidth;
      Settings.line[i*2+2].Type = TYPE_POINT;
   end;
   LastSecond = os.time();
	return OpenedTradesMAX;
end;

function OnCalculate(idx)
   if not InitComplete then return; end;
   local ArrIdx = {};
   if idx == 1 then -- � ������ ���������  
      DSInfo = getDataSourceInfo(); -- �������� ���������� �� ��������� ������     
      FirstDrawComlete = false;
      -- ��������� ����������
      if Settings['������������� ������� *'] == '' then
         message('��������� "��� ������": ��������������!!! �� ������ ������� "������������� �������", ��������� �� ����� �������� ������ ��������������!');
      else
         -- ��������� ������������� ���������� �������������� � ���������
         local label_params = {};
         label_params['TEXT'] = Settings['������������� ������� *']; -- STRING ������� ����� (���� ������� �� ���������, �� ������ ������)        
         label_params['YVALUE'] = O(idx); -- DOUBLE �������� ��������� �� ��� Y, � �������� ����� ��������� �����
         local Y = '';local m = '';local d = '';
         d,m,Y = string.match(tostring(getInfoParam('TRADEDATE')),"(%d*).(%d*).(%d*)");   
         if #d == 1 then d = "0"..d end   
         if #m == 1 then m = "0"..m end
         label_params['DATE'] = tonumber(Y..m..d); -- DOUBLE ���� � ������� ��������Ļ, � ������� ��������� �����           
         label_params['TIME'] = 120000; -- DOUBLE ����� � ������� ������ѻ, � �������� ����� ��������� �����  
         local LabelID = AddLabel(Settings['������������� ������� *'], label_params);
         if LabelID == nil then
            message('��������� "��� ������": ��������������!!! "������������� �������" ������ �� �����, ��������� �� ����� �������� ������ ��������������!');
         else
            DelLabel(Settings['������������� ������� *'], LabelID);
         end;
      end;
      if Settings['����� � �������������'] == '' then NumberInTriangles = -1; else NumberInTriangles = tonumber(Settings['����� � �������������']); end;
      if type(NumberInTriangles) ~= 'number' then NumberInTriangles = -1; message('��������� "��� ������": ��������������!!! ����� ������ ����� ���� �� 0 �� 9, ���� ��� ������. �������� �������!'); end;
      if NumberInTriangles < -1 or NumberInTriangles > 9 then message('��������� "��� ������": ��������������!!! ����� ������ ����� ���� �� 0 �� 9, ���� ��� ������. �������� �������!'); end;
      -- ��������� �����
      Account = Settings['����'];
      -- ������� �������������� ������ ������� ��� �������� ������ ������������
      AccountIndexes = SearchItems("trade_accounts", 0, getNumberOf("trade_accounts")-1, AccountFinded);
      -- ���� � ��������� �� ���������� ����, �� �������� ��������� �������� ������ ������������
      if #AccountIndexes == 0 then
         message('��������� "��� ������": ������!!! �� ������ ����, �� �������� ��������� �������� ������ ������������! ��������� �� �������������!'); InitComplete = false; 
      -- ���� '����'
      elseif Account == '����' then
         -- ��������� ���������� ��������� ����
         Account = getItem('trade_accounts', AccountIndexes[1]).trdaccid;
      -- ���� ������������ ���� ������������� �����
      else
         -- ��������� ������������� ������ ����� � ���������
         local Finded = false;
         for i = 0,getNumberOf("trade_accounts") - 1 do
            if getItem("trade_accounts", i).trdaccid == Account then Finded = true; break; end;
         end;
         -- ���� ����� ���� �� ���������� � ���������
         if not Finded then
            -- ��������� ���������� ��������� ����
            Account = getItem('trade_accounts', AccountIndexes[1]).trdaccid;
            message('��������� "��� ������": ��������������!!! ��������� ���� ���� �� ������ � ������ ������ ���������, ���������� �������� ���� �� ��������� ��� ������� �����������!');
         -- ���� ����� ���� ���������� � ���������
         else
            -- ��������� ��������� �� �� ����� ����� �������� ������ ������������
            local Finded = false;
            for i=1,#AccountIndexes do
               -- ���� ��������� ���� ��������� � ������ ��������� ������
               if Account == getItem('trade_accounts', AccountIndexes[i]).trdaccid then Finded = true; break; end;
            end;
            if not Finded then
               message('��������� "��� ������": ��������������!!! ��������� ���� ���� �� ��������� �������� �� ������� �����������, ���������� �������� ���� �� ��������� ��� ������� �����������!');
               -- ��������� ���������� ��������� ����
               Account = getItem('trade_accounts', AccountIndexes[1]).trdaccid;
            end;
         end;
      end;
      
      if not InitComplete then return; end;
      
      -- �������� ������ ���� � ����� "������(c)quikluacsharp.ru"
      TradesFilePath = getWorkingFolder().."\\������(c)quikluacsharp.ru\\"..Account.."\\"..DSInfo.sec_code..".csv";
      -- ���������/������� ���� ������ �� �������� �����������
      OpenOrCreateFile();
      
      ReadTradesHistoryFile(); -- ������ �� ��������� ����� ������������ ������ � ������      
      CheckNewTradesInFile(); -- ����������� ��������� ����� ������ � �����, ���������� �� � ������ � �������� �����������
      DrawTrades();  -- ������� ������ �� ������� �� ������       
      SetLinesValues(); -- ������������� �������� ��� ���� �������� �����
   end;
   -- ��������� ��������� ����� ������ �� ���� 1 ���� � �������
   if os.time() > LastSecond or not FirstDrawComlete then
      LastSecond = os.time();
      if idx == Size() then
         CheckNewTradesInFile();
         if not FirstDrawComlete then         
            DrawTrades(); -- ������� ������ �� ������� �� ������
            SetLinesValues(); -- ������������� �������� ��� ���� �������� �����
            FirstDrawComlete = true;
         end;
         -- ���� ������ ����� ������, �������������� ����������
         if NewTrade then
            SetLinesValues(); -- ������������� �������� ��� ���� �������� �����
            DrawTrades(); -- ������� ������ �� ������� �� ������
            for i=1,Size()-1,1 do
               for j=1,OpenedTradesMAX*2,1 do
                  SetValue(i, j, LineValue[i][j]);
               end;
            end;
            NewTrade = false;
         end;
      end;   
      
      if #LineValue >= idx then 
         ArrIdx = LineValue[idx];
         return unpack(ArrIdx);         
      end;
   else
      return;
   end;
end;

-- ��������� ��������� �� �� ����������� ����� �������� �� ����������� �������
function AccountFinded(trade_account)
   for str in trade_account.class_codes:gmatch("[^\|]+") do
      if str == DSInfo.class_code then return true; end;       
   end;
   return false;
end;

-- ���������/������� ���� ������ �� �������� ����� � �������� �����������
function OpenOrCreateFile()   
   -- �������� ������� ���� �������� ����������� � ������ "������"
   TradesFile = io.open(TradesFilePath,"r");
   -- ���� ���� �� ����������
   if TradesFile == nil then 
      -- ������� ���� � ������ "������"
      TradesFile = io.open(TradesFilePath,"w");
      -- ��������� ����
      TradesFile:close();
      -- ��������� ��� ������������ ���� � ������ "������"
      TradesFile = io.open(TradesFilePath,"r");
   end;
end;

-- ������ �� ��������� ����� ������������ ������ � ������
function ReadTradesHistoryFile()
   -- ������ � ������ �����
   TradesFile:seek('set',0);
   -- ���������� ������ �����, ��������� ���������� � ������ ������
   local Count = 0; -- ������� �����
   for line in TradesFile:lines() do
      Count = Count + 1;
      if Count > 1 and line ~= "" then
         NewTrade = true;
         Trades[Count-1] = {};
         local i = 0; -- ������� ��������� ������
         for str in line:gmatch("[^;^\n]+") do
            i = i + 1;
            if i == 3 then Trades[Count-1].Num = tonumber(str);
            elseif i == 4 then Trades[Count-1].Date = tonumber(str);
            elseif i == 5 then Trades[Count-1].Time = tonumber(str);
            elseif i == 6 then Trades[Count-1].Operation = str;
            elseif i == 7 then Trades[Count-1].Qty = tonumber(str);
            elseif i == 8 then Trades[Count-1].Price = tonumber(str);
            elseif i == 9 then Trades[Count-1].Hint = str; Trades[Count-1].OpenCount = Trades[Count-1].Qty;
            end; 
         end;
      end;
   end; 
end;

-- ����������� ��������� ����� ������ � �����, ���������� �� � ������, ������������� ���� NewTrade
function CheckNewTradesInFile()
   -- ������ � ������ �����
   TradesFile:seek('set',0);
   -- ���������� ������ �����
   local Count = 0; -- ������� �����
   for line in TradesFile:lines() do
      Count = Count + 1;      
      if Count > 1 and line ~= "" then
         if Count > #Trades + 1 then
            -- ������� ����� ������         
            NewTrade = true;
            -- ��������� ����� ������ � ������
            Trades[Count-1] = {};
            local i = 0; -- ������� ��������� ������
            for str in line:gmatch("[^;^\n]+") do
               i = i + 1;
               if i == 3 then Trades[#Trades].Num = tonumber(str);
               elseif i == 4 then Trades[#Trades].Date = tonumber(str);
               elseif i == 5 then Trades[#Trades].Time = tonumber(str);
               elseif i == 6 then Trades[#Trades].Operation = str;
               elseif i == 7 then Trades[#Trades].Qty = tonumber(str);
               elseif i == 8 then Trades[#Trades].Price = tonumber(str);
               elseif i == 9 then Trades[#Trades].Hint = str; Trades[#Trades].OpenCount = Trades[#Trades].Qty;
               end; 
            end;
         end;
      end;
   end;
end;

-- ������� ������ �� ������� �� ������
function DrawTrades()
   -- ������� ���������� �����
   if #Labels > 0 then -- ������� ������������������ �����
      for i=1,#Labels,1 do
         DelLabel(Settings['������������� ������� *'], Labels[i]);
      end;
      Labels = {};
   end;
   -- �������� � ���������� ����������� ������
   TradesTmp = {{}};
   TradesTmp = Trades;
   -- ���������� ������ ������
   if #TradesTmp > 0 then
      -- ������ ����� ������
      for j=1,#TradesTmp,1 do
         local label_params = {};
         label_params['TEXT'] = ''; -- STRING ������� ����� (���� ������� �� ���������, �� ������ ������)         
         if TradesTmp[j].Operation == "B" then             
            if NumberInTriangles == -1 then
               label_params['IMAGE_PATH'] = getScriptPath()..'\\�����������\\���������_buy.bmp'; -- STRING ���� � ��������, ������� ����� ������������ � �������� ����� (������ ������, ���� �������� �� ���������)  
            else
               local PicPath = getScriptPath()..'\\�����������\\���������_buy'..NumberInTriangles..'.bmp';
               label_params['IMAGE_PATH'] = PicPath;
            end;
            label_params['ALIGNMENT'] = 'BOTTOM'; -- STRING ������������ �������� ������������ ������ (�������� 4 ��������: LEFT, RIGHT, TOP, BOTTOM)  
         else 
            if NumberInTriangles == -1 then
               label_params['IMAGE_PATH'] = getScriptPath()..'\\�����������\\���������_sell.bmp'; -- STRING ���� � ��������, ������� ����� ������������ � �������� ����� (������ ������, ���� �������� �� ���������)  
            else
               local PicPath = getScriptPath()..'\\�����������\\���������_sell'..NumberInTriangles..'.bmp';
               label_params['IMAGE_PATH'] = PicPath;
            end;
            label_params['ALIGNMENT'] = 'TOP'; -- STRING ������������ �������� ������������ ������ (�������� 4 ��������: LEFT, RIGHT, TOP, BOTTOM)  
         end;         
         label_params['YVALUE'] = TradesTmp[j].Price; -- DOUBLE �������� ��������� �� ��� Y, � �������� ����� ��������� �����  
         label_params['DATE'] = TradesTmp[j].Date; -- DOUBLE ���� � ������� ��������Ļ, � ������� ��������� �����  
         label_params['TIME'] = TradesTmp[j].Time; -- DOUBLE ����� � ������� ������ѻ, � �������� ����� ��������� �����  
         label_params['R'] = 0; -- DOUBLE ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]  
         label_params['G'] = 0; -- DOUBLE ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]  
         label_params['B'] = 0; -- DOUBLE ����� ���������� ����� � ������� RGB. ����� � ��������� [0;255]  
         label_params['TRANSPARENCY'] = 0; -- DOUBLE ������������ ����� � ���������. �������� ������ ���� � ���������� [0; 100]  
         label_params['TRANSPARENT_BACKGROUND'] = 1; -- DOUBLE ������������ �����. ��������� ��������: �0� � ������������ ���������, �1� � ������������ ��������  
         label_params['FONT_FACE_NAME'] = 'Verdana'; -- STRING �������� ������ (�������� �Arial�)  
         label_params['FONT_HEIGHT'] = 14; -- DOUBLE ������ ������  
         label_params['HINT'] = TradesTmp[j].Hint:gsub("_", "\n"); -- STRING ����� ���������
         
         local LabelID = AddLabel(Settings['������������� ������� *'], label_params);
         if LabelID ~= nil then Labels[#Labels+1] = LabelID; end;
      end;
   end;
end;

-- ������������� �������� ��� ���� �������� �����
function SetLinesValues()
   -- �������� ��� ����� �� ���� ��������
   for i=0,OpenedTradesMAX/2-1,1 do
      CloseProfitLine[i*2+1] = 0;
      CloseLossLine[i*2+2] = 0;
   end;
   -- �������� � ���������� ����������� ������
   local TradesTmp = {};
   for i=1,#Trades,1 do
      TradesTmp[i] = {};
      TradesTmp[i].Num = Trades[i].Num; 
      TradesTmp[i].Date = Trades[i].Date; 
      TradesTmp[i].Time = Trades[i].Time;
      TradesTmp[i].Operation = Trades[i].Operation;
      TradesTmp[i].Qty = Trades[i].Qty;
      TradesTmp[i].Price = Trades[i].Price;
      TradesTmp[i].OpenCount = Trades[i].Qty;
   end;
   -- ���������� ������ ������
   if #TradesTmp > 0 then
      -- ������������� ������� ������ ������
      for j=1,#TradesTmp,1 do
         for l=1,Size(),1 do
            if l < Size() then
               local Date = tonumber(T(l+1).year);
               local month = tostring(T(l+1).month);
               if #month == 1 then Date = Date.."0"..month; else Date = Date..month; end;
               local day = tostring(T(l+1).day);
               if #day == 1 then Date = Date.."0"..day; else Date = Date..day; end;
               Date = tonumber(Date);
               local Time = "";
               local hour = tostring(T(l+1).hour);
               if #hour == 1 then Time = Time.."0"..hour; else Time = Time..hour; end;
               local minute = tostring(T(l+1).min);
               if #minute == 1 then Time = Time.."0"..minute; else Time = Time..minute; end;
               local sec = tostring(T(l+1).sec);
               if #sec == 1 then Time = Time.."0"..sec; else Time = Time..sec; end;
               Time = tonumber(Time);
               if TradesTmp[j].Date < Date then
                  TradesTmp[j].Index = l;
                  break;
               elseif TradesTmp[j].Date == Date and TradesTmp[j].Time < Time then
                  TradesTmp[j].Index = l;
                  break;
               end;
            elseif l == Size() then
               TradesTmp[j].Index = l;
               break;
            end;
         end;
      end;      
      -- ������� ��� �������� 
      LineValue = {};
      for i=1,Size(),1 do
         LineValue[i] = {};
         for j=1,OpenedTradesMAX,1 do
            LineValue[i][j] = "";
         end;
      end;
      -- ������������� �������� ��� ���� �������� �����
      for i=1,#TradesTmp,1 do
         for j=i+1,#TradesTmp,1 do            
            -- ���� ��������� ������, ������� ������� ���������������
            if TradesTmp[i].OpenCount > 0 and TradesTmp[j].OpenCount > 0 then  
               if TradesTmp[i].Operation == "B" then
                  if TradesTmp[j].Operation == "S" then                      
                     if TradesTmp[j].Qty >= TradesTmp[i].Qty then
                        -- ������� ������ �������� ����������
                        TradesTmp[i].OpenCount = 0;
                        TradesTmp[j].OpenCount = TradesTmp[j].OpenCount - TradesTmp[i].Qty;
                        -- ���� ������ ����������
                        if TradesTmp[j].Price > TradesTmp[i].Price then                           
                           -- ������� ��������� ���������� �����
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);                           
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);                              
                              -- ������������� �������� �� ����� 
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- ������ ���������
                           -- ������� ��������� ��������� �����
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           LineNumber = FreeLine;
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;                              
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --������������� �������� �� ����� 
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     else -- ����� ����������� ������ ������ ��������������
                        -- ������� ������ �������� ����������
                        TradesTmp[i].OpenCount = TradesTmp[i].OpenCount - TradesTmp[j].Qty;
                        TradesTmp[j].OpenCount = 0; 
                        -- ���� ������ ����������
                        if TradesTmp[j].Price > TradesTmp[i].Price then                        
                           -- ������� ��������� ���������� �����
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              -- ������������� �������� �� �����
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- ������ ���������
                           -- ������� ��������� ��������� �����
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --������������� �������� �� �����
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     end;
                  end;
               else -- ������ ������ "S"
                  if TradesTmp[j].Operation == "B" then
                     if TradesTmp[j].Qty >= TradesTmp[i].Qty then
                        -- ������� ������ �������� ����������
                        TradesTmp[i].OpenCount = 0;
                        TradesTmp[j].OpenCount = TradesTmp[j].OpenCount - TradesTmp[i].Qty;
                        -- ���� ������ ����������
                        if TradesTmp[j].Price < TradesTmp[i].Price then                        
                           -- ������� ��������� ���������� �����
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              -- ������������� �������� �� �����
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- ������ ���������
                           -- ������� ��������� ��������� �����
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --������������� �������� �� �����
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     else
                        -- ������� ������ �������� ����������
                        TradesTmp[i].OpenCount = TradesTmp[i].OpenCount - TradesTmp[j].Qty;
                        TradesTmp[j].OpenCount = 0;   
                        -- ���� ������ ����������
                        if TradesTmp[j].Price < TradesTmp[i].Price then                        
                           -- ������� ��������� ���������� �����
                           local FreeLine = GetFreeLineNumber("CPL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              -- ������������� �������� �� �����
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseProfitLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        else -- ������ ���������
                           -- ������� ��������� ��������� �����
                           local FreeLine = GetFreeLineNumber("CLL", TradesTmp[i].Index);
                           if FreeLine ~= nil then
                              local Value = TradesTmp[i].Price;
                              local Step = (TradesTmp[j].Price - TradesTmp[i].Price)/(TradesTmp[j].Index - TradesTmp[i].Index);
                              --������������� �������� �� ����� 
                              for k=TradesTmp[i].Index, TradesTmp[j].Index,1 do
                                 LineValue[k][FreeLine] = Value;
                                 Value = Value + Step;
                              end;
                              CloseLossLine[FreeLine] = TradesTmp[j].Index;
                           else
                              return 0;
                           end;
                        end;
                     end;
                  end;
               end;
            end;
         end;
      end;
   end;
end;

-- ���������� ����� ��������� ����� �� ������������ ("CPL","CLL") � ������� �����, � �������� ����� ��������
function GetFreeLineNumber(Abbr, index)
   local Arr = nil;
   if Abbr == "CPL" then Arr = CloseProfitLine;
   elseif Abbr == "CLL" then Arr = CloseLossLine;
   end;
   for key,value in pairs(Arr) do
       if index < 2 or value+1 < index then return key; end;
   end;
   message('������ ���������� ������ ���� ����������, �.�. ������� ������ ����������� ���������� ���������� ������!!!\n��������� �������� "���������� ������ max" � ���������� ���������� � ��������� ��� �����.',1);
   return nil;
end;

-- ������� ���������� �������� ���� (����� 0, ��� 1) ��� ������� bit (���������� � 0) � ����� flags, ���� ������ ���� ���, ���������� nil
function CheckBit(flags, bit)
   -- ���������, ��� ���������� ��������� �������� �������
   if type(flags) ~= "number" then error("��������������!!! Checkbit: 1-� �������� �� �����!"); end;
   if type(bit) ~= "number" then error("��������������!!! Checkbit: 2-� �������� �� �����!"); end;
   local RevBitsStr  = ""; -- ������������ (����� �������) ��������� ������������� ��������� ������������� ����������� ����������� ����� (flags)
   local Fmod = 0; -- ������� �� ������� 
   local Go = true; -- ���� ������ �����
   while Go do
      Fmod = math.fmod(flags, 2); -- ������� �� �������
      flags = math.floor(flags/2); -- ��������� ��� ��������� �������� ����� ������ ����� ����� �� �������           
      RevBitsStr = RevBitsStr ..tostring(Fmod); -- ��������� ������ ������� �� �������
      if flags == 0 then Go = false; end; -- ���� ��� ��������� ���, ��������� ����
   end;
   -- ���������� �������� ����
   local Result = RevBitsStr :sub(bit+1,bit+1);
   if Result == "0" then return 0;     
   elseif Result == "1" then return 1;
   else return nil;
   end;
end;

function OnDestroy()
   TradesFile = nil;
   if #Labels > 0 then -- ������� ������������������ �����
      for i=1,#Labels,1 do
         DelLabel(Settings['������������� ������� *'], Labels[i]);
      end;
   end;
end;
