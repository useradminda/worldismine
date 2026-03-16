ClinetInfomation = {}												--客户端信息

ClinetInfomation.World_id = nil										--主角
ClinetInfomation.Name = "nil"                                       
ClinetInfomation.MyOwner = 1                                        --1 ， 2 ，3 ，4 蜀 魏 吴 中立
ClinetInfomation.PlayerId = nil
ClinetInfomation.WorldTime = 0
ClinetInfomation.GuaShuaiUUID = nil									--挂帅武将的UUID
ClinetInfomation.Player_id = nil									--玩家ID
ClinetInfomation.Lvl = 0											--玩家等级
ClinetInfomation.VipExp = 0											--vip经验
ClinetInfomation.VipLevel = 0											--vip等级
ClinetInfomation.Fight = 0                                          --战斗力
ClinetInfomation.Honour = 0											--荣誉
ClinetInfomation.Feats = 0											--功勋
ClinetInfomation.Reputation = 0										--声望
ClinetInfomation.Exp = 0											--主角经验
ClinetInfomation.powerRank = 0										--战斗力排名
ClinetInfomation.compRank = 0										--综合排名
ClinetInfomation.featsRewardTimes = 0       
ClinetInfomation.goldticket = 0										--金券（用于寄售行）       
ClinetInfomation.BuyArmyTime = 0
ClinetInfomation.ServeID = "10003"
ClinetInfomation.Ip = ""
ClinetInfomation.Port = 0
ClinetInfomation.King = 0

function ClinetInfomation.GetPlayerInfo(data)  
	local info = data
	local nickname = info["nickname"]
	ClinetInfomation.PlayerName = nickname
    if ClinetInfomation.PlayerName~=nil then
       TalkingDataDemoScript.Ins:SetAccountName(ClinetInfomation.PlayerName)	
    end
    local coin = tonumber(info["coin"])
	ClinetInfomation.Coin = coin
    local diamond = tonumber(info["diamond"])
    ClinetInfomation.Diamond = diamond
    local sta = tonumber(info["sta"])
    ClinetInfomation.Sta = sta
    local energy = tonumber(info["energy"])
    ClinetInfomation.Energy = energy
    local recharge = tonumber(info["recharge"])
    ClinetInfomation.CostRMB = recharge
    VipSys.CostRMB = recharge
    local vip = tonumber(info["vip"])
    ClinetInfomation.VipLevel = vip
    VipSys.VipLevel = vip
    local lvl = tonumber(info["level"])
    ClinetInfomation.Lvl = lvl

    if ClinetInfomation.Lvl~=nil then
       TalkingDataDemoScript.Ins:SetLevle(ClinetInfomation.Lvl)
    end

    local Exp = tonumber(info["exp"])
    ClinetInfomation.Exp = Exp
    local Credit = tonumber(info["credit"])
    ClinetInfomation.Credit = Credit
    local World_id = tostring(info["_id"])
    ClinetInfomation.World_id = World_id
    local MasterCoin = tonumber(info["dsb"])
    ClinetInfomation.MasterCoin = MasterCoin
    local BloodStone = tonumber(info["bloodStone"])
    ClinetInfomation.BloodStone = BloodStone
    local RealId = tonumber(info["realID"])
    ClinetInfomation.RealId = RealId

    local FreeName = info["preName"]
    if FreeName~=nil then
       ClinetInfomation.FreeName = FreeName                                    
    else
       ClinetInfomation.FreeName = nil
    end

    local NextStaTime = tonumber(info["update_sta_time"])
    if ClinetInfomation.WorldTime - NextStaTime > 0 then
        ClinetInfomation.NextSta_Time = 480 - (ClinetInfomation.WorldTime - NextStaTime)
        TimeControl.LoginTime(ClinetInfomation.NextSta_Time , "NextSta_Time")
    end
    local NextEnergyTime = tonumber(info["update_energy_time"])
    if ClinetInfomation.WorldTime - NextStaTime > 0 then
       ClinetInfomation.NextEnergy_Time = 480 - (ClinetInfomation.WorldTime - NextEnergyTime)
       TimeControl.LoginTime(ClinetInfomation.NextEnergy_Time , "NextEnergy_Time")
    end
   
    local FightRank = info["rank"]["battleRank"]
    ClinetInfomation.FightRank = FightRank                                      --战斗力排行
    local StarRank = info["rank"]["mapRank"]
    ClinetInfomation.StarRank = StarRank                                       --星级排行
    local ArenaRank = info["rank"]["arenaRank"]
    ClinetInfomation.ArenaRank = ArenaRank                                      --竞技场排行
    

    local babyinfo =
    { 
        realID = tonumber(info["realID"]),
        star = tonumber(info["star"]),
	    isActivated = 1,
	    quality = tonumber(info["quality"]),
        qualityLvl = tonumber(info["q_level"]),
	    level = tonumber(info["level"]),
        skill = info["skill"],
     }
     local theme = roleDataSys.CreateOneRole(babyinfo)

     local EquipList = info["playerEquip"]                         --主角的穿戴装备
     local Count = #EquipList
     theme.PlayerEquip = {}
     for key , value in pairs(EquipList) do
        local Equip = EquipList[key]
        local uuid = tostring(Equip["uuid"])
        local pos = tonumber(Equip["pos"])
        theme.PlayerEquip[pos] = ItemPackageSys.FindItem(uuid) 
     end

     ClinetInfomation.theMe = theme
     local upRoles = TeamSys.GetPveTeamBaby()
     theme:TeamTotalProp(upRoles)                                           --计算主角属性
     
     local data =                                                   --刷新账号信息
     {  
        Name = nickname,
        Lvl = lvl,
        Coin = coin,
        Diamond = diamond,
        Sta = sta,
        Energy = energy,
        Vip = vip,
        RealId = RealId,
     }
     local ControlTar = MainGameUI.FindPanelTarget("UIControl")
     local ControlGob = MainGameUI.FindPanel("UIControl")
     if ControlTar~=nil and ControlGob~=nil then
        ControlTar:SetLeftTopPlayerInfo(data)
        ControlTar:SetNowMap()       
        if ClinetInfomation.CostRMB==nil or ClinetInfomation.CostRMB==0 then
           --ControlTar:OpenFirstRecharge()
        end
        ControlTar:SetTopLeftFight()
     end 
 
