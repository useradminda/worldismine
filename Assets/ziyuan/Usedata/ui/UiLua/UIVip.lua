--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

UIVip = {}
UIVip = BasePanel:new()
local this = UIVip
--UI相关
UIVip.UIVipGod = nil
UIVip.Controls = {}
UIVip.ViplvlItemGodList = {}
UIVip.VipBuyItemGodList = {}
UIVip.VipDesItemGodList = {}

UIVip.VipPourMoneyPanel = nil
UIVip.VipPourMoneyControls = {}
--Data相关
UIVip.SliderWidthValue = 800
UIVip.SliderPosDel = -396.63
UIVip.HasBuyTimes = 0		--当前已经购买的次数
UIVip.SliderShowDel = 27.04 --用于相同位置的偏移量
UIVip.MaxVipLvl = 14	--最大的Vip等级
UIVip.SliderEndIndexList = 
{
	[1] = 7,
	[2] = 10,
	[3] = 12,
	[4] = 14
}			--sldier 上VIP显示的每个段的最后的index -1
UIVip.SliderEndBuyIndexList={}	--每一段的slider上显示的vipbuy的最后的index

UIVip.CurSliderRangeIndex = 1	--当前显示的VIPslider 上的阶段
UIVip.VipIndex = 2				--当前显示的VIP
UIVip.VipClickBuyItemIndex = 1		--当前点击的那个购买的index
UIVip.VipDataList = {}
UIVip.VipBuyDataList = {}		


function UIVip:OpenUI(_PanelName , _LuaName)
	if UIVip.UIVipGod == nil then
		UIVip.UIVipGod = MainGameUI.FindPanel("UIVip")
		UIVip.VipPourMoneyPanel = UIVip.UIVipGod.transform:FindChild("PourMoneyPanel")
		this:GetControls()
		this:SetInitData()
		UIVip.CurSliderRangeIndex = 1
--		UIVip.VipIndex = 2
--		VipSys.Init()
		this:ShowInfo()
	else
		this:ShowInfo()
	end
end

function UIVip:GetControls()

	local info = UIVip.UIVipGod.transform:FindChild("Info")
	UIVip.Controls.InfoNowLvl = info.transform:FindChild("nowLvl/Label"):GetComponent("UILabel")
	UIVip.Controls.InfoNextLvl = info.transform:FindChild("nextLvl/Label"):GetComponent("UILabel")
	UIVip.Controls.InfoLvlUpDes = info.transform:FindChild("label"):GetComponent("UILabel")
	
	local advantage = UIVip.UIVipGod.transform:FindChild("Advantage")
	UIVip.Controls.ShouldCount = advantage.transform:FindChild("shouldCount"):GetComponent("UILabel")
	UIVip.Controls.nowCost = advantage.transform:FindChild("nowCost"):GetComponent("UILabel")
	UIVip.Controls.Condition = advantage.transform:FindChild("condition"):GetComponent("UILabel")
	UIVip.Controls.CanBuyItemList = advantage.transform:FindChild("ItemList")
	UIVip.Controls.BuyItemGodlist = {}
	for i=1,5,1 do
		UIVip.Controls.BuyItemGodlist[i] = UIVip.Controls.CanBuyItemList.transform:FindChild(tostring(i))
	end
	
	UIVip.Controls.CanBuyTimes = advantage.transform:FindChild("CanBuyTimes"):GetComponent("UILabel")
	UIVip.Controls.HasBuy = advantage.transform:FindChild("hasBuy")
	UIVip.Controls.BuyBtn = advantage.transform:FindChild("GoBuyBtn")
	UIVip.Controls.NoOpen = advantage.transform:FindChild("NoOpen")
	UIVip.Controls.UseLotteryBtn = advantage.transform:FindChild("UseLotteryBtn")

	UIVip.Controls.SliderInfo = UIVip.UIVipGod.transform:FindChild("SliderInfo")
	UIVip.Controls.SliderExp = UIVip.Controls.SliderInfo.transform:FindChild("VipSliderExp"):GetComponent("UISlider")
	UIVip.Controls.SliderVipLvlGrid = UIVip.Controls.SliderInfo.transform:FindChild("VipList")
	UIVip.Controls.SliderVipBuyGrid = UIVip.Controls.SliderInfo.transform:FindChild("VipBuyList")
	
	local Func = UIVip.UIVipGod.transform:FindChild("Function")
	UIVip.Controls.VipDesGrid = Func.transform:FindChild("Des/DesPanel/DesGrid"):GetComponent("UIGrid")
	UIVip.Controls.VipFuncLvl = Func.transform:FindChild("title/vipLvl"):GetComponent("UILabel")
	UIVip.Controls.VipFuncLvl1 = Func.transform:FindChild("title/vipLvl (1)"):GetComponent("UILabel")
	UIVip.Controls.HasRecived = Func.transform:FindChild("HasRec")
	UIVip.Controls.RwdBtn = Func.transform:FindChild("GoBtn")
	UIVip.Controls.NoRwdBtn = Func.transform:FindChild("NoRwd")
	UIVip.Controls.ThumbExpTxt = UIVip.Controls.SliderExp.transform:FindChild("thumb/Label"):GetComponent("UILabel")
	UIVip.Controls.ThumbExpBg = UIVip.Controls.SliderExp.transform:FindChild("thumb/Sprite")
	UIVip.Controls.FuncGrid = Func.transform:FindChild("ItemList"):GetComponent("UIGrid")
	local parent = Func.transform:FindChild("ItemList")
	UIVip.Controls.FucItemList = {}
	for i=1,4,1 do
		UIVip.Controls.FucItemList[i] = parent.transform:FindChild(tostring(i))
	end
	
