UIFirstRecharge = {}
local UIFirstRecharge = BasePanel:new()     
local this = UIFirstRecharge
UIFirstRecharge.UIFirstRechargeGob = nil

function UIFirstRecharge:OpenUI()
	if UIFirstRecharge.UIFirstRechargeGob == nil then
		UIFirstRecharge.UIFirstRechargeGob = MainGameUI.FindPanel("UIFirstRecharge")
	end
   
   this:SetReward()
	this:ShowBtnInfo()
end

UIFirstRecharge.FRReward = nil
UIFirstRecharge.SpReward = nil
function UIFirstRecharge:SetReward()
   if UIFirstRecharge.FRReward == nil then
      local _RewardString , _SpString = ConstConfig.GetFirstRechargeReward() 
      local _TempReward = RewardContentSys.GetRewardListString(_RewardString)
      local _Reward = RewardContentSys.GetRewardIncludeResourceByList(_TempReward)
      UIFirstRecharge.FRReward = _Reward 
      local _SpReward = RewardContentSys.GetRewardListString(_SpString)
      UIFirstRecharge.SpReward = _SpReward
   end
  
   for i = 1 , 6 , 1 do
       if UIFirstRecharge.FRReward.Items[i]==nil then
          UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("ItemGrid"):FindChild(tostring(i)).gameObject:SetActive(false)
       else
          UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("ItemGrid"):FindChild(tostring(i)).gameObject:SetActive(true)
          local _Sprite = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("ItemGrid"):FindChild(tostring(i)):FindChild("Img"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_Sprite , UIFirstRecharge.FRReward.Items[i].AtlasName , UIFirstRecharge.FRReward.Items[i].SpriteName)
	      local _Bg = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("ItemGrid"):FindChild(tostring(i)):FindChild("BG"):GetComponent("UISprite")
	      _Bg.spriteName = UIstring.ItemFg[UIFirstRecharge.FRReward.Items[i].Quality]
          local _Fg = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("ItemGrid"):FindChild(tostring(i)):FindChild("Quality"):GetComponent("UISprite")
	      _Fg.spriteName = UIstring.ItemFg[UIFirstRecharge.FRReward.Items[i].Quality]
			local count = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("ItemGrid"):FindChild(tostring(i)):FindChild("Count"):GetComponent("UILabel")
			count.text = tostring(UIFirstRecharge.FRReward.Items[i].Count)
		end
   end
  local _SpSprite = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("itemIcon"):FindChild("Img"):GetComponent("UISprite")
  AtlasMsg.SetAtlas(_SpSprite , UIFirstRecharge.SpReward.Items[1].AtlasName , UIFirstRecharge.SpReward.Items[1].SpriteName)
  local bg = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("itemIcon"):FindChild("BG"):GetComponent("UISprite")
  bg.spriteName = UIstring.ItemFg[UIFirstRecharge.SpReward.Items[1].Quality]
  local Fg = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("itemIcon"):FindChild("Quality"):GetComponent("UISprite")
  Fg.spriteName = UIstring.ItemFg[UIFirstRecharge.SpReward.Items[1].Quality]
	local oneCount = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("itemIcon"):FindChild("Count"):GetComponent("UILabel")
	oneCount.text = tostring( UIFirstRecharge.SpReward.Items[1].Count)
end

UIFirstRecharge.BtnLabel = nil

function UIFirstRecharge:ShowBtnInfo()
	if UIFirstRecharge.BtnLabel == nil then
		UIFirstRecharge.BtnLabel = UIFirstRecharge.UIFirstRechargeGob.transform:FindChild("PourMoneyBtn/Label"):GetComponent("UILabel")
	end
	if  RechargeSys.IsFrist == 1 then
		UIFirstRecharge.BtnLabel.text = "领取"
	end
	if RechargeSys.IsFrist == 0 then
		UIFirstRecharge.BtnLabel.text = "充点小钱"
	end
end

function UIFirstRecharge:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
   if _Gob.name=="CloseBtn" then
      this:ClosePanel()
   end
	if _Gob.name == "PourMoneyBtn" then
		this:ToBtn()
	end
end

function UIFirstRecharge:ToBtn()
	if RechargeSys.IsFrist == 0 then
		DataUIInstance.OpenRecharge()
	end
	if RechargeSys.IsFrist == 1 then
		RechargeSys.RecFirstRwd()
		this:ShowRecTips()
	end
	this:ClosePanel()
end

function UIFirstRecharge:ShowRecTips()
	local list = {}
	for i=1,#UIFirstRecharge.FRReward.Items,1  do
		table.insert(list , #list +1 ,UIFirstRecharge.FRReward.Items[i])
	end
	table.insert(list , #list+1 , UIFirstRecharge.SpReward.Items[1])
	DataUIInstance.OpenRewards(list)
end

function UIFirstRecharge:ClosePanel()
   UIFirstRecharge.UIFirstRechargeGob.gameObject:SetActive(false)
end


function UIFirstRecharge:ReleasPanel()
	UIFirstRecharge.UIFirstRechargeGob = nil
	UIFirstRecharge.FRReward = nil
	UIFirstRecharge.SpReward = nil
	UIFirstRecharge.BtnLabel = nil
end

function UIFirstRecharge:ReleasData()
	RechargeSys.RechargeDataList = {}
	RechargeSys.IsFrist = 0		-- 0没有首冲， 1 已经首充值
	RechargeSys.IsRecFrist = 0	--是否领取了首冲奖励

	RechargeSys.BuyGoods = 
	{
		["Recharge"] = false,--购买元宝,金券
		["EveryWeekSpecail"] = false, --每周特惠
		["EveryDaySpecail"] = false, -- 每日充值
		["VipSpecail"] = false,	--VIP特惠
		["Fund"] = false, --基金
	}
end
return UIFirstRecharge