--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
TechnologySys = {}
--TechnologySys.Class = 0 ----1 PVE武将出战人数 2 pvp武将出站人数 3 国战移动速度 4 武将训练位置 5 士兵进阶
TechnologySys.HandleDataList = {}		--科技操作的数据
TechnologySys.TempStudyId = nil		--临时的研究数据

TechnologySys.LimitData = 
{
	["OwnHero"] = 0,	--拥有的武将上限
	["PveHero"] = 0,	--pve出站的武将上限
	["PvpHero"] = 0,	--Pvp出战的武将上限
	["HeroTrain"] = 0,	--训练的上限个数
	["SoliderUp"] = 0,	--士兵升阶的等级上限
}
		

function TechnologySys.StudyTech(_Id)
	local info = _Id
	TempStudyId = _Id
	WebEvent.TechStudy(info , "TechnologySys.StudyTechCallBack" , TechnologySys.StudyTechCallBack)
end

function TechnologySys.StudyTechCallBack(data , _returnId)
	MusicManagerSys.TechnologyInjection()
	local uiTechTar = MainGameUI.FindPanelTarget("UITechnology")
	if uiTechTar ~=nil then
		local data = TechnologyDataSys.GetDataById(TempStudyId)
		uiTechTar:ShowStudyTechAfterInfo(data)
	end
	TechnologySys.TempStudyId = nil
end


function TechnologySys.TechSpeed(_ID)					--科技加速
	local info = _ID
	WebEvent.SpeedTech(info , "TechnologySys.TechSpeedCallBack" , TechnologySys.TechSpeedCallBack)
end

function TechnologySys.TechSpeedCallBack(data , returnId)

end

function TechnologySys.PourMoneyToTech(_Data)

--	TechnologySys.TempStudyData = _Data
	local info = _Data.Dbid
	WebEvent.PourMoneyToTech(info , "TechnologySys.PourMoneyToTechCallBack",TechnologySys.PourMoneyToTechCallBack)
end

function TechnologySys.PourMoneyToTechCallBack(data , _returnId)
	MusicManagerSys.TechnologyInjection()
--	local tech = TechnologyDataSys.GetDataById(TechnologySys.TempStudyData.Dbid)
--	local uiTechTar = MainGameUI.FindPanelTarget("UITechnology")
--	if uiTechTar ~=nil then
--		uiTechTar:SetPourMoneyData(tech)
--	end
--	TechnologySys.TempStudyData = nil
end

function TechnologySys.IsCompelte(_Data)			--0是武将 1是小兵  ; return 0之前已经结束的， 1现在正在操作的，2 之后的

end

function TechnologySys.ReFrashItem(_Class , _Id , _Progress , _EndTime)
	local data = TechnologyDataSys.GetDataById(_Id)
	if data == nil then
		return
	end
	data:SetInfo(_Progress , _EndTime)
end

function TechnologySys.GetDataState(_Type)				--根据类型得到是否对该类型进行操作
	for key,value in pairs(TechnologySys.HandleDataList) do
		if key == _Type then
			
			return true
		end
	end
	return false
end

function TechnologySys.GetHandleId(_Type)			--根据类型得到操作数据的ID
	for key,value in pairs(TechnologySys.HandleDataList) do
		if key == _Type then
			local id = tonumber(value["id"])
			return id
		end
	end
	return 0
end



function TechnologySys.GetCurFinishedValue(_Type)	--得到当前已经结束的数据

	local handleId = TechnologySys.GetHandleId(_Type)
	if handleId == 0 then
		return nil
	end
	local handleTech = TechnologyDataSys.CreateTechnology(handleId)
	if handleTech == nil then
		return nil
	end
	local isComplete = handleTech:IsComplete()
	if isComplete == true then
		return handleTech
	end
	if isComplete == false then
		if handleTech.PreId ~=0 then
			return TechnologyDataSys.CreateTechnology(handleTech.PreId)
		else
			return nil
		end
	end
end

function TechnologySys.ComminfoCallBack(data)
	TechnologySys.HandleDataList ={}

	local techList = data["tech"]
	if techList ~=nil then
		for key,value in pairs(techList) do
			
			local class = tonumber(key)
			TechnologySys.HandleDataList[class] = value
			
			local id = tonumber(value["id"])
			local progress = tonumber(value["progress"])
			local endTime = tonumber(value["endTime"])
			TechnologySys.ReFrashItem(class , id , progress , endTime)
		end
	end
	
end


return TechnologySys
--endregion