end

function UIVip:SetInitData()
	local list = VipDataSys.GetDataList()
	for i=1,#list,1 do
		UIVip.VipDataList[i] = list[i]
	end

	local buyList = VipDataSys.GetVipBuyDataList()
	for j=1,#buyList,1 do
		UIVip.VipBuyDataList[j] = buyList[j]
	end
	
	for i=1,#UIVip.SliderEndIndexList,1  do
		local startlvl = 0
		if i ~=1 then
			startlvl = UIVip.SliderEndIndexList[i-1] -1
		end
		local endLvl = UIVip.SliderEndIndexList[i]-1
		
		UIVip.SliderEndBuyIndexList[i] = VipDataSys.GetVipBuyEndIndexByLvl(startlvl , endLvl)
		
	end
end

function UIVip:ShowInfo()				--显示当前VIP的相关信息
	UIVip.VipIndex = VipSys.VipLevel +1
	if UIVip.VipIndex <=1 then
		UIVip.VipIndex = 2
	end
	if UIVip.VipIndex >= LimitDataSys.VipLevelLimit then
		UIVip.VipIndex = LimitDataSys.VipLevelLimit+1
	end
	GameMain.CloseObj(UIVip.VipPourMoneyPanel)
	this:ShowCurVipBasicInfo()
	this:CreateSolider(UIVip.CurSliderRangeIndex)
end

function UIVip:ShowCurVipBasicInfo()	--显示当前VIP的基本信息
	UIVip.Controls.InfoNowLvl.text = "V" .. tostring(VipSys.VipLevel)
	UIVip.Controls.InfoNextLvl.text = "V" .. tostring(VipSys.VipLevel+1)
	local data = VipDataSys.GetVipDataByLvl(VipSys.VipLevel+1)
	if data ~= nil then
		local cost =  data.VipExp - VipSys.Exp
		UIVip.Controls.InfoLvlUpDes.text = UIstring.NormalWordColor.."再充值" .. "[-]" ..UIstring.Red .. tostring(cost) .."[-]" .. UIstring.NormalWordColor.."元宝获得" .."[-]" .. UIstring.Red..tostring(cost).."[-]" ..UIstring.NormalWordColor.."经验成为".."[-]"
	else
		if VipSys.VipLevel >= LimitDataSys.VipLevelLimit then
			UIVip.Controls.InfoLvlUpDes.text = "已经达到VIP最高等级"
			GameMain.CloseObj(UIVip.Controls.InfoNextLvl.transform.parent)
		end
	end
	this:ShowSliderLen(UIVip.CurSliderRangeIndex)
end