end

function ClinetInfomation.Update(dt)				--设置本地的时间
	if ClinetInfomation.WorldTime~=nil then
		ClinetInfomation.WorldTime  = ClinetInfomation.WorldTime +dt
	end
	
end
ClinetInfomation.UpLvl = false
ClinetInfomation.IsReSetChatInfo = false
function  ClinetInfomation.ComminfoCallBack(data) 
    local info = data
    ClinetInfomation.WorldTime = tonumber(data["worldTime"])
	local guashuaiUUID = tostring(data["commanderUUID"])
	if guashuaiUUID ~= ClinetInfomation.GuaShuaiUUID then
		if GameMain.isOpenChat == true then
			ClinetInfomation.IsReSetChatInfo = true
		end
	end
	ClinetInfomation.GuaShuaiUUID = tostring(data["commanderUUID"])
    ClinetInfomation.Player_id = tostring(data["_id"])
  
	local lvl = tonumber(data["level"])
	if ClinetInfomation.Lvl ~= lvl then
		if GameMain.EnterGame == true then
			ClinetInfomation.UpLvl = true
		end
	end
	
	ClinetInfomation.Lvl = lvl

	local name =  tostring(data["name"])
	if name ~=  ClinetInfomation.Name then
		if GameMain.isOpenChat == true then
			ClinetInfomation.IsReSetChatInfo = true
		end
	end
	ClinetInfomation.Name = name
	if GameMain.EnterGame == false then
		GameMain.EnterGame = true
	end
	local camp = tonumber(data["camp"])
	if GameMain.isOpenChat == true then
		if ClinetInfomation.MyOwner ~= camp then
			ClinetInfomation.IsReSetChatInfo = true
		end
	end
	
	ClinetInfomation.MyOwner = camp 
	
	if GameMain.isOpenChat == true then
		if ClinetInfomation.IsReSetChatInfo == true then
			GameMain.SetChatInfo()
			ClinetInfomation.IsReSetChatInfo = false
		end
		
	end
    ClinetInfomation.Vip = tonumber(data["vip"])
	VipSys.VipLevel = ClinetInfomation.Vip
    ClinetInfomation.Diamond = tonumber(data["diamond"])
    ClinetInfomation.Coin = tonumber(data["coin"])
	
    ClinetInfomation.Sta = tonumber(data["sta"])
	ClinetInfomation.Sta_Update_Time = tonumber(data["sta_update_time"])
	ClinetInfomation.VipExp = tonumber(data["vip_exp"])
	VipSys.Exp = ClinetInfomation.VipExp
	VipSys.Exp = ClinetInfomation.VipExp

	TechnologySys.ComminfoCallBack(data)
	GameMain.AddUpdateLua(ClinetInfomation.Update)

    local BFRank = tonumber(data["legionCombatRank"])
    BattleFieldSys.SetBattleFieldRank(BFRank)
    local BHRank = tonumber(data["heroCombatRank"])
    BattleFieldSys.SetBattleHeroRank(BHRank)

    local Active = tonumber(data["active"]) 
    MissionSys.SetNowActive(Active)
    
    ClinetInfomation.Honour = tonumber(data["honour"]) 

	ClinetInfomation.Feats = tonumber(data["feats"])
    local _UIWorldMapTar = MainGameUI.FindPanelTarget("UIWorldMap") 
    if _UIWorldMapTar~=nil then
       _UIWorldMapTar:SetNowGlory()
    end

	ClinetInfomation.Reputation = tonumber(data["reputation"])
	ClinetInfomation.Exp = tonumber(data["exp"])
    ClinetInfomation.featsRewardTimes = tonumber(data["featsRwdTime"])

	local comprehensiveRank = tonumber(data["comprehensiveRank"])
	if comprehensiveRank~=nil then
		 ClinetInfomation.compRank = comprehensiveRank
	end
   
	local powerRank = tonumber(data["powerRank"])
	if powerRank~=nil then
		ClinetInfomation.powerRank =  powerRank
	end
	local lotoTicket = tonumber(data["lotoUsed"])
	if lotoTicket~=nil then
		ConsumeRaffleSys.lotoUsed = lotoTicket
	end
	local consumeDiamoned = tonumber(data["diamond_consumed"])
	if consumeDiamoned~=nil then
		ConsumeRaffleSys.CostDiamoned = consumeDiamoned
	end
	local goldticket = tonumber(data["goldticket"])
	if goldticket~=nil then
		ClinetInfomation.goldticket = goldticket
	end

    local buyPowerChance = tonumber(data["buyPowerChance"])
    if buyPowerChance~=nil then
       WorldMapSys.BuyArmyPower = buyPowerChance
    end

    local king = tonumber(data["king"])
    if king ~=nil then
       ClinetInfomation.King = king
    end

	ClinetInfomation.ServeID = "10003"
	ClinetInfomation.ShowLvlUp()
    local World_id = tonumber(info["_id"])
    ClinetInfomation.World_id = World_id

     local ControlTar = MainGameUI.FindPanelTarget("UIControl")
     local ControlGob = MainGameUI.FindPanel("UIControl")
     if ControlTar~=nil and ControlGob~=nil then
        ControlTar:SetClinetInfo()
        ControlTar:SetNowMap()
		ControlTar:ShowChooseCampBtn()
        ControlTar:SetSta()
		ControlTar:ShowPlayerName()
     end 
	 local UIBagTar  = MainGameUI.FindPanelTarget("UIBag")
	 if UIBagTar ~= nil then
		UIBagTar:ShowBasicInfo()
	 end
	
