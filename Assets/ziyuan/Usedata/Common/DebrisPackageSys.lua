--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
DebrisPackageSys = {}
DebrisPackageSys.DebrisDataList = {}
DebrisPackageSys.IsSort = true

DebrisPackageSys.TempUseDebris = nil
DebrisPackageSys.TempUseCount = 0

function DebrisPackageSys.Use(_Data , _Count)			--碎片使用
	DebrisPackageSys.TempUseDebris  = _Data
	DebrisPackageSys.TempUseCount = _Count
	local info = _Data.Dbid .. "," .. _Count
	WebEvent.DebrisCompose(info , "DebrisPackageSys.UseCallBack" , DebrisPackageSys.UseCallBack)
end

function DebrisPackageSys.UseCallBack(data , returnId)
	if DebrisPackageSys.TempUseDebris.Type == 3 then
		local uiBagTar = MainGameUI.FindPanelTarget("UIBag")
		if uiBagTar ~=nil then
			uiBagTar:ClearPanel()
			uiBagTar:ShowDebrisPanel()
		end
	end
	DebrisPackageSys.ShowRewardTips(DebrisPackageSys.TempUseDebris , DebrisPackageSys.TempUseCount)
	DebrisPackageSys.TempUseDebris =nil
	DebrisPackageSys.TempUseCount = 0
end


function DebrisPackageSys.ShowRewardTips(_Data ,_Count)
	local list = {}
	local data = nil
	if _Data.Type == 1 then 
		data = RoleDataConfig.GetRoleById(_Data.TargetId)
	end
	if _Data.Type == 2 then
		data = EquipDataConfig.GetEquipDBConfig(_Data.TargetId)
	end
	if _Data.Type == 3 then
		data = DebrisConfig.GetDebrisById(_Data.TargetId)
	end
	if _Data.Type == 4 then 
		data = RoleDataConfig.GetRoleById(HeroPackageSys.TempID)
	end
	if _Data.Type == 5 then 
		data = RoleDataConfig.GetRoleById(HeroPackageSys.TempID)--等服务器
	end
	list[1] = data
	list[1].Count = _Count
	DataUIInstance.OpenRewards(list)
end

function DebrisPackageSys.ComminfoCallBack(data)
	if data~=nil then
		for key,value in pairs(data) do
			local index = tonumber(key)
			if index ~= nil then
				local id = index
				local qtt = tonumber(value)
				if qtt~=0 then
					DebrisPackageSys.SetDebrisData(id ,qtt)
				else
					DebrisPackageSys.DelDebrisData(id)
				end
			end
		end
		DebrisPackageSys.IsSort = true
	end
end

function DebrisPackageSys.SetDebrisData(_Id , _Qtt)
	local debrisData = DebrisPackageSys.CreateDebris(_Id , _Qtt)
	if #DebrisPackageSys.DebrisDataList == 0 then
		table.insert(DebrisPackageSys.DebrisDataList ,#DebrisPackageSys.DebrisDataList+1 ,debrisData)
	else
		local index = DebrisPackageSys.GetListIndexById(_Id)
		if index == nil then
			table.insert(DebrisPackageSys.DebrisDataList ,#DebrisPackageSys.DebrisDataList+1 ,debrisData)
		else
			DebrisPackageSys.DebrisDataList[index] = debrisData
		end
	end
	
end

function DebrisPackageSys.DelDebrisData(_Id)
	local index = DebrisPackageSys.GetListIndexById(_Id)
	if index ~=nil then
		table.remove(DebrisPackageSys.DebrisDataList , index)
	end
end

function DebrisPackageSys.GetListIndexById(_Id)
	for key,value in pairs(DebrisPackageSys.DebrisDataList) do
		if value.Dbid == _Id then
			return key
		end
	end
	return nil
end

function DebrisPackageSys.GetCountById(_Id)
	for key,value in pairs(DebrisPackageSys.DebrisDataList) do
		if value.Dbid == _Id then
			return value.Count
		end
	end
	return 0
end


function DebrisPackageSys.CreateDebris(_Id , _Qtt)
	local lua = GameMain.requireLuaFile("Debris")
   local rolebaby = lua:new()
   local _RoleDBdata = DebrisConfig.GetDebrisById(_Id)
   rolebaby:InitSome(_RoleDBdata , _Qtt)
   return rolebaby
end


function DebrisPackageSys.GetDataById(_Id)
	for key,value in pairs(DebrisPackageSys.DebrisDataList) do
		if value.Dbid == _Id then
			return value
		end
	end
	return nil
end

function DebrisPackageSys.GetAllData()			--得到拥有的所有碎片
	if DebrisPackageSys.IsSort == true then
		table.sort(DebrisPackageSys.DebrisDataList , DebrisPackageSys.Comp)
		DebrisPackageSys.IsSort = false
	end
	return DebrisPackageSys.DebrisDataList
end

function DebrisPackageSys.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.Quality == B.Quality then
		if A.Dbid == B.Dbid then
			return true
		end
		if A.Dbid > B.Dbid then
			return true
		end
		if A.Dbid < B.Dbid then
			return false
		end
	end
	if A.Quality>B.Quality then
		return true
	end
	if A.Quality<B.Quality then
		return false
	end
end

return DebrisPackageSys
--endregion
