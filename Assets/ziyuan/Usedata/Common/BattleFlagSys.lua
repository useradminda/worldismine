BattleFlagSys = {}
BattleFlagSys.BattleFlagList = {}                                          --战旗数量
BattleFlagSys.UpBattleFlags = {}                                          --穿在身上的
BattleFlagSys.TotalFlag = 0
BattleFlagSys.CalculateProp = {}


function BattleFlagSys.UpBattleFlag(_Flag , _Number , _Index)                                  --穿战旗  
   local ReflashCount = false
   local _Count = _Flag.Count
   if _Count-1 == 0 then
      table.remove(BattleFlagSys.BattleFlagList , _Number)
   elseif _Count-1 >= 0 then
      ReflashCount = true
      _Flag.Count = _Flag.Count - 1
   end
   
   BattleFlagSys.UpBattleFlags[_Index]  = 
   {
      FlagData = _Flag,
   }

   local _FlagTar = MainGameUI.FindPanelTarget("UIBattleFlag")
   if _FlagTar~=nil then
       if ReflashCount==true then
          _FlagTar:ReflashFlagCount(_Flag , _Number)
       else
          _FlagTar:ReflashFlag()
       end
   end
   CalculateRoleProp.CalculateFight(3)
end

function BattleFlagSys.DownBattleFlag(_Flag , _Index)                                --脱战旗
   local ReflashCount = false

   BattleFlagSys.UpBattleFlags[_Index] = nil

   local _TempFlag , _Number = BattleFlagSys.FindFlagByDBId(_Flag.Dbid)               --背包有脱下的战旗

   if _TempFlag~=nil then
      _Flag.Count = _Flag.Count + 1                                                  --数量加一
   else                                                                              --背包没有 重新加入该战旗 并且数量为1
      _Flag.Count = 1
      table.insert(BattleFlagSys.BattleFlagList , #BattleFlagSys.BattleFlagList + 1 , _Flag)
   end

   local _FlagTar = MainGameUI.FindPanelTarget("UIBattleFlag")
   if ReflashCount==true then
      local _Flag , _Number = BattleFlagSys.FindFlagByDBId(_Flag.Dbid)
      _FlagTar:ReflashFlagCount(_Flag , _Number)
   else
      _FlagTar:ReflashFlag()
   end

   CalculateRoleProp.CalculateFight(3)
end

function BattleFlagSys.SaveBattleFlag()                                         --保存战旗
   local Info = ""
   BattleFlagSys.BattleProp()
   for i = 1 , 5 , 1 do
       if BattleFlagSys.UpBattleFlags[i]~=nil then
          if i == 1 then
             Info = tostring(BattleFlagSys.UpBattleFlags[i].FlagData.Dbid)
          else
             Info = Info..","..tostring(BattleFlagSys.UpBattleFlags[i].FlagData.Dbid)
          end          
       else
          if i==1 then
             Info = "0"
          else
             Info = Info..",".."0"
          end        
       end
   end
   WebEvent.SaveFlag(Info , "BattleFlagSys.SaveBattleFlagCallBack", BattleFlagSys.SaveBattleFlagCallBack)
end

function BattleFlagSys.SaveBattleFlagCallBack(data , returnId)
   
end

function BattleFlagSys.CombineFlag(_Flag , _Type)                                    --战旗合成
   local Info = _Flag.Dbid..","..tostring(_Type)
   WebEvent.CombineFlag(Info , "BattleFlagSys.CombineFlagCallBack", BattleFlagSys.CombineFlagCallBack)
end 

function BattleFlagSys.CombineFlagCallBack(data , returnId)              --战旗合成
   if returnId==0 then
      local _BattleFlagTar = MainGameUI.FindPanelTarget("UIBattleFlag")
      _BattleFlagTar:ReflashCombine()
      DataUIInstance.PopTip("W5")
   else
   
   end
end
   
   
       
function BattleFlagSys.TransFlag(_Flag , _FlagDbid , _Num)                                  --转换战旗
   local Info = tostring(_Flag.Dbid)..","..tostring(_FlagDbid)..","..tostring(_Num)
   WebEvent.TransFlag(Info , "BattleFlagSys.TransFlagCallBack", BattleFlagSys.TransFlagCallBack)
end

function BattleFlagSys.TransFlagCallBack(data , returnId)
   if returnId==0 then
      local _BattleFlagTar = MainGameUI.FindPanelTarget("UIBattleFlag")
      _BattleFlagTar:ReflashTransFlag()
      DataUIInstance.PopTip("W6")
   elseif returnId == 1 then

   end
end

function BattleFlagSys.CalculateBattleProp()
   local _Props = {}
   for i =1 , 3 , 1 do
       if _Props[i]==nil then
          _Props[i] = 
          {
             Hp = 0,
             Attack = 0,
             Reduction = 0,
          }
       end
   end
   _Props.Reduction = 0

   for key , value in pairs(BattleFlagSys.UpBattleFlags) do
       if _Props[value.FlagData.Type] == nil then
          _Props[value.FlagData.Type] = 
          {
             Hp = 0,
             Attack = 0,
             Reduction = 0,
             
          }
       end
       
       _Props[value.FlagData.Type].Hp = _Props[value.FlagData.Type].Hp + value.FlagData.Prop.Hp
       _Props[value.FlagData.Type].Attack = _Props[value.FlagData.Type].Attack + value.FlagData.Prop.Attack
       _Props[value.FlagData.Type].Reduction = _Props[value.FlagData.Type].Reduction + value.FlagData.Prop.Reduction
       _Props.Reduction = _Props[value.FlagData.Type].Reduction
   end
  
   return _Props
end

function BattleFlagSys.CalculateTheWholeBattleProp()
   local _BattleCount = 0
   local _MinLevel = 0
   for key , value in pairs(BattleFlagSys.UpBattleFlags) do
       _BattleCount = _BattleCount + 1
       if _BattleCount==1 then
          _MinLevel = value.FlagData.Lvl
       end
       if value.FlagData.Lvl <= _MinLevel then
          _MinLevel = value.FlagData.Lvl      
       end     
   end
   if _BattleCount~=5 then
      BattleFlagSys.TotalFlag = 0
      return 0 , 0
   elseif _BattleCount == 5 then   
      BattleFlagSys.TotalFlag = _MinLevel  
      local _Prop = BattleFlagDataSys.GetPropByLvl(_MinLevel) 
      CalculateRoleProp.CalculateFight(3)
      return _MinLevel , _Prop
   end
end

function BattleFlagSys.BattleProp()
   local _Props = {}
   for i =1 , 3 , 1 do
       if _Props[i]==nil then
          _Props[i] = 
          {
             Hp = 0,
             Attack = 0,
             Reduction = 0,
          }
       end
   end
   _Props.Reduction = 0

   for key , value in pairs(BattleFlagSys.UpBattleFlags) do
       if _Props[value.FlagData.Type] == nil then
          _Props[value.FlagData.Type] = 
          {
             Hp = 0,
             Attack = 0,
             Reduction = 0,
             
          }
       end
       
       _Props[value.FlagData.Type].Hp = _Props[value.FlagData.Type].Hp + value.FlagData.Prop.Hp
       _Props[value.FlagData.Type].Attack = _Props[value.FlagData.Type].Attack + value.FlagData.Prop.Attack
       _Props[value.FlagData.Type].Reduction = _Props[value.FlagData.Type].Reduction + value.FlagData.Prop.Reduction
       _Props.Reduction = _Props[value.FlagData.Type].Reduction
   end
  
   local _BattleCount = 0
   local _MinLevel = 0
   for key , value in pairs(BattleFlagSys.UpBattleFlags) do
       _BattleCount = _BattleCount + 1
       if _BattleCount==1 then
          _MinLevel = value.FlagData.Lvl
       end
       if value.FlagData.Lvl <= _MinLevel then
          _MinLevel = value.FlagData.Lvl      
       end     
   end
  
   if _BattleCount == 5 then   
      local _Prop = BattleFlagDataSys.GetPropByLvl(_MinLevel) 
      for i = 1 , 3 , 1 do
          _Props[i].Hp = _Props[i].Hp + _Prop
          _Props[i].Attack = _Props[i].Attack + _Prop
      end     
   end
   BattleFlagSys.CalculateProp = _Props
   return _Props
end


function BattleFlagSys.FindFlagByDBId(_DBId)                        --查询背包里的战旗   
   for i =1 , #BattleFlagSys.BattleFlagList , 1 do
       if BattleFlagSys.BattleFlagList[i].Dbid == _DBId then
          return BattleFlagSys.BattleFlagList[i] , i
       end
   end
   return nil , nil
end

function BattleFlagSys.GetFlagCount(_DBId)                          --查询战旗数量
   local _Flag = BattleFlagSys.FindFlagByDBId(_DBId)
   if _Flag~=nil then
      return _Flag.Count
   else
      return -1
   end
end

function BattleFlagSys.FindUpFlagByDBId(_DBId , _Pos)               --查询上阵战旗
   if BattleFlagSys.UpBattleFlags[_Pos]~=nil then
      if BattleFlagSys.UpBattleFlags[_Pos].FlagData.Dbid==_DBId then
         return BattleFlagSys.UpBattleFlags[_Pos].FlagData
      end
   else
      return nil
   end
end

function BattleFlagSys.AddBattleFlag(_DBId , _Count)            --添加战旗到战旗包裹
   local _TempFlag , _Index = BattleFlagSys.FindFlagByDBId(_DBId)

   for key , value in pairs(BattleFlagSys.UpBattleFlags) do
       if value.FlagData.Dbid == _DBId then
          _Count = _Count - 1
       end
   end

   if _TempFlag==nil and _Count~=0 then
       local _Flag = BattleFlagDataSys.CreateFlag(_DBId , _Count)
       table.insert(BattleFlagSys.BattleFlagList , #BattleFlagSys.BattleFlagList + 1 , _Flag)
   elseif _TempFlag~=nil then
       if _Count~=0 then
          _TempFlag.Count = _Count
       else
          table.remove(BattleFlagSys.BattleFlagList , _Index)
       end
   end
   
end

function BattleFlagSys.AddUpBattleFlag(_Dbid , _Pos)                    --穿戴在身上的
   local _TempUpFlag = BattleFlagSys.FindUpFlagByDBId(_Dbid , _Pos)
  -- GameMain.Print(_TempUpFlag)
   if _TempUpFlag==nil then
      local _TempFlag , _Number= BattleFlagSys.FindFlagByDBId(_Dbid)
      if _TempFlag~=nil then
         BattleFlagSys.UpBattleFlag(_TempFlag , _Number , _Pos)
      end
   else

   end
end



function BattleFlagSys.CompType(_Series , _Type , _Lvl)
   local _Count = 0
   local TempBattles = {}
   for i = 1 , #BattleFlagSys.BattleFlagList , 1 do
       if _Series==0 and _Lvl~=0 then
          if BattleFlagSys.BattleFlagList[i].Lvl == _Lvl then 
             _Count = _Count + 1
             local _Battle = BattleFlagSys.BattleFlagList[i]           
             table.insert(TempBattles , 1 , _Battle)
          end
       elseif _Series==0 and _Lvl==0 then
          _Count = #BattleFlagSys.BattleFlagList
          return BattleFlagSys.BattleFlagList , _Count
       elseif _Series~=0 and _Lvl==0 then
          if BattleFlagSys.BattleFlagList[i].Series == _Series and BattleFlagSys.BattleFlagList[i].Type == _Type then 
              _Count = _Count + 1
              local _Battle = BattleFlagSys.BattleFlagList[i]
              table.insert(TempBattles , 1 , _Battle)
          end
       elseif _Series~=0 and _Lvl~=0 then
          if BattleFlagSys.BattleFlagList[i].Series == _Series and BattleFlagSys.BattleFlagList[i].Type == _Type and BattleFlagSys.BattleFlagList[i].Lvl == _Lvl then 
              _Count = _Count + 1
              local _Battle = BattleFlagSys.BattleFlagList[i]
              table.insert(TempBattles , 1 , _Battle)
          end
       end             
   end
   return TempBattles , _Count
end

BattleFlagSys.TempUpInfo = {}
function BattleFlagSys.UpBattleComminfoCallBack(_data)
   BattleFlagSys.TempUpInfo = _data     
  
   if BattleFlagSys.TempUpInfo~=nil then    
         for i =1 , 5 , 1 do
           local _DBid = tonumber(BattleFlagSys.TempUpInfo[tostring(i)])
           if _DBid~=0 and _DBid~=nil then
              --Debug.LogError("123123")
              BattleFlagSys.AddUpBattleFlag(_DBid , i)
           end
         end
         BattleFlagSys.BattleProp()
     end

end


function BattleFlagSys.ComminfoCallBack(_data)
   --BattleFlagSys.BattleFlagList = {}
   for key , value in pairs(_data) do
        local ID = tonumber(key)
        if ID~=nil then
           local _DBid = tonumber(ID)
           local _Count = tonumber(value)  
           BattleFlagSys.AddBattleFlag(_DBid , _Count)         
        end
    end
    

    if BattleFlagSys.TempUpInfo~=nil then    
         for i =1 , 5 , 1 do
           local _DBid = tonumber(BattleFlagSys.TempUpInfo[tostring(i)])
           if _DBid~=0 and _DBid~=nil then
              BattleFlagSys.AddUpBattleFlag(_DBid , i)
           end
         end
         BattleFlagSys.BattleProp()
     end
     BattleFlagSys.TempUpInfo = nil
end

function BattleFlagSys.ReleaseData()
   BattleFlagSys.BattleFlagList = {}
   BattleFlagSys.UpBattleFlags = {} 
   BattleFlagSys.CalculateProp = {}
end

return BattleFlagSys