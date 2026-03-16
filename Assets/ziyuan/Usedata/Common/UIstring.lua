UIstring = {}

function UIstring.Init()   
    for key , value in pairs(MutLanguageConfig.MutLanguage) do
        UIstring[key] = value.MutWord      
    end
end

UIstring.SoliderUpGradeItemId = 1071 --士兵进阶符

UIstring.CostCollectId = 1121		 --强行征收符

UIstring.PurifyEquipItemId = 1081	 --装备洗炼石

UIstring.NormalHireHeroId = 1051	 --初级招募令
UIstring.BetterHireHeroId = 1052	 --中级招募令
UIstring.BestHireHeroId = 1053	 --高级招募令

UIstring.NormalEquipSummonId = 1061		--初级冶炼
UIstring.BetterEquipSummonId = 1062		--中级冶炼
UIstring.BestEquipSummonId = 1063		--高级冶炼

UIstring.CollectSpeedId = 1091			--加速符ID

UIstring.VipTrainId = 1111				--专家训练的Id

UIstring.AddExpItem = 1001				--突飞令

UIstring.BestHeroHunId = 4001			--一流将魂
UIstring.BetterHeroHunId = 4002			--传奇将魂
UIstring.StrengthId = 1101				--装备强化符

UIstring.Ownerships =
{
   [1] = "[蜀]",
   [2] = "[魏]",
   [3] = "[吴]",
   [4] = "[中立]",
}

UIstring.CountryAtlasName = "WordPicture"
UIstring.OwnerShipImg = 
{
   [1] = "shu",
   [2] = "wei",
   [3] = "wu",
   [4] = "wu", 
}

UIstring.WebState =
{
	[1] = "zhengchang",
	[2] = "liuchang",
	[3] = "baoman",
	[4] = "weihu"
}

UIstring.EffectQuality = 
{
	[5] = "FX_pinzhi01",   --紫
    [6] = "FX_pinzhi02",   --金
	[7] = "FX_pinzhi03",   --橙
    [8] = "FX_pinzhi04",   --红
}

UIstring.WordId = {}

UIstring.WordColor =    
{    
    [0] = "[F1F1F1]",
	[1] = "[fefcf1]",   --白 
    [2] = "[54ff00]",   --绿
    [3] = "[00cafd]",   --蓝
	[4] = "[00fee9]",	--青
    [5] = "[fd00fe]",   --紫
    [6] = "[ffd700]",   --金
	[7] = "[ffb900]",   --橙
    [8] = "[fd4802]",   --红
}

UIstring.Golden = "[FFFD5B]"
UIstring.White = "[F1F1F1]"
UIstring.Red = "[FF0000]"
UIstring.Green = "[54ff00]"
UIstring.Yellow = "[FFCE9D]"
UIstring.Purple = "[D956E4]"
UIstring.GrayColor = "[4B2907]"
UIstring.CollectColor = "[6E3300]"
UIstring.PetFrameAtlasName = "UI_HZ_Head_PetFrame1"
UIstring.NormalWordColor = "[651d01]"	--通用字体颜色

UIstring.ItemBabyFg = 
{
    [1] = "kuang_da_lv",
    [2] = "kuang_da_lan",
    [3] = "kuang_da_zi",
    [4] = "kuang_da_cheng",
    [5] = "kuang_da_jin-", 
}

UIstring.ItemXiaoFg = 
{
    [1] = "kuang_xiao_lv",
    [2] = "kuang_xiao_lan",
    [3] = "kuang_xiao_zi",
    [4] = "kuang_xiao_cheng",
    [5] = "kuang_xiao_jin-", 
}

--武将品质图片
UIstring.QuilityImg=
{
--1-白，2-绿，3-蓝，4-青，5-紫，6-金，7-橙，8-神
	[1] = nil,
	[2] = "sanliu",
	[3] = "erliu",
	[4] = "chengming",
	[5] = "yiliu",
	[6] = "chuanqi",
	[7] = "wushuang",
	[8] = "shenwujiang",
}
--通用品质框
UIstring.ItemFg = 
{
	[0] = "baipingz",
    [1] = "baipingz",
    [2] = "lvpingz",
    [3] = "lanpingz",
    [4] = "qingpingz",
    [5] = "zhipingz",
	[6] = "jinpingz",
	[7] = "chengingz",
	[8] = "hongpingz",
}

