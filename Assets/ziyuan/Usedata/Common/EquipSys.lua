EquipSys = {}                                       --装备事件
EquipSys.EquipList = {}
EquipSys.TempEquip = {}
EquipSys.HeroEquipUUIDs = {}								--人物身上穿的装备
EquipSys.HeroEquipList = {}	
EquipSys.BagEquipList = {}									--背包的装备事件
EquipSys.PurifyEquip = nil							--洗炼的装备

EquipSys.StrengthRate = 0							--强化成功率
EquipSys.StrengthRateOverTime = 0					--强化成功率的时间戳
EquipSys.StrengthCD = 0								--强化CD时间戳点

EquipSys.IsSort = true								--是否排序

function EquipSys.InitAfterNet()
	for key,value in pairs(EquipSys.EquipList) do
		local isEquip = EquipSys.IsHasEquip(value.UUID)
		if isEquip == false then
			table.insert(EquipSys.BagEquipList , #EquipSys.BagEquipList+1 , value)
		else
			table.insert(EquipSys.HeroEquipList , #EquipSys.HeroEquipList+1 , value)
		end
	end
end

function EquipSys.AddBagEquip(_Equip)						--将装备数据加入背包
	table.insert(EquipSys.BagEquipList , #EquipSys.BagEquipList+1 , _Equip)
end

function EquipSys.GetBagEquipByType(DressType , Quality , QualityLvl , _UUID)					--根据穿在身上的不同部位的类型获取装备list
	EquipSys.GetEquipList()
	local list = {}
	for key,value in pairs(EquipSys.BagEquipList) do
		if value.EquipType == DressType and value.UUID ~= _UUID then
			if value.Quality == Quality and value.QualityLvl == QualityLvl then
				table.insert(list , #list+1 , value)
			end
		end
	end
	return list
end

function EquipSys.SetStrengthCD()			--设置当前的CD
	local curTime = ClinetInfomation.WorldTime

	if EquipSys.StrengthCD ~= 0 then
		local delTime = EquipSys.StrengthCD - curTime
		if delTime>0 then
			TimeControl.LoginTime(delTime, "StrengthEquipCD")
		else
			TimeControl.SetTime("StrengthEquipCD" , nil)
		end
	end
end

function EquipSys.IsCanStrength()					--是否可以强化
	local curTime = ClinetInfomation.WorldTime
	if EquipSys.StrengthCD == 0 then
		return true
	else
		local del = EquipSys.StrengthCD - curTime
		if del>10*60 then
			return false
		else
			return true
		end
	end
end

function EquipSys.DelBagEquip(_UUID)
	local index = EquipSys.GetHeroEquipUUID(_UUID) 
	table.remove(EquipSys.BagEquipList , index)
end

function EquipSys.AddHeroEquip(_UUID)				
	local uuid = _UUID
	table.insert(EquipSys.HeroEquipUUIDs , #EquipSys.HeroEquipUUIDs+1 , uuid)
end

function EquipSys.DelHeroEquip(_UUID)
	local index = EquipSys.GetHeroEquipUUID(_UUID)
	local equip = EquipSys.HeroEquipList[index]
	EquipSys.AddBagEquip(equip)
	table.remove(EquipSys.HeroEquipUUIDs , index)
end

function EquipSys.GetHeroEquipUUID(_UUID)
	for key,value in pairs(EquipSys.HeroEquipUUIDs) do
		if value == _UUID then
			return key
		end
	end
	return nil
end

function EquipSys.SellEquip(_Equip)              --出售某个装备
   local info = _Equip.UUID
  
   WebEvent.SellEquips(info , "EquipSys.SellEquipCallBack" , EquipSys.SellEquipCallBack)
end

function EquipSys.SellEquipCallBack(data , returnId)              --出售某个装备

end


function EquipSys.UpEquipLvl(_Equip)                --升级
    EquipSys.TempEquip = _Equip
    local info = ""
    WebEvent.UpEquip(info , "EquipSys.UpEquipLvlCallBack" , EquipSys.UpEquipLvlCallBack)
end

function EquipSys.UpEquipLvlCallBack(data , returnId)
    if returnId==0 then
       EquipSys.TempEquip.Lvl = EquipSys.TempEquip.Lvl + 1
    elseif returnId == 1 then
       
    end
end

function EquipSys.StrengthEquip(_Equip , _IsBuyCD , _IsUseProp)		--强化

	local info = _Equip.UUID .. "," .. _IsBuyCD .. "," .. _IsUseProp
	WebEvent.UpEquipQuality(info , "EquipSys.StrengthEquipCallBack" , EquipSys.StrengthEquipCallBack)
end

function EquipSys.StrengthEquipCallBack(data , returnId)
	local num = tonumber(data)
	local UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
	
	if UIEquipTar ~=nil then
		UIEquipTar:ShowStrengthAfterInfo(num)
	end	
	
end

function EquipSys.ClearEquipStrengthCD()							--清除装备强化CD
	local info = nil
	WebEvent.ClearEquipStrengthCD(info , "EquipSys.ClearEquipStrengthCDCallBack" ,EquipSys.ClearEquipStrengthCDCallBack)
end

function EquipSys.ClearEquipStrengthCDCallBack(data, returnId)
	local UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
	
	if UIEquipTar ~=nil then
		UIEquipTar:ClearStrengthCDCallBack()
	end	
end

function EquipSys.GetStrengthRate()									--获得装备强化率
	local info = nil
	WebEvent.GetStrongthRate(info , "EquipSys.GetStrengthRateCallBack" , EquipSys.GetStrengthRateCallBack)
end

function EquipSys.GetStrengthRateCallBack(data , returnId)
	local UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
	if UIEquipTar ~=nil then
		UIEquipTar:ShowStrengthRate()
	end
end

function EquipSys.EquipReCast(_Equip , _MatUUIDs)              --重铸

   local info = tostring(_Equip.UUID) .. "," .. _MatUUIDs
   WebEvent.ReCast(info , "EquipSys.EquipReCastCallBack" , EquipSys.EquipReCastCallBack)
end

function EquipSys.EquipReCastCallBack(data , returnId)
	MusicManagerSys.EquipRecast()
   	local index = EquipSys.FindEquipIndexByUUID(data)
	EquipSys.AddHeroEquip(data)
	local UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
	if UIEquipTar ~=nil then
		UIEquipTar:ShowRecastInfo(EquipSys.EquipList[index] , true)
	end
end

function EquipSys.EquipAddProp(_Equip)					--洗炼
	EquipSys.PurifyEquip  = _Equip
	local info = _Equip.UUID
	WebEvent.ReFine(info , "EquipSys.EquipAddPropCallBack" , EquipSys.EquipAddPropCallBack)
end

function EquipSys.EquipAddPropCallBack(data , returnId)
    if returnId == 0 then
	    MusicManagerSys.EquipWash()
	    local index = EquipSys.FindEquipIndexByUUID(EquipSys.PurifyEquip.UUID)
	    local num = tonumber(data)
	    local UIEquipTar = MainGameUI.FindPanelTarget("UIEquip")
	    if UIEquipTar ~=nil then
		    if num==nil then
			    num = 0
		    end
		    UIEquipTar:ShowPurifyAfterInfo(EquipSys.EquipList[index] , num)
	    end 
    else
       DataUIInstance.PopTip("Z9")
    end
end

function EquipSys.EquipRefine(_Type , _Free)        --刷新冶炼招募    
   local info = _Type .. "," .. _Free		--type 1初级， 2 中级，3高级 ；free 1免费 0 付费
   WebEvent.RefrashEquipStore(info , "EquipSys.EquipRefineCallBack" , EquipSys.EquipRefineCallBack)
end

function EquipSys.EquipRefineCallBack(data , returnId)

end


function EquipSys.SaveEquip(_Role)                        --保存穿着的装备
   local info = nil
   WebEvent.UpEquip(info , "EquipSys.SaveEquipCallBack" , EquipSys.SaveEquipCallBack)
end

function EquipSys.SaveEquipCallBack(data , returnId)                        --保存装备回调
   
end

function EquipSys.GetEquip(_EquipDBid)           --获取抽到的装备
   local info = nil
   WebEvent.GetEquip(info , "EquipSys.GetEquipCallBack" , EquipSys.GetEquipCallBack)
end

function EquipSys.GetEquipCallBack(data , returnId)

end

function EquipSys.UpDownEquip(_Role)                   --穿卸装备
	local info =tostring( _Role.UUID) .. ","
	
	for i=1,8,1 do
		local equipItem = _Role.Equips[i]
		if equipItem == nil then
			if i==1 then
				info =info .. "0"
			else
				info =info .. "_0"
			end
		else
			if i==1 then
				info = info .. equipItem
			else
				info = info .. "_" .. equipItem
			end
		end 
	end
	
	WebEvent.UpandDownEquip(info , "EquipSys.UpDownEquipCallBack" ,EquipSys.UpDownEquipCallBack)
--   _Equip.EquipOn = 1
--   local _EquipType = _Equip.EquipType
--   if _Role.Equips[_EquipType]==nil then
--      _Role.Equips[_EquipType] = {}
--   end
--   _Role.Equips[_EquipType] = _Equip
end
function EquipSys.UpDownEquipCallBack(data , returnId)
	
end

function EquipSys.FindEquipByUUID(_UUID)
   for i =1 , #EquipSys.EquipList , 1 do
       if EquipSys.EquipList[i].UUID == tostring(_UUID) then
          return EquipSys.EquipList[i]
       end
   end
   return nil
end

function EquipSys.FindEquipIndexByUUID(_UUID)
	for i =1 , #EquipSys.EquipList , 1 do
       if EquipSys.EquipList[i].UUID==_UUID then
          return i
       end
   end
   return nil
end

function EquipSys.GetEquipList()				--得到装备列表
	
	EquipSys.BagEquipList={}
	for key,value in pairs(EquipSys.EquipList) do
		local isEquip = EquipSys.IsHasEquip(value.UUID)
		if isEquip == false then
			table.insert(EquipSys.BagEquipList , #EquipSys.BagEquipList+1 , value)
		end
	end
	table.sort(EquipSys.BagEquipList , EquipSys.Comp)
	return EquipSys.BagEquipList
end

function EquipSys.Comp(A, B)
	 if A~=nil and B~=nil then
       if A.Quality>B.Quality then
          return true
	   else
		  if A.Quality==B.Quality then
			if A.Dbid>B.Dbid then
				return true
			else
				return false
			end
		  else
			return false
		  end
	   end
	else
		return false
    end
end

function EquipSys.IsHasEquip(UUID)
	for key,value in pairs(EquipSys.HeroEquipUUIDs) do
		if value == UUID then
			return true
		end
	end
	return false
	
end

function EquipSys.GetHeroEquips()				--得到武将穿戴的装备数据
	return EquipSys.HeroEquipList
end

function EquipSys.GetHeroEquipByUUID(_UUID)		--通过UUID得到武将已经穿戴的装备
	local list = EquipSys.EquipList
	for key,value in pairs(list) do
		if value.UUID == _UUID then
			return value
		end
	end
	return nil
end

function EquipSys.AddEquip(_UUID , _Id , _Lvl , _QualityLvl , _AttackAdd , _HpAdd , _AttackSpeedAdd) 
    local _Equip = EquipDataSys.CreateEquip(_UUID , _Id , _Lvl , _QualityLvl , _AttackAdd , _HpAdd , _AttackSpeedAdd) 
	if #EquipSys.EquipList == 0 then
		table.insert(EquipSys.EquipList , #EquipSys.EquipList+1 , _Equip)
	else
		local index = EquipSys.FindEquipIndexByUUID(_UUID)
		if index ~=nil then
			EquipSys.EquipList[index] = _Equip
		else
			table.insert(EquipSys.EquipList , #EquipSys.EquipList+1 , _Equip)
		end
	end
	
end

function EquipSys.DelEquip(_UUID)
	local index =EquipSys.FindEquipIndexByUUID(_UUID)
	table.remove(EquipSys.EquipList , index)
end
function EquipSys.ComminfoCallBack(data)
   for key , value in pairs(data) do
        local ID = tostring(key)
		local index =  tonumber( value["id"])
        if ID~=nil and index~=nil then
			local delet =tonumber(value["isDelete"])
			local id=value["id"]
			local uuid = ID
			local lv = value["lv"]
			local qlv = value["qlv"]
			local atk_add = value["atk_add"]
			local hp_add = value["hp_add"]
			local atk_speed_add = value["atk_speed_add"]

			if delet ==1 then
				EquipSys.DelEquip(uuid)
			else
				EquipSys.AddEquip(uuid , id , lv , qlv , atk_add , hp_add , atk_speed_add)
			end
        end
    end
end

function EquipSys.ClearAllData()
	EquipSys.EquipList = {}
	EquipSys.TempEquip = {}
	EquipSys.HeroEquipUUIDs = {}								--人物身上穿的装备
	EquipSys.HeroEquipList = {}	
	EquipSys.BagEquipList = {}									--背包的装备事件
	EquipSys.PurifyEquip = nil							--洗炼的装备

	EquipSys.StrengthRate = 0							--强化成功率
	EquipSys.StrengthRateOverTime = 0					--强化成功率的时间戳
	EquipSys.StrengthCD = 0								--强化CD时间戳点

	EquipSys.IsSort = true								--是否排序
end

return EquipSys