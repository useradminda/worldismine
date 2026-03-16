HeroRankListSys = {}
HeroRankListSys.GeneralRankData = {}
HeroRankListSys.FightRankData = {}
HeroRankListSys.HeroData = {}
HeroRankListSys.SoldierData = {}

function HeroRankListSys.GetRankList(_Type)  
   local _Info = tostring(_Type)    
   WebEvent.GetHeroRankList(_Info , "HeroRankListSys.GetRankListCallBack" , HeroRankListSys.GetRankListCallBack)
end

function HeroRankListSys.GetRankListCallBack(data , returnId)      
   local UIHeroRankTar = MainGameUI.FindPanelTarget("UIHeroRankList")
   UIHeroRankTar:CreateRankList()
end

function HeroRankListSys.GetHumanList(_PlayerId)      
   local _Info = tostring(_PlayerId)    
   WebEvent.GetHumenRankList(_Info , "HeroRankListSys.GetHumanListCallBack" , HeroRankListSys.GetHumanListCallBack)
end

function HeroRankListSys.GetHumanListCallBack(data , returnId)      

end



return HeroRankListSys