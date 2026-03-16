UIMonthRight = {}
local UIMonthRight = BasePanel:new()     
local this = UIMonthRight
--UI
UIMonthRight.UIMonthRightGob = nil

UIMonthRight.Controls = {}
--Data
UIMonthRight.GoldDataList = {}
UIMonthRight.SilverDataList = {}

UIMonthRight.GoldData = nil
UIMonthRight.SilverData = nil

function UIMonthRight:OpenUI()
	if UIMonthRight.UIMonthRightGob==nil then
		UIMonthRight.UIMonthRightGob=MainGameUI.FindPanel("UIMonthRight")
		this:GetControls()
		this:SetInitData()
	end
	this:ShowInfo()
	MonthCardSys.IsRwdGod()
end

function UIMonthRight:GetControls()
	UIMonthRight.Controls.GoldNeedDimoned = UIMonthRight.UIMonthRightGob.transform:FindChild("GoldMonth/Money/NeedMoney"):GetComponent("UILabel")
	UIMonthRight.Controls.SilverNeedDiamond = UIMonthRight.UIMonthRightGob.transform:FindChild("SilverMonth/Money/NeedMoney"):GetComponent("UILabel")
	UIMonthRight.Controls.GoldHasRwd = UIMonthRight.UIMonthRightGob.transform:FindChild("GoldMonth/hasReced")
	UIMonthRight.Controls.SilverHasRwd =  UIMonthRight.UIMonthRightGob.transform:FindChild("SilverMonth/hasReced")
	UIMonthRight.Controls.GoldRecBtnTxt = UIMonthRight.UIMonthRightGob.transform:FindChild("GoldMonth/ReceiveGold/Move"):GetComponent("UILabel")
	UIMonthRight.Controls.SilverRecBtnTxt = UIMonthRight.UIMonthRightGob.transform:FindChild("SilverMonth/ReceiveSilver/Move"):GetComponent("UILabel")
	UIMonthRight.Controls.GoldElusDayTxt = UIMonthRight.UIMonthRightGob.transform:FindChild("GoldMonth/TimeLimit/NeedMoney"):GetComponent("UILabel")
	UIMonthRight.Controls.SilverElusDayTxt = UIMonthRight.UIMonthRightGob.transform:FindChild("SilverMonth/TimeLimit/NeedMoney"):GetComponent("UILabel")

	UIMonthRight.Controls.GoldGodList = {}
	UIMonthRight.Controls.SilverGodList = {}
	local goldGrid = UIMonthRight.UIMonthRightGob.transform:FindChild("GoldMonth/Grid")
	local silverGrid = UIMonthRight.UIMonthRightGob.transform:FindChild("SilverMonth/Grid")
	for i=1,6,1  do
		UIMonthRight.Controls.SilverGodList[i] = silverGrid.transform:FindChild(tostring(i))
		UIMonthRight.Controls.GoldGodList[i] = goldGrid.transform:FindChild(tostring(i))
	end
end

function UIMonthRight:SetInitData()
	
	UIMonthRight.GoldData = MonthCardSys.GetGoldData()
	UIMonthRight.SilverData = MonthCardSys.GetSilverData()
	
	local goldList = MonthCardSys.GetGoldItemList()
	local silverList = MonthCardSys.GetSilverItemList()
	for i=1,#goldList,1 do
		UIMonthRight.GoldDataList[i] = goldList[i]
	end
	for i=1,#silverList,1 do
		UIMonthRight.SilverDataList[i] = silverList[i]
	end
	
end

function UIMonthRight:ShowInfo()
	this:ShowBuyInfo()
	this:ShowRewardInfo()
end

function UIMonthRight:ShowBuyInfo()
	this:ShowGoldBuyInfo()
	this:ShowSilverBuyInfo()
end

function UIMonthRight:ShowGoldBuyInfo()
	UIMonthRight.Controls.GoldNeedDimoned.text = tostring(UIMonthRight.GoldData.Diamond)
	local days = MonthCardSys.GoldElusDays()

	UIMonthRight.Controls.GoldElusDayTxt.text = tostring(days)
	local isHasBuy = MonthCardSys.IsHasBuyGod()
	
	if isHasBuy == false then
		GameMain.OpenObj(UIMonthRight.Controls.GoldRecBtnTxt.transform.parent)
		GameMain.CloseObj(UIMonthRight.Controls.GoldHasRwd)
		UIMonthRight.Controls.GoldRecBtnTxt.text = "购买"
		return
	end
	local isRecToday = MonthCardSys.IsRwdGod()
	if isRecToday == true then
		GameMain.CloseObj(UIMonthRight.Controls.GoldRecBtnTxt.transform.parent)
		GameMain.OpenObj(UIMonthRight.Controls.GoldHasRwd)
	else
		GameMain.OpenObj(UIMonthRight.Controls.GoldRecBtnTxt.transform.parent)
		GameMain.CloseObj(UIMonthRight.Controls.GoldHasRwd)
		UIMonthRight.Controls.GoldRecBtnTxt.text = "领取"
	end
end

