--"version :20150810   ser version 387 "


import "UnityEngine"
--import "DotNetClient"

GameMainState = {"null","bulletin","LoadUI","Login","CreatePlayer","mainscene","battle"} --游戏状态
function loadBoosCb(boos)
    local boss = GameObject.Instantiate(boos)
end
GameMain = {}
local MyGameMainState = "null"		--当前游戏状态
local this = GameMain
GameMain.isRolePropShowTest = false
GameMain.isSceneTest = false
GameMain.isSkillDamageTest = false	--技能伤害测试
GameMain.isPVPTest = false			--批量测试pvp匹配成功率
GameMain.UseAutoAttack = 0 --设置玩家托管   要读存档
--进入游戏初始化-

function GameMain.IniDB()
    --[[local AiLvlConflua = this.requireLuaFile("AiLvlConf")
    AiLvlConflua.IniSome()
    local EffectConfiglua =  this.requireLuaFile("EffectConfig")
    EffectConfiglua.IniSome()
    local BuffConfiglua = this.requireLuaFile("BuffConfig")
    BuffConfiglua.IniSome()
    local SkillDatalua = this.requireLuaFile("SkillData")
    SkillDatalua.IniSome()
    local RolePropConfiglua=  this.requireLuaFile("RolePropConfig")
    RolePropConfiglua.IniSome()
    local AmmoConfiglua = this.requireLuaFile("AmmoConfig")
    AmmoConfiglua.IniSome()
    local BSBuffConfiglua = this.requireLuaFile("BSBuffConfig")
    BSBuffConfiglua.IniSome()
    local CurverConfig = this.requireLuaFile("CurverConfig")
    CurverConfig.IniSome()
    local DB_RoleSkillMagConfig = this.requireLuaFile("DB_RoleSkillMag")
    DB_RoleSkillMagConfig.IniSome()
    local ItemDataConfig = this.requireLuaFile("ItemDataConfig")
    ItemDataConfig.IniSome()
    local ResourceDataConfig = this.requireLuaFile("ResourceDataConfig")
    ResourceDataConfig.IniSome()
    local UpLvlConfig = this.requireLuaFile("UpLvlConfig")
    UpLvlConfig.IniSome()
    local UpQualityConfig = this.requireLuaFile("UpQualityConfig")
    UpQualityConfig.IniSome()
    local UpStarConfig = this.requireLuaFile("UpStarConfig")
    UpStarConfig.IniSome()
    local EquipConfig = this.requireLuaFile("EquipDataConfig")
    EquipConfig.IniSome()
    local NeedExpConfig = this.requireLuaFile("UpEquipLvlNeedExpConfig")
    NeedExpConfig.IniSome()
    local EquipExp = this.requireLuaFile("UpEquipExpConfig")
    EquipExp.IniSome()
    local MapConfig = this.requireLuaFile("MapDataConfig")
    MapConfig.IniSome()
    local ChapterConfig = this.requireLuaFile("ChapterDataConfig")
    ChapterConfig.IniSome()
    local DebrisConfig = this.requireLuaFile("DebrisDataConfig")
    DebrisConfig.IniSome()
    local UpEquipQuality = this.requireLuaFile("UpEquipQualityConfig")
    UpEquipQuality.IniSome()
    local Max_Config = this.requireLuaFile("Max_ConfigData")
    Max_Config.IniSome()
    local RewardsConfig = this.requireLuaFile("RewardsContentConfig")
    RewardsConfig.IniSome()
    local SignRewardConfig = this.requireLuaFile("SignDailyRewardConfig")
    SignRewardConfig.IniSome()
    local SignLvlConfig = this.requireLuaFile("SignLvlRewardConfig")
    SignLvlConfig.IniSome()
    local SignOnlineConfig = this.requireLuaFile("SignOnlineRewardConfig")
    SignOnlineConfig.IniSome()
    local VipConfig = this.requireLuaFile("VipConfig")
    VipConfig.IniSome()
    local RoleSkillCoinConfig = this.requireLuaFile("RoleSkillCoinConfig")
    RoleSkillCoinConfig.IniSome()
    local MainRewardConfig = this.requireLuaFile("MainRewardConfig")
    MainRewardConfig.IniSome()
    local DailyRewardConfig = this.requireLuaFile("DailyRewardConfig")
    DailyRewardConfig.IniSome()
    local Role_MapExpConfig = this.requireLuaFile("Role_MapExpConfig")
    Role_MapExpConfig.IniSome()
    local MutLanguageConfig = this.requireLuaFile("MutLanguageConfig")
    MutLanguageConfig.IniSome()
    local NameConfig = this.requireLuaFile("NameConfig")
    NameConfig.IniSome()
    local RiskConfig = this.requireLuaFile("RiskConfig")
    RiskConfig.IniSome()
    local SoundConf = this.requireLuaFile("SoundConf")
    SoundConf.IniSome()
    local TipsConfig = this.requireLuaFile("TipsConfig")
    TipsConfig.IniSome()
    local GuideConfig = this.requireLuaFile("GuideConfig")
    GuideConfig.IniSome()
    local BroadcastConfig = this.requireLuaFile("BroadcastConfig")
    BroadcastConfig.IniSome()
    local TalkConfig = this.requireLuaFile("TalkConfig")
    TalkConfig.IniSome()--]]
	local SystemOpenConfig = this.requireLuaFile("SystemOpenConfig")
	SystemOpenConfig.InitSome()
	local SoundConfig = this.requireLuaFile("SoundConfig") 
	SoundConfig.InitSome()
	local TipsConfig = this.requireLuaFile("TipsConfig") 
	TipsConfig.InitSome()
	local HeroDiscConfig = this.requireLuaFile("HeroDiscConfig")
	HeroDiscConfig.InitSome()
	local HeroShopConfig = this.requireLuaFile("HeroShopConfig")
	HeroShopConfig.InitSome()
	local DebrisConfig = this.requireLuaFile("DebrisConfig") 
	DebrisConfig.InitSome()
    local WorldMapConfig = this.requireLuaFile("WorldMapConfig")
    WorldMapConfig.IniSome()
    local RoleDataConfig = this.requireLuaFile("RoleDataConfig")
    RoleDataConfig.IniSome()
    local RoleSkillConfig = this.requireLuaFile("RoleSkillConfig")
    RoleSkillConfig.IniSome()
    local AmmoConfig = this.requireLuaFile("AmmoConfig")
    AmmoConfig.IniSome()
    local BuffConfig = this.requireLuaFile("BuffConfig")
    BuffConfig.IniSome()
	local TxConfig = this.requireLuaFile("TxConfig")
    TxConfig.IniSome()
    local SoliderQualityUpConfig = this.requireLuaFile("SoliderQualityUpConfig")
    SoliderQualityUpConfig.IniSome()
    local MapConfig = this.requireLuaFile("MapConfig")
    MapConfig.IniSome()
    local ChapterConfig = this.requireLuaFile("ChapterConfig")
    ChapterConfig.IniSome()
    local ItemConfig=this.requireLuaFile("ItemDataConfig")
    ItemConfig.IniSome()
	local OnlineRwdConfig=this.requireLuaFile("OnlineRwdConfig")
	OnlineRwdConfig.InitSome()
    local EquipDataConfig = this.requireLuaFile("EquipDataConfig")
    EquipDataConfig.IniSome()
	local EquipQualityUpConfig = this.requireLuaFile("EquipQualityUpConfig")
	EquipQualityUpConfig.IniSome()
	local EquipLvlUpConfig = this.requireLuaFile("EquipLvlUpConfig")
	EquipLvlUpConfig.IniSome()
    local RoleExpConfig = this.requireLuaFile("RoleExpConfig")
    RoleExpConfig.IniSome()
    local EveryWeekPreferentialConfig = this.requireLuaFile("EveryWeekPreferentialConfig")
	EveryWeekPreferentialConfig.InitSome()
	local EveryDayPreferentialConfig = this.requireLuaFile("EveryDayPreferentialConfig")
	EveryDayPreferentialConfig.InitSome()
	local SignSevenDataConfig = this.requireLuaFile("SignSevenDataConfig")
	SignSevenDataConfig.InitSome()
	local  TechnologyDataConfig = this.requireLuaFile("TechnologyDataConfig")
	TechnologyDataConfig.IniSome()
	local SignTotalDataConfig = this.requireLuaFile("SignTotalDataConfig")
	SignTotalDataConfig.InitSome()
	local SignDataConfig = this.requireLuaFile("SignDataConfig")
	SignDataConfig.InitSome()
	local OfficialDataConfig = this.requireLuaFile("OfficialDataConfig")
	OfficialDataConfig.InitSome()
	local OfficialRwdDataConfig = this.requireLuaFile("OfficialRwdDataConfig") 
	OfficialRwdDataConfig.InitSome()
	local DouJiangTaiShopConfig = this.requireLuaFile("DouJiangTaiShopConfig") 
	DouJiangTaiShopConfig.InitSome()
	local ShaChangShopConfig = this.requireLuaFile("ShaChangShopConfig") 
	ShaChangShopConfig.InitSome()
	local ConsignmentConfig = this.requireLuaFile("ConsignmentConfig") 
	ConsignmentConfig.InitSome()
	local RoleInfoConfig=this.requireLuaFile("RoleInfoConfig")
    RoleInfoConfig.IniSome()
    local DailyMissionConfig=this.requireLuaFile("DailyMissionConfig")
    DailyMissionConfig.IniSome()
    local MainMissionConfig =this.requireLuaFile("MainMissionConfig")
    MainMissionConfig.IniSome()
    local ActiveRewardConfig = this.requireLuaFile("ActiveRewardConfig")
    ActiveRewardConfig.IniSome()
    local BattleFlagConfig = this.requireLuaFile("BattleFlagConfig")
    BattleFlagConfig.IniSome()
	local EquipDataConfig = this.requireLuaFile("EquipDataConfig")
    EquipDataConfig.IniSome()
    local ShopConfig = this.requireLuaFile("ShopConfig")
    ShopConfig.IniSome()
	local FundDataConfig = this.requireLuaFile("FundDataConfig")
	FundDataConfig.InitSome()
	local GiftDataConfig = this.requireLuaFile("GiftDataConfig")
	GiftDataConfig.InitSome()
	
	local MonthCardDataConfig = this.requireLuaFile("MonthCardDataConfig")
	MonthCardDataConfig.InitSome()
	local PlayerExpConfig = this.requireLuaFile("PlayerExpConfig")
	PlayerExpConfig.InitSome()	
	local VipDataConfig = this.requireLuaFile("VipDataConfig")
	VipDataConfig.InitSome()

	local VipBuyDataConfig = this.requireLuaFile("VipBuyDataConfig")
	VipBuyDataConfig.InitSome()
	
	local RechargeDataConfig = this.requireLuaFile("RechargeDataConfig")
	RechargeDataConfig.InitSome()

	local VipBuyDiscConfig = this.requireLuaFile("VipBuyDiscConfig")
	VipBuyDiscConfig.InitSome()

    local ResourceConfig = this.requireLuaFile("ResourceConfig")
	ResourceConfig.InitSome()

    local HandBookConfig = this.requireLuaFile("HandBookConfig")
	HandBookConfig.InitSome()

    local WorldActivityConfig = this.requireLuaFile("WorldActivityConfig")
    WorldActivityConfig.InitSome()

    local RewardConfig = this.requireLuaFile("RewardConfig")
    RewardConfig.InitSome()

    local MutLanguageConfig = this.requireLuaFile("MutLanguageConfig") 
    MutLanguageConfig.IniSome()

    local ConstConfig = this.requireLuaFile("ConstConfig") 
    ConstConfig.IniSome()   
     
    local EventTemplateConfig = this.requireLuaFile("EventTemplateConfig") 
    EventTemplateConfig.InitSome()

    local EventRewardConfig = this.requireLuaFile("EventRewardConfig") 
    EventRewardConfig.InitSome()

	local ConsumeRaffleConfig = this.requireLuaFile("ConsumeRaffleConfig") 
    ConsumeRaffleConfig.InitSome()

    local FeatsRewardConfig = this.requireLuaFile("FeatsRewardConfig") 
    FeatsRewardConfig.InitSome()

	local VipSpecialConfig = this.requireLuaFile("VipSpecialConfig") 
	VipSpecialConfig.InitSome()

    local GuideConfig = this.requireLuaFile("GuideConfig")
    GuideConfig.InitSome()
