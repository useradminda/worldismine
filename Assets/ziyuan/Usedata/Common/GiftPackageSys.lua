--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
GiftPackageSys = {}
GiftPackageSys.GiftList = {}
GiftPackageSys.IsSort = true

function GiftPackageSys.GetGiftList()
	if GiftPackageSys.IsSort == true then
		GiftPackageSys.IsSort = false
		table.sort(GiftPackageSys.GiftList , GiftPackageSys.Comp)
	end
	return GiftPackageSys.GiftList
end

function GiftPackageSys.Comp(A , B)
    if A == nil then
		return false
    end
	if B == nil then
		return false
	end
    if A.Quality>B.Quality then
       return true
	end
	if A.Quality==B.Quality then
		if A.Dbid > B.Dbid then
          return true         
		end   
       if A.Dbid < B.Dbid then
			return false   
       end  
                    
       if A.Dbid==B.Dbid then 
          return false   
		end       
	end  
                         
	if A.Quality<B.Quality then
		return false
	end
    
end
function GiftPackageSys.AddItem(_Id, _Count)
	GiftPackageSys.IsSort = true
	local index = GiftPackageSys.GetIndex(_Id)
	if index ~=nil and GiftPackageSys.GiftList[index] ~=nil then
		GiftPackageSys.GiftList[index].Count = _Count
	else
		local lua = GameMain.requireLuaFile("Gift")
		local gift = lua:new()
		local giftData=GiftDataConfig.GetGiftDataBuyId(_Id)
		gift:InitSome(giftData, tonumber(_Count))
		table.insert(GiftPackageSys.GiftList,#GiftPackageSys.GiftList+1,gift)
	end
end

function GiftPackageSys.DelItem(_Id)
	GiftPackageSys.IsSort = true
	local index = GiftPackageSys.GetIndex(_Id)
	if index ~=nil then
		table.remove(GiftPackageSys.GiftList , index)
	end
	
end


function GiftPackageSys.GetIndex(_Id)
	local list = GiftPackageSys.GiftList
	for key,value in pairs(list) do
		if value.Dbid == _Id then
			return key
		end
	end
	return nil
end

function GiftPackageSys.GetDataById(_Id)
	local list = GiftPackageSys.GiftList
	for key,value in pairs(list) do
		if value.Dbid == _Id then
			return value
		end
	end
	return nil
end

GiftPackageSys.TempUseGift = {}

function GiftPackageSys.Use(_Data, _ReWardId , _Count)		--使用礼包
	GiftPackageSys.TempUseGift = {}
	GiftPackageSys.TempUseGift = 
	{
		Data = _Data.Type,
		Count = _Count,
	}
	local info = _Data.Dbid .. "," .. _ReWardId .. "," .. _Count
	WebEvent.SellGiftItem(info , "GiftPackageSys.UseCallBack" , GiftPackageSys.UseCallBack)
end
function GiftPackageSys.UseCallBack(data , returnId)
	local UIBagTar = MainGameUI.FindPanelTarget("UIBag")
	if UIBagTar ~= nil then
		local id = tonumber(data)
		UIBagTar:ShowUseBagGiftAfter(GiftPackageSys.TempUseGift,id)
	end
end

function GiftPackageSys.ComminfoResource(data)
	for key , dataItem in pairs(data) do
        local ID = tonumber(key)
        if ID ~= nil then
			local id = ID
			local num=tonumber(dataItem)
			if num == 0 then
				GiftPackageSys.DelItem(id)
			else
				GiftPackageSys.AddItem(id,num)
			end
        end
    end
end

function GiftPackageSys.ClearAllData()
	GiftPackageSys.GiftList = {}
	GiftPackageSys.IsSort = true
end

return GiftPackageSys
--endregion