end

function ClinetInfomation.ShowLvlUp()
	if GameMain.IsEnterBattle == false then
		if GameMain.EnterGame == true and ClinetInfomation.UpLvl == true then
			DataUIInstance.OpenPlayerUpLvl()
			ClinetInfomation.UpLvl = false
		end
	end
end

ClinetInfomation.CountroyId = 0
ClinetInfomation.WorldId = 0

function ClinetInfomation.InitChat()
	if GameMain.IOSTest == false then
		GameMain.SendChatData(ClinetInfomation.CountroyId , ClinetInfomation.WorldId) 
	end
	
end

function ClinetInfomation.LvlUpEvent()
    if ClinetInfomation.theMe~=nil then
       local upRoles = TeamSys.GetPveTeamBaby()
       ClinetInfomation.theMe:TeamTotalProp(upRoles)
    end
end

function ClinetInfomation.GetCoin()
   return ClinetInfomation.Coin

end

function  ClinetInfomation.GetDiamond()
 
    return ClinetInfomation.Diamond

end

function ClinetInfomation.GetSta()

    return ClinetInfomation.Sta

end

function ClinetInfomation.GetReputation()
	return ClinetInfomation.Reputation
end

function ClinetInfomation.GetGuaShuaiUUID()			--得到挂帅武将的UUID
   
	return ClinetInfomation.GuaShuaiUUID
end

function ClinetInfomation.GetMyGuaShuaiHeroImg()
    if ClinetInfomation.GuaShuaiUUID=="" or ClinetInfomation.GuaShuaiUUID==nil then
       return nil
    end
    local Ids = GameMain.StringSplit(ClinetInfomation.GuaShuaiUUID , "S")
    local Id = tonumber(Ids[2])
    local _Role = RoleDataConfig.GetRoleById(Id)
    if _Role==nil then
       return nil
    end
    return _Role.FbxName
end

function ClinetInfomation.GetMyGuaShuaiSpriteName()
   local Ids = GameMain.StringSplit(ClinetInfomation.GuaShuaiUUID , "S")
   local Id = tonumber(Ids[2])
   local _Role = RoleDataConfig.GetRoleById(Id)
   if _Role==nil then
       return
    end
   return _Role.SpriteName
end

function ClinetInfomation.GetWorldGuaShuaiHeroImg(_GuaShuaiUUID)
    local Ids = GameMain.StringSplit(_GuaShuaiUUID , "S")
    local Id = tonumber(Ids[2])
    local _Role = RoleDataConfig.GetRoleById(Id)
    if _Role==nil then
       return
    end
    return _Role.FbxName
end

function ClinetInfomation.GetWorldGuaShuaiName(_Id)
    if _Id==0 or _Id==nil then
       return "CaoCao"
    end
    local _Role = RoleDataConfig.GetRoleById(_Id)
    if _Role==nil then
       return
    end
    return _Role.FbxName
end

function ClinetInfomation.GetCamp()					--得到阵营
	return ClinetInfomation.MyOwner
end
return ClinetInfomation