--
UIstring.LoginPutName = "请输入用户名"
UIstring.LoginPutPassWord = "请输入密码"
UIstring.BuyErroer = "购买失败"
UIstring.BuySuccess = "购买成功"
UIstring.CostSuccess = "支付成功"
UIstring.CostErroer = "支付失败"
UIstring.HasOwnFriend = "已添加为好友"

UIstring.QualityAtlasName = "UI_ZQ_Item_Quality"
UIstring.QualityBGAtlasName = "UI_ZQ_BG_Quality"
--装备进阶显示
UIstring.EquipUpGrade = 
{
	[1] = "白色",
	[2] = "绿色",   
    [3] = "蓝色",  
	[4] = "青色",	
    [5] = "紫色",   
    [6] = "金色",   
	[7] = "橙色",   
    [8] = "红色",   
   
}

UIstring.BagTag = 
{
	["NoClick"] = "yeqian",
	["Click"] = "yeqiantihuan",
}


UIstring.kuang_da_2 = "kuang_da_2"

UIstring.EquipQuality = 
{
    [1] = "普通",
    [2] = "优秀",
    [3] = "精良",
    [4] = "史诗",
    [5] = "传说",
}

UIstring.EquipType = 
{
    [1] = "装备",
    [2] = "头盔",
    [3] = "铠甲",
    [4] = "护腕",
    [5] = "鞋子",
    [6] = "披风",
    [7] = "护符",
    [8] = "戒指",
}

UIstring.PropName = 
{
    [1] = "生命",
    [2] = "攻击",
    [3] = "防御",
    [4] = "攻速",
    [5] = "移速",
    [6] = "暴击率",
    [7] = "暴击值",
    [8] = "闪避",
    [9] = "CD缩减",
    [10] = "翅膀",
    [24] = "cd缩减",
    [25] = "闪避",
    [26] = "攻击速度",
}

UIstring.PropName2 = 
{
    ["life"] = "生命",
    ["n_attack"] = "攻击",
    ["n_def"] = "防御",
    ["sp"] = "移速",             --移速
    ["crit"] = "暴击率",           --暴击率
    ["critvalue"] ="暴击值" ,      --暴击值
}

UIstring.VipNumSpriteName =
{
    [0] = "vip_0",
    [1] = "vip_1",
    [2] = "vip_2",
    [3] = "vip_3",
    [4] = "vip_4",
    [5] = "vip_5",
    [6] = "vip_6",
    [7] = "vip_7",
    [8] = "vip_8",
    [9] = "vip_9",   
}

UIstring.NumberSpriteName =
{
    [0] = "nub_0",
    [1] = "nub_1",
    [2] = "nub_2",
    [3] = "nub_3",
    [4] = "nub_4",
    [5] = "nub_5",
    [6] = "nub_6",
    [7] = "nub_7",
    [8] = "nub_8",
    [9] = "nub_9",   
}

UIstring.Series = 
{
   ["0_0"] = "全部",
   ["1_1"] = "天罚.弓",
   ["1_2"] = "天罚.盾",
   ["1_3"] = "天罚.枪",
   ["2_1"] = "鼓舞.弓",
   ["2_2"] = "鼓舞.盾",
   ["2_3"] = "鼓舞.枪",
   ["3_1"] = "强壮.弓",
   ["3_2"] = "强壮.盾",
   ["3_3"] = "强壮.枪",
}

UIstring.BattleFlagType =
{
   [1] = "弓",
   [2] = "盾",
   [3] = "枪",
}

UIstring.FlagLvl = 
{
   [0] = "全部",
   [1] = "1级",
   [2] = "2级",
   [3] = "3级",
   [4] = "4级",
   [5] = "5级",
   [6] = "6级",
   [7] = "7级",
   [8] = "8级",
   [9] = "9级", 
}

UIstring.WorldTeam = 
{
   
   [1] = "队伍一",
   [2] = "队伍二",
   [3] = "队伍三",
   [4] = "队伍四",
   
}

