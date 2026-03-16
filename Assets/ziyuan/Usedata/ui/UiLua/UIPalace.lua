--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIPalace = {}
UIPalace = BasePanel:new()
local this = UIPalace
--UI
UIPalace.UIPalaceGod = nil
UIPalace.ElectPanel = nil
UIPalace.RedPanel = nil
UIPalace.AbilityPanel = nil
UIPalace.ChoosePanel = nil
UIPalace.OtherOffPosPanel = nil

UIPalace.JointBtn = nil

UIPalace.ElectControls = {}
UIPalace.ElectGodList = {}		--参与官员选举的玩家
UIPalace.AbilityControls = {}
UIPalace.AbilityGodList = {}	--官员特权
UIPalace.MainElectGodList = {}	--主界面的官员信息
UIPalace.OtherOffPosControls = {}

UIPalace.MainControls = {}		--初始化界面的控件
UIPalace.OtherOffPosGodList = {}
--Data
UIPalace.ElectDataList = {}		--参与官员选举的玩家数据
UIPalace.ElectPosNameList = {}	--官员选举的官职名字
UIPalace.AbilityRwdDataList = {}	--官员特权数据

UIPalace.voteCount = 0			--投票数量

UIPalace.OfficerDataList = {}	--王宫的排名

UIPalace.IsRecvied = 0				--是否领取

function UIPalace:OpenUI(_PanelName , _LuaName)
	if UIPalace.UIPalaceGod == nil then
		UIPalace.UIPalaceGod = MainGameUI.FindPanel("UIPalace")
		UIPalace.ElectPanel = UIPalace.UIPalaceGod.transform:FindChild("OffElectionPanel")
		UIPalace.RedPanel = UIPalace.UIPalaceGod.transform:FindChild("OffRedPanel")
		UIPalace.AbilityPanel = UIPalace.UIPalaceGod.transform:FindChild("OffAbilityPanel")
		UIPalace.ChoosePanel = UIPalace.UIPalaceGod.transform:FindChild("OffChoosePanel")
		UIPalace.OtherOffPosPanel = UIPalace.UIPalaceGod.transform:FindChild("OffPosPanel")

		this:GetMainControls()
		this:GetOfficialNameInfo()
		
	end
	this:ShowOriPanelInfo()

	PalaceSys.Init()--后续根据时间来判断是否需要请求

end


