DataUIInstance = {}  																	--数据层 逻辑层 调用UI层 都走这边 方便查询
DataUIInstance.CreateBattleUIOn = false																																																																										--生成黑色界面 暂时用这个先z
function DataUIInstance.OpenBlackPanel(pause , type)									--pause 表示 0不暂停 1暂停
																						--type 切屏方式  -1无方式 >=1 表示切屏方式
	if MainGameUI["target"]["BlackPanel"]==nil then										--把切屏对象放入界面管理器z
		local lua = GameMain.requireLuaFile("BlackPanel")
		local obj1 = lua:new()
	   	MainGameUI["target"]["BlackPanel"] = obj1
	end
	MainGameUI["target"]["BlackPanel"]:OpenBlackPanel(pause , type)	
	
end


function DataUIInstance.JudgeUIEvent()													--检测UI射线是否点到
	local nowState = GameMain.GetGameState()
	if nowState=="battle" then
		local BattleUICamera = MainGameUI.GetUICameraInBattle()								--检测点击的UI按钮是否绑定事件z	
		if BattleUICamera~=nil then
			--if BattleUICamera.hoveredObject~=nil then
			    --if lgNoDelCsFun.Ins:CheckObjIsNull(BattleUICamera.hoveredObject)==false then                
				    local UIevent = nil
				    UIevent = lgNoDelCsFun.Ins:GetHoveredObject()	
				    if UIevent~=nil then
					    return true
				    end
			   -- end
            --end
		end
	end
	if nowState~="battle" then
		local MainCityUICamera = MainGameUI.GetUICameraInMainCity()
		if MainCityUICamera~=nil then
			--if MainCityUICamera.hoveredObject~=nil then
			    --if lgNoDelCsFun.Ins:CheckObjIsNull(MainCityUICamera.hoveredObject)==false then	
				    local UIevent = nil
				    UIevent = lgNoDelCsFun.Ins:GetHoveredObject()	
	
				    if UIevent~=nil then
					    return true
				    end
			    --end
            --end
		end 
	end
	
	return false
	
end



function DataUIInstance.ReflashPlayInfo()
    local data =                                                   --刷新账号信息
     {  
        Name = ClinetInfomation.PlayerName,
        Lvl = ClinetInfomation.Lvl,
        Coin = ClinetInfomation.Coin,
        Diamond = ClinetInfomation.Diamond,
        Sta = ClinetInfomation.Sta,
        Energy = ClinetInfomation.Energy,
        Vip = ClinetInfomation.VipLevel,
     }
     local ControlTar = MainGameUI.FindPanelTarget("UIControl")
     if ControlTar~=nil then
        ControlTar:SetLeftTopPlayerInfo(data)
     end
end

