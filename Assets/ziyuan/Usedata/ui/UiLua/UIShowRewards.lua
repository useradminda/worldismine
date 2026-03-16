--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIShowRewards = {}

UIShowRewards = BasePanel:new()
local this = UIShowRewards
--UI
UIShowRewards.UIShowRewardsGod = nil
UIShowRewards.Controls = {}
UIShowRewards.GodList = {}

--Data
UIShowRewards.DataList = {}
UIShowRewards.CurCreateNum = 1

function UIShowRewards:OpenUI(_PanelName , _LuaName)
	if UIShowRewards.UIShowRewardsGod == nil then
		UIShowRewards.UIShowRewardsGod = MainGameUI.FindPanel("UIShowRewards")
		this:GetControls()
	end
end

function UIShowRewards:GetControls()
	UIShowRewards.Controls.UIWrap =  UIShowRewards.UIShowRewardsGod.transform:FindChild("info/RewardsPanel"):GetComponent("UIWrap")
	UIShowRewards.Controls.UIGrid = UIShowRewards.Controls.UIWrap.transform:FindChild("RewardsGrid"):GetComponent("UIGrid")
	UIShowRewards.Controls.Effect = UIShowRewards.UIShowRewardsGod.transform:FindChild("FX_lingjiang01")
	UIShowRewards.Controls.Info = UIShowRewards.UIShowRewardsGod.transform:FindChild("info")
	UIShowRewards.Controls.InfoEff = UIShowRewards.Controls.Info.transform:FindChild("FX_lingjiang03")

	UIShowRewards.Controls.Tween = UIShowRewards.UIShowRewardsGod.transform:FindChild("info"):GetComponent("TweenScale")
end