function UIVip:ShowSliderLen(curIndex)						--显示经验值条的长度
	local index = this:GetCurLvlRangeIndex()
	if index==nil then
		return
	end
	if curIndex<index then
		UIVip.Controls.SliderExp.value =1
		GameMain.CloseObj(UIVip.Controls.ThumbExpBg.transform.parent)
		return
	end
	if curIndex>index then
		UIVip.Controls.SliderExp.value = 0
		GameMain.CloseObj(UIVip.Controls.ThumbExpBg.transform.parent)
		return 
	end
	local data = VipDataSys.GetVipDataByLvl(VipSys.VipLevel)
	if index ==1 then
		local nextId = VipSys.VipLevel +1
		local nextData = VipDataSys.GetVipDataByLvl(nextId)
		local all = nextData.VipExp - data.VipExp
		local del = VipSys.Exp - data.VipExp
		local rangeLen = 1/(UIVip.SliderEndIndexList[1]-1)
		UIVip.Controls.SliderExp.value = rangeLen*VipSys.VipLevel+rangeLen*del/all
	else
		local curOriVip = UIVip.SliderEndIndexList[index-1]-1
		local oriVipData =  VipDataSys.GetVipDataByLvl(curOriVip)
		local endVip = UIVip.SliderEndIndexList[index]-1
		local endVipData = VipDataSys.GetVipDataByLvl(endVip)
		local all = endVipData.VipExp - oriVipData.VipExp
		local del = VipSys.Exp - oriVipData.VipExp
		UIVip.Controls.SliderExp.value = del/all
	end
	this:ShowMyVipExp()
end

function UIVip:ShowMyVipExp()
	GameMain.OpenObj(UIVip.Controls.ThumbExpBg.transform.parent)
	if UIVip.Controls.SliderExp.value ~= 0 then
		UIVip.Controls.ThumbExpTxt.transform.localPosition = Vector3(22 , -33 ,0)
		UIVip.Controls.ThumbExpBg.transform.localPosition = Vector3(22 , -27 ,0)
	else
		UIVip.Controls.ThumbExpTxt.transform.localPosition = Vector3(-28 , -33 ,0)
		UIVip.Controls.ThumbExpBg.transform.localPosition = Vector3(-28 , -27 ,0)
	end
	UIVip.Controls.ThumbExpTxt.text = "vip经验值:" .. VipSys.Exp
end

function UIVip:GetCurLvlRangeIndex()
	for key,value in pairs(UIVip.SliderEndIndexList) do
		if VipSys.VipLevel <= value-1 then
			return key
		end
--		if VipSys.VipLevel == value-1 then
--			local data = VipDataSys.GetVipDataByLvl(VipSys.VipLevel)
--			if data.VipExp>VipSys.Exp then
--				local num = key+1
--				if num>=#UIVip.SliderEndBuyIndexList then
--					return #UIVip.SliderEndBuyIndexList
--				else
--					return num
--				end
--			end
--		end
	end
	return nil
end

function UIVip:ShowSliderInfo(addNum)
	this:ClearSliderInfo()
	UIVip.CurSliderRangeIndex = UIVip.CurSliderRangeIndex + addNum
	if UIVip.CurSliderRangeIndex<=1 then
		UIVip.CurSliderRangeIndex = 1
	end
	if UIVip.CurSliderRangeIndex >= #UIVip.SliderEndIndexList then
		UIVip.CurSliderRangeIndex = #UIVip.SliderEndIndexList
	end

	this:CreateSolider(UIVip.CurSliderRangeIndex)
	this:ShowSliderLen(UIVip.CurSliderRangeIndex)
end

function UIVip:ClearSliderInfo()
	for key,value in pairs(UIVip.ViplvlItemGodList) do
		GameMain.CloseObj(value)
	end
	for k,v in pairs(UIVip.VipBuyItemGodList) do
		GameMain.CloseObj(v)
	end
	
end

function UIVip:CreateSolider(rangeIndex)
	local startIndex = 1
	if rangeIndex >1 then
		startIndex = UIVip.SliderEndIndexList[(rangeIndex -1)]
	end
	
	local endIndex = UIVip.SliderEndIndexList[rangeIndex]
	local sliderTotlaExp = UIVip.VipDataList[endIndex].VipExp - UIVip.VipDataList[startIndex].VipExp
	if #UIVip.ViplvlItemGodList == 0 then
		for i=startIndex,endIndex,1 do
			local data =
			{
				StartIndex = startIndex,
				TotalExp = sliderTotlaExp,
				Index = i,
			}
			MainGameUI.CreateLittleItem(tostring(i) , "VipLvlItem" , UIVip.Controls.SliderVipLvlGrid, data , this.CreateBagListCallBack , "UIVip") 
		end
	else
		for i=startIndex,endIndex,1 do
			local data =
			{
				StartIndex = startIndex,
				TotalExp = sliderTotlaExp,
				Index = i,
			}
			if UIVip.ViplvlItemGodList[i] == nil then
				MainGameUI.CreateLittleItem(tostring(i) , "VipLvlItem" , UIVip.Controls.SliderVipLvlGrid, data , this.CreateBagListCallBack , "UIVip") 
			else
				this:CreateBagListCallBack(UIVip.ViplvlItemGodList[i] , data)
			end
		end
	end
	this:CreateSliderBuyList(rangeIndex)
