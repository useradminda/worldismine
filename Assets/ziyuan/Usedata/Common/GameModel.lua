GameModel = {}

--注册所有的网络发包的事件系�?

function GameModel.Init()
    GameMain.requireLuaFile("UIstring")
    UIstring.Init() 

    GameMain.requireLuaFile("TimeControl")						    --ʱ�������
    TimeControl.InitTime()

    GameMain.requireLuaFile("ClinetSys")

    GameMain.requireLuaFile("RewardContentSys")

	GameMain.requireLuaFile("MonthCardSys")
    GameMain.requireLuaFile("Astar")
	GameMain.requireLuaFile("TransferCountrySys")
    GameMain.requireLuaFile("WorldMapDataSys")
    GameMain.requireLuaFile("WorldMapSys")
    GameMain.requireLuaFile("WorldMapSocketSys") 
    GameMain.requireLuaFile("WorldMapEventSys")
	GameMain.requireLuaFile("LimitDataSys")
    GameMain.requireLuaFile("TeamMakeSys")
	GameMain.requireLuaFile("TeamSys")	
    GameMain.requireLuaFile("PlayerControl")
    GameMain.requireLuaFile("PalaceSys")
	GameMain.requireLuaFile("PlayerInfoSys")
    GameMain.requireLuaFile("LoginData")
	GameMain.requireLuaFile("DebrisPackageSys")
    GameMain.requireLuaFile("RoleDataSys")
	GameMain.requireLuaFile("SignSys")
    GameMain.requireLuaFile("SoliderPackageSys")
	GameMain.requireLuaFile("DepositSys")							--������
	GameMain.requireLuaFile("HonerShopSys")
--    SoliderPackageSys.Init()
	GameMain.requireLuaFile("TechnologyDataSys")					--�Ƽ�
	GameMain.requireLuaFile("TechnologySys")
	GameMain.requireLuaFile("GiftPackageSys")						--���
	GameMain.requireLuaFile("CollectSys")							--����
    GameMain.requireLuaFile("HeroPackageSys")
