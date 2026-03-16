--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

TechnologyDataSys = {}
TechnologyDataSys.Soliders = {}
TechnologyDataSys.Heros = {}

function TechnologyDataSys.Init()
	TechnologyDataSys.Heros = {}
	TechnologyDataSys.Soliders = {}
	local list = TechnologyDataConfig.GetAllData()
	for key,value in pairs(list) do
		local data = TechnologyDataSys.CreateTechnology(key)
		if value.Type == 1 then--1是武将 ，2是小兵
			table.insert(TechnologyDataSys.Heros , #TechnologyDataSys.Heros+1 ,data)
		else
			table.insert(TechnologyDataSys.Soliders , #TechnologyDataSys.Soliders+1 ,data)
		end
	end
	table.sort(TechnologyDataSys.Heros , TechnologyDataSys.Comp)
	table.sort(TechnologyDataSys.Soliders , TechnologyDataSys.Comp)
	TechnologyDataSys.SetInitState()
end

function TechnologyDataSys.SetInitState()
	
	for i=1,5,1 do
		TechnologyDataSys.SetTypeInitState(i)
	end
end

function TechnologyDataSys.SetTypeInitState(_Type)
	if _Type == 5 then
		local soldierState = TechnologySys.GetDataState(_Type)
		if soldierState == true then
			return
		end
		if soldierState == false then
			local lists = {}
			for key,value in pairs(TechnologyDataSys.Soliders) do
				if value.Class == _Type then
					table.insert(lists ,#lists+1 , value)
				end
			end
			table.sort(lists, TechnologyDataSys.Comp)
			lists[1]:SetState()
		end
	else
		local state = TechnologySys.GetDataState(_Type)
		if state == true then
			return 
		end
		if state == false then
			local list = {}
			for key,value in pairs(TechnologyDataSys.Heros) do
				if value.Class == _Type then
					table.insert(list ,#list+1 , value)
				end
			end
			table.sort(list, TechnologyDataSys.Comp)
			list[1]:SetState()
		end
	end
	
end

function TechnologyDataSys.SetNextDataState(_Id , _Type)
	if _Type == 5 then
		for key,value in pairs(TechnologyDataSys.Soliders) do
			if value.Dbid == _Id then
				value:SetState()
			end
		end
	else
		for key,value in pairs(TechnologyDataSys.Heros) do
			if value.Dbid == _Id then
				value:SetState()
			end
		end	
	end
	
end

function TechnologyDataSys.CreateTechnology(_DBid)
   local lua = GameMain.requireLuaFile("Technology")
   local Technology = lua:new()
   local _TechnologyData = TechnologyDataConfig.GetDBConfig(_DBid)
	local list = TechnologySys.HandleDataList
	for key,value in pairs(list) do
		local id = tonumber(value["id"])
		if id == _DBid then
			local progress = tonumber(value["progress"])
			local endTime = tonumber(value["endTime"])
			Technology:Init(_TechnologyData , progress , endTime)
			return Technology
		end	
	end
   Technology:Init(_TechnologyData , 0 , 0)
   return Technology
end

function TechnologyDataSys.GetDataById(_Id)
	if #TechnologyDataSys.Heros ==0  and #TechnologyDataSys.Soliders==0 then
		return nil
	end
	for key,value in pairs(TechnologyDataSys.Heros) do
		if _Id == value.Dbid then
			return value
		end
	end
	for key1,value1 in pairs(TechnologyDataSys.Soliders) do
		if _Id == value1.Dbid then
			return value1
		end
	end
	return nil
end



function TechnologyDataSys.GetSoldiers()					--根据等级显示需要的士兵科技list
	local lv = ClinetInfomation.Lvl
	local list = {}
	for i=1,#TechnologyDataSys.Soliders,1  do
		if TechnologyDataSys.Soliders[i].Show_Lvl <= lv then
			table.insert(list, #list+1 , TechnologyDataSys.Soliders[i])
		end
	end
	return list
end

function TechnologyDataSys.GetHeros()						--根据等级显示需要的武将科技list
	local lv = ClinetInfomation.Lvl
	local list = {}
	for i=1,#TechnologyDataSys.Heros,1  do
		if TechnologyDataSys.Heros[i].Show_Lvl <= lv then
			table.insert(list, #list+1 , TechnologyDataSys.Heros[i])
		end
	end
	return list
end

function TechnologyDataSys.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	
	if A.Dbid > B.Dbid then
		return false
	end
	if A.Dbid == B.Dbid then
		return false
	end
	if A.Dbid < B.Dbid then
		return true
	end
	
end


return TechnologyDataSys

--endregion
