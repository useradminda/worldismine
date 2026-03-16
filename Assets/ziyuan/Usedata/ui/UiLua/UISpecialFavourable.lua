UISpecialFavourable = {}
local UISpecialFavourable = BasePanel:new()     
local this = UISpecialFavourable
--UI
UISpecialFavourable.UISpecialFavourableGob = nil
UISpecialFavourable.Controls = {}

--Data
UISpecialFavourable.CurBuyWeekData = nil
UISpecialFavourable.DayList = {}
UISpecialFavourable.ClickBuyWeedData = nil

function UISpecialFavourable:OpenUI()
	if UISpecialFavourable.UISpecialFavourableGob == nil then
		UISpecialFavourable.UISpecialFavourableGob=MainGameUI.FindPanel("UISpecialFavourable")
		this:GetControls()
		this:SetInit()
	end
	this:ShowInfo()
end

function UISpecialFavourable:GetControls()
	local week = UISpecialFavourable.UISpecialFavourableGob.transform:FindChild("WeekFavourable/left")
	local WeekOne = week.transform:FindChild("BagOne")
	local WeekTwo = week.transform:FindChild("BagTwo")
	UISpecialFavourable.Controls.WeekOneNeedMoney = WeekOne.transform:FindChild("Money/NeedMoney"):GetComponent("UILabel")
	UISpecialFavourable.Controls.WeekTwoNeedMoney = WeekTwo.transform:FindChild("Money/NeedMoney"):GetComponent("UILabel")
	UISpecialFavourable.Controls.WeekOneItemQuality = WeekOne.transform:FindChild("WeekItem/Quality"):GetComponent("UISprite")
	UISpecialFavourable.Controls.WeekOneItemFG = WeekOne.transform:FindChild("WeekItem/FG"):GetComponent("UISprite")
	UISpecialFavourable.Controls.WeekOneItemImg = WeekOne.transform:FindChild("WeekItem/Img"):GetComponent("UISprite")
	UISpecialFavourable.Controls.WeekTwoItemQuality = WeekTwo.transform:FindChild("WeekItem/Quality"):GetComponent("UISprite")
	UISpecialFavourable.Controls.WeekTwoItemFG = WeekTwo.transform:FindChild("WeekItem/FG"):GetComponent("UISprite")
	UISpecialFavourable.Controls.WeekTwoItemImg = WeekTwo.transform:FindChild("WeekItem/Img"):GetComponent("UISprite")
	UISpecialFavourable.Controls.WeekTwoBuy = WeekTwo.transform:FindChild("Buy")
	UISpecialFavourable.Controls.WeekTwoHasBuy = WeekTwo.transform:FindChild("hasBuy")
	UISpecialFavourable.Controls.WeekOneBuy = WeekOne.transform:FindChild("Buy")
	UISpecialFavourable.Controls.WeekOneHasBuy = WeekOne.transform:FindChild("hasBuy")

	local day = UISpecialFavourable.UISpecialFavourableGob.transform:FindChild("EveryDayFavourable/left")
	local dayOne = day.transform:FindChild("One")
	local dayTwo = day.transform:FindChild("Two")
	local dayThree = day.transform:FindChild("Three")
	UISpecialFavourable.Controls.DayOneNeedMoney = dayOne.transform:FindChild("Money/NeedMoney"):GetComponent("UILabel")
	UISpecialFavourable.Controls.DayTwoNeedMoney = dayTwo.transform:FindChild("Money/NeedMoney"):GetComponent("UILabel")
	UISpecialFavourable.Controls.DayThreeNeedMoney = dayThree.transform:FindChild("Money/NeedMoney"):GetComponent("UILabel")
	UISpecialFavourable.Controls.DayOneRandomMoney = dayOne.transform:FindChild("RandomMoney/Money"):GetComponent("UILabel")
	UISpecialFavourable.Controls.DayTwoRandomMoney = dayTwo.transform:FindChild("RandomMoney/Money"):GetComponent("UILabel")
	UISpecialFavourable.Controls.DayThreeRandomMoney = dayThree.transform:FindChild("RandomMoney/Money"):GetComponent("UILabel")
	UISpecialFavourable.Controls.DayThreeHasBuy = dayThree.transform:FindChild("hasBuy")
	UISpecialFavourable.Controls.DayThreeBuy = dayThree.transform:FindChild("Buy")
	UISpecialFavourable.Controls.DayTwoHasBuy = dayTwo.transform:FindChild("hasBuy")
	UISpecialFavourable.Controls.DayTwoBuy = dayTwo.transform:FindChild("Buy")
	UISpecialFavourable.Controls.DayOneHasBuy = dayOne.transform:FindChild("hasBuy")
	UISpecialFavourable.Controls.DayOneBuy = dayOne.transform:FindChild("Buy")
	
	if GameMain.IOSTest == true then
		local one = week.transform:FindChild("Descrip")
		local two = WeekTwo.transform:FindChild("Title2")
		local three = UISpecialFavourable.UISpecialFavourableGob.transform:FindChild("WeekFavourable/bg(1)")
		local four = UISpecialFavourable.UISpecialFavourableGob.transform:FindChild("EveryDayFavourable/bg(1)")
		local five = day.transform:FindChild("Descrip")
		GameMain.CloseObj(one)
		GameMain.CloseObj(two)
		GameMain.CloseObj(three)
		GameMain.CloseObj(four)
		GameMain.CloseObj(five)
	end
	
