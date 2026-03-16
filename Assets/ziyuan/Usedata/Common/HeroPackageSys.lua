HeroPackageSys = {}
HeroPackageSys.Heros = {}

HeroPackageSys.QuilityHeros = {}

HeroPackageSys.IsSort = true											--是否排序
HeroPackageSys.TrainTempUUID = ""										--武将训练的临时UUID
HeroPackageSys.TempAddExpUUID = ""											--武将突飞猛进的临时uuid

function HeroPackageSys.GetHero()
	if HeroPackageSys.IsSort == true then
		HeroPackageSys.IsSort = false
		table.sort(HeroPackageSys.Heros , HeroPackageSys.Comp)
	end

    return HeroPackageSys.Heros
end

function HeroPackageSys.GetCurTrainCount()			--得到当前训练的武将个数
	local count = 0
	for key,value in pairs(HeroPackageSys.Heros) do
		local isTrain = value:IsTrain()
		if isTrain == true then
			count = count + 1
		end
	end
	return count
end

function HeroPackageSys.GetOwnHeroCount()
	return #HeroPackageSys.Heros
end

function HeroPackageSys.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.UUID == ClinetInfomation.GuaShuaiUUID then
		return true
	end
	if B.UUID == ClinetInfomation.GuaShuaiUUID then
		return false
	end
	if A.IsUp == true and B.IsUp == false then
			return true
	end
	if A.IsUp == false and B.IsUp == true then
			return false
	end
			if A.IsUp ==  B.IsUp then
				if A.quality>B.quality then
					return true
				end
				if A.quality<B.quality then
					return false
				end
				if A.quality == B.quality then
					if A.lvl > B.lvl then
						return true
					end
					if A.lvl < B.lvl then
						return false
					end
					if A.lvl == B.lvl then
						if A.Exp > B.Exp then
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
			end
end

