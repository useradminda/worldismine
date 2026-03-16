--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
FundDataSys = {}
FundDataSys.FundDataList = {}

FundDataSys.IsPourMoney = 0 --是否投资
FundDataSys.RwdRecived = {} --已经领取的投资

FundDataSys.Principal = 0			--注入的成本
FundDataSys.ReturnRate = 0			--返回的概率
FundDataSys.AllRewards = 0			--所有返还的元宝

FundDataSys.PrincipalIndex = 0		--返回成本的index
FundDataSys.RateIndex = 0			--返回利率的index

function FundDataSys.GetPourPricipal()			--得到投资的金额
	if FundDataSys.Principal == 0 then
		FundDataSys.Principal = ConstConfig.GetFundNeed()	
	end
	return FundDataSys.Principal
end

function FundDataSys.GetRewardDiamonds()		
	if FundDataSys.AllRewards ~=0 then
		return FundDataSys.AllRewards
	end
	local list = FundDataConfig.GetAllFundData()
	local sum = 0
	for key,value in pairs(list) do
		sum = sum + value.Restore
	end
	FundDataSys.AllRewards = sum
	return sum
end

function FundDataSys.GetRewardRate()
	if FundDataSys.ReturnRate ~= 0 then
		return FundDataSys.ReturnRate
	end
	local pourRewards = FundDataSys.GetPourPricipal()*10 -- 1RMB = 10元宝
	local allRewards = FundDataSys.GetRewardDiamonds()
	FundDataSys.ReturnRate = allRewards/pourRewards
	return FundDataSys.ReturnRate
end

function FundDataSys.InitWeb()			--成长基金初始化
	WebEvent.FundInit(nil , "FundDataSys.InitWebCallBack" , FundDataSys.InitWebCallBack)
end

function FundDataSys.InitWebCallBack(data , returnId)
	local uiFund = MainGameUI.FindPanelTarget("UIFund")
	if uiFund ~=nil then
		uiFund:ShowInfo()
	end
end

function FundDataSys.FundPour()			--投资
--	RechargeSys.BuyGoods.Fund = true
--	local info = ConstConfig.GetFundAppStoreId()
	local info = nil
	WebEvent.FundPour(info, "FundDataSys.FundPourCallBack",FundDataSys.FundPourCallBack)
--	RechargeSys.GenerateOrder(info)

end

function FundDataSys.FundPourCallBack(data , returnId)
	if tonumber(returnId) ~= 0 then
		return
	end
	local num = tonumber(FundDataSys.IsPourMoney)
	local uiFundTar = MainGameUI.FindPanelTarget("UIFund")
	
	if uiFundTar ~=nil then
		local god = uiFundTar.UIFundGod
		if god ~= nil then
			uiFundTar:ShowPourAfter(num)
		end
		
	end
end

function FundDataSys.ReciveRwd(Lvl)		--领取基金奖励
	local info = Lvl
	WebEvent.ReciveRwd(info , "FundDataSys.ReciveRwdCallBack" , FundDataSys.ReciveRwdCallBack)
end

function FundDataSys.ReciveRwdCallBack(data , returnId)
	
end


function FundDataSys.Init()				--基金所有数据初始化
	local list = FundDataConfig.GetAllFundData()
	for key ,value in pairs(list) do
		local fundbaby = FundDataSys.CreateFundItem(value.Lvl)
		table.insert(FundDataSys.FundDataList , #FundDataSys.FundDataList+1 , fundbaby)
	end
	table.sort(FundDataSys.FundDataList , FundDataSys.Comp)
end

function FundDataSys.Comp(A,B)
	if A~=nil and B~=nil then
		if A.Lvl <= B.Lvl then
			return true
		else
			return false
		end
	else
		return false
	end
end

function FundDataSys.CreateFundItem(Lvl)   --创建fund数据
   local lua = GameMain.requireLuaFile("Fund")
   local fundbaby = lua:new()
   local fundData = FundDataConfig.GetFundByLvl (Lvl)
   fundbaby:Init(fundData)
   return fundbaby
end

function FundDataSys.GetFundList()			
	return FundDataSys.FundDataList
end

function FundDataSys.GetPrincipalIndex()	--得到收回成本的那个点
	if FundDataSys.PrincipalIndex ~= 0 then
		return FundDataSys.PrincipalIndex
	end
	local pour = FundDataSys.GetPourPricipal()*10

	local count = 0
	for i=1,#FundDataSys.FundDataList,1  do
		count = count+FundDataSys.FundDataList[i].Restore
		if count>=pour then
			FundDataSys.PrincipalIndex = i
			return i
		end
	end
	return nil
end

function FundDataSys.GetReturnRateIndex()	--得到返利百分比的那个点
	if FundDataSys.RateIndex ~= 0 then
		return FundDataSys.RateIndex
	end
	local pour = FundDataSys.GetPourPricipal()*10
	local returnRate = FundDataSys.GetRewardRate()
	local count = pour *returnRate
	local sum = 0
	for i=1,#FundDataSys.FundDataList,1  do
		sum = sum+FundDataSys.FundDataList[i].Restore
		if sum>=count then
			FundDataSys.RateIndex = i
			return i
		end
	end
	return nil
end

function FundDataSys.SetFund(RwdList)			--设置已经领取基金

	for key,value in pairs(RwdList) do
		local lvl = tonumber(value)
		local index = FundDataSys.GetIndexByLvl(lvl)
		if index~=nil then
			FundDataSys.FundDataList[index]:SetIsRwd(true)
		end
	end
	
	
end

function FundDataSys.GetIndexByLvl(Lvl)			--根据等级得到index
	for i=1,#FundDataSys.FundDataList,1  do
		if FundDataSys.FundDataList[i].Lvl == Lvl then
			return i
		end
	end
	return nil
end

function FundDataSys.ComminfoCallBack(data)
	if data~=nil then
		FundDataSys.IsPourMoney = tonumber(data["isInvested"])
		local rwd = data["rwdRecvd"]
		if rwd~=nil then
			FundDataSys.SetFund(rwd)
		end
	end
	
end


return FundDataSys
--endregion