end

function GameMain.requireIniFile()

   this.requireLuaFile("WebEvent")
   this.requireLuaFile("SocketClient")
   this.requireLuaFile("GameModel")
   this.requireLuaFile("CalculateRoleProp")
   this.requireLuaFile("LoginData")
   this.requireLuaFile("handleNet_Game")
   this.requireLuaFile("BasePanel")
   this.requireLuaFile("MainGameUI")
   --this.requireLuaFile("UIstring")
   this.requireLuaFile("ClinetInfomation")
   this.requireLuaFile("AtlasMsg")
   this.requireLuaFile("ResourceManager")
   this.requireLuaFile("ItemBase")
   this.requireLuaFile("DataUIInstance")
	this.requireLuaFile("LoadingPanel")
   --[[ this.requireLuaFile("SocketClient")

    this.requireLuaFile("configMag")

    this.requireLuaFile("SkillConfig")
    this.requireLuaFile("AmmoColliDisEffConfig")
    this.requireLuaFile("WallConfig")
    this.requireLuaFile("AmmoColliDisEffConfig")
    this.requireLuaFile("lgBsBuffMag")


    this.requireLuaFile("ResourceManager")
    this.requireLuaFile("StringExt")
    this.requireLuaFile("MainGameUI")

    this.requireLuaFile("lgBsBuffMag")
    this.requireLuaFile("lgSkillAiFun")
    this.requireLuaFile("normalAi")


    this.requireLuaFile("ClinetInfomation")
    this.requireLuaFile("DataUIInstance")
    this.requireLuaFile("NormalRecEvent")
    this.requireLuaFile("AccountInfo")
    this.requireLuaFile("BasePanel")
    this.requireLuaFile("ItemBase")
    this.requireLuaFile("PlayerControl")
    this.requireLuaFile("WebEvent")
    this.requireLuaFile("GameModel")
    this.requireLuaFile("LoginData")
    this.requireLuaFile("handleNet_Game")

    this.requireLuaFile("LoadingPanel")

    this.requireLuaFile("lgRolePopListMag")

    this.requireLuaFile("lgMapInfoMag")
    this.requireLuaFile("lgMapStandPosMag")


    this.requireLuaFile("AtlasMsg")
    this.requireLuaFile("Create3DModel")

    this.requireLuaFile("lgFindAmmoPosition")
    this.requireLuaFile("EyeFaceConfig")
    this.requireLuaFile("RoleModeSizeConfig")
    this.requireLuaFile("DebugLogMag")

    --]]
end


function GameMain.IniSome()
    GameMain.requireIniFile()
    GameMain.IniDB()
    GameModel.Init()
    GameMain.InitUI()


    --[[GameMain.IniDB() --加载数据库配置
    GameMain.requireIniFile()

    GameMain.GetAutoAttSet()

    GameModel.Init()

    GameStateIns.LoginAllState()                                    --注册游戏状态
    GameMain.EnterLoadingBoundle()


    GameMain.AddCallBack("GameMain.NetDieCB", GameMain.NetDieCB)--]]
end

local ChangeStateto = "null"

function GameMain.SetStateChange(changeto)
    if MyGameMainState ~= changeto then
        ChangeStateto = changeto
        this.QuitNowState()
    end


end
function GameMain.QuitNowState()
    if MyGameMainState~="null" then
        --snbug
        --Debug.Log("GameMain.QuitNowState "..MyGameMainState)
        this.QuitNowStateFinish()
    else
        this.QuitNowStateFinish()
    end
end

function GameMain.QuitNowStateFinish()

    this.EnterState()
end

function GameMain.EnterState()
    --Debug.Log("GameMain.EnterState "..MyGameMainState.." "..ChangeStateto)
    MyGameMainState = ChangeStateto
    ChangeStateto = "null"

    this["EnterStateCall"][MyGameMainState]()
end
--游戏跟新-
local UpdateLuaList_ = {}
local MainSceneUpdateLuaList = {}

UpdateLuaList_.add = function (thislua) 

    for i=1,#(UpdateLuaList_),1 do
        if UpdateLuaList_[i]== thislua then
           return
        end
    end

    table.insert(UpdateLuaList_,thislua) 
end

UpdateLuaList_.del = function (thislua)
    --Debug.Log("UpdateLuaList_.del "..tostring(thislua))
    for i=1,#(UpdateLuaList_),1 do
        if UpdateLuaList_[i]== thislua then
            table.remove(UpdateLuaList_,i)
            break
        end
    end

end

--注意这里不检查是否存在  可以加2个一样的脚本-
function GameMain.AddUpdateLua(thislua)
    --Debug.Log("GameMain.AddUpdateLua")
    if thislua==nil then
        Debug.Log("GameMain.AddUpdateLua(thislua) nil")
    end
    
    UpdateLuaList_.add(thislua)
end
function GameMain.DelUpdateLua(thislua)
    UpdateLuaList_.del(thislua)
end
GameMain.testobj = nil