end

function UIVip:CreateBagListCallBack(_Gob , _Info)

	local index = _Info.Index
	UIVip.ViplvlItemGodList[index] = _Gob
	local data = UIVip.VipDataList[index]
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)
		
	if _Info.StartIndex == 1 then
		
		local x = UIVip.SliderPosDel + UIVip.SliderWidthValue*((index-1)/(UIVip.SliderEndIndexList[1] -1))
		_Gob.transform.localPosition = Vector3( x, 0, 0)
	
	else
		local startExp = UIVip.VipDataList[_Info.StartIndex].VipExp
		local vipRange = data.VipExp - startExp
		local x = UIVip.SliderPosDel + UIVip.SliderWidthValue*(vipRange/_Info.TotalExp)
		_Gob.transform.localPosition = Vector3( x, 0, 0)
	end
	local lv = _Gob.transform:FindChild("Lvl"):GetComponent("UILabel")
	lv.text ="V" ..	tostring(data.Lvl)
end

function UIVip:CreateSliderBuyList(rangeIndex)					--创建slider上优惠购买的list
	local endIndex = UIVip.SliderEndBuyIndexList[rangeIndex]
	local startIndex =1
	if rangeIndex >1 then
		startIndex = UIVip.SliderEndBuyIndexList[rangeIndex -1]
	end
	
	for i=startIndex,endIndex ,1 do
		local data =
		{
			StartIndex = rangeIndex,
			Index = i,
			Len = endIndex,
		}
		if UIVip.VipBuyItemGodList[i]==nil then
			MainGameUI.CreateLittleItem(tostring(i) , "vipSliderItem" , UIVip.Controls.SliderVipBuyGrid, data , this.CreateBuyListCallBack , "UIVip") 
		else
			this:CreateBuyListCallBack(UIVip.VipBuyItemGodList[i] , data)
		end
	end
end

function UIVip:CreateBuyListCallBack(_Gob , _Info)
	
	local index = _Info.Index
	UIVip.VipBuyItemGodList[index]	= _Gob

	if _Info.Len == index then
			this:ShowBuyItemInfo(UIVip.VipClickBuyItemIndex)
			this:ShowVipInfo(UIVip.VipIndex)	
	end
	local data = UIVip.VipBuyDataList[index]
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)
	local x =0 
	if _Info.StartIndex ==1 then
		
		for i=1,UIVip.SliderEndIndexList[1],1 do
			if data.VipExp >=UIVip.VipDataList[i].VipExp and data.VipExp<= UIVip.VipDataList[i+1].VipExp then
				local endExp = UIVip.VipDataList[i+1].VipExp
				local startExp = UIVip.VipDataList[i].VipExp
				local vipRange = data.VipExp - startExp
					x = UIVip.SliderPosDel + (UIVip.SliderWidthValue/(UIVip.SliderEndIndexList[1]-1))*(i-1+vipRange /(endExp - startExp))
				break
			end
		end
	else
		local totleExp = UIVip.VipDataList[UIVip.SliderEndIndexList[_Info.StartIndex]].VipExp
		local startExp = UIVip.VipDataList[UIVip.SliderEndIndexList[_Info.StartIndex-1]].VipExp
		local vipRange = data.VipExp - startExp
		if vipRange<0 then
			GameMain.CloseObj(_Gob)
		end
		
		x = UIVip.SliderPosDel + UIVip.SliderWidthValue*(vipRange/(totleExp - startExp))
	end

	_Gob.transform.localPosition = Vector3( x, 112.6, 0)
	if index>1 then
		local nowX = _Gob.transform.localPosition.x
		local beforeX = UIVip.VipBuyItemGodList[index-1].transform.localPosition.x
		if nowX == beforeX then
			_Gob.transform.localPosition = Vector3( x+UIVip.SliderShowDel, 125.6, 0)
			this:SetDethUp(_Gob)
		end
	end
	local icon = _Gob.transform:FindChild("IMG"):GetComponent("UISprite")
	local name = _Gob.transform:FindChild("name"):GetComponent("UILabel")
	local lvl = _Gob.transform:FindChild("Lvl"):GetComponent("UILabel")
	local iconQuility = _Gob.transform:FindChild("FG"):GetComponent("UISprite")
	local bg = _Gob.transform:FindChild("BG"):GetComponent("UISprite")
