--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
TipsPanel = {}
TipsPanel = BasePanel:new()
local this = TipsPanel
--UI
TipsPanel.TipsPanelGod = nil
TipsPanel.Controls = {}

--Data
TipsPanel.With = 224

function TipsPanel:OpenUI(_PanelName , _LuaName , _Data)
	this:ShowInitInfo(_Data)
end

function TipsPanel:ShowInitInfo(_Data)
	if TipsPanel.TipsPanelGod == nil then
		TipsPanel.TipsPanelGod = MainGameUI.FindPanel("TipsPanel")
		this:GetControls()
	end
	GameMain.OpenObj(TipsPanel.TipsPanelGod)
	this:ShowTipMsg(_Data)
end

function TipsPanel:ShowTipMsg(_Data)
	local msgList =	this:ByTypeGetMsg(_Data.data , _Data.typeName)
	local str = GameMain.StringSplit(msgList["msg"] , "|")
	local pos = _Data.pos
	if pos ~=nil then
		this:SetPosition(pos , #str , msgList["count"])
	end
	this:ShowInfo(str , msgList["count"])
end

function TipsPanel:ByTypeGetMsg(_Data , _Type)			--根据不同类型得到要显示的内容
	local msg = ""
	if _Type == "Hero" then
		msg = this:GetHeroMsg(_Data)
	end
	if _Type == "Skill" then
		msg = this:GetSkillMsg(_Data)
	end
	if _Type == "Solider" then
		msg = this:GetSoliderMsg(_Data)
	end
	if _Type == "SummonValue" then
		msg = this:GetSummonMsg()
	end
	if _Type == "Item" then
		msg = this:GetItemMsg(_Data)
	end
	if _Type == "Equip" then
		msg = this:GetEquipMsg(_Data)
	end
	if _Type == "BallteFlag" then
		msg = this:GetBattleFlag(_Data)
	end
    if _Type == "BallteFlagLvl" then
        msg = this:GetBattleFlagLvl(_Data)
    end

	return msg
end

function TipsPanel:GetBattleFlag(_Data)
	local nameStr = UIstring.Golden .. "名称:" .. "[-]" .. _Data.Name
	
	local desCount = GameMain.GetStringWordNum(_Data.Descrip)

	local msg = nameStr .. "|" .. UIstring.Golden.. "描述:".."[-]".._Data.Descrip
	local list = {}
	list["msg"] = msg
	list["count"] = desCount
	return list 
end

function TipsPanel:GetBattleFlagLvl(_Data)
    local desCount = 3--GameMain.GetStringWordNum(_Data)
    local list = {}
    list["msg"] = UIstring.Golden.._Data.."[-]"
	list["count"] = desCount
    return list 
end

function TipsPanel:GetEquipMsg(_Data)
	
	local nameStr = UIstring.Golden .. "名称:" .. "[-]" .. UIstring.WordColor[_Data.Quality] .._Data.nickname .. "[-]"
	local typeStr = UIstring.Golden .. "部位:" .. "[-]" .. UIstring.EquipType[_Data.EquipType]
	local lvlStr = UIstring.Golden .. "等级:" .. "[-]" .. _Data.Lvl
	local attrStr = ""
	local hp = _Data:GetNoPurifyHp()
	if hp>0 then
		local hpstr = UIstring.Golden .. "血量:" .."[-]" .. hp .. "(每级增加" .._Data.UpGradeHpList[4]..")"
		attrStr = this:GetAddAttrStr(attrStr , hpstr)
	end
	local atk = _Data:GetNoPurfyAtk()
	if atk >0 then
		local atkStr = UIstring.Golden .. "攻击:" .."[-]" .. atk .. "(每级增加" .._Data.UpGradeAttList[4]..")"
		attrStr = this:GetAddAttrStr(attrStr , atkStr)
	end
	local atkSpeed = _Data:GetNoPurifyAtkSpeed()
	if atkSpeed >0 then
		local atkSpeedStr = UIstring.Golden .. "攻速:" .."[-]" .. atkSpeed
		attrStr = this:GetAddAttrStr(attrStr , atkSpeedStr)
	end
	if _Data.IsSell == 1 then
		local sellPrice = UIstring.Golden.. "出售价格:".. _Data.Price
		attrStr = this:GetAddAttrStr(attrStr , sellPrice)
	end
	local purfityStr = this:GetPurfityAttrInfo(_Data)
	if purfityStr ~= "" then
		purfityStr = "洗炼加成" .. "|" .. purfityStr
	end
	local msg = nameStr .. "|" .. typeStr .. "|" .. lvlStr .. "|" .. attrStr .. "|"..purfityStr
	local list = {}
	list["msg"] = msg
	list["count"] = 1
	return list
end

function TipsPanel:GetPurfityAttrInfo(_Data)
	local str = ""
	if _Data.HpAdd~=0 then
		local color = UIstring.GetHpValueColor(_Data.HpAdd)
		local hpStr = color..  "武将生命+".._Data:GetPurifyHp().."(每级增加".._Data.HpAdd ..")".."[-]"
		str = this:GetAddAttrStr(str , hpStr)
	end
	if _Data.AttackAdd~=0 then
		local color = UIstring.GetAtkValueColor(_Data.AttackAdd)
		local atkStr = color.. "武将攻击+".._Data:GetPurifyAtk().."(每级增加".._Data.AttackAdd ..")" .. "[-]"
		str = this:GetAddAttrStr(str , atkStr)
	end
	if _Data.AttackSpeedAdd~=0 then
		local color = UIstring.GetAtkSpeedValueColor(_Data.AttackSpeedAdd)
		local atkSpeedStr = color.. "武将攻速+".._Data:GetPurifyAtkSpeed().."(每级增加".._Data.AttackSpeedAdd ..")".."[-]"
		str = this:GetAddAttrStr(str , atkSpeedStr)
	end
	return str
end

function TipsPanel:GetAddAttrStr(_Str , _AddStr)
	if _Str == "" then
		_Str = _AddStr
	else
		_Str = _Str .. "|" .. _AddStr
	end
	return _Str
end

function TipsPanel:GetItemMsg(_Data)
	local nameStr = UIstring.Golden.. "名称:".."[-]".._Data.Name  
	local des = _Data.Description
	local count = GameMain.GetStringWordNum(des)
	local msg = nameStr .. "|" .. UIstring.Golden.. "描述:".."[-]"..des
	local list = {}
	list["msg"] = msg
	list["count"] = count
	return list
end

function TipsPanel:GetSummonMsg()
	local value = SummonSys.GetSummonPointValue()
	local summonMsg = "招募值:" .. value
	local des = "可以在武将商店购买高品质武将通过刷新武将获得"
	local desCount = GameMain.GetStringWordNum(des)
	local strs = summonMsg .. "|" .. des
	local list = {}
	list["msg"] = strs
	list["count"] = desCount
	return list
end

function TipsPanel:GetSoliderMsg(heroData)
	local nameLvlStr =  UIstring.Golden.. "名称：".."[-]" .. UIstring.WordColor[heroData.quality] .. heroData.nickname .."[-]" .. "  Lv：" .. heroData.lvl
	local attackTypeStr = UIstring.Golden.."士兵类型：" .."[-]".. heroData.AttackType 	
	local hpStr = UIstring.Golden.."血量：".."[-]" .. heroData:GetLife() .. "(每级增加"..heroData:GetLifeGrowValue()..")"					
	local atkStr = UIstring.Golden.."攻击：" .."[-]" .. heroData:GetAtk() .. "(每级增加" .. heroData:GetAtkGrowValue() .. ")"
	local atkSpeedStr = UIstring.Golden.."攻速：".."[-]" .. heroData:GetAtkSpeed()
	local moveSpeedStr = UIstring.Golden.."移动速度" .. "[-]" .. heroData:GetMoveSpeed()
	local atkDistanceStr = UIstring.Golden.."攻击距离：" .. "[-]" .. heroData.AttackRange
	local peopleStr = UIstring.Golden.."人口：" .."[-]" .. heroData.People
	local DesStr = "描述：" ..heroData.Description
	local DesCount = GameMain.GetStringWordNum(DesStr)
	local strs = nameLvlStr .. "|" .. attackTypeStr .. "|" .. hpStr .. "|" .. atkStr .. "|" .. atkSpeedStr .."|" .. moveSpeedStr .. "|" .. atkDistanceStr .. "|" .. DesStr
	local list = {}
	list["msg"] = strs
	list["count"] = DesCount
	return list
end

function TipsPanel:GetSkillMsg(_Data)
	local skillData = _Data["skill"]
	local value = 
	{
		["atk"] = _Data["atk"],
		["hp"] = _Data["hp"],
	}
	local power = CalculateRoleProp.GetSkillPower(skillData.Buff1_id , skillData.Buff2_id ,value , _Data["lvl"] , _Data["qlvl"])
	local skillStrs = skillData.Descrip
	local count = GameMain.GetStringWordNum(skillStrs)
	
	local strs = UIstring.WordColor[_Data["q"]].. skillData.Name.."[-]" .. "|" .. "技能威力：" ..UIstring.Green..power.."[-]".. "|" .. "效果范围：".. UIstring.Green.. skillData.Range.."[-]" .. "|" .. skillStrs
	local list = {}
	list["msg"] = strs
	list["count"] = count
	return list
end

function TipsPanel:GetHeroMsg(heroData)
	local nameLvlStr = UIstring.Golden.. "名称：".."[-]"..UIstring.WordColor[heroData.quality].. heroData.nickname .."[-]".. "  Lv：" .. heroData.lvl
	local attackTypeStr = UIstring.Golden.."武将类型：".."[-]" .. heroData.AttackType 	
	local hpStr = UIstring.Golden.."血量：".."[-]" .. heroData:GetLife() .. "(每级增加"..heroData:GetLifeGrowValue()..")"					
	local atkStr = UIstring.Golden.."攻击：".."[-]" .. heroData:GetAtk() .. "(每级增加" .. heroData:GetAtkGrowValue() .. ")"
	local atkSpeedStr = UIstring.Golden.."攻速：".."[-]" .. heroData:GetAtkSpeed()
	local moveSpeedStr = UIstring.Golden.."移动速度".."[-]" .. heroData:GetMoveSpeed()
	local atkDistanceStr = UIstring.Golden.."攻击距离：".."[-]" .. heroData.AttackRange
	local peopleStr = UIstring.Golden.."人口：" .. "[-]" .. heroData.People
	local qualityStr = UIstring.Golden.."资质：".."[-]" ..UIstring.QualityStr[heroData.Aptitude]
	local strs = nameLvlStr .. "|" .. attackTypeStr .. "|" .. hpStr .. "|" .. atkStr .. "|" .. atkSpeedStr .."|" .. moveSpeedStr .. "|" .. atkDistanceStr .. "|" .. qualityStr
	local list = {}
	list["msg"] = strs
	list["count"] = 1
	return list
end

function TipsPanel:GetControls()
	TipsPanel.Controls.Bg = TipsPanel.TipsPanelGod.transform:FindChild("bg"):GetComponent("UISprite")
	TipsPanel.Controls.Label = TipsPanel.TipsPanelGod.transform:FindChild("label"):GetComponent("UILabel")
end

function TipsPanel:GetAddRows( _Len, _Count)
	local count = math.ceil( _Count/15)
	return count +_Len
end

function TipsPanel:SetPosition(pos , len , withCount)
	TipsPanel.TipsPanelGod.transform.position = Vector3(pos.x,pos.y,0)
	local curLosition = TipsPanel.TipsPanelGod.transform.localPosition
	local y = curLosition.y+45
	local _len = this:GetAddRows(len , withCount)
	local yLen = y-20*_len - 10
	if yLen<-320 then
		y = curLosition.y+20*_len + 10
	end
	
	local x = curLosition.x + 50
	local limitX = x+ TipsPanel.With
	if limitX >=560 then
		x = curLosition.x - TipsPanel.With - 50
	end
	TipsPanel.TipsPanelGod.transform.localPosition = Vector3(x, y,-600)
	
end

function TipsPanel:ShowInfo(StrList , Count)
	local strs = ""
	local len = this:GetAddRows( #StrList , Count) 
	for key,value in pairs(StrList) do
		if strs == "" then
			strs = strs .. value
		else
			strs = strs .. "\n" .. value
		end
	end
	
	TipsPanel.Controls.Bg.height = 20*len +10
	TipsPanel.Controls.Label.text = strs
end

function TipsPanel:ClosePanel()
	GameMain.CloseObj(TipsPanel.TipsPanelGod)
end

function TipsPanel:ReleasPanel()
    --UI
	TipsPanel.TipsPanelGod = nil
	TipsPanel.Controls = {}
end

return TipsPanel