--GameMain.UpdataHz = 2  --更新的频率
--GameMain.useUpdataHz = -1
GameMain.PauseGameUpdate = false
GameMain.t = 1
function GameMain.Update()
    --[[if GameMain.useUpdataHz==-1 then
    GameMain.useUpdataHz = 1
    return
    else
    GameMain.useUpdataHz=-1
    end--]]
--	GameMain.Print(Time.deltaTime , " lua time deltaTime")
    for listid = 1,#(UpdateLuaList_),1 do
        if UpdateLuaList_[listid]~=nil then
            --return
            UpdateLuaList_[listid](Time.deltaTime/2)
        end

    end

   
end
--[[function GameMain.testabFun(prefab)
GameObject.Instantiate(prefab)
--GameMain.testobj = GameObject.Instantiate(prefab)
--GameMain.testobj.name = "testobj1"
--GameMain.testobj =nil
end	--]]

-- 最好在没有要加载东西的时候调用清理  lgNoDelCsFun.Ins:GetLoadObjCBListNum() ? 0
function GameMain.DoClearAsset()
    collectgarbage("collect")
    lgNoDelCsFun.Ins:DoClear()
end


MainSceneUpdateLuaList.add = function (thislua) table.insert(MainSceneUpdateLuaList,thislua) end
MainSceneUpdateLuaList.del = function (thislua)
    --Debug.Log("MainSceneUpdateLuaList.del "..tostring(thislua))
    for i=1,#(MainSceneUpdateLuaList),1 do
        if MainSceneUpdateLuaList[i]== thislua then
            table.remove(MainSceneUpdateLuaList,i)
            break
        end
    end

end


--mainSceneUpdate方法
function GameMain.AddMainSceneUpdateLua(thislua)
    --Debug.Log("GameMain.AddUpdateLua")
    if thislua==nil then
        Debug.Log("GameMain.AddUpdateLua(thislua) nil")
    end

    MainSceneUpdateLuaList.add(thislua)
end
function GameMain.DelMainSceneUpdateLua(thislua)
    MainSceneUpdateLuaList.del(thislua)
end


local LateUpdateLuaList_ = {}
LateUpdateLuaList_.add = function (thislua) table.insert(LateUpdateLuaList_,thislua) end
LateUpdateLuaList_.del = function (thislua)
    --Debug.Log("UpdateLuaList_.del "..tostring(thislua))
    for i=1,#(LateUpdateLuaList_),1 do
        if LateUpdateLuaList_[i]== thislua then
            table.remove(LateUpdateLuaList_,i)
            break
        end
    end

end
function GameMain.AddLateUpdateLua(thislua)
    --Debug.Log("GameMain.AddUpdateLua")
    if thislua==nil then
        Debug.Log("GameMain.AddLateUpdateLua(thislua) nil")
    end

    LateUpdateLuaList_.add(thislua)
end
function GameMain.DelLateUpdateLua(thislua)
    LateUpdateLuaList_.del(thislua)
end
function GameMain.LateUpdate()
    --Debug.LogError("GameMain.LateUpdate(dt) dt="..dt)
    for listid = 1,#(LateUpdateLuaList_),1 do
        if LateUpdateLuaList_[listid]~=nil then

            LateUpdateLuaList_[listid](Time.deltaTime)
        end

    end
end
--[[function GameMain.CB1(info,assetBundle)

local addobj = GameObject.Instantiate(assetBundle)


--addobj.transform.localPosition = Vector3.zero
--addobj.transform.localRotation = Quaternion.identity

end	--]]

--退出游戏-
function GameMain.Quit()
    Application.Quit();
end

--重新开始游戏-
function GameMain.Resetgame()
    SetStateChange("Login");
end
function GameMain.GetGameState()
    return MyGameMainState
end
--luaPathType =0  uilua  1 gmlua 2 commenlua 3 skilllua
function GameMain.DoLuaFile(luaPathType,filename)

    local path =""
    if isPctest ==true then
        if luaPathType ==0 then
            path =UiLuaPathPc.."/"..filename

        else
            if luaPathType == 1 then
                path = GmLuaPathPc.."/"..filename
            else
                if luaPathType == 2 then
                    path = ComLuaPathPc.."/"..filename
                end
            end
        end
    else
        if luaPathType ==0 then
            path =UiLuaPath.."/"..filename

        else
            if luaPathType == 1 then
                path = GmLuaPath.."/"..filename
            else
                if luaPathType == 2 then
                    path = ComLuaPath.."/"..filename
                end
            end
        end

    end
    path = string.gsub(path,"/","//")
    --Debug.Log("DoLuaFile" .. path)
    return dofile(path)
end
function GameMain.LoadLuaFile(filename)
    --	local luaStr = lgNoDelCsFun.Ins:LoadLuaStr(filename)
    --	return loadstring(luaStr)()
    return loadfile(filename)
end
function GameMain.requireLuaFile(filename)
    --	Debug.Log("requirefile:" .. filename)
    --	local luaStr = lgNoDelCsFun.Ins:LoadLuaStr(filename)
    --	return loadstring(luaStr)()
    return require(filename)
end





--接收聊天消息
function GameMain.ChatSysGetMessage(chatType, dataType, data)
    ChatSys.GetMessage(chatType,dataType, data)
end

--发送聊天消息
function GameMain.ChatSysSendMessage(chatType, dataType, data)
    ChatSys.SendMessage(chatType,dataType, data)
end

--加载bunlde test
function GameMain.LoadUIAssetBundleTest(prefabName)
    ResourceManager.LoadAssetUI(prefabName, GameMain.LoadUIAssetBundleTestCb)
end
--加载bunlde test
function GameMain.LoadGMAssetBundleTest(prefabName)
    ResourceManager.LoadAsset(prefabName, GameMain.LoadGMAssetBundleTestCb)
end
--提示消息
function GameMain.PopTip(tipId)
    DataUIInstance.PopTip(tipId)
end
----AssetBunld初始化完成
--function GameMain.AssetBundleInitFinish(isFinish)
--    ResourceManager.InitFinish()
--end

function GameMain.LoadGMAssetBundleTestCb(bundle)
    Debug.Log("LoadGMAssetBundleTestCb" .. bundle.name)
end

function GameMain.LoadUIAssetBundleTestCb(bundle)
    Debug.Log("LoadUIAssetBundleTestCb" .. bundle.name)
end

GameMain.IsEnterBattle = false
GameMain.MapType = 0            --1 普通副本 3Boss副本 4 Pvp
function GameMain.EnterZQBattle(_Type , _MapDBid , _Isfirst)
    GameMain.isOpenChat = false
	GameMain.IsEnterBattle = true
	MainGameUI.ReleaseAllPanel()
    GameMain.MapType = _Type
    lgNoDelCsFun.Ins:EnterBattle(_Type , _MapDBid , _Isfirst)
    GuideSys.OutUI = false
	MusicManagerSys.BattleBg(_MapDBid)
end

function GameMain.EnterPvpBattle()
   GameMain.MapType = 4
   GameMain.IsEnterBattle = true
   MainGameUI.ReleaseAllPanel()
   lgNoDelCsFun.Ins:EnterBattle(4 , 9002 , false)
   if BattleFieldSys.BattleFieldType ==1 then 
      GameMain.OutBattleToPanel = 9
   elseif BattleFieldSys.BattleFieldType ==2 then
      GameMain.OutBattleToPanel = 10
   end
	MusicManagerSys.PvpBattleMusic()
end

function GameMain.OutZQBattle()
    this.InitUI()
	GameMain.IsEnterBattle = false
	--ClinetInfomation.InitChat()
	if GameMain.IOSTest == false then
	GameMain.OpenChatType(GameMain.ChatObj , 0)
	end
	MusicManagerSys.CastleMusic()
end

--切换加载LoadboundleState
function GameMain.EnterLoadingBoundle()
    GameStateIns.ChangeState("LoadingBoundleState")
end

--切换加载总UI
function GameMain.EnterLoadUI()
    GameStateIns.ChangeState("LoadUIState")
end

--切换公告界面
function GameMain.EnterBroad()
    GameStateIns.ChangeState("BroadState")
end

--切换进入登录
function GameMain.EnterLogin()
    GameStateIns.ChangeState("LoginState")
end
--切换进创角状态
function GameMain.EnterCreatePlayer()
    GameStateIns.ChangeState("CreatePlayerState")
end

--切换进主程状态
function GameMain.EnterMainCity()
    GameStateIns.ChangeState("mainsceneState")
end

--切换战斗状态
function GameMain.EnterBattleState()
    GameStateIns.ChangeState("battleState")
end





function GameMain.CallBack(funname,...)
    if funcname~="HeartJump.SendHeartJumpCallBack" and funcname~= "HeartJump.SavePowerCallBack"  then
        LoadingPanel.StopLoading()
    else
        Debug.LogError(funcname)
    end
    if this["CallBackFun"][funname]~=nil then
        this["CallBackFun"][funname](...)
    end