function DataUIInstance.CreateChooseCamp(CB)		--创建选择阵营界面
	local _father =  MainGameUI.FindPanelTarget("UIControl")		
	MainGameUI.OpenOnePanel("UITransferCountry" , "UITransferCountry" , "UITransferCountry" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenVipSpecial(_Vip)		--打开VIP特惠
	local _father =  MainGameUI.FindPanelTarget("UIControl")		
	MainGameUI.OpenOnePanel("UIVipSpecial" , "UIVipSpecial" , "UIVipSpecial" , _father.AnchorCenter ,nil,_Vip)

end

function DataUIInstance.CreateLoginUI(CB)		--创建注册界面
	local _father =  MainGameUI.FindPanel("UIControl")	
	MainGameUI.OpenOnePanel("UILogin" , "UILogin" , "UILogin" , _father , CB , nil)
end

function DataUIInstance.CreateLogin()           --创建登录
   local _father = MainGameUI.FindPanelTarget("UIControl")
   MainGameUI.OpenOnePanel("UILogin" , "UILogin" , "UILogin" , _father.AnchorCenter , nil , nil)
end

function DataUIInstance.CreateBag(CB)             --创建背包
   
   local UIControl = MainGameUI.FindPanelTarget("UIControl")
   MainGameUI.OpenOnePanel("UIBag" , "UIBag" , "UIBag" , UIControl.AnchorCenter , CB , nil)
end

function DataUIInstance.OpenPlayerUpLvl()             --创建主公升级
   local UIControl = MainGameUI.FindPanelTarget("UIControl")
   MainGameUI.OpenOnePanel("UIPlayerUpLvl" , "UIPlayerUpLvl" , "UIPlayerUpLvl" , UIControl.AnchorCenter , nil , nil)
end

function DataUIInstance.CreateVipLottery(_Id)             --创建vip转盘抽奖
   local UIControl = MainGameUI.FindPanelTarget("UIControl")
   MainGameUI.OpenOnePanel("UIVipLottery" , "UIVipLottery" , "UIVipLottery" , UIControl.AnchorCenter , nil , _Id)
end

function DataUIInstance.CreateMap()		    --创建副本界面
	local UIControl = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIMap" , "UIMap" , "UIMap" , UIControl.AnchorCenter)
end

function DataUIInstance.CreateMakeTeam(CB)     --创建pvp布阵
   local UIControl = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UITeamMake" , "UITeamMake" , "UITeamMake" , UIControl.AnchorCenter , CB)
end

function DataUIInstance.OpenRewards(_List)		--打开奖励面板	
	local UIShowRewardsTar =  MainGameUI.FindPanelTarget("UIShowRewards")
	
	if UIShowRewardsTar==nil then
		local UIControl = MainGameUI.FindPanelTarget("UIControl")
		MainGameUI.OpenOnePanel("UIShowRewards" , "UIShowRewards" , "UIShowRewards" , UIControl.AnchorCenter , DataUIInstance.ShowRewardsBack , _List)
   else
      DataUIInstance.ShowRewardsBack(_List)
   end 
end

function DataUIInstance.ShowRewardsBack(_List)
	local UIPopPanelTar = MainGameUI.FindPanelTarget("UIShowRewards")
	if UIPopPanelTar~=nil then
		UIPopPanelTar:ShowInfo(_List)  
	end
end

function DataUIInstance.CreateTipsPanel(Data , TypeName , Pos)		--创建tips
	local tipsPanelTar =  MainGameUI.FindPanelTarget("TipsPanel")
	local _Data = 
	{
		data = Data,
		pos = Pos,
		typeName = TypeName
	}
	if tipsPanelTar==nil then
		local UIControl = MainGameUI.FindPanelTarget("UIControl")
		MainGameUI.OpenOnePanel("TipsPanel" , "TipsPanel" , "TipsPanel" , UIControl.AnchorCenter , DataUIInstance.TipsPanelBack , _Data)
   else
      DataUIInstance.TipsPanelBack(_Data)
   end
end

function DataUIInstance.TipsPanelBack(_Data)
	local UIPopPanelTar = MainGameUI.FindPanelTarget("TipsPanel")
	if UIPopPanelTar~=nil then
		UIPopPanelTar:ShowInitInfo(_Data)  
	end
end

function DataUIInstance.OpenHireHero(CB)		--创建招募面板
	local UIControl = MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIHireHero" , "UIHireHero" , "UIHireHero" , UIControl.AnchorCenter , CB ,nil)
end

function DataUIInstance.OpenBabyPack()		--创建宝宝背包界面
	local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIBabyPackage" , "UIBabyPackage" , "UIBabyPackage" , _father.AnchorCenter)
end

function DataUIInstance.OpenItemPack(CB)		--创建道具背包界面
	local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIItemPackage" , "UIItemPackage" , "UIItemPackage" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenEquip(CB)			--创装备界面
	local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIEquip" , "UIEquip" , "UIEquip" , _father.AnchorCenter , CB)

end

function DataUIInstance.OpenHeroInfo(CB)  --创建武将信息界面    
	local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIHero" , "UIHero" , "UIHero" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenSoliderInfo(CB)  --创建士兵信息界面  
	local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UISoldier" , "UISoldier" , "UISoldier" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenTechnology(CB)	--创建科技信息界面
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UITechnology" , "UITechnology" , "UITechnology" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenChooseWeb()		--创建服务器列表界面
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIChooseWeb" , "UIChooseWeb" , "UIChooseWeb" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenMarket()			--创建寄售行
		local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIDeposit" , "UIDeposit" , "UIDeposit" , _father.AnchorCenter)
end

function DataUIInstance.OpenCollect(CB)		--创建征收信息界面
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UICollect" , "UICollect" , "UICollect" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenSign()			--创建签到面板
	
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIEveryDaySign" , "UIEveryDaySign" , "UIEveryDaySign" , _father.AnchorCenter)
end

function DataUIInstance.OpenSevenSign()		--创建7日签到界面
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UISevenDaySign" , "UISevenDaySign" , "UISevenDaySign" , _father.AnchorCenter)
end

function DataUIInstance.OpenPlayerInfo()	--打开玩家信息界面
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIPlayerInfo" , "UIPlayerInfo" , "UIPlayerInfo" , _father.AnchorCenter)
end

function DataUIInstance.OpenHonerShop(_Type)		--打开荣誉商店 
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIHonorShop" , "UIHonorShop" , "UIHonorShop" , _father.AnchorCenter ,nil ,_Type)
end

function DataUIInstance.OpenFund()			--创建基金
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIFund" , "UIFund" , "UIFund" , _father.AnchorCenter)
end

function DataUIInstance.OpenVip()			--创建Vip
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIVip" , "UIVip" , "UIVip" , _father.AnchorCenter) 
end

function DataUIInstance.OpenPalace()		--创建王宫
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIPalace" , "UIPalace" , "UIPalace" , _father.AnchorCenter) 
end

function DataUIInstance.OpenRecharge()		--创建充值界面
	local _father = MainGameUI.FindPanelTarget("UIControl")
	MainGameUI.OpenOnePanel("UIRecharge" , "UIRecharge" , "UIRecharge" , _father.AnchorCenter) 
end

function DataUIInstance.OpenWorldMap(CB)     --创建世界地图
    local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIWorldMap" , "UIWorldMap" , "UIWorldMap" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenMission(CB)     --打开任务界面
    local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIMission" , "UIMission" , "UIMission" , _father.AnchorCenter , CB)
end

function DataUIInstance.OpenBattleFlag()           --打开战旗
    local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIBattleFlag" , "UIBattleFlag" , "UIBattleFlag" , _father.AnchorCenter)
end

function DataUIInstance.OpenShop()                  --打开商城
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIShop" , "UIShop" , "UIShop" , _father.AnchorCenter)
end

function DataUIInstance.OpenFriend()          --打开好友
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIFriend" , "UIFriend" , "UIFriend" , _father.AnchorCenter)
end

function DataUIInstance.OpenOnLineReward ()          --打开在线礼包
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIOnLineReward" , "UIOnLineReward" , "UIOnLineReward" , _father.AnchorCenter)
end

function DataUIInstance.OpenFirstRecharge ()          --打开首冲
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIFirstRecharge" , "UIFirstRecharge" , "UIFirstRecharge" , _father.AnchorCenter)
end

function DataUIInstance.OpenConsumpGift()				--打开抽奖
	 local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIConsumpGift" , "UIConsumpGift" , "UIConsumpGift" , _father.AnchorCenter)
	
end

function DataUIInstance.OpenSpecialFavourable()          --打开每周特惠
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UISpecialFavourable" , "UISpecialFavourable" , "UISpecialFavourable" , _father.AnchorCenter)
end

function DataUIInstance.OpenMonthRight()          --打开月卡特权
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIMonthRight" , "UIMonthRight" , "UIMonthRight" , _father.AnchorCenter)
end

function DataUIInstance.OpenHandBook()            --打开图鉴
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIHandBook" , "UIHandBook" , "UIHandBook" , _father.AnchorCenter)
end

function DataUIInstance.OpenBattleField(_Data)         --打开沙场点兵 1 沙场 2 斗将台
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIBattleField" , "UIBattleField" , "UIBattleField" , _father.AnchorCenter , nil , _Data)
end 

function DataUIInstance.OpenHeroRank()         --打开英雄榜
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIHeroRankList" , "UIHeroRankList" , "UIHeroRankList" , _father.AnchorCenter , nil , _Data)
end 

function DataUIInstance.OpenRwdPop(_Data ,_Count , _Type)			--打开礼包界面
	local data = 
	{
		Data = _Data,
		Count = _Count,
		Type = _Type
	}
	local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIRwdPop" , "UIRwdPop" , "UIRwdPop" , _father.AnchorCenter , nil , data)
end


function DataUIInstance.OpenMail()                                          --邮件
   local _father =  MainGameUI.FindPanelTarget("UIControl")	
   MainGameUI.OpenOnePanel("UIMail" , "UIMail" , "UIMail" , _father.AnchorCenter)
end

function DataUIInstance.OpenArena()                                         --竞技场                           
   local _father =  MainGameUI.FindPanel("UIControl")	
   MainGameUI.OpenOnePanel("UIArena" , "UIArena" , "UIArena" , _father) 
end



function DataUIInstance.OpenActivity()                                      --活动界面
   local _father =  MainGameUI.FindPanel("UIControl")	
   MainGameUI.OpenOnePanel("UIActivity" , "UIActivity" , "UIActivity" , _father) 
end

function DataUIInstance.PopConfirmPanel(Msg , ConfrimEvent , CancelEvent , ConfrimData , CancelData)	--确认弹框  
	local _Data = 
	{
		Msg = Msg,	--显示文字
		ConfirmEvent = ConfrimEvent , --确认事件
		CanCelEvent = CancelEvent,	--取消事件
		ConfrimData = ConfrimData,	--确认数据（可有可无）
		CancelData = CancelData,	--取消数据（可有可无）
	}
	local _father =  MainGameUI.FindPanelTarget("UIControl")	
	MainGameUI.OpenOnePanel("UIPopConfirmPanel" , "UIPopConfirmPanel" , "UIPopConfirmPanel" , _father.AnchorCenter , nil , _Data)
end


function DataUIInstance.OpenGameSys()                                          --游戏设置
   local _father =  MainGameUI.FindPanel("UIControl")	
   MainGameUI.OpenOnePanel("UIGameSys" , "UIGameSys" , "UIGameSys" , _father) 
end

function DataUIInstance.OpenChatSys()
   local _father =  MainGameUI.FindPanel("UIControl")	
   MainGameUI.OpenOnePanel("UIChat" , "UIChat" , "UIChat" , _father) 
end

function DataUIInstance.OpenWorldPlayerShow(_WorldPlayer)                      --展示世界玩家
   local _father =  MainGameUI.FindPanel("UIControl")	
   MainGameUI.OpenOnePanel("UIWorldPlayerShow" , "UIWorldPlayerShow" , "UIWorldPlayerShow" , _father , DataUIInstance.WorldPlayerShow ,_WorldPlayer) 
end

function DataUIInstance.WorldPlayerShow(WorldPlayer)
   local UIWorldPlayerShowTar = MainGameUI.FindPanelTarget("UIWorldPlayerShow")
   UIWorldPlayerShowTar:SetWorldPlayer(WorldPlayer)
end

function DataUIInstance.PopTip(_MsgID ,_FontSize, _NowY , _TarY)                                            --弹提示
   local UIPopPanelTar = MainGameUI.FindPanelTarget("UIPopPanel")
   local data = 
   {
      MsgID = _MsgID,
	  FontSize = _FontSize,
      NowY = _NowY,
      TarY = _TarY,
   }	
   if UIPopPanelTar==nil then
      local _father =  MainGameUI.FindPanelTarget("UIControl")    
      if _father~=nil and _father.AnchorCenter~=nil then
         MainGameUI.OpenOnePanel("UIPopPanel" , "UIPopPanel" , "UIPopPanel" , _father.AnchorCenter , DataUIInstance.PopTipCallBack ,data)
      end
   else
      local _Msg = UIstring[data.MsgID]
      if _Msg==nil then
         UIPopPanelTar:PopTip(data.MsgID , data.FontSize , data.NowY , data.TarY)
      else
         UIPopPanelTar:PopTip(_Msg , data.FontSize ,data.NowY , data.TarY)
      end
      
   end
end

function DataUIInstance.PopTipCallBack(data)
   local UIPopPanelTar = MainGameUI.FindPanelTarget("UIPopPanel")
   if UIPopPanelTar~=nil then
      local _Msg = UIstring[data.MsgID]
      if _Msg==nil then
         UIPopPanelTar:PopTip(data.MsgID , data.NowY , data.TarY)
      else
         UIPopPanelTar:PopTip(_Msg , data.NowY , data.TarY)
      end
   end
end

function DataUIInstance.PopProp(_PropList)
   local UIPopPanelTar = MainGameUI.FindPanelTarget("UIPopPanel")
   if UIPopPanelTar==nil then
      local _father =  MainGameUI.FindPanel("UIControl")     
      MainGameUI.OpenOnePanel("UIPopPanel" , "UIPopPanel" , "UIPopPanel" , _father , DataUIInstance.PopPropCallBack ,_PropList)
   else   
      UIPopPanelTar:StartPopProp(_PropList)     
   end
end

function DataUIInstance.PopPropCallBack(_PropList)
   local UIPopPanelTar = MainGameUI.FindPanelTarget("UIPopPanel")
   if UIPopPanelTar~=nil then
      UIPopPanelTar:StartPopProp(_PropList)
   end
end


function DataUIInstance.PopTipPanel(_Type , _CallBack , _Data)                                       --弹板参数类型  , 回调函数 , 数据 ,弹提示面板 
   local data = 
   {
      Type = _Type,
      Data = _Data,
      CallBack = _CallBack,
   }
   
   local UIPopPanelTar = MainGameUI.FindPanelTarget("UIPopPanel")
   if UIPopPanelTar==nil then
      local _father =  MainGameUI.FindPanelTarget("UIControl")
      if _father~=nil then
         MainGameUI.OpenOnePanel("UIPopPanel" , "UIPopPanel" , "UIPopPanel" , _father.AnchorCenter , DataUIInstance.PopTipPanelCallBack ,data)   
      end
   else
      UIPopPanelTar:PopTipPanel(data)
   end
end

function DataUIInstance.PopTipPanelCallBack(_Data)
   local UIPopPanelTar = MainGameUI.FindPanelTarget("UIPopPanel")
   if UIPopPanelTar~=nil then
      UIPopPanelTar:PopTipPanel(_Data)
   end
end

return DataUIInstance