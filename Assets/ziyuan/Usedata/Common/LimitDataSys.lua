--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
LimitDataSys = {}

LimitDataSys.OwnHeroLimit = 0	--拥有武将上限
LimitDataSys.TrainLimit = 4		--训练上限
LimitDataSys.PveLimit = 2		--pve出战武将上限
LimitDataSys.PvPLimit = 3		--Pvp出战武将上限
LimitDataSys.SoliderUpLimit = 1	--士兵进阶等级上限
LimitDataSys.LuckyValueLimit = 0	--人品值上限
LimitDataSys.VipLevelLimit = 13		--vip等级上限
LimitDataSys.LimitNum = 90			--数量上限

--得到拥有武将的个数上限
function LimitDataSys.GetOwnHeroCount()
	local vipData =	VipDataSys.GetVipDataByLvl(VipSys.VipLevel)
	if vipData ~=nil then
		return vipData.HeroLimit
	end
end

--得到训练的最大上限
function LimitDataSys.GetTrainLimitCount()
	local vip = VipDataSys.GetVipDataByLvl(VipSys.VipLevel)
	local limitNum = vip.TrainLimit
	local tech = TechnologySys.GetCurFinishedValue(4)
	if tech~=nil then
		if limitNum >= tech.LimitNum then
			return limitNum
		else
			return tech.LimitNum	
		end
	else
		return limitNum
	end
end

--得到pvp武将出站的最大上限
function LimitDataSys.GetPvPLimitCount()
	local tech = TechnologySys.GetCurFinishedValue(2)
	if tech~=nil then
		return tech.LimitNum
	else
		return LimitDataSys.PvPLimit
	end
end

--得到pve武将出战的最大上限
function LimitDataSys.GetPveLimitCount()
	local tech = TechnologySys.GetCurFinishedValue(1)
	if tech~=nil then
		return tech.LimitNum
	else
		return LimitDataSys.PveLimit
	end
end

--得到士兵升阶的最大上限制
function LimitDataSys.GetLimitSoliderUpLvl()
	local tech = TechnologySys.GetCurFinishedValue(5)
	if tech~=nil then
		return tech.LimitNum
	else
		return LimitDataSys.SoliderUpLimit
	end
end

--得到幸运值上限
function LimitDataSys.GetLuckyMax()
	local vipData =	VipDataSys.GetVipDataByLvl(VipSys.VipLevel)
	if vipData ~=nil then
		return vipData.LuckLimit
	end
end

return LimitDataSys
--endregion
