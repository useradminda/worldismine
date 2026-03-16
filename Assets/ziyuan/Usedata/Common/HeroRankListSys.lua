HeroRankListSys = {}
HeroRankListSys.ComprehensiveRankData = {}
HeroRankListSys.FightRankData = {}
HeroRankListSys.HeroData = {}
HeroRankListSys.SoldierData = {}

function HeroRankListSys.GetPlayerInfo(_Id)
	local info = _Id
	WebEvent.GetPlayerInfo(info , "HeroRankListSys.GetPlayerInfoCallBack" ,HeroRankListSys.GetPlayerInfoCallBack)
end

function HeroRankListSys.GetPlayerInfoCallBack(data , returnId)
	table.sort(HeroRankListSys.HeroData , HeroRankListSys.Comp)
	table.sort(HeroRankListSys.SoldierData , HeroRankListSys.Comp)
	local UIHeroRankTar = MainGameUI.FindPanelTarget("UIHeroRankList")
    UIHeroRankTar:CreateHumanList()
end

function HeroRankListSys.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.quality > B.quality then
		return true
	end
	if A.quality<B.quality then
		return false
	end
	if A.quality == B.quality then
		if A.qualityLvl > B.qualityLvl then
			return true
		end
		if A.qualityLvl < B.qualityLvl then
			return false
		end
		if A.qualityLvl == B.qualityLvl then
			if A.lvl > B.lvl then
				return true
			end
			if A.lvl < B.lvl then
				return false
			end
			if A.lvl == B.lvl then
				if A.Dbid >B.Dbid then
					return true
				end
				if A.Dbid < B.Dbid then
					return false
				end
				if A.Dbid == B.Dbid then
					return true
				end
			end
		end
	end
end

function HeroRankListSys.GetComprehensiveRank()  
   local _Info = nil   
   WebEvent.ComprehensiveRank(_Info , "HeroRankListSys.ComprehensiveRankCallBack" , HeroRankListSys.ComprehensiveRankCallBack)
end

function HeroRankListSys.ComprehensiveRankCallBack(data , returnId)      
   local UIHeroRankTar = MainGameUI.FindPanelTarget("UIHeroRankList")
   UIHeroRankTar:CreateRankList()
end

function HeroRankListSys.GetFightRank()  
   local _Info = nil   
   WebEvent.PowerRank(_Info , "HeroRankListSys.GetFightRankCallBack" , HeroRankListSys.GetFightRankCallBack)
end

function HeroRankListSys.GetFightRankCallBack(data , returnId)    
   local UIHeroRankTar = MainGameUI.FindPanelTarget("UIHeroRankList")
   UIHeroRankTar:CreateRankList()
end

function HeroRankListSys.GetHumanInfo(_PlayerId)      
   local _Info = tostring(_PlayerId)    
   WebEvent.GetHumenRankList(_Info , "HeroRankListSys.GetHumanListCallBack" , HeroRankListSys.GetHumanListCallBack)
end

function HeroRankListSys.GetHumanInfoCallBack(data , returnId)      

end

function HeroRankListSys.GetComprehensiveRankComminfo(data)
   HeroRankListSys.ComprehensiveRankData  = {}
   for key , value in pairs(data) do
        local ID = tonumber(key)
        if ID~=nil then         
           local data = 
           {
			   Id = tonumber(value["id"]),
               Name = tostring(value["name"]),
               Vip = tonumber(value["vip"]),
               Rank = tonumber(value["rank"]),
		       Qlt1 = tonumber(value["qlt_5"]),
		       Qlt2 = tonumber(value["qlt_5"]),
               Qlt3 = tonumber(value["qlt_6"]),
               Qlt4 = tonumber(value["qlt_7"]),
               Qlt5 = tonumber(value["qlt_8"]),
           }
           HeroRankListSys.ComprehensiveRankData[data.Rank] = data        
        end
    end   
end

function HeroRankListSys.GetPowerComminfo(data)
   for key , value in pairs(data) do
        local ID = tonumber(key)
        if ID~=nil then
           local data = 
           {
			   Id = tonumber(value["id"]),
               Name = tostring(value["name"]),
               Vip = tonumber(value["vip"]),
               Rank = tonumber(value["rank"]),
               Fight = tonumber(value["power"]),
           }
           HeroRankListSys.FightRankData[data.Rank] = data
        end
    end   
end

function HeroRankListSys.GetOtherPlayerComminfo(data)
	HeroRankListSys.SoldierData = {}
	HeroRankListSys.HeroData = {}
	for index, dataValue in pairs(data) do
		local armyList = dataValue["Army"]
		if armyList~=nil then
			for key,value in pairs(armyList) do
				local id = tonumber(value["id"])
				local exp = tonumber(value["exp"])
				local qlv = tonumber(value["qlv"])
				local data = RoleDataSys.CreateSolider(id  , qlv ,0 ,exp);
				table.insert(HeroRankListSys.SoldierData , #HeroRankListSys.SoldierData +1 , data)
			end
		end
	
		local heroList = dataValue["Hero"]
		if heroList~=nil then
			for key,value in pairs(heroList) do
				local uuid = tostring(value["uuid"])
				local id = tonumber(value["id"])
--				local lv = tonumber(value["lv"])
				local qlv = tonumber(value["qlv"])
				local exp = tonumber(value["exp"])
				local data = RoleDataSys.CreateHero(id, uuid , qlv , nil , exp)
				table.insert(HeroRankListSys.HeroData , #HeroRankListSys.HeroData+1 , data)
			end
		end
	end
	
	local allData = data["0"]
	
end 

return HeroRankListSys