ItemDataSys = {}

function ItemDataSys.GetResourceData(_Type , _Count)
   local _Data = {}
   local _Item = ResourceConfig.GetResourceConfigByType(_Type)
   _Data =
   {
      Item = _Item,
      Count = _Count,
   }
  return _Data
end

function ItemDataSys.GetResourceByIdCount(_ResourceId)
   if _ResourceId==1001 then                --元宝
      return ClinetInfomation.Diamond
   elseif _ResourceId ==1002 then           --铜钱
      return ClinetInfomation.Coin
   elseif _ResourceId ==1003 then           --荣誉
		return ClinetInfomation.Honour
   elseif _ResourceId ==1004 then           --功勋
		return ClinetInfomation.Feats
   elseif _ResourceId ==1005 then           --经验
		
   elseif _ResourceId ==1006 then           --vip经验
		return VipSys.Exp
   elseif _ResourceId ==1007 then           --声望
		return ClinetInfomation.Reputation
   elseif _ResourceId ==1008 then           --金券
		return ClinetInfomation.goldticket
   elseif _ResourceId ==1009 then           --王者信物

   elseif _ResourceId ==1010 then           --军令

   elseif _ResourceId ==1011 then           --招募值
		return SummonSys.SummonPoint
   end
end

function ItemDataSys.GetResourceByTypeCount(_ResourceType)
   if _ResourceId==1 then                --元宝
      return ClinetInfomation.Diamond
   elseif _ResourceId ==2 then           --铜钱
      return ClinetInfomation.Coin
   elseif _ResourceId ==3 then           --荣誉
		return ClinetInfomation.Honour
   elseif _ResourceId ==4 then           --功勋
		return ClinetInfomation.Feats
   elseif _ResourceId ==5 then           --元宝
		
   elseif _ResourceId ==6 then           --vip经验
		return VipSys.Exp
   elseif _ResourceId ==7 then           --声望
		return ClinetInfomation.Reputation
   elseif _ResourceId ==8 then           --金券
		return ClinetInfomation.goldticket
   elseif _ResourceId ==9 then           --王者信物
		
   elseif _ResourceId ==10 then           --军令

   elseif _ResourceId ==11 then           --招募值
		return SummonSys.SummonPoint
   end
end

return ItemDataSys