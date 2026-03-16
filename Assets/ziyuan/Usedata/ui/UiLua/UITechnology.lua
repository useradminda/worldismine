--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UITechnology = {}
UITechnology=BasePanel:new()
local this = UITechnology
--UI相关
UITechnology.UITechnologyGob = nil
UITechnology.ClickTagGod = nil

UITechnology.GodList = {}

UITechnology.Controls = {}

--Data相关
UITechnology.HeroDataList = {}
UITechnology.SoliderDataList = {}

UITechnology.ClickIndex = 0		--点击选择的那个科技Item
UITechnology.lvl = 0
UITechnology.ClickType = 0		--用于区别点击的那个tag类型 0 武将 1 士兵

UITechnology.HandleHeroIndexList = {}	--记录下需要操作的武将Index
UITechnology.HandleSoliderIndexList = {} --记录下需要操作的士兵index

function UITechnology:OpenUI(_PanelName , _LuaName)
	if UITechnology.UITechnologyGob == nil then
		UITechnology.UITechnologyGob = MainGameUI.FindPanel("UITechnology")
		this:GetControls()
		TechnologyDataSys.Init()
	end
	if UITechnology.lvl ~= ClinetInfomation.Lvl then	--等级与主角等级不一致时进行重新获取数据
		this:GetInitData()
	end
	UITechnology.ClickType = 0 --默认武将
	UITechnology.ClickTagGod = UITechnology.UITechnologyGob.transform:FindChild("Tags/HeroTag")
	GameMain.CloseObj(UITechnology.clickOtherTagGod.transform:FindChild("click"))
	GameMain.OpenObj(UITechnology.clickOtherTagGod.transform:FindChild("normal")) 
	this:ChangeTag(0 , UITechnology.ClickTagGod)
--	this:ShowList(UITechnology.HeroDataList , UITechnology.ClickType)
end

function UITechnology:GetInitData()
	UITechnology.HeroDataList = {}
	UITechnology.SoliderDataList = {}
	local heroList = TechnologyDataSys.GetHeros()
	for i=1,#heroList,1 do
		UITechnology.HeroDataList[i] = heroList[i]
	end
	
	local soliderList = TechnologyDataSys.GetSoldiers()
	for j=1,#soliderList,1  do
	
		UITechnology.SoliderDataList[j] = soliderList[j]
	end
end

function UITechnology:GetControls()			--得到相关控件
	UITechnology.ClickTagGod = UITechnology.UITechnologyGob.transform:FindChild("Tags/HeroTag")
	UITechnology.clickOtherTagGod = UITechnology.UITechnologyGob.transform:FindChild("Tags/SoliderTag")
	UITechnology.Controls.UIWrap = UITechnology.UITechnologyGob.transform:FindChild("Lists"):GetComponent("UIWrap")
	UITechnology.Controls.ListPanel = UITechnology.Controls.UIWrap.transform:FindChild("Panel"):GetComponent("UIPanel")

	UITechnology.Controls.GridList = UITechnology.Controls.ListPanel.transform:FindChild("Grid"):GetComponent("UIGrid")
	UITechnology.Controls.Des = UITechnology.UITechnologyGob.transform:FindChild("Des"):GetComponent("UILabel")
	
	UITechnology.Controls.AboutSlider = UITechnology.UITechnologyGob.transform:FindChild("AboutSlider")
	UITechnology.Controls.Solider = UITechnology.Controls.AboutSlider.transform:FindChild("Slider"):GetComponent("UISlider")
	UITechnology.Controls.SoliderNum = UITechnology.Controls.AboutSlider.transform:FindChild("sliderNum"):GetComponent("UILabel")
	UITechnology.Controls.TopDes = UITechnology.Controls.AboutSlider.transform:FindChild("desTop"):GetComponent("UILabel")
	UITechnology.Controls.DownDes = UITechnology.Controls.AboutSlider.transform:FindChild("desDown"):GetComponent("UILabel")
	UITechnology.Controls.BuyBtnLabel = UITechnology.Controls.AboutSlider.transform:FindChild("BuyBtn/Move"):GetComponent("UILabel")
