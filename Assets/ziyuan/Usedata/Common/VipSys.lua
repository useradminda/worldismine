--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipSys = {}
VipSys.VipLevel = 0		--当前的VIP等级
VipSys.Exp = 0			--VIP经验值

VipSys.IsRwd = 0		--VIP奖励0可以领取， 1不可以领取
VipSys.LotteryIdDic = {}	--VIP转盘ID dic

function VipSys.Init()
--	WebEvent.InitSummonStore(nil , "VipSys.InitCallBack" , VipSys.InitCallBack)
end

function VipSys.InitCallBack(data , _returnId)
	local uiVipTar = MainGameUI.FindPanelTarget("UIVip")
	if uiVipTar ~=nil then
		uiVipTar:ShowInfo()
	end 
end


function VipSys.BuyVipGoods(_Id)				--购买元宝 _id vip_buy的ID
--	RechargeSys.GenerateOrder(_Id)
	local info = _Id
	WebEvent.BuyVipGoods(_Id , "VipSys.BuyVipGoodsCallBack" , VipSys.BuyVipGoodsCallBack)
end

function VipSys.BuyVipGoodsCallBack(data , returnId)
	local UIVipTar = MainGameUI.FindPanelTarget("UIVip")
	
	if UIVipTar ~= nil  then
		UIVipTar:ShowBuyCallBack()
	end
end

function VipSys.ReceiveDailyVipRwd()			--领取Vip每日奖励
	local info = nil
	WebEvent.ReceiveDailyVipRwd(info , "VipSys.ReceiveDailyVipRwdCallBack" , VipSys.ReceiveDailyVipRwdCallBack)
end
function VipSys.ReceiveDailyVipRwdCallBack(data , _returnId)
	
end

function VipSys.Lottery(_Id)					--VIP转盘抽奖
	local info = _Id
	WebEvent.VipLottery(info , "VipSys.LotteryCallBack" ,VipSys.LotteryCallBack)
end

function VipSys.LotteryCallBack(data , returnId)
	local UIVipLotteryTar = MainGameUI.FindPanelTarget("UIVipLottery")
	if UIVipLotteryTar ~= nil then
		UIVipLotteryTar:ToChooseGiftCallBack(data)
	end
end

function VipSys.GetLotteryCountById(_Id)
	if VipSys.LotteryIdDic[_Id] ~= nil then
		return VipSys.LotteryIdDic[_Id]
	end
	return 0
end

function VipSys.CommoninfoCallBack(data)
	local list = data["vipGoodsBoughtTimes"]
	if list~=nil then
		for key,value in pairs(list) do
			local id = tonumber(key)
			local times = tonumber(value)
			VipDataSys.SetBuyData(id , times)
		end
	end
end

function VipSys.DiskChangeCallBack(_Data)
	local data = _Data["vipDiskChance"]
	if data ~= nil then
		for key,value in pairs(data) do
			local id = tonumber(key)
			if id ~= nil then
				local num = tonumber(value)
				VipSys.LotteryIdDic[id] = num
			end
		end
	end
end


return VipSys
--endregion