function UIPalace:GetOfficialNameInfo()
	local posList = OfficialDataConfig.GetDB()
	for key,value in pairs(posList) do
		table.insert(UIPalace.ElectPosNameList , #UIPalace.ElectPosNameList+1 , value)
	end
	table.sort(UIPalace.ElectPosNameList , UIPalace.Comp)
end

--region .*主界面显示
function UIPalace:OpenOtherOffPosPanel()
	UIPalace.MainControls.NextBtn.transform.localScale = Vector3(-1,1,1)
	GameMain.CloseObj(UIPalace.MainControls.Poses)
	GameMain.OpenObj(UIPalace.MainControls.TitleImg)
	GameMain.OpenObj(UIPalace.OtherOffPosPanel)
	if UIPalace.OtherOffPosControls.ScrewView == nil then
		this:GetOtherOffPosControls()
	end
	this:ShowOtherOffPosInfo()
end

function UIPalace:GetOtherOffPosControls()
	UIPalace.OtherOffPosControls.ScrewView = UIPalace.OtherOffPosPanel.transform:FindChild("PosList/PosListPanel"):GetComponent("UIScrollView")
	UIPalace.OtherOffPosControls.Grid = UIPalace.OtherOffPosControls.ScrewView.transform:FindChild("PosGrid"):GetComponent("UIGrid")
end

function UIPalace:ShowOtherOffPosInfo()
	UIPalace.OtherOffPosControls.ScrewView.currentMomentum = Vector3(0,0,0)
	local panel = UIPalace.OtherOffPosControls.ScrewView:GetComponent("UIPanel")
	panel.transform.localPosition = Vector3(0,0,0)
	panel.clipOffset = Vector2(0,0)
	this:CreateOtherOffPosList()

end

function UIPalace:CreateOtherOffPosList()
	for i=1,24,1 do
		local data =
		{
			Index = i,
		}
		if UIPalace.OtherOffPosGodList[i] ~= nil then
			this:CreateOtherOffPosCallBack(UIPalace.OtherOffPosGodList[i] , data)
		else
			MainGameUI.CreateLittleItem(tostring(i) , "OffPosItem" , UIPalace.OtherOffPosControls.Grid, data , this.CreateOtherOffPosCallBack , "UIPalace") 
		end
	end
	
end

function UIPalace:CreateOtherOffPosCallBack(_Gob , _Info)
	UIPalace.OtherOffPosGodList[_Info.Index] = _Gob
	
	local name = _Gob.transform:FindChild("name"):GetComponent("UILabel")
	local Img = _Gob.transform:FindChild("IMG"):GetComponent("UISprite")
	local no = _Gob.transform:FindChild("noPos")
	local titleName = _Gob.transform:FindChild("title/name"):GetComponent("UILabel")
	if _Info.Index <=8 then
		--前将军
		titleName.text = "前将军"
	else
		--中郎将	
		titleName.text = "中郎将"
	end
	local addPosNum = _Info.Index + 8
	local data = UIPalace.OfficerDataList[addPosNum]
	if data == nil then
		GameMain.CloseObj(name)
		GameMain.CloseObj(Img)
		GameMain.OpenObj(no)
	else
		GameMain.OpenObj(name)
		GameMain.OpenObj(Img)
		GameMain.CloseObj(no)
		
		name.text = "V" .. tostring(data.Lvl) .. " " .. UIstring.Yellow..data.Name.."[-]"
		local heroData = RoleDataConfig.GetRoleById(data.ModelId)
		if heroData~=nil then
			AtlasMsg.SetAtlas(Img , heroData.AtlasName , heroData.SpriteName)
		end
	end
	if _Info.Index == 24 then
		UIPalace.OtherOffPosControls.Grid.enabled = true
		UIPalace.OtherOffPosControls.Grid:Reposition()
	end
end


function UIPalace:ShowOriPanelInfo()
	UIPalace.MainControls.NextBtn.transform.localScale = Vector3(1,1,1)
	GameMain.OpenObj(UIPalace.MainControls.Poses)
	GameMain.CloseObj(UIPalace.MainControls.TitleImg)
	GameMain.CloseObj(UIPalace.OtherOffPosPanel)	
end

function UIPalace:GetMainControls()
	UIPalace.MainControls.NextBtn = UIPalace.UIPalaceGod.transform:FindChild("InitPanel/NextBtn")
	UIPalace.MainControls.JointBtn = UIPalace.UIPalaceGod.transform:FindChild("InitPanel/OpenJointBtn")
	UIPalace.MainControls.Poses = UIPalace.UIPalaceGod.transform:FindChild("Poses")
	UIPalace.MainControls.TitleImg = UIPalace.UIPalaceGod.transform:FindChild("InitPanel/title")
	for i=1,9,1  do
		UIPalace.MainElectGodList[i] = UIPalace.MainControls.Poses.transform:FindChild(tostring(i))
	end
	
end

function UIPalace:ShowPalaceInfo()
	this:SetInitData()
	UIPalace.voteCount = PalaceSys.VoteCount
	this:ShowJointInfo()
	
	for i=1,9,1  do
		this:ShowOffItemInfo(i)
	end
end

function UIPalace:ShowJointInfo()
	if PalaceSys.IsJoined ==0 then
		GameMain.OpenObj(UIPalace.MainControls.JointBtn)
	else
		GameMain.CloseObj(UIPalace.MainControls.JointBtn)
	end
end

function UIPalace:SetInitData()	--初始化王宫主界面数据
	UIPalace.OfficerDataList = PalaceSys.OfficerList
	UIPalace.IsRecvied = PalaceSys.IsRwdRecvd
end

function UIPalace:ShowOffItemInfo(Index)
	local god = UIPalace.MainElectGodList[Index]
	local model = god.transform:FindChild("Model")
	local no = god.transform:FindChild("no")

	local data = UIPalace.OfficerDataList[Index]
	if data ==nil then
		GameMain.CloseObj(model)
		GameMain.OpenObj(no)
		return
	end
	GameMain.OpenObj(model)
	GameMain.CloseObj(no)
	local name = model.transform:FindChild("name"):GetComponent("UILabel")
	name.text =  "V" .. tostring(data.Lvl) .. "[FFC01C]" .. tostring(data.Name) .."[-]"
	local heroModel = model.transform:FindChild("HeroModel")
	
	local hero = heroModel.transform:FindChild("Hero")
	if hero~=nil then
		 GameObject.Destroy(hero.gameObject)
	end

	local heroData  = RoleDataConfig.GetRoleById(data.ModelId)
	if heroData~=nil then
		Create3DModel.CreateThModel(heroData.FbxName , nil , 5 , heroModel, UIPalace.CreateModelCallBack , true , "Hero")  
	end
end


function UIPalace.CreateModelCallBack(NeedModel , _Data)
	NeedModel.gameObject.name = _Data
--	local eff = NeedModel.gameObject.transform:FindChild("Bip001/Bip001 Pelvis/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand/RightHand/1")
--	GameMain.CloseObj(eff)
	Create3DModel.CreateHorse(NeedModel , UIPalace.Create3DHorseCallBack)  
end

function UIPalace.Create3DHorseCallBack(_Model , _Data)
   _Model.transform.localPosition = Vector3(0 , -2 , 0)
end
--endregion

--region *.官员选举

function UIPalace:OpenElectPanel()
	GameMain.OpenObj(UIPalace.ElectPanel)
	this:InitElectData()
	PalaceSys.InitElect()
--	this:ShowElectPanelInfo()
	this:ShowMyModel()
end

function UIPalace:ShowMyModel()
	local model = UIPalace.ElectControls.MyModel.transform:FindChild("MyHero")
	if model ~=nil then
		 GameObject.Destroy(model.gameObject)
	end
	local heroData = HeroPackageSys.GetOneHeroBy_UUID(ClinetInfomation.GuaShuaiUUID)
	if heroData ~= nil then
		Create3DModel.CreateThModel(heroData.ModelName , nil , 5 , UIPalace.ElectControls.MyModel , UIPalace.CreateMyModelCallBack , true , "MyHero") 
	end
end

function UIPalace.CreateMyModelCallBack(NeedModel , _Data)
	NeedModel.gameObject.name = _Data
	 Create3DModel.CreateHorse(NeedModel , UIPalace.CreateMy3DHorseCallBack)  
end

function UIPalace.CreateMy3DHorseCallBack(_Model , _Data)
   _Model.transform.localPosition = Vector3(0 , -2 , 0)
end

function UIPalace:InitElectData()
	
	if UIPalace.ElectControls.UIWrap == nil then
		this:GetElectControls()
	end

end

function UIPalace.Comp(A , B)		--将官职按从小到大排序
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.Id>B.Id then
		return false
	end
	if A.Id == B.Id then
		return false
	end
	if A.Id < B.Id then
		return true
	end
end

function UIPalace:GetElectControls()
	UIPalace.ElectControls.UIWrap = UIPalace.ElectPanel.transform:FindChild("ElectList"):GetComponent("UIWrap")
	UIPalace.ElectControls.ListPanel = UIPalace.ElectControls.UIWrap.transform:FindChild("ElectListPanel"):GetComponent("UIPanel")
	UIPalace.ElectControls.Gird = UIPalace.ElectControls.ListPanel.transform:FindChild("ElectGrid"):GetComponent("UIGrid")

	local info = UIPalace.ElectPanel.transform:FindChild("MyInfo")
	UIPalace.ElectControls.MyPosName = info.transform:FindChild("titleName/name"):GetComponent("UILabel")
	UIPalace.ElectControls.MyArray = info.transform:FindChild("myArray/label"):GetComponent("UILabel")
	UIPalace.ElectControls.MyPos = info.transform:FindChild("myPos/label"):GetComponent("UILabel")
	UIPalace.ElectControls.FreeTimes = info.transform:FindChild("freeTimes/label"):GetComponent("UILabel")
	
	UIPalace.ElectControls.JointBtn = info.transform:FindChild("jointBtn")
	UIPalace.ElectControls.HasJointed = info.transform:FindChild("HasChoose")
	UIPalace.ElectControls.MyModel = info.transform:FindChild("Model")
end

function UIPalace:SetInitElectData()			--设置初始化官员选举玩家信息
	local list = PalaceSys.GetElectDataList()
	for i=1,#list,1 do
		UIPalace.ElectDataList[i] = list[i]
	end
end

function UIPalace:ShowElectPanelInfo()			--初始化显示官员选举信息
	this:SetInitElectData()

	if UIPalace.ElectControls.FreeTimes==nil then
		this:GetElectControls()
	end
	this:ShowMyElectInfo()
	this:ShowJointInfo()

	if PalaceSys.IsJoined == 0 then
		GameMain.OpenObj(UIPalace.ElectControls.JointBtn)
		GameMain.CloseObj(UIPalace.ElectControls.HasJointed)
	else
		GameMain.CloseObj(UIPalace.ElectControls.JointBtn)
		GameMain.OpenObj(UIPalace.ElectControls.HasJointed)
	end
	
	UIPalace.ElectControls.FreeTimes.text = tostring(UIPalace.voteCount)

	this:ShowElectList()
	
end

function UIPalace:ShowMyElectInfo() -- 显示选举界面中我的信息
	local myPos = PalaceSys.GetMyOffical()
	UIPalace.ElectControls.MyPosName.text = myPos
	UIPalace.ElectControls.MyPos.text = myPos
	if PalaceSys.IsJoined == 0 then -- 没有参选
		UIPalace.ElectControls.MyArray.text = "无"
	else
		UIPalace.ElectControls.MyArray.text = tostring( PalaceSys.GetMyPosition())
	end
end

function UIPalace:ShowElectList()				--显示列表
	UIPalace.ElectControls.ListPanel.transform.localPosition = Vector3(0 , 0 , 0)
	UIPalace.ElectControls.ListPanel.clipOffset = Vector2(0, 0)
	UIPalace.ElectControls.UIWrap:ResetTrans(#UIPalace.ElectDataList)

	for i=1,12,1  do
		local data = 
		{
			Index = i,
		}
		if UIPalace.ElectGodList[i] ~= nil then
			this:CreateElectListCallBack(UIPalace.ElectGodList[i] , data)
		else
			MainGameUI.CreateLittleItem(tostring(i) , "OffElectItem" , UIPalace.ElectControls.Gird, data , this.CreateElectListCallBack , "UIPalace") 
		end
	end
	
end

function UIPalace:CreateElectListCallBack(_Gob , _Info)
	if _Info.Index == 12 then
		UIPalace.ElectControls.Gird.enabled = true
		UIPalace.ElectControls.Gird:Reposition()
		UIPalace.ElectControls.UIWrap:SetData(#UIPalace.ElectDataList , "UIPalace")
	end
	local index = tonumber(_Info.Index)
	this:ShowElectItem(_Gob , index)
end

function UIPalace:ShowElectItem(_God , _Index)
	UIPalace.ElectGodList[_Index] = _God
	local data = UIPalace.ElectDataList[_Index]
	if data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local name = _God.transform:FindChild("name"):GetComponent("UILabel")
	local num = _God.transform:FindChild("countTimes"):GetComponent("UILabel")
	local array = _God.transform:FindChild("array"):GetComponent("UILabel")
	local pos = _God.transform:FindChild("pos"):GetComponent("UILabel")
	name.text = data.Name
	array.text = tostring(_Index)
	
	num.text = tostring(data.OwnCount)
	if _Index<10 then
		pos.text = UIPalace.ElectPosNameList[_Index].Name
		return
	end
	if _Index>=10 and _Index<=17 then
		pos.text = UIPalace.ElectPosNameList[10].Name
		return
	end
	if _Index>=18 and _Index<=33 then
		pos.text = UIPalace.ElectPosNameList[11].Name
		return
	end
	pos.text = UIPalace.ElectPosNameList[12].Name
end

function UIPalace:UpdateItem(_LuaName , _Item) 
	local parentName = _Item.transform.parent.name
	if parentName == "ElectGrid" then
		local index = tonumber(_Item.name)
		this:ShowElectItem(_Item , index)
	end
end

function UIPalace:ElectJoin()					--参选
	GameMain.OpenObj(UIPalace.ChoosePanel)
end

function UIPalace:Vote(Index)
	local data = UIPalace.ElectDataList[Index]
	if data.Dbid == ClinetInfomation.Player_id then
		DataUIInstance.PopTip("不能给自己投票")
		return
	end
	
	if UIPalace.voteCount<=0 then
		UIPalace.ElectControls.FreeTimes.text = tostring(0)
		DataUIInstance.PopTip("投票次数已经用尽")
		return
	end

	UIPalace.voteCount = UIPalace.voteCount -1
	UIPalace.ElectControls.FreeTimes.text = tostring(UIPalace.voteCount)

	PalaceSys.Vote(data.Dbid)
	
end

--endregion

--region *.参选界面
function UIPalace:JointElect()
	local myDiamoned = ClinetInfomation.GetDiamond()
	if myDiamoned<300 then
		DataUIInstance.PopTip("元宝不足")
		return 
	end
	PalaceSys.JoinElection()
	
end

function UIPalace:ShowJointElectAfter()
	this:CloseChoosePanel()
	GameMain.CloseObj(UIPalace.MainControls.JointBtn)
	if UIPalace.ElectControls.JointBtn~=nil then
		GameMain.CloseObj(UIPalace.ElectControls.JointBtn)
		GameMain.OpenObj(UIPalace.ElectControls.HasJointed)--
	end
	DataUIInstance.PopTip("参选成功")
	--自己的官职
	PalaceSys.Init()
end

function UIPalace:CloseChoosePanel()
	GameMain.CloseObj(UIPalace.ChoosePanel)
end
--endregion


--region *.官员特权（领取俸禄）
function UIPalace:OpenAbility()
	GameMain.OpenObj(UIPalace.AbilityPanel)
	if UIPalace.AbilityControls.Grid == nil then
		this:GetAbilityControls()
		this:SetInitAbilityData()
		this:ShowAbilityBasicInfo()
	end
	this:ShowMyAblityInfo()
end


function UIPalace:SetInitAbilityData()
	local list = OfficialRwdDataConfig.GetDB()
	for key,value in pairs(list) do
		table.insert(UIPalace.AbilityRwdDataList , #UIPalace.AbilityRwdDataList +1 ,value)
	end
	table.sort(UIPalace.AbilityRwdDataList , UIPalace.Comp)
end
function UIPalace:GetAbilityControls()
	UIPalace.AbilityControls.Grid = UIPalace.AbilityPanel.transform:FindChild("AbilityList/AbilityListPanel/AbilityGrid"):GetComponent("UIGrid")
	UIPalace.AbilityControls.RecBtn = UIPalace.AbilityPanel.transform:FindChild("ReciverBtn")
	UIPalace.AbilityControls.HasReced = UIPalace.AbilityPanel.transform:FindChild("hasRecived")
	local info = UIPalace.AbilityPanel.transform:FindChild("MyInfo")
	UIPalace.AbilityControls.MyPos = info.transform:FindChild("pos"):GetComponent("UILabel")
	UIPalace.AbilityControls.MyDiamoned = info.transform:FindChild("diamond/count"):GetComponent("UILabel")
	UIPalace.AbilityControls.MyCoin = info.transform:FindChild("coin/count"):GetComponent("UILabel")
	UIPalace.AbilityControls.MyOtherRwd = info.transform:FindChild("maomaochong"):GetComponent("UILabel")
end

function UIPalace:ShowAbilityBasicInfo()
	this:ReciveRwdInfo()
	this:ShowAbilityList()
end

function UIPalace:ShowMyAblityInfo()		--显示我的俸禄信息

	UIPalace.AbilityControls.MyPos.text = UIstring.NormalWordColor .. UIstring.PalaceMyPos .."[-]"..UIstring.Red .. PalaceSys.GetMyOffical().."[-]"
	local data = PalaceSys.GetPosRewardData()
	local rewardData = RewardConfig.GetRewardConfig(tonumber(data.Salary))
			
	local jsonItems = RewardContentSys.GetRewardStringType(rewardData.RewardString)
		
	UIPalace.AbilityControls.MyDiamoned.text = tostring( jsonItems.reputation)
	UIPalace.AbilityControls.MyCoin.text = tostring( jsonItems.coin)

end

function UIPalace:ShowAbilityList()
	for i=1,#UIPalace.AbilityRwdDataList,1 do
		local data = 
		{
			Index = i,
			Len = #UIPalace.AbilityRwdDataList,
		}
		if UIPalace.AbilityGodList[i] ~= nil then
			this:CreateAbilityListCallBack(UIPalace.AbilityGodList[i] , data)
		else
			MainGameUI.CreateLittleItem(tostring(i) , "OffAbilityItem" , UIPalace.AbilityControls.Grid, data , this.CreateAbilityListCallBack , "UIPalace") 
		end
	end
	
end

function UIPalace:CreateAbilityListCallBack(_Gob , _Info)
	local index = _Info.Index
	UIPalace.AbilityGodList[index] = _Gob
	local data = UIPalace.AbilityRwdDataList[index]
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	end

	local name = _Gob.transform:FindChild("des"):GetComponent("UILabel")
	local call = _Gob.transform:FindChild("callTimes"):GetComponent("UILabel")
	local stop = _Gob.transform:FindChild("stopSpeakTimes"):GetComponent("UILabel")
	name.text = data.Name
	call.text = tostring(data.Call)
	stop.text = tostring(data.Ban)
	local Rewards = OfficialRwdDataConfig.GetRewardItems(data.Id)
	
	local coinTxt = _Gob.transform:FindChild("coin/count"):GetComponent("UILabel")
	coinTxt.text = tostring(Rewards.coin)
	local diamonedTxt = _Gob.transform:FindChild("diamond/count"):GetComponent("UILabel")
	diamonedTxt.text = tostring(Rewards.reputation)
--	local otherTxt = _Gob.transform:FindChild("maomaochong/count"):GetComponent("UILabel")
	--otherTxt.text = tostring(Rewards.item[1].Count)
	if _Info.Len == index then
		UIPalace.AbilityControls.Grid.enabled = true
		UIPalace.AbilityControls.Grid:Reposition()
	end
end

function  UIPalace:ReciveRwd()
	PalaceSys.RecvReward()
	UIPalace.IsRecvied = 1
	this:ReciveRwdInfo()
end

function UIPalace:ReciveRwdInfo()
	if UIPalace.IsRecvied == 1 then
		GameMain.CloseObj(UIPalace.AbilityControls.RecBtn)
		GameMain.OpenObj(UIPalace.AbilityControls.HasReced)
	else
		GameMain.OpenObj(UIPalace.AbilityControls.RecBtn)
		GameMain.CloseObj(UIPalace.AbilityControls.HasReced)
	end
end
--endregion

function UIPalace:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "jointBtn" then
		this:ElectJoin()
	end
	if _Gob.name == "NextBtn" then
		if UIPalace.MainControls.Poses.gameObject.activeInHierarchy == true then
			this:OpenOtherOffPosPanel()
		else
			this:ShowOriPanelInfo()
		end
		
	end
	if _Gob.name == "ClosePalaceBtn" then
		GameMain.CloseObj(UIPalace.UIPalaceGod)
	end
	if _Gob.name == "OpenRedBtn" then
		GameMain.OpenObj(UIPalace.RedPanel)
	end
	if _Gob.name == "OpenOffMoneyBtn" then
		this:ClosePoses()
		this:OpenAbility()
	end
	if _Gob.name == "OpenOffElectBtn" then
		this:ClosePoses()
		this:OpenElectPanel()
	end
	if _Gob.name == "OpenJointBtn" then
		this:ClosePoses()
		GameMain.OpenObj(UIPalace.ChoosePanel)
	end

	if _Gob.name == "CloseAbilityBtn" then
		GameMain.CloseObj(UIPalace.AbilityPanel)
		this:OpenPoses()
	end
	if _Gob.name == "CloseElectBtn" then
		GameMain.CloseObj(UIPalace.ElectPanel)
		this:OpenPoses()
	end
	if _Gob.name == "CloseChooseBtn" then
		this:OpenPoses()
		this:CloseChoosePanel()
	end
	if _Gob.name == "CloseRedBtn" then
		GameMain.CloseObj(UIPalace.RedPanel)
		this:OpenPoses()
	end

	if _Gob.name == "ConfirmBtn" then
		this:JointElect()
	end
	if _Gob.name == "putBtn" then
		--投票
		local index = tonumber(_Gob.transform.parent.name)
		this:Vote(index)
	end
	if _Gob.name == "ReciverBtn" then
		--领取俸禄
		this:ReciveRwd()
	end
end

function UIPalace:ClosePoses()
	if UIPalace.MainControls.Poses.gameObject.activeInHierarchy == true then
		GameMain.CloseObj(UIPalace.MainControls.Poses)
	end
end

function UIPalace:OpenPoses()
	
	if UIPalace.OtherOffPosPanel.gameObject.activeInHierarchy == false then
		GameMain.OpenObj(UIPalace.MainControls.Poses)
	end
end

function UIPalace:ReleasPanel()
	--UI
	UIPalace.UIPalaceGod = nil
	UIPalace.ElectPanel = nil
	UIPalace.RedPanel = nil
	UIPalace.AbilityPanel = nil
	UIPalace.ChoosePanel = nil
	UIPalace.OtherOffPosPanel = nil

	UIPalace.JointBtn = nil

	UIPalace.ElectControls = {}
	UIPalace.ElectGodList = {}		--参与官员选举的玩家
	UIPalace.AbilityControls = {}
	UIPalace.AbilityGodList = {}	--官员特权
	UIPalace.MainElectGodList = {}	--主界面的官员信息
	UIPalace.OtherOffPosControls = {}

	UIPalace.MainControls = {}		--初始化界面的控件
	UIPalace.OtherOffPosGodList = {}
	--Data
	UIPalace.ElectDataList = {}		--参与官员选举的玩家数据
	UIPalace.ElectPosNameList = {}	--官员选举的官职名字
	UIPalace.AbilityRwdDataList = {}	--官员特权数据

	UIPalace.voteCount = 0			--投票数量
end

function UIPalace:ReleasData()
	PalaceSys.InitElectId = 0	--初始化的ID
	PalaceSys.IsJoined = 0		--是否参选
	PalaceSys.VoteCount = 0		--投票的次数
	PalaceSys.ElectList = {}	--官员选举的官职列表

	PalaceSys.OfficerList = {}	--王宫的排名

	PalaceSys.IsRwdRecvd = 0	--是否领取俸禄

    if PalaceElect==nil then
       return
    end

	PalaceElect.Dbid = ""			--玩家的ID
	PalaceElect.OwnCount =	0		--玩家获得的票数 
	PalaceElect.CreateTime = 0		--武将进入的时间
	PalaceElect.VipLvl = 0			--玩家VIP等级
	PalaceElect.Name = ""			--玩家姓名
end

return UIPalace
--endregion
