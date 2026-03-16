--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
ConsumeRaffleSys = {}
ConsumeRaffleSys.lotoUsed = 0
ConsumeRaffleSys.CostDiamoned = 0
ConsumeRaffleSys.SimpleNeedDiamoned = 500--500钻石抽一次奖

function ConsumeRaffleSys.GetAllData()
	local dataList = {}
	local list = ConsumeRaffleConfig.GetDB()
	for key,value in pairs(list) do
		table.insert(dataList , #dataList+1 , value)
	end
	return dataList
end

function ConsumeRaffleSys.GetCount()	--得到抽奖的次数
	local count = ConsumeRaffleSys.CostDiamoned/ConsumeRaffleSys.SimpleNeedDiamoned
	if count<=0 then
		return 0 
	end
	local equls = count - ConsumeRaffleSys.lotoUsed
	if equls<=0 then
		return 0
	else
		return GameMain.ConvertToInt(equls)
	end
end

function ConsumeRaffleSys.lottery()				--抽奖
	local info = nil
	WebEvent.lotteryReward(info , "ConsumeRaffleSys.lotteryCallBack" , ConsumeRaffleSys.lotteryCallBack)
end

function ConsumeRaffleSys.lotteryCallBack(data , returnId)
	local uiConsumpGiftTar = MainGameUI.FindPanelTarget("UIConsumpGift")
	if uiConsumpGiftTar ~=nil then
		uiConsumpGiftTar:ToChooseGiftCallBack(data)
	end
end

return ConsumeRaffleSys
--endregion
