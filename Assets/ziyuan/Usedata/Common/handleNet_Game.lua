handleNet_Game = {}																								--处理角色登陆 创建信息


function handleNet_Game.RequestPlayerInfo(data)																		--请求玩家信息
	
	WebEvent.RequirePlayerinfo(nil , "handleNet_Game.handlePlayerInfo" , handleNet_Game.handlePlayerInfo)

end

function handleNet_Game.handlePlayerInfo(data , _returnId)																	--处理账号信息
    GameMain.Print(data)
    if _returnId==0 then    
		local isTest = tonumber( data["isReviewVersion"])
		if isTest ~= nil then
			if isTest == 1 then
				GameMain.IOSTest = false
			else
				GameMain.IOSTest = true
			end
		else
			GameMain.IOSTest = true
		end

        ClinetInfomation.Ip = tostring(data["ip"])
        ClinetInfomation.Port = tonumber(data["port"])

		local nationchat = tonumber(data["nationChat"])
		local worldChat = tonumber(data["worldChat"])
		if nationchat ~= nil then
			ClinetInfomation.CountroyId = nationchat
		end
		if worldChat ~=nil then
			ClinetInfomation.WorldId = worldChat
		end
		if GameMain.IOSTest == true then
			local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
			if UIControlTar ~= nil then
				UIControlTar:ShadeWorldBattle()
			end
		end
		ClinetInfomation.InitChat()
		lgNoDelCsFun.Ins:IniSdk(0,1)--测试
--		EquipSys.InitAfterNet()																				--处理装备，将武将装备和背包装备分开
--		RechargeSys.Init()
		HeroPackageSys.SetGuaiShuaiHero()
		VipSpecailSys.InitShow()
		
        PlayerControl.CreateMy()

        CalculateRoleProp.CalculateFight(1)
        CalculateRoleProp.CalculateFight(2)
        CalculateRoleProp.CalculateFight(3)
        CalculateRoleProp.CalculateFight(4)        
        HeartJump.Init()

        local UILoginTar = MainGameUI.FindPanelTarget("UILogin")
		if UILoginTar ~= nil then
			UILoginTar:CloseUILogin()
		end

        GuideSys.InitGuide()
		
      --[[ LoadResourceCache.Init()                                                                         --预加载

	   GameMain.SetStateChange("mainscene") 
       GameMain.EnterMainCity()

       ItemPackageSys.InitPackage(data)                                                                         --处理背包物品
  	    
       TeamSys.GetTeamMsg(data)                                                                                    --分类队伍系统

	   BabyPackSys.RequireBabyListCallBack(data)																	--处理宝宝模块

       MapSys.GetMapInfo(data)                                                                                      --解析地图信息

       ClinetInfomation.GetPlayerInfo(data)                                                                        --解析玩家主角的信息


       if GuideSys.NowBigStep~=1 then                                                                               --第一次进不创建
          --handleNet_Game.handlePlyerGrowInfo()
          GameMain.CreateCity()                                                                                      --创建主城
       else                                                                                                          --第一次进直接打架     
          TeamSys.IsGuide = true                                                                                                        
          local _Mapinfo =   MapSys.NormalMaplist[1][1]                                                                                                         
          MapSys.FightMap(_Mapinfo)                                                                                  --副本战斗开始
          TalkingDataDemoScript.Ins:StartFirstFuben()          
       end
        if ClinetSys.IsDevelop == false then                      
			ChatManager.Ins:_Init(ClinetInfomation.World_id, 31200281, 0, ClinetInfomation.PlayerName .. "&" .. ClinetInfomation.VipLevel .. "&" .. ClinetInfomation.World_id .. "&" .. ClinetInfomation.RealId)  
		end--]]
    end  
end

function handleNet_Game.handlePlyerGrowInfo()                    --处理成长信息
    WebEvent.InitPlayerGrow(nil , "handleNet_Game.handlePlyerGrowInfoCallBack" , handleNet_Game.handlePlyerGrowInfoCallBack)
end

function handleNet_Game.handlePlyerGrowInfoCallBack(data)
   PlayerGrowSys.InitGrowSysCallBack(data)
   for i = 1 , #PlayerGrowSys.MainlineList , 1 do
       local Mission = PlayerGrowSys.MainlineList[i]
       if Mission.Complete >= Mission.Require then
          GameMain.Print(Mission)
          ClinetSys.OpenNotice("playerGrow" , true)
          handleNet_Game.handleMailInfo()
          return
       end
   end
   for i = 1 , #PlayerGrowSys.DailyList , 1 do
       local Mission = PlayerGrowSys.DailyList[i]
       if Mission.Complete >= Mission.Require then
          GameMain.Print(Mission)
          ClinetSys.OpenNotice("playerGrow" , true)
          handleNet_Game.handleMailInfo()
          return
       end
   end
   handleNet_Game.handleMailInfo()
end