function UIShowRewards:ShowInfo(_List)
	MusicManagerSys.Reward()
	UIShowRewards.DataList = {}
	for key,value in pairs(_List) do
		table.insert(UIShowRewards.DataList ,#UIShowRewards.DataList +1 , value)
	end
	GameMain.OpenObj(UIShowRewards.UIShowRewardsGod)
	GameMain.OpenObj(UIShowRewards.Controls.Effect)
	GameMain.CloseObj(UIShowRewards.Controls.Info)
	this:ToShowList()
end

function UIShowRewards:ToShowList()
	GameMain.OpenObj(UIShowRewards.Controls.Info)
	GameMain.CloseObj(UIShowRewards.Controls.InfoEff)
	UIShowRewards.Controls.Tween.enabled = true
	UIShowRewards.Controls.Tween:ResetToBeginning()
	UIShowRewards.Controls.Tween:Play()
	
	UIShowRewards.CurCreateNum = 1
	this:CreateList()

end

function UIShowRewards:CreateList()
	local len = #UIShowRewards.DataList
	UIShowRewards.Controls.UIWrap:ResetTrans(#UIShowRewards.DataList)
	UIShowRewards.Controls.UIWrap.transform.localPosition = Vector3(0,0,0)
	UIShowRewards.Controls.UIWrap.transform:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	
	this:ClearGodList()
	for i=1,6,1  do
		local data=
		{
			Index=i,
		}
		if UIShowRewards.GodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "RewardItem" , UIShowRewards.Controls.UIGrid , data , this.CreateListCallBack , "UIShowRewards") 
		else
			this:CreateListCallBack(UIShowRewards.GodList[i],data)
		end
	end
end

function UIShowRewards:ClearGodList()
	if #UIShowRewards.GodList>0 then
		for  i=1,#UIShowRewards.GodList,1  do
			GameMain.CloseObj(UIShowRewards.GodList[i])
		end
	end
end


function UIShowRewards:CreateListCallBack(_God,_Info)
	GameMain.CloseObj(_God)
	if _Info.Index == 6 then
		if #UIShowRewards.DataList <=5 then
			UIShowRewards.Controls.UIWrap:SetGridCenter()
			UIShowRewards.Controls.UIGrid.transform.localPosition = Vector3(-5.28,44.9,0)
		else
			UIShowRewards.Controls.UIWrap:SetGridTopLeft()
			UIShowRewards.Controls.UIGrid.transform.localPosition = Vector3(-199.4,44.9,0)
			UIShowRewards.Controls.UIWrap:SetData(#UIShowRewards.DataList , "UIShowRewards")
		end
		UIShowRewards.Controls.UIGrid.enabled = true
		UIShowRewards.Controls.UIGrid:Reposition()
		this:ShowItemList()
	end
	this:CreateItem(_Info.Index , _God)
end

function UIShowRewards:ShowItemList()
	this:ShowItemAndEff()
	TimeControl.LoginTime(0.2,"ShowRewardsListTime")
	GameMain.AddUpdateLua(this.UpDateTime)
end

function UIShowRewards:ShowItemAndEff()
	local _God = UIShowRewards.GodList[UIShowRewards.CurCreateNum]
	local data = UIShowRewards.DataList[UIShowRewards.CurCreateNum]
	if data == nil then
		GameMain.DelUpdateLua(this.UpDateTime)
		return
	end
	GameMain.OpenObj(_God)
	local eff = _God.transform:FindChild("FX_lingjiang02")
	if UIShowRewards.CurCreateNum>5 then
		GameMain.CloseObj(eff)
	else
		GameMain.OpenObj(eff)
	end
	UIShowRewards.Controls.UIGrid.enabled = true
	UIShowRewards.Controls.UIGrid:Reposition()
	if UIShowRewards.CurCreateNum<=5 then
		TimeControl.LoginTime(0.2,"ShowRewardsListTime")
		GameMain.AddUpdateLua(this.UpDateTime)
	else
		GameMain.DelUpdateLua(this.UpDateTime)
	end
end

function UIShowRewards.UpDateTime()
	local time = TimeControl.GetTime("ShowRewardsListTime")
	
	if time<=0 then
		UIShowRewards.CurCreateNum = UIShowRewards.CurCreateNum + 1
		this:ShowItemAndEff()
--		GameMain.DelUpdateLua(this.UpDateTime)
		return
	end
	
	
end

function UIShowRewards:CreateItem(_Index , _God)
	
	UIShowRewards.GodList[_Index] = _God
	
	local data = UIShowRewards.DataList[_Index]
	if data == nil then
		GameMain.CloseObj(_God)
		return
	else
		GameMain.CloseObj(_God)
		local img = _God.transform:FindChild("Img"):GetComponent("UISprite")
		local bg = _God.transform:FindChild("BG"):GetComponent("UISprite")
		local quality = _God.transform:FindChild("Quality"):GetComponent("UISprite")
		local count = _God.transform:FindChild("Label"):GetComponent("UILabel")
--		local eff = _God.transform:FindChild("FX_lingjiang02")
--		if _Index>5 then
--			GameMain.CloseObj(eff)
--		else
--			GameMain.OpenObj(eff)
--		end
		AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)
		local qualityValue = data.Quality
		if qualityValue == nil then
			qualityValue = data.quality
			if qualityValue == nil then
				qualityValue = 1
			end
		end
		quality.spriteName = UIstring.ItemFg[qualityValue]
		bg.spriteName = UIstring.ItemFg[qualityValue]
		count.text = tostring(data.Count)
	end
end

function UIShowRewards:UpdateItem(_LuaName , _Item) 
	local Index = tonumber(_Item.name)
	this:ShowItem(Index , _Item)
end

function UIShowRewards:ShowItem(_Index , _Item)
	this:CreateItem(_Index , _Item)
	GameMain.OpenObj(_Item)
end

function UIShowRewards:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "ConfirmBtn" then
		this:ClosePanel()
	end
	if _Gob.name == "CloseBtn" then
		this:ClosePanel()
	end
    if _Gob.name == "UIShowRewards" then
       this:ClosePanel()
    end
end

function UIShowRewards:ClosePanel()
	GameMain.CloseObj(UIShowRewards.UIShowRewardsGod)
end

function UIShowRewards:ReleasPanel()
	--UI
	UIShowRewards.UIShowRewardsGod = nil
	UIShowRewards.Controls = {}
	UIShowRewards.GodList = {}

	--Data
	UIShowRewards.DataList = {}
	GameMain.DelUpdateLua(this.UpDateTime)
--	GameMain.DelUpdateLua(this.UpDateTimeToShow)
end

return UIShowRewards
--endregion