UIstring.QualityStr = 
{
	[0] = "末流",
	[1] = UIstring.WordColor[1].. "普通" .. "[-]",   --白 
    [2] = UIstring.WordColor[2] .. "三流" .. "[-]",   --绿
    [3] = UIstring.WordColor[3] .."二流" .. "[-]",   --蓝
	[4] = UIstring.WordColor[4] .."成名" .. "[-]",	--青
    [5] = UIstring.WordColor[5] .."一流" .. "[-]",   --紫
    [6] = UIstring.WordColor[6] .."传奇" .. "[-]",   --金
	[7] = UIstring.WordColor[7] .."无双" .. "[-]",   --橙
    [8] = UIstring.WordColor[8] .."神" .. "[-]",   --红
}

UIstring.OfficerName = 
{
   [0] = "",
   [1] = "国王",
   [2] = "大将军(一品)",
   [3] = "丞相(一品)",
   [4] = "大都督(一品)",
   [5] = "大司马(一品)",
   [6] = "虎翼将军(二品)",
   [7] = "龙骧将军(二品)",
   [8] = "骠骑将军(二品)",
   [9] = "车骑将军(二品)",
   [10] = "前将军(三品)", 
   [11] = "中郎将(四品)",
   [12] = "骑都尉(无品)",   
}

UIstring.PalaceMyPos = "我的职位:"

--region *.签到
UIstring.SignHasSigned = "已经累计签到"
UIstring.SignTimes = "次"
UIstring.SignHasRecived = "已领取"
--endregion

--region *.Vip
UIstring.VipHasExp = "vip经验达到"
UIstring.VipCanBuy = "可购买"
UIstring.VipNoOpen = "暂未开启"
UIstring.VipNoLvl = "VIP等级不足"
--endregion

--region *.基金
UIstring.FundTodayRec = "当天立即获得"
UIstring.FundCanRecived = "级可领取"
UIstring.FundNeedPour = "投资后方可领取"
UIstring.FundHasRwd = "已经收回成本"
UIstring.FundReturn = "返还"
UIstring.FundNoLvl = "等级不足，不可领取"
--endregion

--region *.征收
UIstring.CollectGet = "本次获得"
UIstring.CollectMoney = "金钱"
UIstring.CollectOwn = "当前拥有"
UIstring.CollectCount = "枚"
UIstring.CollectCost = "，本次强征消耗"
UIstring.CollectNoNeedSpeed = "当前不需要加速"
UIstring.CollectNoEngouh = "加速符不足"
UIstring.CollectSpeedItem = "加速符"
--endregion

--region *.武将
UIstring.HeroCanNotUpGrade = "该武将不可以转生"
UIstring.HeroHasUpGrade = "该武将已经提升至最高品质"
UIstring.HeroUpNeedCount = "转生需要"
UIstring.HeroMoney = "铜钱"
UIstring.HeroConsume = "1.消耗"
UIstring.HeroSimiliarQuality = "个同品质武将可获得" 
--endregion

--region *.士兵
UIstring.SoldierHasUpHeigthGrade = "已经提升至最高品质"
UIstring.SoliderHasOwnZero = "当前拥有0个"
UIstring.SoldierOwn = "当前拥有"
UIstring.SoliderItem = "个"
UIstring.SoliderHasNoProp = "道具不足，无法进阶"
--endregion

--region *.招募
UIstring.HireHeroChoose = "武将慕名投奔，请主公定夺"
--endregion

--region *.装备
UIstring.EquipCanRecast = "紫色及以上的品质才可重铸"
UIstring.EquipHasUpGrade = "已经重铸到最高品质"
UIstring.EquipPleaseStrength = "请选择装备进行强化"
UIstring.EquipPleaseRecast = "请选择装备进行重铸"
UIstring.EquipPleasePurify = "请选择装备进行洗炼"
UIstring.EquipMatNotEnough = "材料不足"
UIstring.EquipCanNotRecast = "紫色及以上的品质才可重铸"
UIstring.EquipCanNotPurify = "紫色及以上品质才可洗练"
UIstring.EquipItemNotEngouh = "道具不足"
--endregion

--region *任务
UIstring.MissionCanNotRec = "不可领取"
UIstring.TodayMissionHasRec = "已经领取"
--endregion

--region *登录
UIstring.CanNotHasKey = "不得含有关键字"
--endregion

UIstring.NoUpLevel = "等级不足"

UIstring.Banwords = ""
UIstring.PeleaseJoinPalace = "请先加入国家"