--    HeroPackageSys.Init()
	GameMain.requireLuaFile("ItemPackageSys")						--��Ʒ����
	GameMain.requireLuaFile("EquipSummonSys")						--װ����ļ
    GameMain.requireLuaFile("ItemDataSys")
	GameMain.requireLuaFile("SpecialFavourableSys")
    GameMain.requireLuaFile("TeamSys")						        --����ϵͳ
	GameMain.requireLuaFile("FriendSys")

    GameMain.requireLuaFile("MapSys")						        --������ͼ
    GameMain.requireLuaFile("MapDataSys")						    --������ͼ����
    MapSys.Init()

    GameMain.requireLuaFile("SummonSys")						    --������ͼ
   
	GameMain.requireLuaFile("FundDataSys")							--����
	FundDataSys.Init()
	
	GameMain.requireLuaFile("VipDataSys")							--VIP
	VipDataSys.Init()
	GameMain.requireLuaFile("VipSys")
	
    GameMain.requireLuaFile("EquipSys")						        --������ͼ
    GameMain.requireLuaFile("EquipDataSys")						    --������ͼ����

    GameMain.requireLuaFile("MissionSys")
    GameMain.requireLuaFile("MissionDataSys")

    GameMain.requireLuaFile("BattleFlagDataSys")
    GameMain.requireLuaFile("BattleFlagSys")
    BattleFlagDataSys.InitProp()

	GameMain.requireLuaFile("RechargeSys")							--��ֵ����
	RechargeSys.Init()

	GameMain.requireLuaFile("OnlineRwdSys")
    GameMain.requireLuaFile("ShopSys")
    GameMain.requireLuaFile("ShopDataSys")
    ShopSys.InitShop()

    GameMain.requireLuaFile("HandBookSys")
    HandBookSys.Init()

    GameMain.requireLuaFile("HeroRankListSys")

    GameMain.requireLuaFile("Create3DModel")
	GameMain.requireLuaFile("MusicManagerSys")

    GameMain.requireLuaFile("BattleFieldSys")

    GameMain.requireLuaFile("ArmyMoneySys") 
    GameMain.requireLuaFile("ArmyMoneyDataSys")
    
    GameMain.requireLuaFile("ArmyGloryDataSys")
    GameMain.requireLuaFile("ArmyGlorySys")

    GameMain.requireLuaFile("ConsumeRaffleSys")

    GameMain.requireLuaFile("GameVersion")
    GameVersion.InitVersion()

    GameMain.requireLuaFile("HeartJump")                            --����
    
    GameMain.requireLuaFile("GuideSys")                             --通用网络事件
    GameMain.requireLuaFile("GuideDataSys")

    GameMain.requireLuaFile("SystemOpenSys")

    GameMain.requireLuaFile("MailSys")
    
    GameMain.requireLuaFile("BoardCastSys")

    GameMain.requireLuaFile("Comminfo")                             --通用网络事件
    Comminfo.InitSome()
	GameMain.requireLuaFile("VipSpecailSys")                             --通用网络事件
	VipSpecailSys.InitSome()


   --[[ GameMain.requireLuaFile("GameStateIns")
    GameMain.requireLuaFile("BaseState")

    GameMain.requireLuaFile("PlayerControl")

	GameMain.requireLuaFile("RouteSys")								--移动行为系统

	GameMain.requireLuaFile("TeamSys")								--队伍系统

    GameMain.requireLuaFile("CreatePlayerSys")						--创角系统

    GameMain.requireLuaFile("BabyPackSys")							--宝宝背包 系统

	GameMain.requireLuaFile("roleDataSys")							--创建宝宝 查询宝宝进阶�?
	GameMain.requireLuaFile("BabyActionSys")						--宝宝行为

    GameMain.requireLuaFile("ItemPackageSys")						--物品背包
    GameMain.requireLuaFile("ItemsDataSys")						    --物品查询�?

    GameMain.requireLuaFile("ItemFactorySys")						--道具工厂
    GameMain.requireLuaFile("ItemFactoryDataSys")				    --道具工厂数据查询

    GameMain.requireLuaFile("EquipMentSys")						    --装备系统
    GameMain.requireLuaFile("EquipDataSys")						    --装备查询�?

    GameMain.requireLuaFile("MapSys")                               --副本系统
    GameMain.requireLuaFile("MapDataSys")                           --副本查询�?

    GameMain.requireLuaFile("MasterSys")                            --天梯系统
    GameMain.requireLuaFile("MasterDataSys")                        --天梯查询�?

    GameMain.requireLuaFile("SummonSys")                            --召唤系统
    GameMain.requireLuaFile("SummonDataSys")                        --召唤查询

    GameMain.requireLuaFile("MailSys")                              --邮件系统
    GameMain.requireLuaFile("MailDataSys")                          --邮件数据查询

    GameMain.requireLuaFile("ArenaSys")                             --竞技场系�?
    GameMain.requireLuaFile("ArenaDataSys")                         --竞技场数据查�?

    GameMain.requireLuaFile("DailyBossSys")                         --天天BOSS系统
    GameMain.requireLuaFile("DailyBossDataSys")                     --天天BOSS数据查询

    GameMain.requireLuaFile("SignRewardDataSys")                    --签到奖励查询
    GameMain.requireLuaFile("SignRewardSys")                        --签到奖励

    GameMain.requireLuaFile("FriendSys")                            --好友系统
    GameMain.requireLuaFile("FriendDataSys")                        --好友数据库查�?

    GameMain.requireLuaFile("ShopSys")                              --商城系统
    GameMain.requireLuaFile("ShopDataSys")                          --商城数据库查�?

    GameMain.requireLuaFile("VipSys")                               --Vip系统
    GameMain.requireLuaFile("VipDataSys")                           --Vip数据库查�?

    GameMain.requireLuaFile("ActivitySys")                          --活动界面
    GameMain.requireLuaFile("ActivityDataSys")                      --活动数据�?

    GameMain.requireLuaFile("XiaoLaBaSys")                          --小喇叭系�?

    GameMain.requireLuaFile("RankListSys")                          --排行�?

    GameMain.requireLuaFile("PlayerGrowSys")                        --玩家成长�?
    GameMain.requireLuaFile("PlayerGrowDataSys")                    --玩家成长�?

    GameMain.requireLuaFile("ClinetSys")                            --游戏设置系统

    GameMain.requireLuaFile("RoleSkillUpDataSys")                   --主角技能金币查�?
    GameMain.requireLuaFile("PlayerSkillSys")                       --主角技能升�?

    GameMain.requireLuaFile("ItemUseSys")                           --道具使用

    GameMain.requireLuaFile("Role_MapExpData")                     --查询主角升级需要的经验

    GameMain.requireLuaFile("GameSys")                              --游戏设置

    GameMain.requireLuaFile("AtlasMsg")                             --设置Atlas

    GameMain.requireLuaFile("RewardContentSys")                     --奖励结构

    GameMain.requireLuaFile("WorldPlayerSys")                       --世界玩家

    GameMain.requireLuaFile("KingCallSys")

    GameMain.requireLuaFile("TimeControl")                          --时间控制结构
    TimeControl.InitTime()

    GameMain.requireLuaFile("RolePropCalculate")                   --宝宝属性计�?

    GameMain.requireLuaFile("LoadingPanel")                         --转圈�?

    GameMain.requireLuaFile("ChatSys")                             --聊天�?

    GameMain.requireLuaFile("HeartJump")                            --心跳�?
    HeartJump.Init()

    GameMain.requireLuaFile("SkillBuffDescrip")                            --心跳�?

    GameMain.requireLuaFile("UIstring")
    UIstring.Init()

    GameMain.requireLuaFile("FirstRechargeDataSys")                 --首冲
    GameMain.requireLuaFile("FirstRechargeSys")

    GameMain.requireLuaFile("MusicPlaySys")                          --播放音效


    GameMain.requireLuaFile("TalkSys")

    GameMain.requireLuaFile("LoadResourceCache")                    --预加载资�?

    GameMain.requireLuaFile("Comminfo")                             --通用网络事件
    Comminfo.InitSome()
   --]]
end


return GameModel