--	lvl.text = tostring(data.Dbid)			--用于测试，区分不同的icon头像数据不同
	local count = _Gob.transform:FindChild("count"):GetComponent("UILabel")
	if data.UseId~= 0 then
		local showData = VipBuyDiscConfig.GetDataById(data.UseId)
		if showData ~= nil then
			AtlasMsg.SetAtlas(icon , showData.AtlasName , showData.SpriteName)
			iconQuility.spriteName = UIstring.ItemFg[showData.Quality]
			bg.spriteName = UIstring.ItemFg[showData.Quality]
			count.text = tostring(1)
			name.text =	UIstring.WordColor[showData.Quality] ..	showData.Name .. "[-]"
		end
	else
		local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Reward))
			
		local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)
		
		local item= jsonItems.Items[data.ShowOrder]
		if item ~= nil then
			AtlasMsg.SetAtlas(icon , item.AtlasName , item.SpriteName)
			iconQuility.spriteName = UIstring.ItemFg[item.Quality]
			bg.spriteName = UIstring.ItemFg[item.Quality]
			count.text = tostring(item.Count)
			name.text =	UIstring.WordColor[item.Quality] ..	item.Name .. "[-]"
		end
	end
	if data.ShowName == 1 then
		GameMain.OpenObj(name)
	else
		GameMain.CloseObj(name)
	end
	
end

function UIVip:SetDethUp(_Gob)
	_Gob.transform:FindChild("Lvl"):GetComponent("UIWidget").depth = 7
	_Gob.transform:FindChild("BG"):GetComponent("UIWidget").depth = 4
	_Gob.transform:FindChild("IMG"):GetComponent("UIWidget").depth = 6
	_Gob.transform:FindChild("name"):GetComponent("UIWidget").depth = 7
	_Gob.transform:FindChild("FG"):GetComponent("UIWidget").depth = 7
	_Gob.transform:FindChild("Sprite"):GetComponent("UIWidget").depth = 3
	_Gob.transform:FindChild("Choose"):GetComponent("UIWidget").depth = 7
	
end

function UIVip:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		GameMain.CloseObj(UIVip.UIVipGod)
	end
	if _Gob.name == "SliderLeftBtn" then
		this:ShowSliderInfo(-1)
	end
	if _Gob.name == "SliderRightBtn" then
		this:ShowSliderInfo(1)	
	end
	
	if _Gob.name == "VipRightBtn" then
		this:ChangeShowVipInfo(1)
	end
	if _Gob.name == "VipLeftBtn" then
		this:ChangeShowVipInfo(-1)
	end
	if _Gob.name == "ReciverBtn" then
		DataUIInstance.OpenRecharge()			--打开充值界面
	end
	if _Gob.name == "PourCloseBtn" then
		GameMain.CloseObj(UIVip.VipPourMoneyPanel)
	end
	if _Gob.name == "GoBuyBtn" then
		this:BuyVipGoods()						--vip购买礼包
	end
	if _Gob.name == "mask" then
		GameMain.CloseObj(UIVip.VipPourMoneyPanel)
	end
	if _Gob.name == "GoBtn" then
		this:ReceiveDailyVipRwd()				--领取VIP每日奖励
	end
	if _Gob.name == "NoOpen" then
		DataUIInstance.PopTip(UIstring.VipNoOpen)
	end
	if _Gob.name == "NoRwd" then
		DataUIInstance.PopTip(UIstring.VipNoLvl)
	end
	if _Gob.name == "UseLotteryBtn" then
		DataUIInstance.CreateVipLottery(UIVip.VipBuyDataList[UIVip.VipClickBuyItemIndex])
	end
	local key = tonumber(_Gob.transform.name)
	if key~=nil and _Gob.transform.parent.name == "VipBuyList" then
		this:ShowBuyItemInfo(key)
	end
end

function UIVip:ReceiveDailyVipRwd()
	local lvl = UIVip.VipIndex -1
	if lvl>VipSys.VipLevel then
		DataUIInstance.PopTip("Vip等级不足")
		return
	end
	GameMain.CloseObj(UIVip.Controls.RwdBtn)
	GameMain.OpenObj(UIVip.Controls.HasRecived)
	VipSys.ReceiveDailyVipRwd()
	this:ShowRecRewardsTip()
