SoliderPackageSys = {}
SoliderPackageSys.Soliders = {}
SoliderPackageSys.DunSoliders={}
SoliderPackageSys.QiangSoliders={}
SoliderPackageSys.GongSoliders={}

SoliderPackageSys.UpGradeTempId = 0		--进阶士兵的临时ID（用于区分是进阶的，还是获得的）
SoliderPackageSys.TrainTempId = 0		--当前训练的士兵ID
SoliderPackageSys.AddExpId = 0			--当前突飞，猛进的武将
--是否排序
SoliderPackageSys.IsSort = true;

--SoliderPackageSys.TrainList = {}		--训练的士兵

function SoliderPackageSys.GetSoliders()
	if SoliderPackageSys.IsSort == true then
		table.sort(SoliderPackageSys.Soliders,SoliderPackageSys.Comp)
		SoliderPackageSys.IsSort = false
	end
	
	return SoliderPackageSys.Soliders	
end

function SoliderPackageSys.GetNormalSoliders()
	table.sort(SoliderPackageSys.Soliders,SoliderPackageSys.CompID)
	return SoliderPackageSys.Soliders
end

function SoliderPackageSys.CompID(A , B)
	if A==nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.Dbid>B.Dbid then
		return false
	end
	if A.Dbid == B.Dbid then
		return true
	end
	if A.Dbid<B.Dbid then
		return true
	end
end