end

function UITechnology:ChangeTag(tagNum , _God)						

	if UITechnology.ClickTagGod ~= nil then
		GameMain.CloseObj(UITechnology.ClickTagGod.transform:FindChild("click")) 
		GameMain.OpenObj(UITechnology.ClickTagGod.transform:FindChild("normal")) 
	end
	UITechnology.ClickTagGod = _God
	GameMain.OpenObj(UITechnology.ClickTagGod.transform:FindChild("click")) 
	GameMain.CloseObj(UITechnology.ClickTagGod.transform:FindChild("normal"))

	UITechnology.ClickType = tagNum
	
	if UITechnology.ClickType == 0 then					--0是武将 1是士兵 
		this:ShowList(UITechnology.HeroDataList , UITechnology.ClickType)
	else
		this:ShowList(UITechnology.SoliderDataList , UITechnology.ClickType)
	end
	
end

function UITechnology:ClearGodList()
	if #UITechnology.GodList >0 then
		for key,value in pairs(UITechnology.GodList) do
			GameMain.CloseObj(value)
		end
	end
end

function UITechnology:ShowList(_List , _Type)	--_Type 0是武将；1是士兵
	UITechnology.Controls.ListPanel.transform.localPosition = Vector3(0 , 0 , 0)
	UITechnology.Controls.ListPanel.clipOffset = Vector2(0, 0)
	UITechnology.Controls.UIWrap:ResetTrans(#_List)
	this:ClearGodList()
	if #UITechnology.GodList == 0 then
		for i=1,20,1  do
			local data = 
			{
				Index = i,
				Type = _Type
			}
		MainGameUI.CreateLittleItem(tostring(i) , "TechnologyItem" , UITechnology.Controls.GridList , data , this.CreateListCallBack , "UITechnology") 
		end
	else
		for i=1,20,1  do
			local data = 
			{
				Index = i,
				Type = _Type,
			}
			if UITechnology.GodList[i] ~= nil then
				this:CreateListCallBack(UITechnology.GodList[i],data)
			else
				MainGameUI.CreateLittleItem(tostring(i) , "TechnologyItem" , UITechnology.Controls.GridList , data , this.CreateListCallBack , "UITechnology") 
			end
		end
		
	end
end

function UITechnology:CreateListCallBack(_Gob , _Info)
	
	if _Info.Index == 20 then
		UITechnology.Controls.GridList.enabled = true
		UITechnology.Controls.GridList:Reposition()
		if _Info.Type == 0 then
			UITechnology.Controls.UIWrap:SetData(#UITechnology.HeroDataList , "UITechnology")
			this:ShowClickItemInfo( 1 ,UITechnology.HeroDataList[1])
		end
		if _Info.Type ==1 then
			UITechnology.Controls.UIWrap:SetData(#UITechnology.SoliderDataList , "UITechnology")
			
			this:ShowClickItemInfo( 1 ,UITechnology.SoliderDataList[1])
		end
		
	end
	UITechnology.GodList[_Info.Index] = _Gob

	if _Info.Type == 0 then
		this:ShowTechnologyItem(UITechnology.HeroDataList[_Info.Index] , _Gob)		
	end

	if _Info.Type ==1 then
		this:ShowTechnologyItem(UITechnology.SoliderDataList[_Info.Index] , _Gob)	
	end

end

function UITechnology:UpdateItem(_LuaName , _Item) 
		local id = tonumber(_Item.name)
		UITechnology.GodList[id] = _Item
		
		if UITechnology.ClickType == 0 then
			--武将
			this:ShowTechnologyItem(UITechnology.HeroDataList[id] , _Item)
		else
			--士兵
			this:ShowTechnologyItem(UITechnology.SoliderDataList[id] , _Item)
		end

end

function UITechnology:ShowTechnologyItem(_Data , _Gob)
	if _Data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	local index = tonumber(_Gob.name)
	
	GameMain.OpenObj(_Gob)

	if index~=UITechnology.ClickIndex then
		GameMain.CloseObj(_Gob.transform:FindChild("Click"))
	else
		GameMain.OpenObj(_Gob.transform:FindChild("Click"))
	end

	local info = _Gob.transform:FindChild("info")
	local who = _Gob.transform:FindChild("who")

	local img = info.transform:FindChild("IMG"):GetComponent("UISprite")
	local name = info.transform:FindChild("name"):GetComponent("UILabel")
	local canCost = info.transform:FindChild("CanCost")
	local Complete = info.transform:FindChild("completeStudy")
	local canStudy = info.transform:FindChild("canStudying")
	local studyTxt = info.transform:FindChild("studying"):GetComponent("UILabel")
	local studyTime = studyTxt.transform:FindChild("time"):GetComponent("UILabel")
	GameMain.CloseObj(info)
	GameMain.CloseObj(who)
	GameMain.CloseObj(canStudy)
	GameMain.CloseObj(canCost)
	GameMain.CloseObj(studyTxt.gameObject)
	GameMain.CloseObj(Complete)
	AtlasMsg.SetAtlas(img , _Data.AtlasName , _Data.SpriteName)
	if _Data.Learn_Lvl > ClinetInfomation.Lvl then
		GameMain.OpenObj(who)
		return
	else
		GameMain.OpenObj(info)
	end

	name.text = tostring(_Data.Name)

	local handleId = TechnologySys.GetHandleId(_Data.Class)
	if handleId~=0 then
		if _Data.Dbid < handleId then
			GameMain.OpenObj(Complete)
			GameMain.CloseObj(studyTxt)
			return
		end
	end

	if _Data.state == 1 then
		GameMain.OpenObj(canCost)
		return
	end
	local state = _Data:GetState()
--1可投资 2 可研究 3研究中 4 研究完成
	if state == 1 then
		
		GameMain.OpenObj(canCost)
	end
	if state == 2 then
		
		GameMain.OpenObj(canStudy)
	end
	if state == 3 then
		
		GameMain.OpenObj(studyTxt)
		
		this:SetIndexList(_Data.Class , index)
	end
	if state == 4 then
		GameMain.OpenObj(Complete)
		GameMain.CloseObj(studyTxt)
	end
end

function UITechnology:SetIndexList( _Type,_Index)

	if UITechnology.ClickType == 0 then
		--武将
		UITechnology.HandleHeroIndexList[_Type]=_Index 

	else
		UITechnology.HandleSoliderIndexList[_Type]=_Index 
	end

	if _Type ==1 then
		GameMain.AddUpdateLua(this.UpdateTimeOne)
	elseif _Type == 2 then
		GameMain.AddUpdateLua(this.UpdateTimeTwo)
	elseif _Type == 3 then
		GameMain.AddUpdateLua(this.UpdateTimeThree)
	elseif _Type == 4 then
		GameMain.AddUpdateLua(this.UpdateTimeFour)
	elseif _Type == 5 then
		GameMain.AddUpdateLua(this.UpdateTimeFive)
	end

end

function UITechnology:UpdateTimeOne()
	if UITechnology.ClickType == 0 then
	
		local index =UITechnology.HandleHeroIndexList[1]
		local data = UITechnology.HeroDataList[index]
		local timeName = "TechStudyTime" .. tostring(data.Dbid)
		local time = TimeControl.GetTime(timeName)

		this:UpdateTimeInfo(data ,time , index)
		if time == nil then
			GameMain.DelUpdateLua(this.UpdateTimeOne)
		end
		if time==0  then
			GameMain.DelUpdateLua(this.UpdateTimeOne)
		end
	end
end

function UITechnology:UpdateTimeTwo()
	if UITechnology.ClickType == 0 then
	
		local index =UITechnology.HandleHeroIndexList[2]
		local data = UITechnology.HeroDataList[index]
		local timeName = "TechStudyTime" .. tostring(data.Dbid)
		local time = TimeControl.GetTime(timeName)

		this:UpdateTimeInfo(data ,time , index)
		if time == nil then
			GameMain.DelUpdateLua(this.UpdateTimeTwo)
		end
		if time==0  then
			GameMain.DelUpdateLua(this.UpdateTimeTwo)
		end
	end
end
function UITechnology:UpdateTimeThree()
	if UITechnology.ClickType == 0 then
	
		local index =UITechnology.HandleHeroIndexList[3]
		local data = UITechnology.HeroDataList[index]
		local timeName = "TechStudyTime" .. tostring(data.Dbid)
		local time = TimeControl.GetTime(timeName)

		this:UpdateTimeInfo(data ,time , index)
		if time == nil then
			GameMain.DelUpdateLua(this.UpdateTimeThree)
		end
		if time==0  then
			GameMain.DelUpdateLua(this.UpdateTimeThree)
		end
	end
end
function UITechnology:UpdateTimeFour()
	if UITechnology.ClickType == 0 then
	
		local index =UITechnology.HandleHeroIndexList[4]
		local data = UITechnology.HeroDataList[index]
		local timeName = "TechStudyTime" .. tostring(data.Dbid)
		local time = TimeControl.GetTime(timeName)

		this:UpdateTimeInfo(data ,time , index)
		if time == nil then
			GameMain.DelUpdateLua(this.UpdateTimeFour)
		end
		if time==0  then
			GameMain.DelUpdateLua(this.UpdateTimeFour)
		end
	end
end

function UITechnology:UpdateTimeFive()
	if UITechnology.ClickType == 1 then
	
		local index =UITechnology.HandleSoliderIndexList[5]
		local data = UITechnology.SoliderDataList[index]
		local timeName = "TechStudyTime" .. tostring(data.Dbid)
		local time = TimeControl.GetTime(timeName)

		this:UpdateTimeInfo(data ,time , index)
		if time == nil then
			GameMain.DelUpdateLua(this.UpdateTimeFive)
		end
		if time==0  then
			GameMain.DelUpdateLua(this.UpdateTimeFive)
		end
	end
end

function UITechnology:UpdateTimeInfo(_Data , _Time , _Index)
		
		local studyTime = UITechnology.GodList[_Index].transform:FindChild("info/studying/time"):GetComponent("UILabel")
		local complete = UITechnology.GodList[_Index].transform:FindChild("info/completeStudy"):GetComponent("UILabel")
		if _Time == nil then
			GameMain.CloseObj(studyTime.transform.parent)
			GameMain.OpenObj(complete)
		else
			if _Time<=0 then
				GameMain.CloseObj(UITechnology.Controls.AboutSlider)
				GameMain.OpenObj(UITechnology.Controls.Des)
				GameMain.CloseObj(studyTime.transform.parent)
				GameMain.OpenObj(complete)
			
				_Data.PourTime = _Data.Times
				_Data.EndTime = ClinetInfomation.WorldTime
				this:SetCompleteTech(_Data)
				if _Data.Next_Id ~=0 then
					
					TechnologyDataSys.SetNextDataState( _Data.Next_Id, _Data.Class)
						
					this:ShowNextItem(_Index+1)
				end
			else
--				GameMain.OpenObj(studyTime.transform.parent)
				studyTime.text = TimeControl.GetTimeString(_Time)
			end
				
		end
end

function UITechnology:SetCompleteTech(_Data)
	if UITechnology.ClickType == 0 then
		for key,value in pairs(UITechnology.HeroDataList) do
			if value.Dbid == _Data.Dbid then
				UITechnology.HeroDataList[key] = _Data
				return
			end
		end
		
	else
		for key,value in pairs(UITechnology.SoliderDataList) do
			if value.Dbid == _Data.Dbid then
				UITechnology.SoliderDataList[key] = _Data
				return
			end
		end
	end
end

function UITechnology:ShowNextItem(_Index)
		--武将
		 GameMain.OpenObj(UITechnology.GodList[_Index].transform:FindChild("info/CanCost"))
	
end

function UITechnology:ShowClickItemInfo(_Index , _Data)		--显示点击科技item后的信息
	if UITechnology.ClickIndex ~= 0 then
		GameMain.CloseObj(UITechnology.GodList[UITechnology.ClickIndex].transform:FindChild("Click"))		
	end
	UITechnology.ClickIndex = _Index
	GameMain.OpenObj(UITechnology.GodList[UITechnology.ClickIndex].transform:FindChild("Click"))	

	GameMain.DelUpdateLua(this.ShowUpdateClickInfo)
	
	if _Data == nil then
		GameMain.CloseObj(UITechnology.Controls.AboutSlider)
		GameMain.CloseObj(UITechnology.Controls.Des)
	else
		this:ShowClickTypeItemInfo(_Index ,UITechnology.ClickType , _Data)
	end
end

function UITechnology:ShowClickTypeItemInfo(_Index , _Type , _Data)
	
	if _Data.Learn_Lvl >ClinetInfomation.Lvl then
		GameMain.CloseObj(UITechnology.Controls.AboutSlider)
		GameMain.OpenObj(UITechnology.Controls.Des)
		UITechnology.Controls.Des.text = "你需要达到" .. tostring(_Data.Learn_Lvl) .. "级才能解锁"
		return
	end

	if _Data.State == 1 and _Data.PourTime==0 then
		GameMain.OpenObj(UITechnology.Controls.AboutSlider)
		GameMain.CloseObj(UITechnology.Controls.Des)
		UITechnology.Controls.TopDes.text = _Data.DesCription
		GameMain.OpenObj(UITechnology.Controls.SoliderNum)
		UITechnology.Controls.BuyBtnLabel.text = "注资"
		local sliderValue = _Data.PourTime / _Data.Times
		UITechnology.Controls.Solider.value = sliderValue
		UITechnology.Controls.SoliderNum.text = tostring(_Data.PourTime) .. "/" .. tostring(_Data.Times)
		UITechnology.Controls.DownDes.text ="注资一次需要资源:" .. tostring(_Data.Need_Money)
		return 
	end

	local god = UITechnology.GodList[_Index]
	local state = _Data:GetState()
	--1可投资 2 可研究 3研究中 4 研究完成
	if state == 1 then
		GameMain.OpenObj(UITechnology.Controls.AboutSlider)
		GameMain.OpenObj(UITechnology.Controls.SoliderNum)
		GameMain.CloseObj(UITechnology.Controls.Des)
		UITechnology.Controls.TopDes.text = _Data.DesCription
		GameMain.OpenObj(UITechnology.Controls.SoliderNum)
		UITechnology.Controls.BuyBtnLabel.text = "注资"
		local sliderValue = _Data.PourTime / _Data.Times
		UITechnology.Controls.Solider.value = sliderValue
		UITechnology.Controls.SoliderNum.text = tostring(_Data.PourTime) .. "/" .. tostring(_Data.Times)
		UITechnology.Controls.DownDes.text = "注资一次需要资源:" ..tostring(_Data.Need_Money)
	elseif state ==2 then
		GameMain.OpenObj(UITechnology.Controls.SoliderNum)
		GameMain.OpenObj(UITechnology.Controls.AboutSlider)
		
		GameMain.CloseObj(UITechnology.Controls.SoliderNum)
		GameMain.CloseObj(UITechnology.Controls.Des)
		UITechnology.Controls.TopDes.text = _Data.DesCription
		
		UITechnology.Controls.BuyBtnLabel.text = "研究"
		local sliderValue = _Data.PourTime / _Data.Times
		UITechnology.Controls.Solider.value = sliderValue
		UITechnology.Controls.SoliderNum.text = tostring(_Data.PourTime) .. "/" .. tostring(_Data.Times)
		UITechnology.Controls.DownDes.text ="研究需要时间：" .. UIstring.Green .. tostring(GameMain.RetainPoint( _Data.LearnTime,1)) .. "分钟".."[-]"
	elseif state ==3 then
		this:ShowClickStudyTechIng(_Data)
	else
		this:ShowClickStudyOver(_Data)
	end
end

function UITechnology:ShowClickStudyOver(_Data)--研究结束
	GameMain.CloseObj(UITechnology.Controls.AboutSlider)
	GameMain.OpenObj(UITechnology.Controls.Des)
	UITechnology.Controls.Des.text = _Data.DesCription
end


function UITechnology:ShowClickStudyTechIng(_Data)	--研究中
	GameMain.OpenObj(UITechnology.Controls.AboutSlider)
	UITechnology.Controls.BuyBtnLabel.text = "加速"
	GameMain.CloseObj(UITechnology.Controls.Des)
	GameMain.CloseObj(UITechnology.Controls.SoliderNum)
	UITechnology.Controls.TopDes.text = _Data.DesCription
	GameMain.AddUpdateLua(this.ShowUpdateClickInfo)
end

--如果点击的科技是研究中
function UITechnology:ShowUpdateClickInfo()
	local data = nil
	if UITechnology.ClickType == 0 then					--0是武将 1是士兵 
		data = UITechnology.HeroDataList[UITechnology.ClickIndex]
	else
		data = UITechnology.SoliderDataList[UITechnology.ClickIndex]
	end
	local time = TimeControl.GetTime("TechStudyTime" .. tostring(data.Dbid))
	if time==nil then
		GameMain.CloseObj(UITechnology.Controls.AboutSlider)
		GameMain.OpenObj(UITechnology.Controls.Des)
		GameMain.DelUpdateLua(this.ShowUpdateClickInfo)
		return
	end
	if time<=0 then
		UITechnology.Controls.Solider.value = 1
		GameMain.CloseObj(UITechnology.Controls.AboutSlider)
		GameMain.OpenObj(UITechnology.Controls.Des)
		GameMain.DelUpdateLua(this.ShowUpdateClickInfo)
	else
		local curTime = ClinetInfomation.WorldTime
		local delTime = data.EndTime - curTime
		
		UITechnology.Controls.DownDes.text ="研究需要时间:".. UIstring.Green .. TimeControl.GetTimeString(delTime).."[-]"
		local sliderValue =	(data.LearnTime*60 - delTime)/(data.LearnTime*60)
	
		UITechnology.Controls.Solider.value = sliderValue
	end
end


function UITechnology:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "HeroTag" then
		this:ChangeTag(0 , _Gob)
	end
	if _Gob.name == "SoliderTag" then
		this:ChangeTag(1 , _Gob)
	end

	if _Gob.name == "CloseBtn" then
		GameMain.CloseObj(UITechnology.UITechnologyGob)
	end
	local key = tonumber(_Gob.name)
	if key ~= nil then
		--根据现有的信息显示面板
		if UITechnology.ClickType == 0 then
			--武将
			this:ShowClickItemInfo(key , UITechnology.HeroDataList[key])
		else
			--士兵
			this:ShowClickItemInfo(key , UITechnology.SoliderDataList[key])
		end
	end
	if _Gob.name == "BuyBtn" then
		this:SendWebEvent()
	end
end

function UITechnology:SendWebEvent()
	local Index =  UITechnology.ClickIndex
	if Index~=0 then
		if UITechnology.ClickType == 0  then
			local data = UITechnology.HeroDataList[Index]
			this:SendWebItemEvent(data)
		else
			local soliderData = UITechnology.SoliderDataList[Index]
			this:SendWebItemEvent(soliderData)
		end
		
	end
end
----注资之后的显示
--function UITechnology:SetPourMoneyData(data)
--	if UITechnology.ClickType == 0  then
--		UITechnology.HeroDataList[UITechnology.ClickIndex]=data
--	else
--		UITechnology.SoliderDataList[UITechnology.ClickIndex] = data
--	end
--end

function UITechnology:SendWebItemEvent(data)
	
	local times = data.PourTime
	if times < data.Times then
		--注资
		local myMoney = ClinetInfomation.GetCoin()
		if myMoney<data.Need_Money then
			DataUIInstance.PopTip("铜钱不足")
			DataUIInstance.OpenCollect()
			return
		end
		local tempData = data
		tempData.PourTime = tempData.PourTime+1
		tempData.State =0 

		if UITechnology.ClickType == 0 then
			--武将
			UITechnology.HeroDataList[UITechnology.ClickIndex]  = tempData
		else
			--士兵
			UITechnology.SoliderDataList[UITechnology.ClickIndex] = tempData
		end
	
		data:PourMoney()
		times = times + 1
		
		local sliderValue = times/ data.Times
		UITechnology.Controls.Solider.value = sliderValue
		UITechnology.Controls.SoliderNum.text = tostring(times) .. "/" .. tostring(data.Times)
		
		if times == data.Times then
			UITechnology.Controls.BuyBtnLabel.text = "研究"
			local canStudy = UITechnology.GodList[UITechnology.ClickIndex].transform:FindChild("info/canStudying")
			GameMain.OpenObj(canStudy)
			local canPourmoney = UITechnology.GodList[UITechnology.ClickIndex].transform:FindChild("info/CanCost")
			GameMain.CloseObj(canPourmoney)
			UITechnology.Controls.DownDes.text ="研究需要时间：" .. UIstring.Green.. tostring(GameMain.RetainPoint( data.LearnTime,1)) .. "分钟" .. "[-]"
		else
			UITechnology.Controls.DownDes.text = "注资一次需要资源:" .. tostring(data.Need_Money)
			UITechnology.Controls.BuyBtnLabel.text = "注资"
		end
		DataUIInstance.PopTip("注资成功")	
	else
		local state = data:GetState()
		
		if state == 2 then
			--研究
			GameMain.OpenObj(UITechnology.Controls.AboutSlider)
			UITechnology.Controls.BuyBtnLabel.text = "加速"
	--		GameMain.OpenObj(UITechnology.Controls.Des)
			UITechnology.Controls.Des.text = data.DesCription
			data:StudyTech()
			DataUIInstance.PopTip("研究成功")
		end
		if state == 3 then
			
			this:ShowSpeedConfirmPop(data)
			
		end
	end
end		

function UITechnology:ShowSpeedConfirmPop(data)
	local needDimond = math.ceil( data.LearnTime/10)
	local msg = "是否使用"..UIstring.Green.. needDimond.."元宝".."[-]" .."加速科技研究？"
	DataUIInstance.PopConfirmPanel(msg , this.ConfirmSpeedTech , nil)
end

function UITechnology:ConfirmSpeedTech()
	local data = nil
	if UITechnology.ClickType == 0  then
		data = UITechnology.HeroDataList[UITechnology.ClickIndex]
	else
		data = UITechnology.SoliderDataList[UITechnology.ClickIndex]
	end
		
	local myDiamond = ClinetInfomation.GetDiamond()
	local needDimond = math.ceil( data.LearnTime/10)
	if myDiamond < needDimond then
		DataUIInstance.PopTip("元宝不足")
		DataUIInstance.OpenRecharge()
		return
	end
	TechnologySys.TechSpeed(data.Dbid)
	this:SpeedStudyTech(data)
end

function UITechnology:SpeedStudyTech(_Data)
	_Data.EndTime = ClinetInfomation.WorldTime
	this:ShowClickStudyOver(_Data)

	if UITechnology.ClickType == 0 then
		UITechnology.HeroDataList[UITechnology.ClickIndex] = _Data
		this:ShowTechnologyItem(_Data,UITechnology.GodList[UITechnology.ClickIndex])
	else
		UITechnology.SoliderDataList[UITechnology.ClickIndex] = _Data
		this:ShowTechnologyItem(_Data,UITechnology.GodList[UITechnology.ClickIndex])
	end

	if _Data.Class ==1 then
		GameMain.DelUpdateLua(this.UpdateTimeOne)
	elseif _Type == 2 then
		GameMain.DelUpdateLua(this.UpdateTimeTwo)
	elseif _Type == 3 then
		GameMain.DelUpdateLua(this.UpdateTimeThree)
	elseif _Type == 4 then
		GameMain.DelUpdateLua(this.UpdateTimeFour)
	elseif _Type == 5 then
		GameMain.DelUpdateLua(this.UpdateTimeFive)
	end
	if _Data.Next_Id ~=0 then
					
		TechnologyDataSys.SetNextDataState( _Data.Next_Id, _Data.Class)
						
		this:ShowNextItem(UITechnology.ClickIndex+1)
	end
	DataUIInstance.PopTip("加速完成")
end

function UITechnology:ShowStudyTechAfterInfo(_Data)			--研究后服务器返回信息后做相应的显示
	local canStudy = UITechnology.GodList[UITechnology.ClickIndex].transform:FindChild("info/canStudying")
	GameMain.CloseObj(canStudy)
	local studyTime = UITechnology.GodList[UITechnology.ClickIndex].transform:FindChild("info/studying")
	GameMain.OpenObj(studyTime)
	
	if UITechnology.ClickType == 0 then
		UITechnology.HeroDataList[UITechnology.ClickIndex] = _Data
		this:SetIndexList( UITechnology.HeroDataList[UITechnology.ClickIndex].Class , UITechnology.ClickIndex )
		
	else
		UITechnology.SoliderDataList[UITechnology.ClickIndex] = _Data
		this:SetIndexList(UITechnology.SoliderDataList[UITechnology.ClickIndex].Class , UITechnology.ClickIndex)
		
	end
	this:ShowClickStudyTechIng(_Data)
end

function UITechnology:ReleasPanel()
	--UI相关
	UITechnology.UITechnologyGob = nil
	UITechnology.ClickTagGod = nil

	UITechnology.GodList = {}

	UITechnology.Controls = {}

	--Data相关
	UITechnology.HeroDataList = {}
	UITechnology.SoliderDataList = {}

	UITechnology.ClickIndex = 0		--点击选择的那个科技Item
	UITechnology.lvl = 0
	UITechnology.ClickType = 0		--用于区别点击的那个tag类型 0 武将 1 士兵

	UITechnology.HandleHeroIndexList = {}	--记录下需要操作的武将Index
	UITechnology.HandleSoliderIndexList = {} --记录下需要操作的士兵index
	
	GameMain.DelUpdateLua(this.UpdateTimeOne)
	GameMain.DelUpdateLua(this.UpdateTimeTwo)
	GameMain.DelUpdateLua(this.UpdateTimeThree)
	GameMain.DelUpdateLua(this.UpdateTimeFour)
	GameMain.DelUpdateLua(this.UpdateTimeFive)

	GameMain.DelUpdateLua(this.ShowUpdateClickInfo)
end

function UITechnology:ReleasData()
	TechnologySys.HandleDataList = {}		--科技操作的数据
TechnologySys.TempStudyId = nil		--临时的研究数据

TechnologySys.LimitData = 
{
	["OwnHero"] = 0,	--拥有的武将上限
	["PveHero"] = 0,	--pve出站的武将上限
	["PvpHero"] = 0,	--Pvp出战的武将上限
	["HeroTrain"] = 0,	--训练的上限个数
	["SoliderUp"] = 0,	--士兵升阶的等级上限
}
		
end

return UITechnology
--endregion