UIstring.DiamonedIsNotEngth = "元宝不足"

--region *Tips
function UIstring.GetHpValueColor(Value)
	if Value>=0 and Value<=1000 then
		return UIstring.WordColor[1]
	end
	if Value>=1001 and Value<=2000 then
		return UIstring.WordColor[2]
	end
	if Value>=2001 and Value<=3000 then
		return UIstring.WordColor[3]
	end
	if Value>=3001 and Value<=3500 then
		return UIstring.WordColor[5]
	end
	if Value>=3501 and Value<=4000 then
		return UIstring.WordColor[6]
	end
end

function UIstring.GetAtkValueColor(Value)
	if Value>=0 and Value<=40 then
		return UIstring.WordColor[1]
	end
	if Value>=41 and Value<=80 then
		return UIstring.WordColor[2]
	end
	if Value>=81 and Value<=120 then
		return UIstring.WordColor[3]
	end
	if Value>=121 and Value<=160 then
		return UIstring.WordColor[5]
	end
	if Value>=161 and Value<=200 then
		return UIstring.WordColor[6]
	end
end

function UIstring.GetAtkSpeedValueColor(Value)
	if Value>=0 and Value<=2 then
		return UIstring.WordColor[1]
	end
	if Value>=3 and Value<=4 then
		return UIstring.WordColor[2]
	end
	if Value>=5 and Value<=6 then
		return UIstring.WordColor[3]
	end
	if Value>=7 and Value<=8 then
		return UIstring.WordColor[5]
	end
	if Value>=9 and Value<=10 then
		return UIstring.WordColor[6]
	end
end
--endregion

UIstring.WhenStarIs = "当星级是"
UIstring.WhenLvlIs = "等级是"
UIstring.WhenReflevel = "精炼+"
UIstring.Star = "星"
UIstring.Lvl = "级"
UIstring.NoActived = "(未激活)"
UIstring.Actived = "（已激活）"
UIstring.ActivedWord = "激活"

UIstring.ResignTip = "您最多可以补签"
UIstring.Resign = "补签"

UIstring.AntCi = "次"
UIstring.ItemAnt = "个"
UIstring.RechargeByDay = "每日充值累计"
UIstring.Yuan = "元"
UIstring.OnLineTime = "在线时长"
UIstring.MaxVip = "你是我心中最大滴土豪"
UIstring.NeedRecharge = "再充"

UIstring.Year = "年"
UIstring.Month = "月"
UIstring.Day = "日"

UIstring.Hour = "时"
UIstring.Minit = "分"
UIstring.Second = "秒"

UIstring.Zoon = "区"

UIstring.jjc_1 = "前1000名，每次刷新最高排名都会获得钻石奖励！"
UIstring.jjc_2 = "每晚10点发放竞技场奖励"
UIstring.jjc_3 = "竞技场说明 1、竞技场每次胜利会获得少了声望。。。"

UIstring.dszl_1 = "大师挑战赛每届奖励 第1名：150钻石，48大师币 第2名：130钻石，44大师币 第3名..."
UIstring.dszl_2 = "匹配时间：12到24点 每天20到21点双倍积分"
UIstring.dszl_3 = ""

UIstring.ttboss_1 = "进入等级"
UIstring.ttboss_2 = "深海巨兽 挑战大章鱼可获得大量章鱼碎片，钻石，金币等道具 剩余开启时间01:12:25"
UIstring.ttboss_3 = "1、天天BOSS每日开启2次，12:30和20:30玩家可组队入场挑战BOSS以及胜利后可获得奖励..."
UIstring.ttboss_4 = "BOSS太过强大，但是不要灰心，你的小精灵还在，保卫精灵城就靠你了。"

UIstring.stlboss_1 = ""
UIstring.stlboss_2 = ""

UIstring.nd = ""

UIstring.qjgc_1 = "器具工厂说明 1，器具工厂分为三部分，分布是装备分解，装备还原和商店！ 2，分解装备..."

UIstring.ChoseServer = "请选择服务器"

UIstring.Nothing = "无"

UIstring.Gold = "金币"

UIstring.Life = "生命"
UIstring.Attack = "攻击"

UIstring.HighEggDsc = "最高产出道具和装备"
UIstring.SuperEggDsc = "最高产出道具和装备"