end

function UIVip:ShowRecRewardsTip()
	local data = VipDataSys.GetVipByLvl(VipSys.VipLevel)

	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.ReWard))
		
	local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
	local item= jsonItems.Items
	DataUIInstance.OpenRewards(item)
end

function UIVip:ShowBuyRewardsTip()
	local data = UIVip.VipBuyDataList[UIVip.VipClickBuyItemIndex]
	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Reward))
			
	local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
	local items= jsonItems.Items
	DataUIInstance.OpenRewards(items)
end


function UIVip:BuyVipGoods()		--购买Vip礼包
	local dimoned = ClinetInfomation.GetDiamond()
	local buyData = UIVip.VipBuyDataList[UIVip.VipClickBuyItemIndex]
	if dimoned < buyData.Price then
		DataUIInstance.PopTip("元宝不足")
		return
	end
	local curExp = VipSys.Exp
	if curExp >= buyData.VipExp then
		buyData:BuyDiamoned()
	else
		DataUIInstance.PopTip("Vip经验不足")
	end

end

function UIVip:ShowBuyCallBack()
	local buyData = UIVip.VipBuyDataList[UIVip.VipClickBuyItemIndex]
		UIVip.HasBuyTimes = UIVip.HasBuyTimes+1
		if UIVip.HasBuyTimes >= buyData.TotalTimes then
			
			GameMain.CloseObj(UIVip.Controls.CanBuyTimes)
			GameMain.CloseObj(UIVip.Controls.BuyBtn)
			local lotteryNum =  VipSys.GetLotteryCountById(buyData.UseId)
			if lotteryNum == 0 then
				GameMain.OpenObj(UIVip.Controls.HasBuy)
				GameMain.CloseObj(UIVip.Controls.UseLotteryBtn)
			else
				GameMain.CloseObj(UIVip.Controls.HasBuy)
				GameMain.OpenObj(UIVip.Controls.UseLotteryBtn)
			end
			
		else
			GameMain.OpenObj(UIVip.Controls.CanBuyTimes)
			GameMain.OpenObj(UIVip.Controls.BuyBtn)
			GameMain.CloseObj(UIVip.Controls.HasBuy)
			GameMain.CloseObj(UIVip.Controls.UseLotteryBtn)
			UIVip.Controls.CanBuyTimes.text = "可购买" .. tostring(UIVip.HasBuyTimes) .. "/" .. buyData.TotalTimes .. "次"
		end
		this:ShowBuyRewardsTip()
end

function UIVip:ShowUseLotteryInfo()
	this:ShowBuyItemInfo(UIVip.VipClickBuyItemIndex)
end