end

function UISpecialFavourable:SetInit()
	local WeekList = SpecialFavourableSys.GetWeekDBData()
	local curData = WeekList[1]
	UISpecialFavourable.CurBuyWeekData = curData
	UISpecialFavourable.Controls.WeekOneNeedMoney.text = tostring(curData.NeedRmb)
	local nextData = EveryWeekPreferentialConfig.GetDataById(curData.NextId)
	UISpecialFavourable.Controls.WeekTwoNeedMoney.text = tostring(nextData.NeedRmb)
	
	local giftOne = GiftDataConfig.GetGiftDataBuyId(curData.Reward)
	local giftTwo = GiftDataConfig.GetGiftDataBuyId(nextData.Reward)
	
	AtlasMsg.SetAtlas( UISpecialFavourable.Controls.WeekOneItemImg , giftOne.AtlasName , giftOne.SpriteName)
	AtlasMsg.SetAtlas( UISpecialFavourable.Controls.WeekTwoItemImg , giftTwo.AtlasName , giftTwo.SpriteName)
	UISpecialFavourable.Controls.WeekOneItemQuality.spriteName = UIstring.ItemFg[giftOne.Quality]
	UISpecialFavourable.Controls.WeekTwoItemQuality.spriteName = UIstring.ItemFg[giftTwo.Quality]
	UISpecialFavourable.Controls.WeekOneItemFG.spriteName = UIstring.ItemFg[giftOne.Quality]
	UISpecialFavourable.Controls.WeekTwoItemFG.spriteName = UIstring.ItemFg[giftTwo.Quality]

	local DayList = SpecialFavourableSys.GetDayDBData()
	UISpecialFavourable.DayList = DayList
	UISpecialFavourable.Controls.DayOneNeedMoney.text = tostring(DayList[1].NeedRmb)
	UISpecialFavourable.Controls.DayOneRandomMoney.text = tostring(DayList[1].Get_Min)
	
	UISpecialFavourable.Controls.DayTwoNeedMoney.text = tostring(DayList[2].NeedRmb)
	UISpecialFavourable.Controls.DayTwoRandomMoney.text = tostring(DayList[2].Get_Min)
	
	UISpecialFavourable.Controls.DayThreeNeedMoney.text = tostring(DayList[3].NeedRmb)
	UISpecialFavourable.Controls.DayThreeRandomMoney.text = tostring(DayList[3].Get_Min)
end