UIstring.OneCoinCall = "20000" --单抽需要多少金币
UIstring.TenCoinCall = "198000" --十抽需要多少金币
UIstring.OneDiamondCall = "280" --单抽钻石
UIstring.TenDiamondCall = "2660" --十抽钻石

UIstring.OneNiu = "扭蛋一次"
UIstring.TenNiu = "扭蛋十次"

UIstring.ChangeName = "是否花费1000钻修改名字!!"


UIstring.SellEuipsAllTip = "蓝绿装备最好用于装备强化哦，您真的要出售所有蓝绿装备么？"

UIstring.Vip = "Vip"
UIstring.CanBuy = "可以购买"
UIstring.NoLimitBuy = "无限畅购"
UIstring.Libao = "礼包"

UIstring.NetError = "网络错误，请重新登录"
UIstring.CPPNetError = "匹配网络错误，请稍候重试"

UIstring.LoadingDescrip = "会不会玩 , 低俗 , 幼稚"

UIstring.PlayerHeadSpriteName = 
{
    [111001] = "Icon_Headpic_2",
    [111002] = "Icon_Headpic_1",
}

UIstring.PlayerHeadAtlas = "UI_HZ_Hedpic"

UIstring.BossLastTime = "Boss剩余时间"
UIstring.BossOpenTime = "Boss即将开放"

UIstring.BossZhangyuName = "深渊巨兽"
UIstring.BossZhangyuDescrip = "挑战深海大章鱼可以获得大量章鱼碎片、钻石、美女等道具"

UIstring.Sta = "体力"
UIstring.Energy = "精力"
UIstring.Dsb = "大师币"

UIstring.Fight = "战斗力"

UIstring.PlayerBoy = "海战骑士"
UIstring.PlayerGirl = "冒险家"

UIstring.SummonLater = "后免费"
UIstring.Blood = "血石"

UIstring.Get = "获得"

UIstring.Travel = "游客"
UIstring.User = "用户"

UIstring.NoOpen = "(未开启)"
UIstring.OpenEd = "(已开启)"

UIstring.Attack = "攻击"
UIstring.Blood = "血量"
UIstring.BattleLvl = "战旗等级"
UIstring.OnSoldier = "上阵士兵"
UIstring.ReduceHurt = "伤害减少"
UIstring.WorldActivity = "国战活动"
UIstring.Ming = "名"
UIstring.SouthMan = "远征军"
UIstring.FarMan = "远征军"
UIstring.YellowLeftCity = "座城池未被占领，所有黄城被占领领取奖励"

UIstring.NoEnoughArmy = "兵力不足 无法换阵"

UIstring.FightYou = "挑战你"
UIstring.YouFight = "你挑战"

UIstring.NoPoint= "第"
UIstring.Map = "关"

UIstring.NextBattleLvl = "下一个战旗等级"
UIstring.Win = "你获胜了啦"
UIstring.Lose = "你失败了啦"

UIstring.RankUp = "排名提升至"
UIstring.RankDown = "排名下降至"
UIstring.From = "从"
UIstring.PerCent = "百分之"
UIstring.ArmyTitle = "档期军资"
UIstring.Bei = "倍"
UIstring.OfficerNo = "官职(无)"
UIstring.HireArmy = "借兵"
UIstring.UseHuFu = "是否花费虎符*"
UIstring.UseHuFuSweep = "是否花费虎符*"
UIstring.Xing1 = ""
UIstring.Ming1 = ""
UIstring.RewardBoxGet = "点活跃领取"
UIstring.BuyArmyPower = "募兵"

UIstring.SHJL1 = ""
UIstring.SHJL2 = ""
UIstring.SHJL3 = ""
UIstring.SHJL4 = ""
UIstring.SHJL5 = ""

UIstring.NMRQ1 = ""
UIstring.NMRQ2 = ""
UIstring.NMRQ3 = ""
UIstring.NMRQ4 = ""
UIstring.NMRQ5 = ""

