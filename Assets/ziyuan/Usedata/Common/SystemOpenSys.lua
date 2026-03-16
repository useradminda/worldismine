--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SystemOpenSys = {}

SystemOpenSys.OpenSysName = {}

function SystemOpenSys.IsOpen(SystemId)
	local systemData = SystemOpenConfig.GetDataById(SystemId)
	if systemData.OpenType == 1 then
		--关卡 
        local _TempChapterData =  MapDataSys.GetChapterByTurn(MapSys.NowChapter)
        if _TempChapterData==nil then
           return false
        end
        local _MapData = MapConfig.GetMapByChapterIDMapTurn(_TempChapterData.DbId , MapSys.NowMap)
        if _MapData==nil then
           return false
        end

		local curPassLevel = _MapData.DBid	--获取
		if curPassLevel > systemData.LevelMap then
			return true
		else
			if systemData.Description ~= "0" then
				DataUIInstance.PopTip(systemData.Description)
			end
			return false
		end
	end
	if systemData.OpenType == 2 then
		--等级
		if ClinetInfomation.Lvl >= systemData.NeedLvl then
			return true
		else
			if systemData.Description ~= "0" then
				DataUIInstance.PopTip(systemData.Description)
			end
			return false
		end
	end
end

return SystemOpenSys
--endregion