function UIVip:ShowBuyItemInfo(_Index)
	if UIVip.VipClickBuyItemIndex ~= _Index then
		GameMain.CloseObj(UIVip.VipBuyItemGodList[UIVip.VipClickBuyItemIndex].transform:FindChild("Choose"))
	end

	UIVip.VipClickBuyItemIndex = _Index

	GameMain.OpenObj(UIVip.VipBuyItemGodList[UIVip.VipClickBuyItemIndex].transform:FindChild("Choose"))

	local data = UIVip.VipBuyDataList[_Index]
	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Reward))
			
	local jsonItems = RewardContentSys.GetRewardResourceString(rewardData.RewardString)

	local items= jsonItems.Items
	for i=1,5,1  do
		local god = UIVip.Controls.BuyItemGodlist[i]
		if items[i] == nil then
			GameMain.CloseObj(god)
		else
			GameMain.OpenObj(god)
			local img = god.transform:FindChild("Img"):GetComponent("UISprite")
			local quality = god.transform:FindChild("Quility"):GetComponent("UISprite")
			local bg = god.transform:FindChild("Bg"):GetComponent("UISprite")
			local count = god.transform:FindChild("count"):GetComponent("UILabel")
			count.text = tostring(items[i].Count)
			bg.spriteName = UIstring.ItemFg[items[i].Quality]
			quality.spriteName = UIstring.ItemFg[items[i].Quality]
			AtlasMsg.SetAtlas(img , items[i].AtlasName , items[i].SpriteName)
		end
	end
	
	UIVip.Controls.ShouldCount.text = data.DesCription
	UIVip.Controls.nowCost.text = tostring(data.Price)
	UIVip.Controls.Condition.text = UIstring.VipHasExp .. tostring(data.VipExp) .. UIstring.VipCanBuy
	if data.VipExp>VipSys.Exp then
		GameMain.CloseObj(UIVip.Controls.BuyBtn)
		GameMain.CloseObj(UIVip.Controls.CanBuyTimes)
		GameMain.CloseObj(UIVip.Controls.HasBuy)
		GameMain.OpenObj(UIVip.Controls.NoOpen)
		GameMain.CloseObj(UIVip.Controls.UseLotteryBtn)
		return
	end
	GameMain.CloseObj(UIVip.Controls.NoOpen)

	if data.Count>= data.TotalTimes then
		GameMain.CloseObj(UIVip.Controls.CanBuyTimes)
		GameMain.CloseObj(UIVip.Controls.BuyBtn)
		if VipSys.GetLotteryCountById(data.UseId) == 0 then
			GameMain.OpenObj(UIVip.Controls.HasBuy)
			GameMain.CloseObj(UIVip.Controls.UseLotteryBtn)
		else
			GameMain.CloseObj(UIVip.Controls.HasBuy)
			GameMain.OpenObj(UIVip.Controls.UseLotteryBtn)
		end
	else
		GameMain.OpenObj(UIVip.Controls.CanBuyTimes)
		GameMain.OpenObj(UIVip.Controls.BuyBtn)
		GameMain.CloseObj(UIVip.Controls.HasBuy)
		GameMain.CloseObj(UIVip.Controls.UseLotteryBtn)

		UIVip.HasBuyTimes = data.Count
		UIVip.Controls.CanBuyTimes.text = "可购买" .. tostring(data.Count) .. "/" .. data.TotalTimes .. "次"
	end
	
end

function UIVip:ChangeShowVipInfo(addNum)			
	UIVip.VipIndex = UIVip.VipIndex + addNum
	if UIVip.VipIndex <=2 then		--vip特权介绍从Vip1开始
		UIVip.VipIndex = 2
	end
	if UIVip.VipIndex >=UIVip.MaxVipLvl then
		UIVip.VipIndex = UIVip.MaxVipLvl
	end
	this:ShowVipInfo(UIVip.VipIndex)
end

function UIVip:ShowVipInfo(Index)
	local lvl = Index -1
	
	UIVip.Controls.VipFuncLvl.text = "Vip" .. tostring(lvl)
	UIVip.Controls.VipFuncLvl1.text = "Vip" .. tostring(lvl)
	this:ShowVipRecList(lvl)
	if lvl<VipSys.VipLevel then
		GameMain.CloseObj(UIVip.Controls.RwdBtn)
		GameMain.CloseObj(UIVip.Controls.HasRecived)
		GameMain.CloseObj(UIVip.Controls.NoRwdBtn)
	end

	if lvl == VipSys.VipLevel then
		if VipSys.IsRwd == 0 then
			GameMain.CloseObj(UIVip.Controls.HasRecived)
			GameMain.OpenObj(UIVip.Controls.RwdBtn)
			GameMain.CloseObj(UIVip.Controls.NoRwdBtn)
		else
			GameMain.OpenObj(UIVip.Controls.HasRecived)
			GameMain.CloseObj(UIVip.Controls.RwdBtn)
			GameMain.CloseObj(UIVip.Controls.NoRwdBtn)
		end
	end
	
	if lvl>VipSys.VipLevel then
		GameMain.CloseObj(UIVip.Controls.HasRecived)
		GameMain.CloseObj(UIVip.Controls.RwdBtn)
		GameMain.CloseObj(UIVip.Controls.NoRwdBtn)
		if lvl == 1 and VipSys.VipLevel == 0 then
			GameMain.OpenObj(UIVip.Controls.NoRwdBtn)
		end
	end

	local data = UIVip.VipDataList[Index]
	local list = GameMain.StringSplit(data.Description , ",")
	if #UIVip.VipDesItemGodList~=0 then
		for key,value in pairs(UIVip.VipDesItemGodList) do
			GameMain.CloseObj(value)
		end
	end
	for i=1,#list,1 do
		local data = 
		{
			Data = list[i],
			Len = #list,
			Index = i,
		}
		if UIVip.VipDesItemGodList[i] ==nil then
			MainGameUI.CreateLittleItem(tostring(i) , "VipFunctionItem" , UIVip.Controls.VipDesGrid, data , this.CreateDesListCallBack , "UIVip") 
		else
			this:CreateDesListCallBack(UIVip.VipDesItemGodList[i] , data)
		end
	end
	UIVip.Controls.VipDesGrid.enabled = true
	UIVip.Controls.VipDesGrid:Reposition()