UIstring.Day1_1 = ""
UIstring.Day1_2 = ""
UIstring.Day1_3 = ""
UIstring.Day2_1 = ""
UIstring.Day2_2 = ""
UIstring.Day2_3 = ""
UIstring.Day3_1 = ""
UIstring.Day3_2 = ""
UIstring.Day3_3 = ""
UIstring.Day4_1 = ""
UIstring.Day4_2 = ""
UIstring.Day4_3 = ""
UIstring.Day5_1 = ""
UIstring.Day5_2 = ""
UIstring.Day5_3 = ""
UIstring.Day6_1 = ""
UIstring.Day6_2 = ""
UIstring.Day6_3 = ""
UIstring.Day7_1 = ""
UIstring.Day7_2 = ""
UIstring.Day7_3 = ""

UIstring.npc_1_1 = ""
UIstring.npc_1_2 = ""
UIstring.npc_2_1 = ""
UIstring.npc_2_2 = ""
UIstring.npc_3_1 = ""
UIstring.npc_3_2 = ""
UIstring.npc_4_1 = ""
UIstring.npc_4_2 = ""

UIstring.shop1 = ""
UIstring.shop2 = ""
UIstring.shop3 = ""
UIstring.shop4 = ""
UIstring.shop5 = ""
UIstring.shop6 = ""
UIstring.shop7 = ""
UIstring.shop8 = ""

UIstring.HJQYTIME = ""
UIstring.HJQYDIS = ""

UIstring.SHJLTime = ""
UIstring.SHJLDIS = ""

UIstring.XRZLTime = ""
UIstring.XRZLDIS = ""

UIstring.GX1 = ""
UIstring.GX2 = ""
UIstring.GX3 = ""
UIstring.GX4 = ""

UIstring.A1 = "宝宝不存在"
UIstring.A2 = "材料不足"
UIstring.A3 = "升星失败"
UIstring.A4 = "品质已满"
UIstring.A5 = "等级不足"
UIstring.A6 = "星级已满"
UIstring.A7 = "金币不足"
UIstring.A8 = "等级已满"
UIstring.A9 = "位置错误"

UIstring.B1 = "同类装备不存在"
UIstring.B2 = "该装备不可分解"
UIstring.B3 = "体力不足"
UIstring.B4 = "副本次数不足"
UIstring.B5 = "战斗失败"
UIstring.B6 = "次数不足"
UIstring.B7 = "宝箱未被激活"
UIstring.B8 = "天梯尚未开战"
UIstring.B9 = "对手不存在"

UIstring.C1 = "尚未到免费事件"
UIstring.C2 = "钻石不足"
UIstring.C3 = "邮件不存在"
UIstring.C4 = "没有可领取的邮件"
UIstring.C5 = "BOSS已被击败"
UIstring.C6 = "BOSS战尚未开启"
UIstring.C7 = "好友不存在"
UIstring.C8 = "不能加自己为好友"
UIstring.C9 = "好友数量已满"

UIstring.D1 = "好友不在申请列表"
UIstring.D2 = "没有可领取的精力"
UIstring.D3 = "今日不能再领"
UIstring.D4 = "搜索的好友不存在"
UIstring.D5 = "今日已领取"
UIstring.D6 = "奖励不存在"
UIstring.D7 = "奖励已经领取"
UIstring.D8 = "货币不足"
UIstring.D9 = "小喇叭不足"

UIstring.F1 = "装备等级已满"
UIstring.F2 = "小喇叭不足"
UIstring.F3 = "今日已经领取过签到奖励"
UIstring.F4 = "声望不足"
UIstring.F5 = "存在屏蔽字"
UIstring.F6 = "名字已存在"
UIstring.F7 = "查询的玩家不存在"
UIstring.F8 = "当前技能等级已到顶"
UIstring.F9 = "角色等级不足"

UIstring.G1 = "品质已达到最高"
UIstring.G2 = "背包已满"
UIstring.G3 = "装备等级是主角等级的两倍"
UIstring.G4 = "无法将穿戴的装备当作材料"
UIstring.G5 = "装备不存在"
UIstring.G6 = "没有可以出售的装备了"
UIstring.G7 = "关卡未开启"
UIstring.G8 = "精力不足"
UIstring.G9 = "鼓舞已到上限次数"

UIstring.H1 = "鸡血石不足"
UIstring.H2 = "已申请过该好友"
UIstring.H3 = "已赠送过该好友"
UIstring.H4 = "已领取"
UIstring.H5 = "道具不存在"
UIstring.H6 = "碎片不足"
UIstring.H7 = "该位置没有宝宝 无法上阵"
UIstring.H8 = "无法下阵已经骑行的坐骑"
UIstring.H9 = "该宝宝已经在该位置上阵了"

