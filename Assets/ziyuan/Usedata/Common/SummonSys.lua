SummonSys = {}
SummonSys.TempSummonResult = {}					 --临时招募到的英雄
SummonSys.SummonFreeTime = {}

SummonSys.ShopHeroList = {}
SummonSys.ShopHunList = {}

SummonSys.luckyPoint = 0					--人品值
SummonSys.SummonPoint = 0					--招募值 

function SummonSys.GetConfigData()
	local allData = HeroShopConfig.GetAllData()
	SummonSys.ShopHeroList = {}
	SummonSys.ShopHunList = {}
	for key,value in pairs(allData) do
		local item = SummonSys.CreateHeroShopItem(key)
		if value.Type == 1 then
			table.insert(SummonSys.ShopHeroList , #SummonSys.ShopHeroList +1 , item)
		else
			table.insert(SummonSys.ShopHunList , #SummonSys.ShopHunList +1 , item)
		end
	end
end

function SummonSys.CreateHeroShopItem(_Id)
	 local lua = GameMain.requireLuaFile("HeroShop")
	 local rolebaby = lua:new()
	 local _RoleDBdata = HeroShopConfig.GetHeroShopItemById(_Id)
	 rolebaby:Init(_RoleDBdata)
	 return rolebaby
end

function SummonSys.GetSummonPointValue()	--得到招募值
	return SummonSys.SummonPoint
end

function SummonSys.GetLuckyPoint()			--得到人品值
	local luckyLimit = ConstConfig.GetLuckLimit()
	if SummonSys.luckyPoint>=luckyLimit then
		SummonSys.luckyPoint = luckyLimit
	end
	return SummonSys.luckyPoint
end

function SummonSys.GetShopHeroList()		
	return SummonSys.ShopHeroList
end

function SummonSys.GetShopHunList()
	return SummonSys.ShopHunList
end

function SummonSys.GetHeroDiscData()
	local list = {}
	local allList = HeroDiscConfig.GetAllDBData()
	for key,value in pairs(allList) do
		table.insert(list, #list +1 , value)
	end
	return list
end



function SummonSys.SummonStoreInit()
--	WebEvent.InitSummonStore(nil , "SummonSys.SummonStoreInitCallBack" , SummonSys.SummonStoreInitCallBack)
end

function SummonSys.IsFree(_Type)				--是否免费
	
	local curTime = ClinetInfomation.WorldTime
	local startTime = SummonSys.SummonFreeTime[_Type]
	local del = startTime - curTime
	if del <= 0 then
		return true
	end

	if del>0 then
		TimeControl.LoginTime(del, "FreeSummonTime" .. _Type)
		return false
	end
end
function SummonSys.SummonStoreInitCallBack(data , returnId)
	local uiHireHeroTar = MainGameUI.FindPanelTarget("UIHireHero")
		if uiHireHeroTar ~=nil then
			uiHireHeroTar:ShowHireHeroPanelInfo()
		end
end
function SummonSys.SummonCard(_Type , _Free)                  --抽卡 1 普通 2中级 3 高级 _Free 1 免费  0收费
   local Info = tostring(_Type)..","..tostring(_Free)

   WebEvent.SummonCard(Info , "SummonSys.SummonNormalCardCallBack" , SummonSys.SummonCardCallBack)
end

function SummonSys.SummonCardCallBack(data , returnId)        --抽卡
   if returnId == 0 then
         DataUIInstance.PopTip("Z6")
		for i = 1 , #data , 1 do
			if data[i] ~= 0 then
				SummonSys.TempSummonResult[i] = data[i]
			end
		end
		local uiHireHeroTar = MainGameUI.FindPanelTarget("UIHireHero")
		if uiHireHeroTar ~=nil then
			uiHireHeroTar:ShowHireCallBack()
		end
        
   elseif returnId == 1 then
		
   end
end


function SummonSys.GetSummonHeroById(_Id)		--通过ID得到一个招募的英雄信息
	local RoleInfo = RoleDataSys.TempHero(_Id,1,1)
	return RoleInfo
end


function SummonSys.SummonGetCard(_HeroDbid)                    --获取英雄
  
   local Info = _HeroDbid
   WebEvent.SummonGetCard(Info , "SummonSys.SummonGetCardCallBack" , SummonSys.SummonGetCardCallBack)

--   HeroPackageSys.AddHero(_HeroDbid , 1, 1)
   local _index = SummonSys.GetHeroById(_HeroDbid)
   table.remove(SummonSys.TempSummonResult , _index)
end

function SummonSys.SummonGetCardCallBack(data , returnId)            --获取英雄
	if ClinetInfomation.GuaShuaiUUID == "" then
		HeroPackageSys.SavePvPHeros(HeroPackageSys.Heros[1].UUID)
		HeroPackageSys.Heros[1].IsGuaShuai = true
	end
	local uiHireHeroTar = MainGameUI.FindPanelTarget("UIHireHero")
	if uiHireHeroTar ~= nil then
		uiHireHeroTar:ShowLotteryHeroInfo()
	end
end

function SummonSys.GetHeroById(_Id)
	for key,value in pairs(SummonSys.TempSummonResult) do
		if key == _Id then
			return key
		end
	end
	
end
function SummonSys.SummonTurnReward()                 --轮盘抽奖
   local Info = nil
   WebEvent.HeroDisc(Info , "SummonSys.SummonTurnRewardCallBack" , SummonSys.SummonTurnRewardCallBack)
end 

function SummonSys.SummonTurnRewardCallBack(data , returnId)                 --轮盘抽奖
   local uiHireHeroTar = MainGameUI.FindPanelTarget("UIHireHero")
	if uiHireHeroTar ~= nil then
		uiHireHeroTar:ToChooseRwdCallBack(tonumber(data))
	end
end

function SummonSys.SummonBuyHeroItem(_Id , _Count)		--商店购买
	local info = _Id .."," .._Count
	WebEvent.HeroShop(info , "SummonSys.SummonBuyHeroItemCallBack" , SummonSys.SummonBuyHeroItemCallBack)
end

function SummonSys.SummonBuyHeroItemCallBack(data , returnId)
	local uiHireHeroTar = MainGameUI.FindPanelTarget("UIHireHero")
	if uiHireHeroTar ~=nil then
		uiHireHeroTar:BuyHeroShopCallBack()
	end
end

function SummonSys.ComminfoCallBack(data)
	SummonSys.luckyPoint = 0					
	SummonSys.SummonPoint = 0	
	local luckValue = tonumber(data["luckyPoint"])	
	if luckValue~=nil then
		SummonSys.luckyPoint = luckValue
	end		
	local summonValue = tonumber(data["summonPoint"])
	if summonValue~=nil then
		SummonSys.SummonPoint = summonValue
	end
   SummonSys.TempSummonResult = {}
   local _SummonData = data["summonResult"]
   if _SummonData~=nil then
       for i = 1 , #_SummonData , 1 do
			if _SummonData[i] ~= 0 then
				SummonSys.TempSummonResult[i] = _SummonData[i]
			end
       end
   end

   SummonSys.SummonFreeTime = {}
   local _SummonFreeData = data["freeSummonBegin"]
   if _SummonFreeData~=nil then
      for key,value in pairs(_SummonFreeData) do
			SummonSys.SummonFreeTime[tonumber(key)] = value
      end
   end
	CollectSys.ComminfoCallBack(data)
	RechargeSys.ComminfoCallBack(data)
	VipSys.CommoninfoCallBack(data)
	MonthCardSys.CommonInfoCallBack(data)
	SpecialFavourableSys.CommonInfoCallBack(data)
	VipSpecailSys.CommonInfoCallBack(data)
	VipSys.DiskChangeCallBack(data)
end

function SummonSys.ClearTempHeros()				--每次招募都需要先清一下以前招募到的临时武将
	SummonSys.TempSummonResult = {}
end
return SummonSys