function UISpecialFavourable:ShowInfo()
	this:ShowWeekInfo()
	this:ShowDayInfo()
end

function UISpecialFavourable:ShowWeekInfo()
	if GameMain.IOSTest == true then
		this:ShowNormalWeek()
		return
	end
	local isExprite = SpecialFavourableSys.IsWeekExpire()
	if isExprite == true then
		this:ShowNormalWeek()
	else
		if SpecialFavourableSys.EveryWeekList[1] == nil then
			this:ShowNormalWeek()
		else
			GameMain.OpenObj(UISpecialFavourable.Controls.WeekOneHasBuy)
			GameMain.CloseObj(UISpecialFavourable.Controls.WeekOneBuy)
			if SpecialFavourableSys.EveryWeekList[2] == nil  then
				GameMain.CloseObj(UISpecialFavourable.Controls.WeekTwoHasBuy)
				GameMain.OpenObj(UISpecialFavourable.Controls.WeekTwoBuy)
			else
				GameMain.OpenObj(UISpecialFavourable.Controls.WeekTwoHasBuy)
				GameMain.CloseObj(UISpecialFavourable.Controls.WeekTwoBuy)
			end
		end
		
	end
end

function UISpecialFavourable:ShowNormalWeek()
	GameMain.CloseObj(UISpecialFavourable.Controls.WeekOneHasBuy)
	GameMain.CloseObj(UISpecialFavourable.Controls.WeekTwoHasBuy)
	GameMain.OpenObj(UISpecialFavourable.Controls.WeekTwoBuy)
	GameMain.OpenObj(UISpecialFavourable.Controls.WeekOneBuy)
end

function UISpecialFavourable:ShowDayInfo()
	if GameMain.IOSTest == true then
		this:ShowNoBuyDay()
		return
	end
	local isBuy = SpecialFavourableSys.IsBuyDayRecharge()
	if isBuy == true then
		this:ShowBuyDay()
	else
		this:ShowNoBuyDay()
	end
end

function UISpecialFavourable:ShowNoBuyDay()
	GameMain.CloseObj(UISpecialFavourable.Controls.DayOneHasBuy)
	GameMain.CloseObj(UISpecialFavourable.Controls.DayTwoHasBuy)
	GameMain.CloseObj(UISpecialFavourable.Controls.DayThreeHasBuy)
	GameMain.OpenObj(UISpecialFavourable.Controls.DayOneBuy)
	GameMain.OpenObj(UISpecialFavourable.Controls.DayTwoBuy)
	GameMain.OpenObj(UISpecialFavourable.Controls.DayThreeBuy)
end

function UISpecialFavourable:ShowBuyDay()
	GameMain.OpenObj(UISpecialFavourable.Controls.DayOneHasBuy)
	GameMain.OpenObj(UISpecialFavourable.Controls.DayTwoHasBuy)
	GameMain.OpenObj(UISpecialFavourable.Controls.DayThreeHasBuy)
	GameMain.CloseObj(UISpecialFavourable.Controls.DayOneBuy)
	GameMain.CloseObj(UISpecialFavourable.Controls.DayTwoBuy)
	GameMain.CloseObj(UISpecialFavourable.Controls.DayThreeBuy)
end

function UISpecialFavourable:UIHand(_LuaName , _Gob)
   MusicManagerSys.ButtonClick()
	if _Gob.name=="CloseBtn" then
      this:ClosePanel()
   end
	if _Gob.name == "Buy" then
		local parentName = _Gob.transform.parent.name
		if parentName == "BagOne" then
			this:ToBuyWeekDiamoned(1)
		end
		if parentName == "BagTwo" then
			this:ToBuyWeekDiamoned(2)
		end
		local parent = _Gob.transform.parent.parent.parent.name
		if parent == "EveryDayFavourable" then
			this:ToBuyEveryDayRecharge(parentName)
		end
	end
end

