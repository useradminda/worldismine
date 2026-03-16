--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipSpecailSys = {}
VipSpecailSys.DataList = {}				
VipSpecailSys.RecDataList = {}			--已经购买的数据

function VipSpecailSys.IsShowOpen()
	local lvl = ClinetInfomation.Lvl
	local vip = VipSys.VipLevel
	if vip >= VipSpecailSys.DataList[#VipSpecailSys.DataList].VipLevel then
		return false
	end
	if lvl<VipSpecailSys.DataList[1].NeedLevel then
		return false
	end
	return true
end

function VipSpecailSys.InitShow()
	local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
	if UIControlTar ~= nil then
		UIControlTar:ShowVipSpecailInfo()
	end
end

function VipSpecailSys.InitSome()
	local list = VipSpecialConfig.GetAllData()
	for key,value in pairs( list) do
		table.insert(VipSpecailSys.DataList , #VipSpecailSys.DataList +1 , value)
	end
	table.sort(VipSpecailSys.DataList , VipSpecailSys.Comp)
end

function VipSpecailSys.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.Id>B.Id then
		return false
	end
	if A.Id < B.Id then
		return true
	end
	if A.Id == B.Id then
		return false
	end
end

function VipSpecailSys.GetDataList()
	return VipSpecailSys.DataList
end

function VipSpecailSys.GetDataByVipLvl()			--根据VIP等级得到数据
	local vipLvl = VipSys.VipLevel
	for i=1,#VipSpecailSys.DataList,1  do
		local data = VipSpecailSys.DataList[i]
		if vipLvl<data.VipLevel then
			return data
		end
	end
	return nil
end

function VipSpecailSys.GetDataByVipLvlTest(_Lvl)
	local vipLvl = _Lvl
	for i=1,#VipSpecailSys.DataList,1  do
		local data = VipSpecailSys.DataList[i]
		if vipLvl==data.VipLevel then
			return data
		end
	end
	return nil
end

function VipSpecailSys.GetNextDataById(_Id)
	local data = VipSpecialConfig.GetDataById(_Id)
	if data.NextId ~= 0 then
		return VipSpecialConfig.GetDataById(data.NextId)
	else
		return nil
	end
end

function VipSpecailSys.ReciveRwd(_Id)				--购买
	RechargeSys.BuyGoods.VipSpecail = true
	RechargeSys.GenerateOrder(_Id)
--	local info = _Id
--	WebEvent.ReciveVipPreferential( info , "VipSpecailSys.ReciveRwdCallBack" , VipSpecailSys.ReciveRwdCallBack)
end

function VipSpecailSys.ReciveRwdCallBack()
	local UIVipSpecialTar = MainGameUI.FindPanelTarget("UIVipSpecial")
	if UIVipSpecialTar ~= nil then
		local god = UIVipSpecialTar.UIVipSpecialGod
		if god ~= nil then
			UIVipSpecialTar:ShowBuyAfter()
		end
	end
	if GameMain.IOSTest == true then
		return
	end
	local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
	if UIControlTar ~= nil then
		UIControlTar:ShowVipSpecailInfo()
	end
end

function VipSpecailSys.CommonInfoCallBack(_Data)
	VipSpecailSys.RecDataList = {}
	local dataList = _Data["vipPreferential"]
	if dataList ~= nil then
		for key,value in pairs(dataList) do
			local id = tonumber(value)
			VipSpecailSys.RecDataList[id] = id
--			table.insert(VipSpecailSys.RecDataList , #VipSpecailSys.RecDataList +1 , id)
		end
	end
end

function VipSpecailSys.IsHasBuy(_Id)
	if VipSpecailSys.RecDataList[_Id] ~=nil then
		return true
	end
	return false
end

return VipSpecailSys
--endregion