function HeroPackageSys.GetGradeEqualHero(_HeroData)					--得到不同类型品阶的武将列表
	local heroList = {}
	for key,value in pairs(HeroPackageSys.GetHero()) do
		local isCanAdd = TeamSys.GetUpTeams(value.UUID)
		if isCanAdd == true then
			if _HeroData.quality == value.quality and value.UUID ~=_HeroData.UUID then
				table.insert(heroList, #heroList + 1 , value)
			end
		end
	end
	return heroList
end

function HeroPackageSys.CreateHero(_DBid , _UUID , _Qvl , _Equips , _Exp , _BeginTime , _EndTime , _Type)
    local _Hero = RoleDataSys.CreateHero(_DBid , _UUID ,_Qvl , _Equips,_Exp , _BeginTime , _EndTime , _Type)
	if #HeroPackageSys.Heros == 0 then
		
		table.insert(HeroPackageSys.Heros , #HeroPackageSys.Heros + 1 , _Hero)
	else
		local index = HeroPackageSys.GetOneHeroIndex(_UUID)
		if HeroPackageSys.Heros[index] ~=nil then
			HeroPackageSys.Heros[index] = _Hero
			if HeroPackageSys.Heros[index].UUID == ClinetInfomation.GuaShuaiUUID then
				HeroPackageSys.Heros[index].IsGuaShuai = true
			end	
		else
			table.insert(HeroPackageSys.Heros , #HeroPackageSys.Heros + 1 , _Hero)
		end
	end
	
end

function HeroPackageSys.AddHero(_Id , _lvl , _QuiltyLv)
	local _Hero = RoleDataSys.TempHero(_Id ,_lvl ,_QuiltyLv)
	table.insert(HeroPackageSys.Heros , #HeroPackageSys.Heros + 1 , _Hero)
	HeroPackageSys.IsSort = true
end

function HeroPackageSys.SetGuaiShuaiHero()	--设置挂帅的武将显示
	local GuaiShuaiUUID = ClinetInfomation.GetGuaShuaiUUID()
	if GuaiShuaiUUID == "" then
		--HeroPackageSys.SavePvPHeros(HeroPackageSys.Heros[1].UUID)
		--HeroPackageSys.Heros[1].IsGuaShuai = true
	else
		local uicontrolTar = MainGameUI.FindPanelTarget("UIControl")
		if uicontrolTar~=nil then
			uicontrolTar:ShowHeroInfo()
		end
		for key,value in pairs(HeroPackageSys.Heros) do
			if value.UUID == GuaiShuaiUUID then
				value:SetGuaShuaiHero(GuaiShuaiUUID)
			end
		end
	end
end


function HeroPackageSys.GetOneHeroBy_UUID(_UUID)    
    for i = 1 , #HeroPackageSys.Heros , 1 do       
        if HeroPackageSys.Heros[i].UUID == _UUID then
           return HeroPackageSys.Heros[i]       
        end
    end
    return nil
end

function HeroPackageSys.GetOneHeroIndex(_UUID) --传一个uuid确定该英雄所在列表的位置
	for key, value in pairs(HeroPackageSys.GetHero()) do
		if value.UUID == _UUID then
			return key
		end
	end
	
    return nil
end

HeroPackageSys.TempUUID = ""
function HeroPackageSys.HeroUpGrade(_HeroData , _HeroList , _UUID)			--武将转生
	
	HeroPackageSys.TempUUID = _HeroData.UUID
	HeroPackageSys.TempDbid = _HeroData.AdvanceId
	
	local strs = ""
	for key,value in pairs(_HeroList) do
		if strs == "" then
			strs = tostring(value.UUID)
		else
			strs = strs .. "_".. tostring(value.UUID)
		end
	end
	local data = ""
	if _UUID == 1 then
		data = _HeroData.UUID .. "," .. strs
	else
		data = _HeroData.UUID .. "," .. strs	..",".. _UUID
	end
	WebEvent.HeroUpQuilty(data , "HeroPackageSys.HeroUpGradeCallBack" ,HeroPackageSys.HeroUpGradeCallBack)
	HeroPackageSys.IsSort = true
end

function HeroPackageSys.HeroUpGradeCallBack(data , _returnId)
		MusicManagerSys.HeroTransfer()
		local uiHireHeroTar = MainGameUI.FindPanelTarget("UIHero")
		if uiHireHeroTar ~=nil then
			uiHireHeroTar:ShowUpGradeAfterInfo()
		end
		local uicontrolTar = MainGameUI.FindPanelTarget("UIControl")
		if uicontrolTar~=nil then
			uicontrolTar:ShowHeroInfo()
		end
		local newHeroUUID = HeroPackageSys.GetOneHeroByDbid(HeroPackageSys.TempDbid)
		TeamSys.ReSetHeroUUID(HeroPackageSys.TempUUID , newHeroUUID)
	
end
HeroPackageSys.TempDbid = 0

function HeroPackageSys.GetOneHeroByDbid(_Dbid)
	for key,value in pairs(HeroPackageSys.Heros) do
		if _Dbid == value.Dbid then
			return value.UUID
		end
	end
end


function HeroPackageSys.UpQuality(_Role)    --升阶
	HeroPackageSys.IsSort = true
	WebEvent.SavePveHeros(info , "HeroPackageSys.UpQualityCallBack" , HeroPackageSys.UpQualityCallBack)
end

function HeroPackageSys.UpQualityCallBack(data , _returnId)    --升阶
   local uicontrolTar = MainGameUI.FindPanelTarget("UIControl")
	if uicontrolTar~=nil then
		uicontrolTar:ShowHeroInfo()
	end
end

function HeroPackageSys.UpLvl(_Role)        --升级
	HeroPackageSys.IsSort = true
   WebEvent.SavePveHeros(info , "HeroPackageSys.UpLvlCallBack" , HeroPackageSys.UpLvlCallBack)
end

function HeroPackageSys.UpLvlCallBack(data , _returnId)    --升级
   
end

function HeroPackageSys.SavePvPHeros(_UUID) --挂帅
	HeroPackageSys.IsSort = true
	
	WebEvent.SavePvPHeros(_UUID , "HeroPackageSys.ShowPvPHerosCallBack" , HeroPackageSys.ShowPvPHerosCallBack)
	
end

function HeroPackageSys.ShowPvPHerosCallBack(data , returnId)    --挂帅
	if returnId ~= 0 then
		return 
	end
	local uicontrolTar = MainGameUI.FindPanelTarget("UIControl")
	if uicontrolTar~=nil then
		uicontrolTar:ShowHeroInfo()
        PlayerControl.ReleaseMyCharacter()
        PlayerControl.CreateMy()
	end
end

function HeroPackageSys.FirePVPHero(_UUID , _newUUID)      --解雇
	local info = _UUID .. "," .. _newUUID
	WebEvent.FirePVPHero(info , "HeroPackageSys.FirePVPHeroCallBack" , HeroPackageSys.FirePVPHeroCallBack)

	local index = HeroPackageSys.GetOneHeroIndex(_UUID)
	table.remove(HeroPackageSys.Heros,index)
	HeroPackageSys.IsSort = true
end

function HeroPackageSys.FirePVPHeroCallBack(data , returnId)      --解雇
	local uiHeroTar = MainGameUI.FindPanelTarget("UIHero")
	if uiHeroTar~=nil then
		uiHeroTar:ShowHeroInfoPanel()
	end
end


function HeroPackageSys.HeroTrain(_UUID , _Type)						--武将训练
	HeroPackageSys.TrainTempUUID = _UUID
	local info = _UUID .. "," .. _Type
	WebEvent.HeroTrain(info , "HeroPackageSys.HeroTrainCallBack" , HeroPackageSys.HeroTrainCallBack)
end

function HeroPackageSys.HeroTrainCallBack(data ,returnId)
	local uiheroTar = MainGameUI.FindPanelTarget("UIHero")
	if uiheroTar ~=nil then
		local data = HeroPackageSys.GetOneHeroBy_UUID(HeroPackageSys.TrainTempUUID)
		if data~=nil then
			uiheroTar:SendWebTrainAfterInfo(data)
		end
	end
end

function HeroPackageSys.HeroStopTrain(_UUID )					--武将训练停止
	local info = _UUID
	WebEvent.HeroStopTrain(info , "HeroPackageSys.HeroStopTrainCallBack" ,HeroPackageSys.HeroStopTrainCallBack)
end

function HeroPackageSys.HeroStopTrainCallBack(data , returnId)

end


function HeroPackageSys.AddExpWithItem(_UUID , _Type)			--武将训练加经验 ——type==1 突飞，2猛进
	HeroPackageSys.TempAddExpUUID = _UUID
	local info = _UUID .. "," .. _Type
	WebEvent.HeroAddExpWithItem(info , "HeroPackageSys.AddExpWithItemCallBack" , HeroPackageSys.AddExpWithItemCallBack)
end

function HeroPackageSys.AddExpWithItemCallBack(data , returnId)
	local uiHeroTar = MainGameUI.FindPanelTarget("UIHero")
	if uiHeroTar~=nil then
		local data = HeroPackageSys.GetOneHeroBy_UUID(HeroPackageSys.TempAddExpUUID)
		if data~=nil then
			uiHeroTar:ShowAddExpByItemCallBack(data)
		end
	end
end

function HeroPackageSys.ClearAddExpCD()				--清除武将加经验CD
	local info = nil
	WebEvent.ClearAddExpCD(info , "HeroPackageSys.ClearAddExpCDCallBack" , HeroPackageSys.ClearAddExpCDCallBack)
end

function HeroPackageSys.ClearAddExpCDCallBack(data , returnId)
	local uiHeroTar = MainGameUI.FindPanelTarget("UIHero")
	if uiHeroTar~=nil then
		uiHeroTar:ShowClearColdBack()
	end
end

function HeroPackageSys.ReSort(index)
	for key,value in pairs(HeroPackageSys.Heros) do
		if key > index then
			local num = key-1
			HeroPackageSys.Heros[num] = value
		end
	end
	
end

function HeroPackageSys.RemoveHero(_UUID)			--删除武将
	local index = HeroPackageSys.GetOneHeroIndex(_UUID)
	if index~=nil then
		table.remove(HeroPackageSys.Heros , index)
	end
end

HeroPackageSys.TempID = 0
function HeroPackageSys.ComminfoCallBack(_data)
	if _data~=nil then

		for key , value in pairs(_data) do
			local index = tostring(key)
			local index1 = tonumber(value["id"])
				if index ~=nil and index1 ~= nil then
					local _DBid = tonumber(value["id"])
                    HeroPackageSys.TempID = _DBid
					local _UUID = index
--					local _Lvl = tonumber(value["lv"])
					local _Qvl = tonumber(value["qlv"])
					local _Equips = value["equips"]
					local isDelet = tonumber(value["isDelete"])
					local _Exp = tonumber(value["exp"])
					local _BeginTime = tonumber(value["begin_time"])
					local _EndTime = tonumber(value["end_time"])
					local _Type = tonumber(value["type"])
					if isDelet~=nil and isDelet == 1 then
						HeroPackageSys.RemoveHero(_UUID)
					else
						HeroPackageSys.CreateHero(_DBid , _UUID  , _Qvl , _Equips,_Exp , _BeginTime , _EndTime , _Type)
					end
					
				end
		end
		HeroPackageSys.IsSort = true
	end

end

function HeroPackageSys.ClearData()
	HeroPackageSys.Heros = {}

	HeroPackageSys.QuilityHeros = {}

	HeroPackageSys.IsSort = true											--是否排序
	HeroPackageSys.TrainTempUUID = ""										--武将训练的临时UUID
	HeroPackageSys.TempAddExpUUID = ""		
end

return HeroPackageSys