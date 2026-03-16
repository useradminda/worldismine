Comminfo = {}								--Comminfo 通用网络事件信息

local this = Comminfo

Comminfo["ComminfoCallBack"] =
{

}
function Comminfo.InitSome()
    --[[Comminfo["ComminfoCallBack"]["Mount"] = BabyPackSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["Player"] = ClinetInfomation.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["Equip"] = EquipMentSys.CommonInfoCallBack
    Comminfo["ComminfoCallBack"]["consumeEquip"] = EquipMentSys.ConsumeEquip
    Comminfo["ComminfoCallBack"]["Map"] = MapSys.CommonInfoCallBack
    Comminfo["ComminfoCallBack"]["Reward"] = ItemPackageSys.ComminfoReward
    Comminfo["ComminfoCallBack"]["Item"] = ItemPackageSys.ComminfoItems
    Comminfo["ComminfoCallBack"]["Resource"] = ItemPackageSys.ComminfoResource
    Comminfo["ComminfoCallBack"]["Debris"] = ItemPackageSys.ComminfoDebris
    
    Comminfo["ComminfoCallBack"]["LineReward"] = PlayerGrowSys.LineReward
    Comminfo["ComminfoCallBack"]["DailyReward"] = PlayerGrowSys.DailyRewardComminfo
    Comminfo["ComminfoCallBack"]["MainReward"] = PlayerGrowSys.PlayerGrowComminfo
    Comminfo["ComminfoCallBack"]["Store"] = ShopSys.StoneComminfo
    Comminfo["ComminfoCallBack"]["Vip"] = VipSys.VipComminfo
    Comminfo["ComminfoCallBack"]["Shop"] = ShopSys.ShopComminfo
    Comminfo["ComminfoCallBack"]["Activity"] = ActivitySys.ComminfoActivity
    Comminfo["ComminfoCallBack"]["Broad"] = XiaoLaBaSys.LabaComminfo--]]
	Comminfo["ComminfoCallBack"]["Player"] = ClinetInfomation.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["army"] = SoliderPackageSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["hero"] = HeroPackageSys.ComminfoCallBack
	Comminfo["ComminfoCallBack"]["item"] = ItemPackageSys.ComminfoResource
	Comminfo["ComminfoCallBack"]["gift"] = GiftPackageSys.ComminfoResource
    Comminfo["ComminfoCallBack"]["Formation"] = TeamSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["Map"] = MapSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["Store"] = SummonSys.ComminfoCallBack		
--	Comminfo["ComminfoCallBack"]["Store"] = CollectSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["Event"] = MissionSys.ComminfoCallBack
	Comminfo["ComminfoCallBack"]["voteResult"] = PalaceSys.VoteResultCallBack
	Comminfo["ComminfoCallBack"]["Palace"] = PalaceSys.ComminfoCallBack
	Comminfo["ComminfoCallBack"]["EquipStore"] = EquipSummonSys.ComminfoCallBack
	Comminfo["ComminfoCallBack"]["equip"] = EquipSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["symbol"] = BattleFlagSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["ActivatedSymbol"] = BattleFlagSys.UpBattleComminfoCallBack
	Comminfo["ComminfoCallBack"]["Fund"] = FundDataSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["LegionCombatRank"] = BattleFieldSys.BattleFieldTopComminfo
    Comminfo["ComminfoCallBack"]["LegionCombatRival"] = BattleFieldSys.BattleFieldRankComminfo
    Comminfo["ComminfoCallBack"]["HeroCombatRank"] = BattleFieldSys.BattleHeroTopComminfo     
    Comminfo["ComminfoCallBack"]["HeroCombatRival"] = BattleFieldSys.BattleHeroRankComminfo  
    Comminfo["ComminfoCallBack"]["LegionCombatHistory"] = BattleFieldSys.BattleInfoComminfo
    Comminfo["ComminfoCallBack"]["HeroCombatHistory"] = BattleFieldSys.BattleInfoComminfo
    Comminfo["ComminfoCallBack"]["MapRank"] = MapSys.MapRankCallBack     
    Comminfo["ComminfoCallBack"]["ComprehensiveRank"] = HeroRankListSys.GetComprehensiveRankComminfo   
    Comminfo["ComminfoCallBack"]["PowerRank"] = HeroRankListSys.GetPowerComminfo
	Comminfo["ComminfoCallBack"]["InfoWithPlayerId"] = PlayerInfoSys.SetInfo
	Comminfo["ComminfoCallBack"]["Officer"] = PalaceSys.ComminfoInitCallBack
	Comminfo["ComminfoCallBack"]["RecomendedFriend"] = FriendSys.SetReconmendInfo
	Comminfo["ComminfoCallBack"]["Friend"] = FriendSys.ComminfoInitCallBack
	Comminfo["ComminfoCallBack"]["debris"] = DebrisPackageSys.ComminfoCallBack
    Comminfo["ComminfoCallBack"]["CampReward"] = ArmyMoneySys.ArmyMoneyCallBack
	Comminfo["ComminfoCallBack"]["AllProduct"] = DepositSys.GetAllProductsInfoCallBack
	Comminfo["ComminfoCallBack"]["MyProduct"] = DepositSys.GetMyProductsInfoCallBack
    Comminfo["ComminfoCallBack"]["FeatsRank"] = ArmyGlorySys.GloryComminfo
    Comminfo["ComminfoCallBack"]["Guidance"] = GuideSys.GuideSysComminfo
	Comminfo["ComminfoCallBack"]["Orders"] = RechargeSys.ClearOrdersCallBack
    Comminfo["ComminfoCallBack"]["Mail"] = MailSys.MailComminfo
    Comminfo["ComminfoCallBack"]["Broadcast"] = BoardCastSys.Comminfo
    Comminfo["ComminfoCallBack"]["Battle"] = BattleFieldSys.BattleTimesComminfo
end

function Comminfo.HandleCommon(_Comminfodata)
    local Comminfodata = GameMain.JsonDecode(_Comminfodata)
    local Count = #Comminfodata

    for i = 1 , Count , 1 do
        local ModelName = tostring(Comminfodata[i]["moduleName"])
        if Comminfo["ComminfoCallBack"][ModelName]~=nil then
          -- GameMain.Print(Comminfodata)
           Comminfo["ComminfoCallBack"][ModelName](Comminfodata[i])
        end
    end

end

function  Comminfo.Test(_data)
    for key , value in pairs(_data) do
        local ID = tonumber(key)
        if ID~=nil then
           Debug.LogError(ID)
        end
    end
end

return Comminfo