UIstring.I1 = "无法下阵已经骑行的坐骑"
UIstring.I2 = "该位置没有宝宝 无法坐骑"
UIstring.I3 = "已赠送过该好友"
UIstring.I4 = "已领取"
UIstring.I5 = "道具不存在"
UIstring.I6 = "碎片不足"
UIstring.I7 = "该位置没有宝宝 无法上阵"
UIstring.I8 = "无法下阵已经骑行的坐骑"
UIstring.I9 = "位置已满"

UIstring.J1 = "该物品无法使用"
UIstring.J2 = "账号已被注册"
UIstring.J3 = "账号格式错误"
UIstring.J4 = "注册成功"
UIstring.J5 = "碎片不可出售"
UIstring.J6 = "无法挑战自己"
UIstring.J7 = "血石不足"
UIstring.J8 = "请选择需要分解的装备"
UIstring.J9 = "刷新次数不足"

UIstring.K1 = "超过限时时间无法领取"
UIstring.K2 = "账号已被注册"
UIstring.K3 = "账号格式错误"
UIstring.K4 = "注册成功"
UIstring.K5 = "碎片无法整理"
UIstring.K6 = "无需补签"
UIstring.K7 = "最近未登录"
UIstring.K8 = "请选择服务器"
UIstring.K9 = "无法扫荡非三星副本"

UIstring.L1 = "技能尚未激活"
UIstring.L2 = "任务尚未完成,无法领取"
UIstring.L3 = "技能还未激活"
UIstring.L4 = "请求邀请好友成功"
UIstring.L5 = "您尚未有排行"
UIstring.L6 = "含有非法字符"
UIstring.L7 = "您创建的名字过长"
UIstring.L8 = "领取成功"
UIstring.L9 = "补签成功"

UIstring.M1 = "购买成功"
UIstring.M2 = "Vip等级不足无法购买"
UIstring.M3 = "升级成功"
UIstring.M4 = "精炼成功"
UIstring.M5 = "出售成功"
UIstring.M6 = "赠送精力成功"
UIstring.M7 = "条件不足，无法领取"
UIstring.M8 = "已购买"
UIstring.M9 = "名字不能为空"

UIstring.N1 = "没有可以添加的材料"
UIstring.N2 = "副本暂未开放"
UIstring.N3 = "该玩家已经是好友"
UIstring.N4 = "您当前VIP等级下被限购"
UIstring.N5 = "星数未满"
UIstring.N6 = "已领取过该奖励"
UIstring.N7 = "未上榜"
UIstring.N8 = "敬请期待"
UIstring.N9 = "账户或密码不能为空"

UIstring.O1 = "每日可发送聊天消息次数已达上限"
UIstring.O2 = "发送聊天消息过快"
UIstring.O3 = "大师币不足"
UIstring.O4 = "宝宝等级不能超过主角等级"
UIstring.O5 = "Vip等级不足"
UIstring.O6 = "上次战斗还未结束"
UIstring.O7 = "大师赛15级开放"
UIstring.O8 = "竞技场10级开放"
UIstring.O9 = "特殊副本12级开放"

UIstring.P1 = "技能等级不能超过主角"
UIstring.P2 = "精炼等级已经到顶级"
UIstring.P3 = "战斗掉线 请稍后再匹配"
UIstring.P4 = "账号或密码错误"
UIstring.P5 = "主角技能升级成功"
UIstring.P6 = "当前VIP等级下购买次数已达上限"
UIstring.P7 = "没有可以分解的装备"
UIstring.P8 = "账号或密码不能为空"
UIstring.P9 = "注册失败"

UIstring.Q1 = "用户名最短5位，最长12位 , 只可使用英文字母、数字和下划线"
UIstring.Q2 = "密码名最短6位，最长16位 , 不可使用中文"
UIstring.Q3 = "通关本章后解锁"
UIstring.Q4 = "充值未开启"
UIstring.Q5 = "精力已满"
UIstring.Q6 = "体力已满"
UIstring.Q7 = "你没有权限开启次任务"
UIstring.Q8 = "你已经开启该特权任务"
UIstring.Q9 = "开启特权任务成功"