end

function UIVip:ShowVipRecList(_Lvl)
	local data = VipDataSys.GetVipByLvl(_Lvl)

	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.ReWard))
		
	local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
	local item= jsonItems.Items
	for i=1,4,1 do
		local data = item[i]
		local god = UIVip.Controls.FucItemList[i]
		if data == nil then
			GameMain.CloseObj(god)
		else
			GameMain.OpenObj(god)
			local img = god.transform:FindChild("Img"):GetComponent("UISprite")
			local quality = god.transform:FindChild("Quility"):GetComponent("UISprite")
			local count = god.transform:FindChild("count"):GetComponent("UILabel")
			local fg = god.transform:FindChild("FG"):GetComponent("UISprite")
			AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)
			quality.spriteName = UIstring.ItemFg[data.Quality]
			fg.spriteName = UIstring.ItemFg[data.Quality]
			count.text = tostring(data.Count)
		end
	end
	
end

function UIVip:CreateDesListCallBack(_Gob , _Info)
	local data = _Info.Data
	local len = _Info.Len
	GameMain.OpenObj(_Gob)
	local id = tonumber(_Gob.transform.name)
	UIVip.VipDesItemGodList[id] = _Gob
	local txt = UIVip.VipDesItemGodList[id].transform:FindChild("Label"):GetComponent("UILabel")
	txt.text = data
	if _Info.Index == len then
		UIVip.Controls.FuncGrid.enabled = true
		UIVip.Controls.FuncGrid:Reposition()
	end
end

function UIVip.ShowPourMoneyInfo()
	if UIVip.VipPourMoneyControls.Cost == nil then
		this:GetPourMoneyControls()
	end
	GameMain.OpenObj(UIVip.VipPourMoneyPanel)
end

function UIVip:GetPourMoneyControls()
	UIVip.VipPourMoneyControls.Cost = UIVip.VipPourMoneyPanel.transform:FindChild("needMoney"):GetComponent("UILabel")
	UIVip.VipPourMoneyControls.VipLvl = UIVip.VipPourMoneyPanel.transform:FindChild("vipLvl"):GetComponent("UILabel")
	
	UIVip.VipPourMoneyControls.BuyNum = UIVip.VipPourMoneyPanel.transform:FindChild("itemIcon/count"):GetComponent("UILabel")
	UIVip.VipPourMoneyControls.VipExp = UIVip.VipPourMoneyPanel.transform:FindChild("vipExp/count"):GetComponent("UILabel")
end

function UIVip:ReleasPanel()
	--UI相关
	UIVip.UIVipGod = nil
	UIVip.Controls = {}
	UIVip.ViplvlItemGodList = {}
	UIVip.VipBuyItemGodList = {}
	UIVip.VipDesItemGodList = {}

	UIVip.VipPourMoneyPanel = nil
	UIVip.VipPourMoneyControls = {}
	--Data相关
	UIVip.SliderWidthValue = 800
	UIVip.SliderPosDel = -396.63
	UIVip.HasBuyTimes = 0		--当前已经购买的次数
	UIVip.SliderShowDel = 27.04 --用于相同位置的偏移量
	UIVip.MaxVipLvl = 14	--最大的Vip等级
	UIVip.SliderEndIndexList = 
	{
		[1] = 7,
		[2] = 10,
		[3] = 12,
		[4] = 14
	}			--sldier 上VIP显示的每个段的最后的index -1
	UIVip.SliderEndBuyIndexList={}	--每一段的slider上显示的vipbuy的最后的index

	UIVip.CurSliderRangeIndex = 1	--当前显示的VIPslider 上的阶段
	UIVip.VipIndex = 2				--当前显示的VIP
	UIVip.VipClickBuyItemIndex = 1		--当前点击的那个购买的index
	UIVip.VipDataList = {}
	UIVip.VipBuyDataList = {}	

end

function UIVip:ReleasData()
	VipSys.VipLevel = 0		--当前的VIP等级
	VipSys.Exp = 0			--VIP经验值

	VipSys.IsRwd = 0		--VIP奖励0可以领取， 1不可以领取
	VipSys.LotteryIdDic = {}	--VIP转盘ID dic
end
return UIVip
--endregion
