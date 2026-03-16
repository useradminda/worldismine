WebEvent = {}
local this = WebEvent


function WebEvent.SendPack(data , _luacname , cb)
	
	data.token = LoginData.token
	data.GameUrl = LoginData.LoginURL .. "?ctl=request&act=unpack"
--	data.GameUrl = LoginData.ModelUrl
	data.playerId = LoginData.PlayerID
	data.luac = _luacname

	GameMain.SendPack(data , _luacname , cb)	
end

function WebEvent.GenerateOrder(info , cbname , cb)				--生成订单号
	local data = 
	{
		A = "generateOrder",
		M = "Recharge",
		P = info	
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end


--寄售行
function WebEvent.MarketAllProduct(info , cbname , cb)			--请求所有物品
	local data = 
	{
		A = "allProduct",
		M = "Market",
		P = info	
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.MarketMyProduct(info , cbname , cb)			--请求我的货架
	local data = 
	{
		A = "myProduct",
		M = "Market",
		P = info	
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.MarketSellProduct(info , cbname , cb)			--出售
	local data = 
	{
		A = "updateProduct",
		M = "Market",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.MarketReceiveMoney(info , cbname , cb)			--收钱
	local data = 
	{
		A = "receiveMoney",
		M = "Market",	
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.MarketRemoveProduct(info , cbname , cb)			--下架商品
	local data = 
	{
		A = "removeProduct",
		M = "Market",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.MarketBuyProduct(info , cbname , cb)			--购买商品
	local data = 
	{
		A = "buyProduct",
		M = "Market",
		P = info	
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end


--创角
function WebEvent.RequirePlayerinfo(info , cbname , cb)												--请求某个玩家的信息

	local data = 
	{
		A = "init",
		M = "Player",	
	}
	
	WebEvent.SendPack(data , cbname , cb)	
	
end

function WebEvent.CreatePlayer(info , cbname , cb)														--创建角色

	local data = 
	{
		A = "create",
		M = "Player",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

function WebEvent.SetNamePlayer(info , cbname , cb)														--改名

	local data = 
	{
		A = "setName",
		M = "Player",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

function WebEvent.BuyPreferentialEveryWeek(info , cbname , cb)					--每周特惠
	local data = 
	{
		A = "buyPreferentialEveryWeek",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.BuyRechargeEveryDay(info , cbname , cb)					--每日一充
	local data = 
	{
		A = "buyRechargeEveryDay",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.VipLottery(info , cbname , cb)					--vip转盘抽奖
	local data = 
	{
		A = "vipBuyDisk",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.BuyDoujiangtaiShop(info , cbname , cb)					--购买斗将台商品
	local data = 
	{
		A = "doujiangtaiShop",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.BuyShaChangShop(info , cbname , cb)					--购买沙场的商品
	local data = 
	{
		A = "shaChangShop",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.BuyMonthlyCard(info , cbname , cb)					--购买月卡
	local data = 
	{
		A = "buyMonthlyCard",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.ReceiveMonthlyCardReward(info , cbname , cb)			--领取月卡
	local data = 
	{
		A = "receiveMontylyCardReward",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReciveVipPreferential(info , cbname , cb)			--领取vip特惠
	local data = 
	{
		A = "vipPreferential",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

--选择阵营
function WebEvent.ChooseCamp(info , cbname , cb)													

	local data = 
	{
		A = "setCamp",
		M = "Player",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

--王宫
function WebEvent.PalaceInit(info , cbname , cb)	--王宫初始化												

	local data = 
	{
		A = "init",
		M = "Palace",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.PalaceRwd(info , cbname , cb)	--领取俸禄											

	local data = 
	{
		A = "recvReward",
		M = "Palace",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end


function WebEvent.PalaceInitElection(info , cbname , cb)	--选举初始化												

	local data = 
	{
		A = "initElection",
		M = "Palace",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.PalaceVote(info , cbname , cb)			--投票	

	local data = 
	{
		A = "vote",
		M = "Palace",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.PalaceJoinElection(info , cbname , cb)	--参选

	local data = 
	{
		A = "joinElection",
		M = "Palace",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

--科技

function WebEvent.PourMoneyToTech(info , cbname , cb)													--注资科技

	local data = 
	{
		A = "researchTech",
		M = "Player",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.TechStudy(info , cbname , cb)															--研究科技

	local data = 
	{
		A = "unlockTech",
		M = "Player",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SpeedTech(info , cbname , cb)															--科技加速

	local data = 
	{
		A = "speedUpTeck",
		M = "Player",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end


--抽卡英雄的缓存
function WebEvent.InitSummonStore(info , cbname , cb)														--

	local data = 
	{
		A = "init",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

--抽卡
function WebEvent.SummonCard(info , cbname , cb)														--

	local data = 
	{
		A = "summon",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

--获取英雄
function WebEvent.SummonGetCard(info , cbname , cb)														

	local data = 
	{
		A = "hireHero",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

--转盘抽奖
function WebEvent.SummonTurnReward(info , cbname , cb)														

	local data = 
	{
		A = "create",
		M = "Player",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

--征收
function WebEvent.Collect(info , cbname , cb)
	local data = 
	{
		A = "harvest",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)			
end

--征收加速
function WebEvent.CollectSpeed(info , cbname , cb)
	local data = 
	{
		A = "harvestSpeedUp",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)			
end

--充值购买元宝
function WebEvent.BuyDiamond(info , cbname , cb)
	local data = 
	{
		A = "buyDiamond",
		M = "Store",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)		
end

--上阵PVE英雄
function WebEvent.SavePveHeros(info , cbname , cb)
    
    local data = 
	{
		A = "setFormation",
		M = "Army",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

--挂帅武将 PVP 上阵 
function WebEvent.SavePvPHeros(info , cbname , cb)
	local data=
	{
		A = "setCommander",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

--解雇武将 PVP 下阵
function WebEvent.FirePVPHero(info , cbname , cb)
	local data=
	{
		A = "fireHero",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)

end

--成长基金
function WebEvent.FundInit(info , cbname , cb)			--初始化成长基金
	local data=
	{
		A = "init",
		M = "Fund",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.FundPour(info , cbname , cb)			--投资
	local data=
	{
		A = "invest",
		M = "Fund",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReciveRwd(info , cbname , cb)			--领取基金奖励
	local data=
	{
		A = "recvRwd",
		M = "Fund",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

--士兵相关
function WebEvent.SoldierLvUp(info , cbname , cb)                       --士兵升级
	local data=
	{
		A = "soldierLvUp",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SoliderQuiltyUp(info , cbname , cb)					--士兵进阶
	local data=
	{
		A = "soldierQltUp",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SoliderTraning(info , cbname , cb)					--士兵训练
	local data=
	{
		A = "soldierTraning",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.StopSoliderTraning(info , cbname , cb)					--取消士兵训练	
	local data=
	{
		A = "stopSoldierTraning",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SoliderAddExpWithItem(info , cbname , cb)					--士兵训练加经验
	local data=
	{
		A = "soldierAddExpWithItem",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ClearAddExpCD(info , cbname , cb)					--清理加经验CD
	local data=
	{
		A = "clearAddExpCD",
		M = "Army",
		P = info
	}
	WebEvent.SendPack(data , cbname , cb)
end
--整容模块
--[[function WebEvent.SaveTeamMsg(info , cbname , cb)														--保存整容

	local data = 
	{
		A = "setTroop",
		M = "Troop",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end--]]

--宝宝模块
function WebEvent.RequireBabyList(info , cbname , cb)													--请求宝宝列表

	local data = 
	{
		A = "init",
		M = "Mount",
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end

function WebEvent.UpLvl(info , cbname , cb)														     --宝宝升级

	local data = 
	{
		A = "levelUp",
		M = "mount",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

function WebEvent.UpQuality(info , cbname , cb)														--宝宝升阶

	local data = 
	{
		A = "qualityUp",
		M = "mount",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

function WebEvent.UpStar(info , cbname , cb)														--宝宝升星

	local data = 
	{
		A = "starUp",
		M = "mount",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	

end

--武将模块
function WebEvent.HeroUpLv(info , cbname , cb)												--武将升级
	local data = 
	{
		A = "heroLvUp",
		M = "Army",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.HeroTrain(info , cbname , cb)												--武将训练
	local data = 
	{
		A = "heroTraning",
		M = "Army",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.HeroStopTrain(info , cbname , cb)											--武将训练停止
	local data = 
	{
		A = "stopHeroTraning",
		M = "Army",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.HeroAddExpWithItem(info , cbname , cb)											--武将训练加经验
	local data = 
	{
		A = "heroAddExpWithItem",
		M = "Army",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.HeroUpQuilty(info , cbname , cb)											--武将转生
	local data = 
	{
		A = "heroQltUp",
		M = "Army",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.HeroTraning(info , cbname , cb)											--武将训练
	local data = 
	{
		A = "heroTraning",
		M = "Army",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.lotteryReward(info , cbname , cb)									--抽奖
	local data = 
	{
		A = "loto",
		M = "Event",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReceiveFirstRecharge(info , cbname , cb)							--领取首冲奖励
	local data = 
	{
		A = "receiveFirstRechargeReward",
		M = "Event",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReceiveOnlineReward(info , cbname , cb)							--领取在线奖励
	local data = 
	{
		A = "receiveOnlineReward",
		M = "Event",
		P = info 
	}
	WebEvent.SendPack(data , cbname , cb)
end


--装备模块
function WebEvent.UpandDownEquip(info , cbname , cb)                                               --穿卸装备

    local data = 
	{
		A = "dressUp",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)	
end



function  WebEvent.UpEquipLvl(info , cbname , cb)                                           --装备升级
    
    local data = 
	{
		A = "levelUp",
		M = "equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function  WebEvent.UpEquipQuality(info , cbname , cb)                                       --装备强化
    
    local data = 
	{
		A = "lvUp",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function  WebEvent.ClearEquipStrengthCD(info , cbname , cb)                                       --清除装备强化CD
    
    local data = 
	{
		A = "clearQltUpCD",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function  WebEvent.GetStrongthRate(info , cbname , cb)                                       --获取装备强化率
    
    local data = 
	{
		A = "qltUpPer",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end


function WebEvent.SellEquips(info , cbname , cb)                                             --出售装备

    local data = 
	{
		A = "sell",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.GetEquip(info , cbname , cb)
    local data = 
	{
		A = "sellEquip",
		M = "equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReCast(info , cbname , cb)                                             --重铸装备

    local data = 
	{
		A = "qltUp",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.ReFine(info , cbname , cb)                                             --洗练装备

    local data = 
	{
		A = "addProp",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.RefrashEquipStore(info , cbname , cb)									--刷新冶炼装备
	local data = 
	{
		A = "refreshEquipStore",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.BuyStoreEquip(info , cbname , cb)										--兑换刷新出的装备
	local data = 
	{
		A = "buyEquip",
		M = "Equip",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.DebrisCompose(info , cbname , cb)										--使用碎片
	local data = 
	{
		A = "useDebris",
		M = "Package",
		P = info
	}
	
	WebEvent.SendPack(data , cbname , cb)

end

--签到
function WebEvent.ReceiveSevenDaySign(info ,cbname , cb)            --领取七日签到
    local data =
    {
        A = "receive7dRwd",
		M = "Event",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReceiveMonthSign(info ,cbname , cb)            --领取每日签到
    local data =
    {
        A = "receiveMonthlyRwd",
		M = "Event",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReceiveTotalSign(info ,cbname , cb)            --领取总签到奖励
    local data =
    {
        A = "receiveTotalLoginRwd",
		M = "Event",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end
--日常任务

function WebEvent.ReceiveDaily(info ,cbname , cb)            --领取日常
    local data =
    {
        A = "receiveDailyRwd",
		M = "Event",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

--主线任务
function WebEvent.ReceiveMain(info ,cbname , cb)            --领取主线
    local data =
    {
        A = "receiveTaskRwd",
		M = "Event",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

--领取活跃度
function WebEvent.ReceiveActiveReward(info ,cbname , cb)
   local data =
    {
        A = "receiveActiveRwd",
		M = "Event",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.HeroDisc(info ,cbname , cb)            --武将转盘
    local data =
    {
        A = "heroDisc",
		M = "Store",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.HeroShop(info ,cbname , cb)            --武将商店
    local data =
    {
        A = "heroShop",
		M = "Store",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

--战旗
function WebEvent.InitFlag(info ,cbname , cb)            --初始化战旗
    local data =
    {
        A = "init",
		M = "store",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SaveFlag(info ,cbname , cb)            --保存战旗
    local data =
    {
        A = "dressUp",
		M = "Symbol",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.CombineFlag(info ,cbname , cb)         --合并战旗
    local data =
    {
        A = "refine",
		M = "Symbol",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.TransFlag(info , cbname ,cb)           --转换战旗
	local data=
	{
		A = "split",
		M = "Symbol",
		P = info,
	}
	
	WebEvent.SendPack(data , cbname ,cb)
end

function WebEvent.UseFactoryItem(info , cbname , cb)		--使用道具
	local data = 
	{
		A = "useItem",
		M = "Package",
		P = info,
	}
	WebEvent.SendPack(data , cbname ,cb)
end

function WebEvent.SellFactoryItem(info , cbname , cb)
	local data = 
	{
		A = "sellItem",
		M = "Package",
		P = info,
	}
	WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SellGiftItem(info , cbname , cb)
	local data = 
	{
		A = "useGift",
		M = "Package",
		P = info,
	}
	WebEvent.SendPack(data , cbname , cb)
end

--副本模块
function WebEvent.RequireMapRankInfo(info ,cbname , cb)        --获得副本排行

    local data = 
	{
		A = "rank",
		M = "map",
	}
	
	WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.MapFight(info ,cbname , cb)               --副本战斗开始

    local data =
    {
        A = "start",
		M = "map",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)

end


function WebEvent.MapFightOver(info ,cbname , cb)           --副本战斗结束

    local data =
    {
        A = "over",
		M = "map",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)

end


function WebEvent.MapSweep(info ,cbname , cb)               --副本扫荡

     local data =
    {
        A = "auto",
		M = "map",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
    
end


--**********************************************商店接口

function WebEvent.BuyNormalItem(info ,cbname , cb)               --购买普通道具

    local data =
    {
        A = "buyGoods",
		M = "Store",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.BuyBossItem(info ,cbname , cb)               --副本通关排行

    local data =
    {
        A = "starRank",
		M = "map",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)

end


--******************************英雄排行
function WebEvent.GetHeroRankList(info ,cbname , cb)               --获得玩家排行数据

    local data =
    {
        A = "starRank",
		M = "map",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.GetHumenRankList(info ,cbname , cb)               --获取玩家英雄数据

    local data =
    {
        A = "starRank",
		M = "map",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)

end


function WebEvent.RequestList(info ,cbname , cb)               --获取玩家英雄数据

    local data =
    {
        A = "starRank",
		M = "map",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)

end


--*********************获取沙场点兵英雄
function WebEvent.RequestBattleField(info ,cbname , cb)
   local data =
    {
        A = "legionCombatInit",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.RequestBattleFieldInfo(info ,cbname , cb)
   local data =
    {
        A = "legionCombatHistory",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.StartBattleField(info ,cbname , cb)
   local data =
    {
        A = "legionCombatStart",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.OverBattleField(info ,cbname , cb)
   local data =
    {
        A = "legionCombatOver",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.GetBattleFieldReward(info ,cbname , cb)
    local data =
    {
        A = "legionCombatReward",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

--*********************获取斗奖台英雄

function WebEvent.RequestBattleHero(info ,cbname , cb)
   local data =
    {
        A = "heroCombatInit",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.RequestBattleHeroInfo(info ,cbname , cb)
   local data =
    {
        A = "heroCombatHistory",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.StartBattleHero(info ,cbname , cb)
   local data =
    {
        A = "heroCombatStart",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.OverBattleHero(info ,cbname , cb)
   local data =
    {
        A = "heroCombatOver",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.GetBattleHeroReward(info ,cbname , cb)
   local data =
    {
        A = "heroCombatReward",
		M = "Battle",
        P = info
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.GetPlayerInfo(info , cbname , cb)
    
    local data =
    {
        A = "infoWithPlayerId",
		M = "Player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end


--心跳包
function WebEvent.HeartJump(info , cbname , cb)
    
    local data =
    {
        A = "heartBeat",
		M = "Player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.SavePower(info , cbname , cb)
    
    local data =
    {
        A = "setPower",
		M = "Player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

--**********战斗力排行
function WebEvent.PowerRank(info , cbname , cb)
   local data =
    {
        A = "powerRank",
		M = "Battle",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

--**********综合排行
function WebEvent.ComprehensiveRank(info , cbname , cb)
    local data =
    {
        A = "comprehensiveRank",
		M = "Battle",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end













--邮件系统
function WebEvent.InitMail(info ,cbname , cb)               

    local data =
    {
        A = "init",
		M = "mail",
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.GetFujian(info ,cbname , cb)            --领取附件

     local data =
    {
        A = "receive",
		M = "mail",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.ReceiveAllFujian(info ,cbname , cb)            --领取所有附件

     local data =
    {
        A = "receiveAll",
		M = "mail",
    }

    WebEvent.SendPack(data , cbname , cb)

end
function WebEvent.DeleteAllMails(info ,cbname , cb)                --一键删除

     local data =
    {
        A = "deleteAll",
		M = "mail",
    }

    WebEvent.SendPack(data , cbname , cb)

end
function WebEvent.HaveSeeTheMails(info ,cbname , cb)            --标记查看过的邮件

     local data =
    {
        A = "view",
		M = "mail",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

--竞技场系统
function WebEvent.InitArenaInfo(info ,cbname , cb)

    local data =
    {
        A = "init",
		M = "arena",
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.RequestRankList(info ,cbname , cb)

   local data =
    {
        A = "arenaRank",
		M = "arena",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.RequestMyRank(info ,cbname , cb)
    
     local data =
    {
        A = "myRank",
		M = "arena",
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.ArenaFight(info ,cbname , cb)
    
    local data =
    {
        A = "start",
		M = "arena",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.ArenaOver(info ,cbname , cb)
    
    local data =
    {
        A = "over",
		M = "arena",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.InitArenaShop(info ,cbname , cb)         --竞技场商店
    local data =
    {
        A = "init",
		M = "store",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReflashArenaShop(info ,cbname , cb)         --刷新竞技场商店
    local data =
    {
        A = "refresh",
		M = "store",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.BuyArenaItem(info ,cbname , cb)         --购买竞技场商店道具
    local data =
    {
        A = "buy",
		M = "store",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end



--查询玩家
function WebEvent.SearchWorldPlayer(info ,cbname , cb)
    
    local data =
    {
        A = "playerInfo",
		M = "player",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end


--天天Boss系统
--初始化BOSS信息
function WebEvent.InitDailyBoss(info ,cbname , cb)
    local data =
    {
        A = "init",
		M = "boss",
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.DailyBossStart(info ,cbname , cb)
    local data =
    {
        A = "start",
		M = "boss",
    }

    WebEvent.SendPack(data , cbname , cb)
end

--天天Boss打完一局
function WebEvent.DailyBossOver(info ,cbname , cb)
    
     local data =
    {
        A = "over",
		M = "boss",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

--天天Boss伤害排行
function WebEvent.DailyBossDemageRank(info ,cbname , cb)
    
     local data =
    {
        A = "rank",
		M = "boss",
       -- P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

--天天BOSS鼓舞
function WebEvent.DailyBossInspire(info ,cbname , cb)
    
     local data =
    {
        A = "inspire",
		M = "boss",
       -- P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

--天天BOSS复活
function WebEvent.DailyBossRevive(info ,cbname , cb)
    
     local data =
    {
        A = "revive",
		M = "boss",
       -- P = info,
    }

    WebEvent.SendPack(data , cbname , cb)

end

--好友模块
function WebEvent.RecommendFriend(info ,cbname , cb)									--推荐好友
    local data =
    {
        A = "recomended",
		M = "Friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SearchFriendInfo(info ,cbname , cb)									--查询好友(好友界面)
    local data =
    {
        A = "findPlayerWithKeyword",
		M = "Friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.RequestFriend(info ,cbname , cb)                                         --请求添加好友
    local data =
    {
        A = "request",
		M = "Friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.RemoveFriend(info ,cbname , cb)											 --删除好友
    local data =
    {
        A = "remove",
		M = "Friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end



function WebEvent.ResponseFriend(info ,cbname , cb)                                          --处理好友请求
    local data =
    {
        A = "response",
		M = "Friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end



function WebEvent.AddBlackFriend(info ,cbname , cb)                                               --加入黑名单
    local data =
    {
        A = "addBlackname",
		M = "Friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.RemoveBlackFriend(info ,cbname , cb)                                              --删除黑名单
    local data =
    {
        A = "removeBlackname",
		M = "Friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SendEnergy(info ,cbname , cb)                                                 --赠送精力
    local data =
    {
        A = "give",
		M = "friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end


function WebEvent.ReceiveEnergy(info ,cbname , cb)                                                 --领取精力
    local data =
    {
        A = "receive",
		M = "friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.ReceiveAllEnergy(info ,cbname , cb)                                                 --一键领取精力
    local data =
    {
        A = "receiveAll",
		M = "friend",
       -- P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.DeleteFriend(info ,cbname , cb)                                                   --删除好友
    local data =
    {
        A = "delFriend",
		M = "friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SearchFriend(info ,cbname , cb)                                                   --查找好友
    local data =
    {
        A = "searchFriend",
		M = "friend",
        P = info,
    }

    WebEvent.SendPack(data , cbname , cb)
end

--签到
function WebEvent.InitSignDailyReward(info ,cbname , cb)
   local data =
    {
        A = "init",
		M = "reward",
        --P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.GetSignReward(info ,cbname , cb)
    local data =
    {
        A = "receive",
		M = "reward",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.replenishSign(info ,cbname , cb)
   local data =
    {
        A = "replenishSign",
		M = "reward",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

--商城系统
function WebEvent.InitShop(info ,cbname , cb)                                               --商城初始化

     local data =
    {
        A = "init",
		M = "shop",
        --P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.BuyVipGoods(info ,cbname , cb)                                               --购买Vip福利

     local data =
    {
        A = "buyVipGoods",
		M = "store",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.ReceiveDailyVipRwd(info ,cbname , cb)                                         --领取Vip每日奖励

     local data =
    {
        A = "receiveDailyVipRwd",
		M = "event",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.BuyRechargeItem(info ,cbname , cb)                                               --购买充值道具

     local data =
    {
        A = "generateOrder",
		M = "shop",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.InitNormalItemShop(info ,cbname , cb)                                               --道具商店初始化

     local data =
    {
        A = "init",
		M = "store",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.RefreshNormalItemShop(info ,cbname , cb)                                               --刷新道具商店

     local data =
    {
        A = "refresh",
		M = "store",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.BuyShopNormalItem(info ,cbname , cb)                                               --购买道具商店道具

     local data =
    {
        A = "buy",
		M = "store",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

--活动界面
function WebEvent.InitActivity(info ,cbname , cb)                           --初始化活动                                          

     local data =
    {
        A = "init",
		M = "activity",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.ReceiveAcitvity(info ,cbname , cb)                        --领取奖励                                              

     local data =
    {
        A = "receive",
		M = "activity",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end


--排行榜
function WebEvent.RequireRankList(info ,cbname , cb)                        --请求排行                                              

     local data =
    {
        A = "rank",
		M = "player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

--主角升级技能
function WebEvent.UpPlayerSkill(info ,cbname , cb)                        --主角升级技能                                         

     local data =
    {
        A = "skillUp",
		M = "player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

--主线任务
function WebEvent.InitPlayerGrow(info , cbname , cb)                                          --获取主线任务 日常任务
   local data =
    {
        A = "init",
		M = "reward",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end


--玩家账号操作
function WebEvent.ChangeName(info , cbname , cb)
    local data =
    {
        A = "changeName",
		M = "player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

--发送小喇叭
function WebEvent.SendLaBa(info , cbname , cb)
   local data =
    {
        A = "playerMsg",
		M = "Broadcast",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

--道具使用
function WebEvent.UseItem(info , cbname , cb)

    local data =
    {
        A = "useItem",
		M = "package",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

--合成系统
function WebEvent.Combine(info , cbname , cb)
   local data =
    {
        A = "debrisSynthesis",
		M = "package",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end


--引导提交
function WebEvent.SendGuide(info , cbname , cb)

     local data =
    {
        A = "updateGuide",
		M = "player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)

end

function WebEvent.ActiveRight(info , cbname , cb)           --开启特权
   local data =
    {
        A = "specialRight",
		M = "special",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SearchTeam(info , cbname , cb)
   local data =
    {
        A = "searchTeam",
		M = "special",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.FightDoubleDragon(info , cbname , cb)
   local data =
    {
        A = "start",
		M = "special",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.FightDoubleDragonOver(info , cbname , cb)
   local data =
    {
        A = "over",
		M = "special",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.FightDoubleDragonInit(info , cbname , cb)
   local data =
    {
        A = "init",
		M = "special",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.GetArmyMoney(info , cbname , cb)           --获得军资
    local data =
    {
        A = "receiveCampReward",
		M = "Event",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.GetArmyGloryReward(info , cbname , cb)
    local data =
    {
        A = "receiveFeatsReward",
		M = "Event",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.BuyArmyGloryReward(info , cbname , cb)
    local data =
    {
        A = "buyFeats",
		M = "Store",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.GetArmyGloryRank(info , cbname , cb)                --查询荣耀排行榜
   local data =
    {
        A = "featsRank",
		M = "Battle",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end

function WebEvent.SendGuide(info , cbname , cb)
    local data =
    {
        A = "saveGuidance",
		M = "Player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end


--邮件
function WebEvent.SendMail(info , cbname , cb)
    local data =
    {
        A = "addMail",
		M = "Test",
      --  P = "Test",
    }
    WebEvent.SendPack(data , cbname , cb)
end

--领取邮件
function WebEvent.GetMail(info , cbname , cb)
    local data =
    {
        A = "receiveMail",
		M = "Player",
        P = info,
    }
    WebEvent.SendPack(data , cbname , cb)
end


return WebEvent