end
function GameMain.AddCallBack(funname, cb)
    if this["CallBackFun"][funname]==nil then
        this["CallBackFun"][funname] = cb
    end
end
local GetHitRayCB =nil

function GameMain.GetCollisionPos( thiscollision, id)
    return lgNoDelCsFun.Ins:GetCollisionPos(thiscollision, id)
end

function GameMain.GetHitRayCB(...)
    if GetHitRayCB~=nil then
        GetHitRayCB(...)
    end
end

function GameMain.GetHitRayCollider(collider,ray,far,cb)
    GetHitRayCB = cb
    GameMain["CallBackFun"]["GetHitRay"] = GameMain.GetHitRayCB
    lgNoDelCsFun.Ins:GetColliderHitRay(collider,ray,far,"GetHitRay")

end

function GameMain.GetHitRay(ray,far,cb)
    GetHitRayCB = cb
    GameMain["CallBackFun"]["GetHitRay"] = GameMain.GetHitRayCB
    lgNoDelCsFun.Ins:GetHitRay(ray,far,"GetHitRay")
end
--接收战斗网络事件下发-
function GameMain.RecNetEvent(e)
    --GameMain.Print(e," GameMain.RecNetEvent")
    if MyGameMainState == "battle" and lgBtSceneMag~=nil and lgBtSceneMag.EveSysIni ==true  then
        lgBtEventMag.NetEvent(e)
    else
        NormalRecEvent.HandleNormalNet(e)
    end
end
function GameMain.SendHttpRequest(url, data, funname, cb)
    GameMain.AddCallBack(funname, cb)

    local Wrm = WebRequestManager.GetInstance();
    Wrm:SendRequest3(url, data, funname);
end

function GameMain.SendHttpRequestNormal(url, funname, cb)
    GameMain.AddCallBack(funname, cb)

    local Wrm = WebRequestManager.GetInstance();
    Wrm:SendRequest(url , funname);
end

function GameMain.handleHttpRequest(result, returnID, errorMsg, cb)
    if returnID == 0 then
        local resulTable = GameMain.JsonDecode(result)
        this.CallBack(cb, resulTable , returnID)
    else

        this.CallBack(cb, nil , returnID)
        -- prompt error message on client
    end
end
function GameMain.SendSocketRequest(data, funname, cb)
    GameMain.AddCallBack(funname, cb)
end
function GameMain.handleSocketRequest(result, cb)
    this.CallBack(cb, result)
end

function GameMain.handleCommoninfo(data)
    --LoadingPanel.StopLoadingPanel()
    Comminfo.HandleCommon(data)

end

local JSON = nil
function GameMain.JsonDecode(jsonStr)
    if JSON==nil then
        JSON = GameMain.requireLuaFile("JSON")
    end
    return JSON:decode(jsonStr)
end
function GameMain.JsonEncode(thistable)
    if JSON==nil then
        JSON = GameMain.requireLuaFile("JSON")
    end
    return JSON:encode(thistable)
end

function SetNetUseCB(cb)
    GameMain["CallBackFun"]["NetUseCb"] = cb
end

GameMain["CallBackFun"] = {
    ["null"] = nil,
    ["LoadSceneCB"] = this.LoadSceneCB,
    ["handleHttpRequest"] = this.handleHttpRequest,
    ["Commoninfo"] = this.handleCommoninfo,
    ["GetHitRay"] =nil,
    ["NetUseCb"] = nil,
}

GameMain["EnterStateCall"] = {
    ["null"] = nil,
    ["bulletin"] = nil,
    ["LoadUI"] = nil,--this.EnterLoadUIControl,
    ["Login"] = nil,--this.EnterLogin,
    ["CreatePlayer"] =nil,-- this.EnterCreatePlayer,
    ["mainscene"] = this.LoadMainScene,
    ["battle"] =  this.EnterBattle,
}

GameMain.SkillMsg = {
    skillNoCoolDown = "skillNoCoolDown",

}
function GameMain.StringSplit(str,split)
    --Debug.Log("GameMain.StringSplit-- str = "..tostring(str))
    local list = {}
    local pos = 1
    if string.find("", split, 1) then -- this would result in endless loops
        error("split matches empty string!")
    end
    while 1 do
        local first, last = string.find(str, split, pos)
        if first then -- found?
            table.insert(list, string.sub(str, pos, first-1))
            pos = last+1
        else
            table.insert(list, string.sub(str, pos))
            break
        end
    end
    return list
end
function GameMain.Print ( t, msg )
    local print_r_cache={}

    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            return "\n" .. indent.."*"..tostring(t)
        else
            print_r_cache[tostring(t)]=true

            if (type(t)=="table") then
                local ret = ""
                for pos,val in pairs(t) do
                    if (type(val)=="table") then

                        ret = ret .. "\n" .. indent.."["..pos.."] => "..tostring(t).." {"
                        ret = ret .. "" .. sub_print_r(val,indent..string.rep(" ",string.len(pos)+2))
                        ret = ret .. "\n" .. indent--[[..string.rep(" ",string.len(pos)+6)--]].."}"

                    elseif (type(val)=="string") then
                        ret = ret .. "\n" .. indent.."["..pos..'] => "'..val..'"'
                    else
                        ret = ret .. "\n" .. indent.."["..pos.."] => "..tostring(val)
                    end
                end

                return ret
            else
                return "\n" .. indent..tostring(t)
            end
        end
    end

    local ret = ""
    if (type(t)=="table") then
        ret = tostring(t).." {"
        ret = ret .. sub_print_r(t,"  ")
        ret = ret .. "\n" .. "}"
    else
        ret = sub_print_r(t,"  ")
    end

    if msg == nil then
        msg = ""
    end
    Debug.Log( "---- PRINT " .. msg ..  "\n" .. ret )
end

--设置表只读
function GameMain.table_read_only(t)

    local proxy = {}
    local mt = {         -- create metatable
    __index = t,
    __newindex = function (t,k,v)
        error("attempt to update a read-only table", 2)
    end
}

setmetatable(proxy, mt)
return proxy

end


--[[
/**
@brief 一维Hermite曲线位置插值
@param fT   范围(0-1) 参数
fP0  起点位置
fP1  终点位置
fM0  起点切线
fM1  终点切线
*/
]]--
function GameMain.m_hermite_C(fT,fP0,fP1,fM0,fM1)

    local fT2 = fT*fT;
    local fT3 = fT*fT*fT;
    return (2*fT3-3*fT2+1)*fP0 + (fT3-2*fT2+fT)*fM0 + (fT3-fT2)*fM1 + (-2*fT3 + 3*fT2)*fP1
end
--[[
/**
@brief 一维Hermite曲线切线插值
@param fT   范围(0-1) 参数
fP0  起点位置
fP1  终点位置
fM0  起点切线
fM1  终点切线
*/
]]--
function GameMain.m_hermiteD_C( fT, fP0, fP1, fM0, fM1)

    local fT2 = fT*fT;
    return (6*fT2-6*fT)*fP0 + (3*fT2-4*fT+1)*fM0 + (3*fT2-2*fT)*fM1 + (-6*fT2 + 6*fT)*fP1
end

--pos str to vector3
function GameMain.PosStrToVector3( postr)
    local pos3 = GameMain.StringSplit(postr,",")
    return Vector3(tonumber( pos3[1]),tonumber(pos3[2]),tonumber(pos3[3]))
end

function GameMain.GetNowLevelName()

    local name = lgNoDelCsFun.Ins:GetNowLevelName() --Application.loadedLevelName
    return name
end

function GameMain.ListenGoinUIcontrol()											--监听加载总界面z


    local LevelName = this.GetNowLevelName()
    local bundleState = lgNoDelCsFun.Ins:GetAssetBoundleState()
    Debug.LogError("LevelName:" .. LevelName .. ",bundleState:" .. bundleState);
    if LevelName=="MainGame" then
        if bundleState==1 or bundleState == 2 then                                            --监听完成后获取服务器列表

            GameMain.EnterLoadUI()
        end
    end
end




function GameMain.ListenGoinLogin()                                               --监听加载登录界面z
    local Panelobj = MainGameUI.FindPanel("UIControl")
    if GameStateIns.NowStateName=="LoadUIState" and Panelobj~=nil then
        GameMain.EnterBroad()
    end
end

--test
function GameMain.ClickEvent(_Gob)

     PlayerControl.ClickCityEvent(_Gob)

end