function UISpecialFavourable:ToBuyWeekDiamoned(Index)
	
	local data = UISpecialFavourable.CurBuyWeekData
	local nextData = EveryWeekPreferentialConfig.GetDataById(data.NextId)
	UISpecialFavourable.ClickBuyWeedData = nil
	local myownDiamoned = ClinetInfomation.GetDiamond()
	if Index == 1 then
		if myownDiamoned < data.NeedRmb then
			DataUIInstance.PopTip(UIstring.DiamonedIsNotEngth)
			return
		end
--		SpecialFavourableSys.BuyEveryWeekById(data.Id)
		SpecialFavourableSys.BuyEveryWeekById(data.AppStore_Id)
		UISpecialFavourable.ClickBuyWeedData = data
--		this:ShowRecTips(data)
	end
	
	if Index == 2 then
		if GameMain.IOSTest == false then
			if SpecialFavourableSys.EveryWeekList[1] == nil then
				DataUIInstance.PopTip("需先购买礼包一")
				return
			end
		end	
		if myownDiamoned < nextData.NeedRmb then
			DataUIInstance.PopTip(UIstring.DiamonedIsNotEngth)
			return
		end
		UISpecialFavourable.ClickBuyWeedData = nextData
--		local nextData = EveryWeekPreferentialConfig.GetDataById(data.NextId)
--		this:ShowRecTips(nextData)
--		SpecialFavourableSys.BuyEveryWeekById(data.NextId)
		SpecialFavourableSys.BuyEveryWeekById(nextData.AppStore_Id)
	end
	
end

function UISpecialFavourable:ShowBuyWeedAfter()
	this:ShowWeekInfo()
	this:ShowRecTips(UISpecialFavourable.ClickBuyWeedData)
end

function UISpecialFavourable:ShowRecTips(_Data)
	local data = GiftDataConfig.GetGiftDataBuyId(_Data.Reward)
	local list = {}
	list[1] = data	
	list[1].Count = 1
	DataUIInstance.OpenRewards(list)
end

function UISpecialFavourable:ToBuyEveryDayRecharge(_Name)
	local data = nil
	if _Name == "One" then
		data = UISpecialFavourable.DayList[1]
	end
	if _Name == "Two" then
		data = UISpecialFavourable.DayList[2]
	end
	if _Name == "Three" then
		data = UISpecialFavourable.DayList[3]
	end
	local myOwnDiamoned = ClinetInfomation.GetDiamond()
	if myOwnDiamoned < data.NeedRmb then
		DataUIInstance.PopTip(UIstring.DiamonedIsNotEngth)
		return
	end
	
	SpecialFavourableSys.BuyEveryDayById(data.Id)
end

function UISpecialFavourable:ShowBuyEveryDayRechargeAfter(_Data)
	local str = "获得" .. _Data .. "元宝"
	local _Reward = ItemDataSys.GetResourceData(1 ,_Data)
	local rewardData = {}
	rewardData = _Reward.Item
	rewardData.Count = _Data
	local list =
	{
		[1] = rewardData
	}
	DataUIInstance.OpenRewards(list)
	this:ShowDayInfo()
end


function UISpecialFavourable:ClosePanel()
   UISpecialFavourable.UISpecialFavourableGob.gameObject:SetActive(false)
end

function UISpecialFavourable:ReleasPanel()
	--UI
	UISpecialFavourable.UISpecialFavourableGob = nil
	UISpecialFavourable.Controls = {}

	--Data
	UISpecialFavourable.CurBuyWeekData = nil
	UISpecialFavourable.DayList = {}
	UISpecialFavourable.ClickBuyWeedData = nil
end

function UISpecialFavourable:ReleasData()
	SpecialFavourableSys.EveryDayList = {}
	SpecialFavourableSys.EveryWeekList = {}

	SpecialFavourableSys.WeekExpireTime = 0	--每周特惠过期时间戳
	SpecialFavourableSys.DayExpireTime = 0	--每日一充过期时间戳

end

return UISpecialFavourable