function SoliderPackageSys.Comp(A ,B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	
	if A.quality > B.quality then
		return true
	end
	if A.quality < B.quality then
		return false
	end	
	if A.quality == B.quality then
		
		if A.Exp >B.Exp then
			return true
		end
		if A.Exp < B.Exp then
			return false
		end
		if A.Exp == B.Exp then
			if A.Dbid > B.Dbid then
				return true
			end
			if A.Dbid<B.Dbid then
				return false
			end
			if A.Dbid == B.Dbid then
				return false
			end
		end
	end
end



function SoliderPackageSys.CreateSolider(_DBid , _QualityLvl , _IsActive , _Exp , _BeginTime , _EndTime , _Type)
   local _Solider = RoleDataSys.CreateSolider(_DBid , _QualityLvl , _IsActive , _Exp , _BeginTime , _EndTime , _Type)
--   if _BeginTime~=nil then
--		table.insert(SoliderPackageSys.TrainList , #SoliderPackageSys.TrainList +1 , _Solider)
--   end
   local _soliderIndex = SoliderPackageSys.GetListItemIndexById(SoliderPackageSys.Soliders , _DBid)
   if _soliderIndex == nil then
		table.insert(SoliderPackageSys.Soliders , #SoliderPackageSys.Soliders + 1 , _Solider)
   else
		SoliderPackageSys.Soliders[_soliderIndex] = _Solider
   end
end

function SoliderPackageSys.GetOneSolider(_DBid)
   for i = 1 , #SoliderPackageSys.Soliders , 1 do       
       if SoliderPackageSys.Soliders[i].Dbid == _DBid then         
          return SoliderPackageSys.Soliders[i]
       end
   end
   return nil
end

function SoliderPackageSys.UpQuality(_Id , _Type)      --进阶
	
	SoliderPackageSys.IsSort =true

	SoliderPackageSys.UpGradeTempId = _Id
	local info = _Id
    WebEvent.SoliderQuiltyUp(info , "SoliderPackageSys.UpQualityCallBack" , SoliderPackageSys.UpQualityCallBack)
end

function SoliderPackageSys.UpQualityCallBack(data , _returnId)
	MusicManagerSys.SoliderUpGrade()
	local roleData = SoliderPackageSys.GetListItemById( SoliderPackageSys.Soliders, SoliderPackageSys.UpGradeTempId)
		
	if tonumber(data.idChanged) == 1  then
		
		local index = SoliderPackageSys.GetListItemIndexById(SoliderPackageSys.Soliders , SoliderPackageSys.UpGradeTempId)
		table.remove(SoliderPackageSys.Soliders , index)
		TeamSys.ReSetSoldierID(SoliderPackageSys.UpGradeTempId , SoliderPackageSys.Soliders[#SoliderPackageSys.Soliders].Dbid)
	end

	SoliderPackageSys.UpGradeTempId = 0

	local uisolierTar = MainGameUI.FindPanelTarget("UISoldier")
	if uisolierTar ~=nil then
		if tonumber(data.idChanged) == 1 then
			uisolierTar:ShowHeroUpGradeWebAfterInfo(SoliderPackageSys.Soliders[#SoliderPackageSys.Soliders])
		else
			uisolierTar:ShowHeroUpGradeWebAfterInfo(roleData)
		end
		
	end
end

function SoliderPackageSys.GetListItemById( _list, _Id)

	for key,value in pairs(_list) do
		if value.Dbid == _Id then
			return _list[key]
		end
	end
	
end

function SoliderPackageSys.GetListItemIndexById(_list, _Id)
	for key,value in pairs(_list) do
		if value.Dbid == _Id then
			return key
		end
	end
	return nil
end

function SoliderPackageSys.NextGradeData(_Role)		--得到下一个要升阶的数据
	local curData = SoliderQualityUpConfig.GetDBByQuilityAndLv(_Role.quality , _Role.qualityLvl)
	local nextData = SoliderQualityUpConfig.GetNextQualityInfo(curData.Id)
	if nextData~=nil then
		return nextData
	else
		return nil
	end
end

function SoliderPackageSys.UpLvl(_Role)          --升级
    WebEvent.SavePveHeros(info , "SoliderPackageSys.UpLvlCallBack" , SoliderPackageSys.UpLvlCallBack)
end

function SoliderPackageSys.UpLvlCallBack(data , _returnId)          --升级
	
end


function SoliderPackageSys.Train(_Id , _Type)			--士兵训练
	SoliderPackageSys.TrainTempId = _Id
	local info = tostring(_Id) .. "," .. tostring(_Type)
	WebEvent.SoliderTraning(info , "SoliderPackageSys.TrainCallBack" , SoliderPackageSys.TrainCallBack)
end

function SoliderPackageSys.TrainCallBack(data , returnId)
	MusicManagerSys.Train()
	local uisolierTar = MainGameUI.FindPanelTarget("UISoldier")
	if uisolierTar ~=nil then
		local data = SoliderPackageSys.GetListItemById(SoliderPackageSys.Soliders , SoliderPackageSys.TrainTempId)
		uisolierTar:SendWebTrainAfterInfo(data)
	end
end


function SoliderPackageSys.StopTrain(_Id)		--取消士兵训练
	local info = _Id
	WebEvent.StopSoliderTraning(info , "SoliderPackageSys.StopTrainCallBack" , SoliderPackageSys.StopTrainCallBack)
end

function SoliderPackageSys.StopTrainCallBack(data , returnId)
	
end

function SoliderPackageSys.AddExpWithItem(_Id , _Type)			--士兵训练加经验_type=1 突飞，=2猛进
	SoliderPackageSys.IsSort = true
	SoliderPackageSys.AddExpId = _Id
	local info = _Id .. "," .. _Type
	WebEvent.SoliderAddExpWithItem(info , "SoliderPackageSys.AddExpWithItemCallBack",SoliderPackageSys.AddExpWithItemCallBack)
end

function SoliderPackageSys.AddExpWithItemCallBack(data , returnId)
	local uisolierTar = MainGameUI.FindPanelTarget("UISoldier")
	if uisolierTar ~=nil then
		local data = SoliderPackageSys.GetOneSolider(SoliderPackageSys.AddExpId)
		uisolierTar:ShowAddExpByItemCallBack(data)
	end
end

function SoliderPackageSys.ClearAddExpCD()
	local info = nil
	WebEvent.ClearAddExpCD(info , "SoliderPackageSys.ClearAddExpCDCallBack" , SoliderPackageSys.ClearAddExpCDCallBack)
end

function SoliderPackageSys.ClearAddExpCDCallBack(data , returnId)
	local uisolierTar = MainGameUI.FindPanelTarget("UISoldier")
	if uisolierTar ~=nil then
		uisolierTar:ClearAddExpCDCallBack()
	end
end

function SoliderPackageSys.ComminfoCallBack(_data)    

     for key , value in pairs(_data) do
        local ID = tonumber(key)
        if ID~=nil then
           local data = value
           local _DBid = ID
           local _QualityLvl = tonumber(data["qlv"])
--           local _Lvl = tonumber(data["lv"])
           local _isActive = tonumber(data["isActive"])
		   local _Exp = tonumber(data["exp"])
		   local _Type = tonumber(data["type"])
		   local _BeginTime = tonumber(data["begin_time"])
		   local _EndTime = tonumber(data["end_time"])
           SoliderPackageSys.CreateSolider(_DBid , _QualityLvl , _isActive , _Exp , _BeginTime , _EndTime , _Type)
        end
    end
--	GameMain.AddUpdateLua(SoliderPackageSys.UpdataTime)
end

function SoliderPackageSys.UpdataTime()
	if #SoliderPackageSys.TrainList<=0 then
		GameMain.DelUpdateLua(SoliderPackageSys.UpdataTime)
		return
	end
	
	local curTime = ClinetInfomation.WorldTime
	for i=1,#SoliderPackageSys.TrainList,1 do
		local data = SoliderPackageSys.TrainList[i]
		if curTime>=data.EndTime then
			--训练结束
			--加经验
			data:AddExp()
			table.remove(SoliderPackageSys.TrainList , i)
		else
			local curExp = data:CalCulateExpByTime(curTime)
			if curExp>data.Exp then
				--加经验了
				data:AddExp()
			end
		end
	end
end

function SoliderPackageSys.ClearData()
   SoliderPackageSys.Soliders = {}
	SoliderPackageSys.DunSoliders={}
	SoliderPackageSys.QiangSoliders={}
	SoliderPackageSys.GongSoliders={}

	SoliderPackageSys.UpGradeTempId = 0		--进阶士兵的临时ID（用于区分是进阶的，还是获得的）
	SoliderPackageSys.TrainTempId = 0		--当前训练的士兵ID
	SoliderPackageSys.AddExpId = 0			--当前突飞，猛进的武将
	--是否排序
	SoliderPackageSys.IsSort = true;
end

return SoliderPackageSys