UIstring.R1 = "暂未开放"
UIstring.R2 = "Boss已死亡"
UIstring.R3 = "前往"
UIstring.R4 = "领取"
UIstring.R5 = "未完成"
UIstring.R6 = "登录成功 "
UIstring.R7 = "主线任务"
UIstring.R8 = "日常任务"
UIstring.R9 = "相同战旗已有两个"

UIstring.S1 = "相同战旗的相同类型无法穿戴"
UIstring.S2 = "战旗已满"
UIstring.S3 = "已镶嵌天罚类战旗"
UIstring.S4 = "数量不足无法合成"
UIstring.S5 = "1级的战旗等级无法转化"
UIstring.S6 = "数量不足"
UIstring.S7 = "数量不可小于1"
UIstring.S8 = "请选择一个需要转换的战旗"
UIstring.S9 = "不可领取"

UIstring.T1 = "可领取"
UIstring.T2 = "已领取"
UIstring.T3 = "兵力不足 无法换阵"
UIstring.T4 = "没有可以移动的路径"
UIstring.T5 = "已被包围 无法撤退"
UIstring.T6 = "无法突进"
UIstring.T7 = "该队伍没有布阵 无法改变"
UIstring.T8 = "已战斗 无法换阵"
UIstring.T9 = "请先选择阵营"

UIstring.U1 = "借兵成功"
UIstring.U2 = "购买兵力成功"
UIstring.U3 = "换阵成功"
UIstring.U4 = "移动失败 请查看兵力等情况"
UIstring.U5 = "剩余次数不足 无法领取"
UIstring.U6 = "请先通关之前的章节"
UIstring.U7 = "可领取功勋盒子数量为0 无法领取"
UIstring.U8 = "人数已达上阵上限"
UIstring.U9 = "您已领取过"

UIstring.V1 = "当前阵容没有布阵"
UIstring.V2 = "军队非空闲状态"
UIstring.V3 = "请先通关前面的关卡"
UIstring.V4 = "没有军队"
UIstring.V5 = "当前状态无法移动"
UIstring.V6 = "路径小于2"
UIstring.V7 = "当前位置有误 请重新移动"
UIstring.V8 = "兵力为0"
UIstring.V9 = "以上阵该武将"

UIstring.W1 = "至少上阵一人"
UIstring.W2 = "元宝不足"
UIstring.W3 = "镶嵌成功"
UIstring.W4 = "卸载成功"
UIstring.W5 = "合成成功"
UIstring.W6 = "转化成功"
UIstring.W7 = "请选择一个战旗"
UIstring.W8 = "当前队伍已经上阵"
UIstring.W9 = "您的功勋已满"

UIstring.X1 = "您当前的队伍没有英雄上阵"
UIstring.X2 = "当前没有排行"
UIstring.X3 = "名字不能为空"
UIstring.X4 = "玩家名字最多7个字"
UIstring.X5 = "征战失败，请主公募兵再战！"
UIstring.X6 = "Vip1开启扫荡功能"
UIstring.X7 = "军令为0"
UIstring.X8 = "军令不足"
UIstring.X9 = "虎符不足"

UIstring.Y9 = "扫荡次数不能为0"
UIstring.Y10 = "扫荡成功"
UIstring.Y1 = "购买成功"
UIstring.Y2 = "恭喜您 金币获得暴击奖励!!!"
UIstring.Y3 = "领取金币 *"
UIstring.Y4 = "将军,我方正在重整部队 , 请稍事休息后再进"
UIstring.Y5 = "名字中含有非法字符"
UIstring.Y6 = "名字中含有屏蔽字"
UIstring.Y7 = "名字不能为空"
UIstring.Y8 = "兵力已满"

UIstring.Z1 = "投票成功"
UIstring.Z2 = "更新票数失败"
UIstring.Z3 = "信物不足"
UIstring.Z4 = "无单挑对象"
UIstring.Z5 = "借兵失败"
UIstring.Z6 = "招募成功"
UIstring.Z7 = "招募次数不足"
UIstring.Z8 = "您当前未挂帅，无法进入国战"
UIstring.Z9 = "无法再洗练"

UIstring.nanzhujiao_2 = "男主角描述"
UIstring.nvzhujiao_2 = "女主角描述"
return UIstring