GameMain.TeamMakeSys = nil
GameMain.WorldMapSys = nil
GameMain.SoldierList = {}
GameMain.Hero = nil
GameMain.isFirst = false
GameMain.OutBattleToPanel = 0
GameMain.GuideNeed = true
GameMain.ChatObj = nil
GameMain.EnterGame = false
function GameMain.InitUI()
	if GameMain.isFirst == true then
		local initPanel = GameObject.Find("UIControl/Camera/AnchorCenter/UIChooseWeb")
		GameMain.CloseObj(initPanel)
    end
	if GameMain.isFirst == false then
		if MainGameUI["target"]["UIChooseWeb"]==nil then
			local lua = GameMain.requireLuaFile("UIChooseWeb")
			local obj2 = lua:new()
	   		MainGameUI["target"]["UIChooseWeb"] = obj2
	   end
		if MainGameUI["GameObject"]["UIChooseWeb"]==nil then
		  MainGameUI["GameObject"]["UIChooseWeb"] = GameObject.Find("UIControl/Camera/AnchorCenter/UIChooseWeb").gameObject--.transform:FindChild("Camera"):FindChild("UITT")
	   end
		MainGameUI["target"]["UIChooseWeb"]:OpenUI()
		GameMain.isFirst = true
	end
    

    if MainGameUI["target"]["UIControl"]==nil then
		local lua = GameMain.requireLuaFile("UIControl")
		local obj1 = lua:new()
	   	MainGameUI["target"]["UIControl"] = obj1
   end
   if MainGameUI["GameObject"]["UIControl"]==nil then
      MainGameUI["GameObject"]["UIControl"] = GameObject.Find("UIControl").gameObject--.transform:FindChild("Camera"):FindChild("UITT")
   end
   MainGameUI["target"]["UIControl"]:OpenUI()  

   PlayerControl.CreateMy() 
   GameMain.ChatObj = GameObject.Find("UIControl/Camera/AnchorCenter/UIChat").gameObject
   GameMain.TeamMakeSys = GameObject.Find("AnotherSys").transform:FindChild("TeamMakeSys")
   GameMain.WorldMapSys = GameObject.Find("AnotherSys").transform:FindChild("CitySys")


   GuideSys.OutUI = true
   local _GuideTar = MainGameUI.FindPanelTarget("UIGuide")
   if _GuideTar~=nil then
      _GuideTar:ReleasPanel()
      MainGameUI["GameObject"]["UIGuide"] = nil
      MainGameUI["target"]["UIGuide"] = nil
   end
   if GuideSys.UIYindao == true then
      GuideSys.CreateOutUIGuide()
   end

   GameMain.SoldierList = {}
   local _Soldier1 = GameObject.Find("daoju").transform:FindChild("Soldier1")
   if _Soldier1~=nil then
      table.insert(GameMain.SoldierList , #GameMain.SoldierList + 1 , _Soldier1.gameObject)
      local _Soldier2 = GameObject.Find("daoju").transform:FindChild("Soldier2").gameObject
      table.insert(GameMain.SoldierList , #GameMain.SoldierList + 1 , _Soldier2)
      GameMain.Hero = GameObject.Find("daoju").transform:FindChild("Hero").gameObject      
      GameMain.AddUpdateLua(GameMain.UpdateAnimation)
   end

   if WorldMapSocketSys.ReceiveBattle==true then
      SocketClient.DisConnect()
      MainGameUI["target"]["UIControl"]:OpenWorldMap()
      WorldMapSocketSys.ReceiveBattle = false
   end

    GameMain.OpenPanel(GameMain.OutBattleToPanel)
    GameMain.OutBattleToPanel = 0
end

GameMain.TotalTime = 2
GameMain.NowTime = 0
function GameMain.UpdateAnimation(dt)
   GameMain.NowTime = GameMain.NowTime + dt
   if GameMain.NowTime <= GameMain.TotalTime then
      
   else
      lgNoDelCsFun.Ins:PlayAnimation(GameMain.Hero , "Hero42_1" , "attack")
      for i = 1 , #GameMain.SoldierList , 1 do
          GameMain.SoldierList[i]:GetComponent("Animation"):Play("attack")

      end
      GameMain.NowTime = 0
   end
end

function GameMain.OpenPanel(Panel_Index)
   if GuideDataSys.GetBigStep(GuideSys.NowBigStep)~=nil then
      return
   end
   if Panel_Index==1 then                   --武将召唤
      DataUIInstance.OpenHireHero()
   elseif Panel_Index == 2 then             --强化装备
      DataUIInstance.OpenEquip()
   elseif Panel_Index == 3 then             --武将训练
      DataUIInstance.OpenHeroInfo()     
   elseif Panel_Index == 4 then             --士兵训练
      DataUIInstance.OpenSoliderInfo()
   elseif Panel_Index == 9 then             --沙场点兵
      DataUIInstance.OpenBattleField(1)
   elseif Panel_Index == 10 then             --斗将台 
      DataUIInstance.OpenBattleField(2)
   end
end

function GameMain.Release()
    GameMain.DelUpdateLua(GameMain.UpdateAnimation)
    GameMain.SoldierList = {}
    GameMain.Hero = nil
end

function GameMain.ReLogin()
    GameMain.OutBattleToPanel = 0
end

--UIeventUI事件的监听分发z
function GameMain.UIHandleEvent(_Lua , _Gob)
    if MainGameUI["UIEvent"][_Lua]~=nil then
        MainGameUI["UIEvent"][_Lua](nil , _Lua , _Gob)

    else
        --local lua = this.requireLuaFile(_Lua)
        --local gob = _Gob
        --local obj1 = lua:new()
        local Target = nil
        if MainGameUI["target"][_Lua]~=nil then
            Target = MainGameUI["target"][_Lua]
            MainGameUI["UIEvent"][_Lua] = Target.UIHand
            MainGameUI["UIEvent"][_Lua](Target , _Lua , _Gob)
        end
        -- lua = nil
        --  gob = nil

    end
end

function  GameMain.UIDragUpEvent(_Lua , _UpGob , _DragGob)
    if MainGameUI["UIDragUpEvent"][_Lua]~=nil then
        MainGameUI["UIDragUpEvent"][_Lua](nil , _Lua , _UpGob , _DragGob)
    else

        --local lua = this.requireLuaFile(_Lua)
        --local obj1 = lua:new()
        local Target = nil
        if MainGameUI["target"][_Lua]~=nil then
            -- MainGameUI["target"][_Lua] = obj1
            Target = MainGameUI["target"][_Lua]
            if Target.UIDragUpEvent==nil then
                return
            end
            MainGameUI["UIDragUpEvent"][_Lua] = Target.UIDragUpEvent
            MainGameUI["UIDragUpEvent"][_Lua](Target , _Lua , _UpGob , _DragGob)
        end
    end
end

function  GameMain.UIDragEvent(_Lua , _Gob , _Detal)
    if MainGameUI["UIDragEvent"][_Lua]~=nil then
        MainGameUI["UIDragEvent"][_Lua](nil , _Lua , _Gob , _Detal)
    else

        --local lua = this.requireLuaFile(_Lua)

        --local obj1 = lua:new()
        local Target = nil
        if MainGameUI["target"][_Lua]~=nil then
            -- MainGameUI["target"][_Lua] = obj1
            Target = MainGameUI["target"][_Lua]
            if Target.UIDragEvent==nil then
                return
            end

            MainGameUI["UIDragEvent"][_Lua] = Target.UIDragEvent
            MainGameUI["UIDragEvent"][_Lua](Target , _Lua , _Gob , _Detal)
        end
    end
end

function  GameMain.UIPressItemEvent(_Lua , _Gob , _isPress)

    if MainGameUI["UIOnPress"][_Lua]~=nil then
        MainGameUI["UIOnPress"][_Lua](nil , _Lua , _Gob , _isPress)
    else
        --local lua = this.requireLuaFile(_Lua)

        --local obj1 = lua:new()
        local Target = nil
        if MainGameUI["target"][_Lua]~=nil then
            Target = MainGameUI["target"][_Lua]
            if Target.UIOnPress==nil then
                return
            end
            MainGameUI["UIOnPress"][_Lua] = Target.UIOnPress
            MainGameUI["UIOnPress"][_Lua](Target , _Lua , _Gob , _isPress)
            -- MainGameUI["target"][_Lua] = obj1
        end
    end
end

function GameMain.UpdateItems(_Lua , _Item)
     if MainGameUI["target"][_Lua]~=nil then
        local Target = MainGameUI["target"][_Lua]
        Target:UpdateItem(_Lua , _Item)
    end
end

function GameMain.SetIcon(_Sprite , _AtlasName , _SpriteName)

    AtlasMsg.SetAtlas(_Sprite , _AtlasName , _SpriteName)

end

function GameMain.SetIconById(_Sprite , _Id)   
  local HeroData =  RoleDataConfig.GetRoleById(_Id) 
  AtlasMsg.SetAtlas(_Sprite , HeroData.AtlasName , HeroData.SpriteName)                                          
end

function GameMain.GetConfigData(_Type , _Id)
    if _Type == "RoleData" then
       return RoleDataSys.GetRoleById(_Id)
    elseif _Type == "Skill" then
       return RoleSkillConfig.GetRoleSkillById(_Id)
    elseif _Type == "Ammo" then
       return AmmoConfig.GetAmmoById(_Id)
    elseif _Type == "Buff" then
       return BuffConfig.GetBuffById(_Id)
    elseif _Type == "Map" then
       return MapConfig.GetMapConfigById(_Id)
    elseif _Type == "Tx" then
       return TxConfig.GetTxById(_Id)
	 elseif _Type == "RoleInfo" then
       return RoleInfoConfig.GetRoleInfoConfig()
    end
end

function GameMain.GetRoleProp(_Id , _Lvl , _QualityLvl)
    return CalculateRoleProp.CalculatProp(_Id , _Lvl , _QualityLvl)
end

function GameMain.GetHeroProp(_Type , _Camp , _UUID)
    return CalculateRoleProp.GetHeroProp(_Type , _Camp , _UUID)
end

function GameMain.GetSoliders()
    return TeamSys.GetPveSoliders()
end

function GameMain.GetHero()

    local _PveInfo = TeamSys.GetPveHeros()
    local PveList = {}
    for i = 1 , #_PveInfo , 1 do
        local hero = HeroPackageSys.GetOneHeroBy_UUID(_PveInfo[i].UUID)
        if hero~=nil then
           table.insert(PveList , #PveList + 1 , hero)
        end
    end
    return PveList

end

function GameMain.GetPvpTeam()
    if BattleFieldSys.BattleFieldType ==1 or BattleFieldSys.BattleFieldType ==0 then 
       return TeamSys.GetPvpTeam()
    elseif BattleFieldSys.BattleFieldType ==2 then
       return TeamSys.GetJJCTeam()
    end
end

function GameMain.GetPvpTeam2()
    if BattleFieldSys.BattleFieldType ==1 then 
       if #BattleFieldSys.TempPlayerInfo.BattleFieldFormation==0 then
          return TeamSys.GetPVPDefaltTeam()--TeamSys.GetPvpTeam()
       end
       return BattleFieldSys.TempPlayerInfo.BattleFieldFormation

    elseif BattleFieldSys.BattleFieldType ==2 then
       if #BattleFieldSys.TempPlayerInfo.BattleHeroFormation==0 then
          return TeamSys.GetJJCDefaltTeam()--TeamSys.GetJJCTeam()
       else
          return BattleFieldSys.TempPlayerInfo.BattleHeroFormation
       end       
    end
end

function GameMain.GetBattleInfo1()
    local _data = 
    {
        AddAttack = 0,
        AddAttack1 = 0,
        AddAttack2 = 0,
        AddAttack3 = 0,
        AddHp = 0,
        AddHp1 = 0,
        AddHp2 = 0,
        AddHp3 = 0,
        ReduceDamDepart = 0,
        ReduceDamNum  = 0,
    }

    if BattleFlagSys.CalculateProp[1]~=nil then         --盾     
       _data.AddAttack1 = BattleFlagSys.CalculateProp[1].Attack
       _data.AddHp1 = BattleFlagSys.CalculateProp[1].Hp
       if BattleFlagSys.CalculateProp[1].Reduction~=0 then
          _data.ReduceDamDepart = 1
          _data.ReduceDamNum = BattleFlagSys.CalculateProp[1].Reduction
       end

    end
    if BattleFlagSys.CalculateProp[2]~=nil then         --弓
       _data.AddAttack2 = BattleFlagSys.CalculateProp[2].Attack
       _data.AddHp2 = BattleFlagSys.CalculateProp[2].Hp
       if BattleFlagSys.CalculateProp[2].Reduction~=0 then
          _data.ReduceDamDepart = 2
          _data.ReduceDamNum = BattleFlagSys.CalculateProp[2].Reduction
       end
    end
    if BattleFlagSys.CalculateProp[3]~=nil then         --枪
       _data.AddAttack3 = BattleFlagSys.CalculateProp[3].Attack
       _data.AddHp3 = BattleFlagSys.CalculateProp[3].Hp
       if BattleFlagSys.CalculateProp[3].Reduction~=0 then
          _data.ReduceDamDepart = 3
          _data.ReduceDamNum = BattleFlagSys.CalculateProp[3].Reduction
       end
    end 
    return _data  
end

function GameMain.GetBattleInfo2()
   local _data = 
    {
        AddAttack = 0,
        AddAttack1 = 0,
        AddAttack2 = 0,
        AddAttack3 = 0,
        AddHp = 0,
        AddHp1 = 0,
        AddHp2 = 0,
        AddHp3 = 0,
        ReduceDamDepart = 0,
        ReduceDamNum  = 0,
    }
    return _data
end



function GameMain.GetWorldBattleInfo()                                  --获取当前国战战斗
   WorldMapSocketSys.SendRequestSeeFight(WorldMapSocketSys.FightType , WorldMapSocketSys.FightCity)
   WorldMapSocketSys.SendRequestRoomMember(3 , WorldMapSocketSys.FightCity , GameMain.SetPvpBattleInfo)
end

function GameMain.SetPvpBattleInfo(_data)
   local _AttackMember = {}
   local _DefenceMemebr = {}
   for i = 1 , _data.defenceNum , 1 do
       local data = 
       {
          name = UIstring.Ownerships[_data.MembersComp[i + 3]].._data.Members[i],
       }
       table.insert(_DefenceMemebr , #_DefenceMemebr + 1 , data)
   end

   
   for i = _data.defenceNum + 1 , _data.TotoalNum , 1 do
       local data = 
       {
          name = UIstring.Ownerships[_data.MembersComp[i + 3]].._data.Members[i],
       }
       table.insert(_AttackMember , #_AttackMember + 1 , data)
   end
   lgNoDelCsFun.Ins:Setpvprolelist(_AttackMember , _DefenceMemebr)
end



function GameMain.MapOver(_Win , _SpriteFather)
	MusicManagerSys.BattleAfter(_Win)
   
    if GameMain.MapType == 4 then                                       --Pvp
       if BattleFieldSys.BattleFieldType ==1 then                       --沙场点兵 
          BattleFieldSys.BattleFieldOver(_Win , _SpriteFather)
       elseif BattleFieldSys.BattleFieldType ==2 then                   --斗将台
          BattleFieldSys.BattleHeroOver(_Win , _SpriteFather)
       end
        BattleFieldSys.BattleFieldType = 1
    elseif GameMain.MapType == 2 then
       _SpriteFather.gameObject:SetActive(true)
    elseif GameMain.MapType == 1 then                                    --normal map
       MapSys.OverMap(_Win , _SpriteFather)
    elseif GameMain.MapType == 3 then                                    --boss map
       MapSys.OverMap(_Win , _SpriteFather)
    end
end

function GameMain.JumpToPanel(_Type)
   GameMain.OutBattleToPanel = _Type + 1
end

function GameMain.BattleReady()                                       --战斗界面创建完毕 开始引导
   GuideSys.CreateBigStepGob()
   Debug.LogError("战斗界面创建完毕 开始引导")
end

function GameMain.GetBattleUIGob()                                      --获取战斗引导Gob
  -- Debug.LogError("获取战斗引导Gob")
   local _BattleGob = lgNoDelCsFun.Ins:GetBattleUI()
   --Debug.LogError(_BattleGob)
   return _BattleGob
end

function GameMain.SetBattleYindao()                                 --设置战斗引导
   Debug.LogError("设置战斗引导")
   lgNoDelCsFun.Ins:SetYindao()
end

function GameMain.OutSoldier(_Index)                                      --出小兵
   lgNoDelCsFun.Ins:OutSoldier(_Index)
end

function GameMain.OutHero(_Index)                                     --出英雄
   lgNoDelCsFun.Ins:OutHero(_Index)
end

function GameMain.SetNoHumanHero(_Type)
   lgNoDelCsFun.Ins:SetNoHumanHero(_Type)
end

function GameMain.PauseBattleGame()                                   --暂停打开战斗进程
   Debug.LogError("暂停战斗流程")
   lgNoDelCsFun.Ins:PauseGameAll()
end

function GameMain.StartBattleGame()                                   --暂停打开战斗进程
   Debug.LogError("开始战斗流程")
   lgNoDelCsFun.Ins:PauseGameAll()
end

function GameMain.OutBattleGuide()

end

function GameMain.WebEvent(_EventId)
    local Data =
    {
        Descrip = ""
    }
    if _EventId==1002 then
       -- Data.Descrip = UIstring.NetError
        DataUIInstance.PopTipPanel("NetError" , GameMain.HandleWebEvent , Data)
    end
    if _EventId==1007 then
       -- Data.Descrip = UIstring.CPPNetError
        LoadingPanel.StopChangeScenePanel()
       -- DataUIInstance.PopTipPanel("NetError" , GameMain.HandleCPPNet , Data)
    end
    if _EventId==2 then
       DataUIInstance.PopTipPanel("NetError" , GameMain.HandleWebEvent , Data)
    end
end

function GameMain.HandleWebEvent()
    LoadingPanel.StopLoading()                                          --清除转圈
    GuideSys.ReleaseGuide()                                             --清除引导

    for key , value in pairs(MainGameUI.GameObject) do
        if key == "UIControl" then

        else

           value.gameObject:SetActive(false)
        end
    end

    if MainGameUI.PanelOpenName=="UIWorldMap" then
       if MainGameUI.NowPanelTarget~=nil then
          MainGameUI.NowPanelTarget:InitPanel()
       end
    end
    if MainGameUI.PanelOpenName=="UITeamMake" then
       if MainGameUI.NowPanelTarget~=nil then
          MainGameUI.NowPanelTarget:InitPanel()
       end
    end
    
    GameMain.LoginOutGame()

   --[[ if MainGameUI.PanelOpenName~="null" and MainGameUI.NowPanelTarget~=nil then
       MainGameUI.NowPanelTarget:InitPanel()
    end

    if MainGameUI.LastPanelTar~=nil then
       MainGameUI.LastPanelTar:InitPanel()
    end--]]

    

    --[[if MainGameUI.PanelOpenName~="null" and MainGameUI.NowPanelTarget~=nil then
        MainGameUI.NowPanelTarget:ClosePanel()
    end
    local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    if UIControlTar~=nil then
        UIControlTar:ClosePanel()
    end
    local UIPopPanelTar = MainGameUI.FindPanelTarget("UIPopPanel")
    if UIPopPanelTar~=nil then
        UIPopPanelTar:ClosePanel()
    end

    GuideSys.ReleaseGuide()                  --释放引导
    LoadingPanel.CloseLoadingGamePanel()

    if GameStateIns.NowStateName == "mainsceneState" then
        GameStateIns.ChangeState("LoginState")
    end

    if GameStateIns.NowStateName == "battleState" then
        if lgBtSceneMag~=nil  then
            lgBtSceneMag.EndBtSceneLogic()
        end
    end           --]]
end

function GameMain.HandleCPPNet()

end

--PHP网络事件z
function GameMain.SendPack(data , funcname , cb)
    if funcname~="HeartJump.SendHeartJumpCallBack" and funcname~= "HeartJump.SavePowerCallBack" then
        LoadingPanel.OpenLoading()
    end
    GameMain.AddCallBack(funcname, cb)

    local PackIns = packMgr.GetInstance();
    PackIns:limitSendPackLua(data);
end

--深拷贝
function GameMain.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[GameMain.DeepCopy(orig_key)] = GameMain.DeepCopy(orig_value)
        end
        setmetatable(copy, GameMain.DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GameMain.AddComponent(obj,csstr)
    lgNoDelCsFun.Ins:AddComponent(obj.transform,csstr)
end

--更新一次自动战斗设置
function GameMain.UpdateAutoAtt()
    GameMain.SetPlayerIntSet("AutoAtt",GameMain.UseAutoAttack)
end

function GameMain.GetAutoAttSet()
    local result = false

    result,GameMain.UseAutoAttack = GameMain.GetPlayerIntSet("AutoAtt")
    if result==false then
        --GameMain.UseAutoAttack = false
        GameMain.SetPlayerIntSet("AutoAtt",GameMain.UseAutoAttack)
    end

end

--保存玩家设置 整形
function GameMain.SetPlayerIntSet(str,va)
    PlayerPrefs.SetInt (str, va)
end


--得到玩家设置 -
function GameMain.GetPlayerIntSet(str)
    if PlayerPrefs.HasKey (str) ==true then
        return true, PlayerPrefs.GetInt (str)
    end
    return false , 0
end

--获得当前开发环境
function GameMain.GetDevelopEnviroment()
    return lgNoDelCsFun.Ins:GamePlatform()
end

--网络异常通知
function GameMain.NetDieCB(str)
    DebugLogMag.PrintThisThis(3,"GameMain_NetDieCB","GameMain_NetDieCB str="..str,nil)
    if MyGameMainState == "battle" then --在战斗中 --提示退出战斗
        --弹出网络异常通知
        --GameMain.CB_QuitNowBt()

        local Data={}
        Data.Descrip =""
        if str~=nil then
            Data.Descrip = str
        end
        DataUIInstance.PopTipPanel("NetError" , GameMain.CB_QuitNowBt , Data)

    else --在外面主城
        local Data={}
        Data.Descrip =""
        if str~=nil then
            Data.Descrip = str
        end
        DataUIInstance.PopTipPanel("NetError" , nil , Data)
    end
end

--通知退出当前战斗
function GameMain.CB_QuitNowBt()
    if lgBtSceneMag~=nil  then
        lgBtSceneMag.EndBtSceneLogic()
    end
end

GameMain.ShowLog = false
---------------------------------------------------------
--  网络模块测试代码
---------------------------------------------------------
function GameMain.SocketTestCase()
    -- 建立连接
    --local SocketIp = "120.27.35.40"

    SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveAfterConnected, GameMain.ReceiveAfterConnectedHandle); --确认连接    
    SocketClient.RegistMsgHandle(SocketClient.MsgID.ReceiveDebugMsg, GameMain.ReceiveDebugMsgHandle);   
    WorldMapSocketSys.LoginSocketEvent()
    GameMain.ShowLog = true
    --SocketClient.CreateConnection("172.16.3.126", 49001);
    --local SocketIp = "172.16.3.126"     --张蓉蓉
    -- SocketClient.CreateConnection("127.0.0.1", 49001);
    -- 注册网络收包回调函数
    Debug.LogError("服务器下发的IP：")
    Debug.LogError(ClinetInfomation.Ip)
    Debug.LogError("服务器下发的端口：")
    Debug.LogError(ClinetInfomation.Port)
    SocketClient.CreateConnection(ClinetInfomation.Ip , ClinetInfomation.Port); 
    --SocketClient.CreateConnection("127.0.0.1", 49001); 
   -- SocketClient.CreateConnection("116.62.46.41", 49001);         --线上     


end
function GameMain.SendCastSpell(spellId)
    local data = {
        intList = { tonumber(spellId) },
    };
	SocketClient.SendNetEvent(SocketClient.MsgID.RequestCastSpell, data);
end
function GameMain.SendMove(pos)
    local data = {
        intList = { tonumber(pos) },
    };
    SocketClient.SendNetEvent(SocketClient.MsgID.RequestMove, data);
end

function GameMain.ReceiveLoginHandle(data)
   GameMain.Print(data , "返回登录")


end

function GameMain.ReceiveAfterConnectedHandle(data)
    Debug.LogError("握手成功");
    local playerDataVersion = 1;
    local data = {
        intList = { GameVersion.TeamVersion , LoginData.LoginServerId},
        stringList = { LoginData.token },
    };
--    GameMain.Print(LoginData.LoginServerId , "serverid")
    SocketClient.SendNetEvent(SocketClient.MsgID.RequestLogin, data);
end

function GameMain.ReceiveDebugMsgHandle(data)
    Debug.LogWarning("Info: " .. data.stringList[1]);
end

--[[function GameMain.ReceiveMoveHandle(data)
    local playerId = tonumber(data.intList[1]);
    local v = tonumber(data.intList[2]);
    local s = "广播：禽兽" .. tostring(playerId);
    local s2
    if v == 1 then
        s2 = "向左移动啦";
    elseif v == 2 then
        s2 = "向右移动啦";
    elseif v == 3 then
        s2 = "向上移动啦";
    elseif v == 4 then
        s2 = "向下移动啦";
    end
    Debug.Log(s .. s2);
end--]]

--[[function GameMain.ReceiveCastSpellHandle(data)
    local playerId = tonumber(data.intList[1]);
    local v = tonumber(data.intList[2]);
    local s = "广播：禽兽" .. tostring(playerId);
    Debug.Log(s .. "放了大招" .. tostring(v));
end--]]

function GameMain.ReceiveBattleEndHandle(data)
    Debug.LogWarning("战斗结束: " .. data.stringList[1]);
end

--取整数(向下取)
function GameMain.ConvertToInt(Num)
	if Num <= 0 then
	   return math.ceil(Num);
	end

	if math.ceil(Num) == Num then
	   Num = math.ceil(Num);
	else
	   Num = math.ceil(Num) - 1;
	end
	return Num;
end

function GameMain.ConvertNumStr(num)
	local str = ""
	if num>100000000 then
		local count = num / 100000000
		local showNum = GameMain.RetainPoint(count ,2)
		str = tostring(showNum) .."亿"
		return str
	end
	if num>100000 then
		num = GameMain.ConvertToInt(num/10000)
		str = tostring(num) .."万"
	else
		str = tostring(num)
	end
	
	return str
end

--region *.lua  将物体隐藏、打开

function GameMain.CloseObj(obj)
	if obj~=nil then
		obj.gameObject:SetActive(false)
	end
end

function GameMain.OpenObj(obj)
	if obj~=nil then
		obj.gameObject:SetActive(true)
	end
end
--endregion

function GameMain.GetChilds(parent)		--获得包括自己在内的子物体	
	local list = lgNoDelCsFun.Ins:GetChilds(parent.transform)
	if list == nil then
		return nil
	else
		return list
	end
end

function GameMain.RetainPoint(Num , n)--取小数点后面第几位（Num:数；n:位数）四舍五入
	if type(Num) ~= "number" then
			return Num;
		end
    
	n = n or 0;
	n = math.floor(n)
	local fmt = '%.' .. n .. 'f'
	local nRet = tonumber(string.format(fmt, Num))

    return nRet;
end

 function GameMain.GetStringWordNum(str)
--    local fontSize = 20
    local lenInByte = #str
    local count = 0
    local i = 1
    while true do
        local curByte = string.byte(str, i)
        if i > lenInByte then
            break
        end
        local byteCount = 1
        if curByte > 0 and curByte < 128 then
            byteCount = 1
        elseif curByte>=128 and curByte<224 then
            byteCount = 2
        elseif curByte>=224 and curByte<240 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        else
            break
        end
        -- local char = string.sub(str, i, i+byteCount-1)
        i = i + byteCount
        count = count + 1
    end
    return count
end

function GameMain.ToPlayAni(_Model , _AnimationName)		--播放动画
	 lgNoDelCsFun.Ins:PlayAnimation(_Model , _ModelName , _AnimationName)   
end

function GameMain.DoDbInfo(_DBInfo)
   local DbInfo = {}
   for i = 1 , #_DBInfo , 1 do
       DbInfo[i-1] = _DBInfo[i]
   end
   return DbInfo
end

function GameMain.modf(_Num , _N)
   local t1 , t2 = math.modf(_Num/_N)
   return t2
end
GameMain.isOpenChat = false
--发送初始化的聊天信息
function GameMain.SendChatData( _CountryChatId , _WorldChatId)
	if GameMain.IsEnterBattle == true then
		return
	end
	if GameMain.isOpenChat == true then
		return
	end
	GameMain.isOpenChat = true
	local name = ClinetInfomation.Name

	local uuid = ClinetInfomation.GuaShuaiUUID
	if uuid == "" then
		uuid = ""
	end
	local lvl = ClinetInfomation.Lvl
	local vip = VipSys.VipLevel
	local countroy = ClinetInfomation.MyOwner
	if countroy == 0 then
		countroy = -1
	end
	local commandId = 0
	if uuid ~= "" then
		local commandList = GameMain.StringSplit(uuid , "S")
		commandId = tonumber( commandList[2])
		if commandId == nil then
			commandId = 0
		end
	end
	lgNoDelCsFun.Ins:SendInitChat(name , uuid , countroy , _CountryChatId , _WorldChatId , lvl , 4 , UIstring.CountryAtlasName , UIstring.OwnerShipImg[ClinetInfomation.MyOwner] , commandId)

	GameMain.OpenChatType(GameMain.ChatObj , 0)
end
--打开不同的聊天类型
function GameMain.OpenChatType( _God, _Type)
	if lgChatMag.Ins~=nil then
		lgChatMag.Ins:OpenChat(GameMain.ChatObj , _Type)
	end
	
end

function GameMain.SetChatInfo()
	local commandId = 0
	if ClinetInfomation.GuaShuaiUUID ~= nil then
		local commandList = GameMain.StringSplit(ClinetInfomation.GuaShuaiUUID , "S")
		commandId = tonumber(commandList[2])
		if commandId == nil then
			commandId = 0
		end
	end
	local name = ClinetInfomation.Name
	local countroy = ClinetInfomation.MyOwner
	if countroy == 0 then
		countroy = -1
	end
	if lgChatMag.Ins ~= nil then
		lgChatMag.Ins:SetChatfblvl(ClinetInfomation.Lvl , countroy , commandId , name)
	end
	
end

--得到网络的状态 0 没有网络；1流量上网；2WiFi上网
function GameMain.GetNetState()
	local netState = lgNoDelCsFun.Ins:GetNetState()
	return netState
end

--得到电量信息
function GameMain.GetBattery()
	local battle = lgNoDelCsFun.Ins:GetBattery()
	if battle ==-1 then
		return -1
	end
	return battle/100
end

function GameMain.GetStrByteCount(_Str)
	local count =  lgNoDelCsFun.Ins:GetStrByteCount(_Str)
	return count
end

--专为聊天飘字
function GameMain.PopChatTips(_Str)
	DataUIInstance.PopTip(_Str)
end

--发送购买的信息
function GameMain.ToSendBuyInfo(_AppStoreId, _Str)
--	GameMain.EndSendBuyInfo(true , 100)--ceshi
	lgNoDelCsFun.Ins:AskBuy(_AppStoreId , _Str)
end

function GameMain.StartSendBuyInfo()
	LoadingPanel.OpenLoading()
end

function GameMain.EndBuyWeb(_IsSuccess)
	LoadingPanel.StopLoading()
	if _IsSuccess == 0 then
		DataUIInstance.PopTip(UIstring.CostSuccess)
	else
		DataUIInstance.PopTip(UIstring.CostErroer)
	end
end

function GameMain.EndSendBuyInfo(_IsSuccess , _Num)
	if _IsSuccess == true then
		if RechargeSys.BuyGoods.Recharge == true then
			RechargeSys.BuyGoods.Recharge = false
			RechargeSys.BuyDiamondCallBack()
		end
		
		if RechargeSys.BuyGoods.EveryWeekSpecail == true then
			RechargeSys.BuyGoods.EveryWeekSpecail = false
			SpecialFavourableSys.BuyEveryWeekByIdCallBack()
		end
		
		if RechargeSys.BuyGoods.EveryDaySpecail == true then
			RechargeSys.BuyGoods.EveryDaySpecail = false
			SpecialFavourableSys.BuyEveryDayByIdCallBack(_Num)
		end
		if RechargeSys.BuyGoods.VipSpecail == true then
			RechargeSys.BuyGoods.VipSpecail = false
			VipSpecailSys.ReciveRwdCallBack()
		end
		if RechargeSys.BuyGoods.Fund == true then
			RechargeSys.BuyGoods.Fund = false
			FundDataSys.FundPourCallBack()
		end
	else
		DataUIInstance.PopTip(UIstring.BuyErroer)
		RechargeSys.BuyGoods.Fund = false
		RechargeSys.BuyGoods.VipSpecail = false
		RechargeSys.BuyGoods.EveryDaySpecail = false
		RechargeSys.BuyGoods.EveryWeekSpecail = false
		RechargeSys.BuyGoods.Recharge = false
	end
end

--删除支付的订单
function GameMain.ClearBuyRecord(_IsSuccess , _Num)
	GameMain.EndSendBuyInfo(_IsSuccess , _Num)
	lgNoDelCsFun.Ins:ClearBuyRecord()
end

function GameMain.CSSendWeb(_M , _A , _P)

   local data = 
	{
		A = _A,
		M = _M,
		P = _P	
	}
	
	WebEvent.SendPack(data , "GameMain.CSSendWebCallBack" , GameMain.CSSendWebCallBack)	
end

function GameMain.CSSendWebCallBack(data , _returnId)
   lgNoDelCsFun.Ins:SendWebCallBack(_returnId)
end

GameMain.IOSTest = false--是否是苹果测试版本
GameMain.StopSysBan = true	

function GameMain.LoginOutGame()
	for key, value in pairs(MainGameUI["target"]) do
        if value~=nil then      
           value:ReleasData()
        end
	end
    PlayerControl.ReleaseData() 
    WorldMapEventSys.ReleaseData()
    BoardCastSys.ReleaseData()
    MissionSys.ReleaseData()
    HeroPackageSys.ClearData()
    SoliderPackageSys.ClearData()
    TeamSys.ClearData()
    BattleFlagSys.ReleaseData()
    HeartJump.Release()
	GameMain.EnterGame = false
	GameMain.isFirst = false
	GameMain.isOpenChat = false
	GameMain.InitUI()
	lgChatMag.Ins:CloseChat(true)
 
end

function GameMain.SetParticleScale(_Scale , _God)
--	lgNoDelCsFun.Ins:SetParticleScale(_Scale , _God)
end

function GameMain.AddFriend(_UUID)
	FriendSys.RequestFriend(_UUID)
end

return GameMain