function handleNet_Game.handleMailInfo()                          --处理邮件
   WebEvent.InitMail(nil , "handleNet_Game.handleMailInfoCallBack" , handleNet_Game.handleMailInfoCallBack)
end

function handleNet_Game.handleMailInfoCallBack(data)
   MailSys.InitMailsCallBack(data)
   if #MailSys.MailsList > 0 then
      ClinetSys.OpenNotice("Mail" , true)
   end
   handleNet_Game.handleSignInfo()
end

function handleNet_Game.handleSignInfo()                              --处理签到
   WebEvent.InitSignDailyReward(nil , "handleNet_Game.handleSignInfoCallBack" , handleNet_Game.handleSignInfoCallBack)
end

function handleNet_Game.handleSignInfoCallBack(data)                          --处理签到
   SignRewardSys.InitDailyRewardCallBack(data)

   for i = 1 , #SignRewardSys.LoginRewardList , 1 do
       if SignRewardSys.LoginRewardList[i].Receive==1 then
          ClinetSys.OpenNotice("Sign" , true)
          handleNet_Game.handleActivityInfo()
          return
       end
   end

   for i = 1 , #SignRewardSys.LvlRewardList , 1 do  
      if SignRewardSys.LoginRewardList[i].Receive==1 then
         ClinetSys.OpenNotice("Sign" , true)
         handleNet_Game.handleActivityInfo()
         return
      end
   end

   for i = 1 , #SignRewardSys.OnLineRewrdList , 1 do
      if SignRewardSys.LoginRewardList[i].Receive==1 then
         ClinetSys.OpenNotice("Sign" , true)
         handleNet_Game.handleActivityInfo()
         return
      end
   end
   handleNet_Game.handleActivityInfo()
end

function handleNet_Game.handleActivityInfo()                        --处理活动
   WebEvent.InitActivity(nil , "handleNet_Game.handleActivityInfoCallBack" , handleNet_Game.handleActivityInfoCallBack)
end

function handleNet_Game.handleActivityInfoCallBack(data)
   ActivitySys.InitAcivityCallBack(data , 0)
  
  if ActivitySys.DailyLoginReward.Receive==1 then
     ClinetSys.OpenNotice("Activity" , true)
     handleNet_Game.handSummonInfo()
     return
  end
   
  if ActivitySys.FreeEnergy.Receive==1 then  
     ClinetSys.OpenNotice("Activity" , true)
     handleNet_Game.handSummonInfo()
     return 
  end

  --[[for i = 1 , #ActivitySys.RechargeReward.Reward.list , 1 do
      if ActivitySys.RechargeReward.Reward.list[i].receive==1 then 
         ClinetSys.OpenNotice("Activity" , true)
         handleNet_Game.handSummonInfo()
         return
      end
  end--]]

  local LeftTime = ActivitySys.LimitCard.NextFreeTime - ClinetInfomation.WorldTime
  if LeftTime<=0 then
     ClinetSys.OpenNotice("Activity" , true)
     handleNet_Game.handSummonInfo()
     return
  end

  handleNet_Game.handSummonInfo()

end

function handleNet_Game.handSummonInfo()
   WebEvent.InitSummon(nil , "handleNet_Game.handSummonInfoCallBack" , handleNet_Game.handSummonInfoCallBack)  
end

function handleNet_Game.handSummonInfoCallBack(data)

    local nextHighFreeTime = tonumber(data.Summon.normal.nextFreeTime)    --下次免费抽时间
    local nextSuperFreeTime = tonumber(data.Summon.super.nextFreeTime)

    local LeftTime = nextHighFreeTime - ClinetInfomation.WorldTime

    local LeftTimes = SummonSys.HighFreeTotalTimes - tonumber(data.Summon.normal.freeTimes)          --剩余次数

    if LeftTime<=0 and LeftTimes > 0 then
       ClinetSys.OpenNotice("Summon" , true)
       handleNet_Game.handMasterInfo()
       return
    end

    local SLeftTime = nextSuperFreeTime - ClinetInfomation.WorldTime
    if SLeftTime<=0 then
       ClinetSys.OpenNotice("Summon" , true)
       --handleNet_Game.handMasterInfo()
       return
    end

    return
end

function handleNet_Game.handMasterInfo()
    WebEvent.GetMasterRankList(nil , "handleNet_Game.handMasterInfoCallBack" , handleNet_Game.handMasterInfoCallBack)
end

function handleNet_Game.handMasterInfoCallBack(data)
    MasterSys.RequireRankListCallBack(data)
    for i = 1 , #MasterSys.LastMasterRankList , 1 do
       local lastplayer = MasterSys.LastMasterRankList[i]
       if lastplayer~=nil then
          local RealId = lastplayer.RealId
          local Rank = lastplayer.Rank
          local PlayerName = lastplayer.Name
          local WordId = lastplayer.WorldId
          PlayerControl.CreateMasterPlayer(RealId , PlayerName , Rank , WordId)
       end       
    end  
    --LoadingPanel.StopLoadingGamePanel()
end

return handleNet_Game