function UIMonthRight:ShowSilverBuyInfo()
	UIMonthRight.Controls.SilverNeedDiamond.text = tostring(UIMonthRight.SilverData.Diamond)
	local days = MonthCardSys.SilverElusDays()

	UIMonthRight.Controls.SilverElusDayTxt.text = tostring(days)
	
	local isHasBuy = MonthCardSys.IsHasBuySilver()

	if isHasBuy == false then
		GameMain.OpenObj(UIMonthRight.Controls.SilverRecBtnTxt.transform.parent)
		GameMain.CloseObj(UIMonthRight.Controls.SilverHasRwd)
		UIMonthRight.Controls.SilverRecBtnTxt.text = "购买"
		return
	end
	local isRecToday = MonthCardSys.IsRwdSilver()
	if isRecToday == true then
		GameMain.CloseObj(UIMonthRight.Controls.SilverRecBtnTxt.transform.parent)
		GameMain.OpenObj(UIMonthRight.Controls.SilverHasRwd)
	else
		GameMain.OpenObj(UIMonthRight.Controls.SilverRecBtnTxt.transform.parent)
		GameMain.CloseObj(UIMonthRight.Controls.SilverHasRwd)
		UIMonthRight.Controls.SilverRecBtnTxt.text = "领取"
	end
end

function UIMonthRight:ShowRewardInfo()
	for i=1,#UIMonthRight.GoldDataList,1  do
		local data = UIMonthRight.GoldDataList[i]
		local god = UIMonthRight.Controls.GoldGodList[i]
		this:ShowItemInfo(god , data)
	end
	for i=1,#UIMonthRight.SilverDataList,1  do
		local data = UIMonthRight.SilverDataList[i]
		local god = UIMonthRight.Controls.SilverGodList[i]
		this:ShowItemInfo(god , data)
	end
end

function UIMonthRight:ShowItemInfo(God , Data)
	local img = God.transform:FindChild("Img"):GetComponent("UISprite")
	local quality = God.transform:FindChild("Quality"):GetComponent("UISprite")
	local count = God.transform:FindChild("Count"):GetComponent("UILabel")
	local bg = God.transform:FindChild("BG"):GetComponent("UISprite")
	bg.spriteName = UIstring.ItemFg[Data.Quality]
	AtlasMsg.SetAtlas(img , Data.AtlasName , Data.SpriteName)
	quality.spriteName = UIstring.ItemFg[Data.Quality]
	count.text = tostring(Data.Count)
end

function UIMonthRight:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()  
 if _Gob.name=="CloseBtn" then
      this:ClosePanel()
   end

	if _Gob.name == "ReceiveGold" then
		--黄金月卡
		this:BuyOrRecGold()
	end
	if _Gob.name == "ReceiveSilver" then
		--白银月卡
		this:BuyOrRecSilver()
	end
end

function UIMonthRight:BuyOrRecGold()
	local isHasBuy = MonthCardSys.IsHasBuyGod()
	if isHasBuy == false then
		local myDiamond = ClinetInfomation.GetDiamond()
		if myDiamond<UIMonthRight.GoldData.Diamond then
			DataUIInstance.PopTip("元宝不足")
			return
		end
		MonthCardSys.BuyMonthCard(102)
		DataUIInstance.PopTip("购买成功")
	else
		MonthCardSys.ReceiveMonthCard(102)
		this:ShowRecTips(UIMonthRight.GoldDataList)
	end
end

function UIMonthRight:BuyOrRecSilver()
	local isHasBuy = MonthCardSys.IsHasBuySilver()
	if isHasBuy == false then
		local myDiamond = ClinetInfomation.GetDiamond()
		if myDiamond<UIMonthRight.SilverData.Diamond then
			DataUIInstance.PopTip("元宝不足")
			return
		end
		MonthCardSys.BuyMonthCard(101)
		DataUIInstance.PopTip("购买成功")
	else
		MonthCardSys.ReceiveMonthCard(101)
		this:ShowRecTips(UIMonthRight.SilverDataList)
	end
end

function UIMonthRight:ShowRecTips(_list)
	DataUIInstance.OpenRewards(_list)
end

function UIMonthRight:ClosePanel()
   UIMonthRight.UIMonthRightGob.gameObject:SetActive(false)
end

function UIMonthRight:ReleasPanel()
	--UI
	UIMonthRight.UIMonthRightGob = nil

	UIMonthRight.Controls = {}
	--Data
	UIMonthRight.GoldDataList = {}
	UIMonthRight.SilverDataList = {}

	UIMonthRight.GoldData = nil
	UIMonthRight.SilverData = nil
end

function UIMonthRight:ReleasData()
	MonthCardSys.GoldExpireTime = 0		--黄金月卡的过期时间戳
	MonthCardSys.SilverExpireTime = 0	--白银月卡的过期时间戳

	MonthCardSys.GoldLastRwdTime = 0	--黄金月卡上次领取的时间戳
	MonthCardSys.SilverLastRwdTime = 0	--白银月卡上次领取的时间戳
end

return UIMonthRight