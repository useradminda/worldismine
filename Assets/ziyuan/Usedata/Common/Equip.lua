Equip = {}											--人物属性基类
Equip.__index = Equip

Equip.EquipData = nil								--人物数据库信息
Equip.Dbid = 0
Equip.nickname = ""								   --装备名称
Equip.AtlasName = ""                               --装备Atlas
Equip.SpriteName = ""                              --装备Sprite
Equip.ItemType = 0                                 --物品类型  1道具 2碎片 3资源 4装备
Equip.EquipType = 0                                --装备类型
Equip.BuyPrice = 0
Equip.Price = 100                                  --出售价钱
Equip.Lvl = 0
Equip.Quality = 0                                  --装备品质
Equip.QualityLvl = 0
Equip.Star = 0
Equip.Descrip = ""
Equip.IsRecast = 0                                --重铸
Equip.IsRefine = 0                                --洗练
Equip.UUID = ""
Equip.EquipOn = 0                                  --0表示没有被穿 1 表示被穿

Equip.Prop = {}

Equip.AttackAdd = 0								
Equip.HpAdd = 0
Equip.AttackSpeedAdd =0

Equip.AdvancedId = 0							--进阶后的ID

Equip.IsBuy = false								--装备已经购买，仅仅用于洗炼装备
Equip.IsSell = 0								--1 可以出售 0 不能出售

Equip.UpGradeAttList = nil						--装备攻击属性
Equip.UpGradeHpList = nil						--装备血量属性
Equip.UpGradeSpeedList = nil					--装备攻速属性

function Equip:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Equip:BuyInfo(_isBuy)
	if _isBuy == nil then
		self.IsBuy = false
	end
	
	if _isBuy == 1 then
		self.IsBuy = true
	end
end

function Equip:Init(_EquipDB , _UUID , _Lvl , _QualityLvl ,_AttackAdd , _HpAdd , _AttackSpeedAdd)
   
    self.UUID = _UUID
    self.Lvl = _Lvl
    self.QualityLvl = _QualityLvl
    self.EquipOn = 0
	self.AttackAdd = _AttackAdd
	self.HpAdd = _HpAdd
	self.AttackSpeedAdd = _AttackSpeedAdd
    self:SetEquipDb(_EquipDB)
    
end

function Equip:SetUpQuality(_EquipDB)
    self:SetEquipDb(_EquipDB)
    self.Quality = self.Quality + 1
end

function Equip:SetEquipDb(_EquipDB)
    
    self.Dbid = _EquipDB.Id
    self.nickname = _EquipDB.Name
    self.ItemType = 4
    self.EquipType = _EquipDB.Type  
    self.Quality = _EquipDB.Quality
    self.BuyPrice = _EquipDB.BuyPrice
    self.Price = _EquipDB.SellPriec
    self.Star = _EquipDB.Star
    self.Descrip = _EquipDB.Descrip
    self.IsRecast = _EquipDB.IsRecast
    self.IsRefine = _EquipDB.IsRefine
    self.AtlasName = _EquipDB.AtlasName
    self.SpriteName = _EquipDB.SpriteName
	self.AdvancedId = _EquipDB.AdvanceId
	self.IsSell = _EquipDB.IsSell
	self.UpGradeAttList = _EquipDB.UpgradeAttList
	self.UpGradeHpList = _EquipDB.UpgradeHpList
	self.UpGradeSpeedList = _EquipDB.UpgradeSpeedList
	
	self.EquipData = _EquipDB
end

function Equip:SellEquip()										--出售装备
    EquipSys.SellEquip(self)
end

function Equip:UpEquipLvl()										--升级
    EquipSys.UpEquipLvl(self)
end

function Equip:UpEquipQualityLvl()								--升阶
    EquipSys.UpEquipQualityLvl(self)
end

function Equip:EquipReCast(_MatUUIDs)							--重铸
    EquipSys.EquipReCast(self , _MatUUIDs)
end

function Equip:EquipRefine()									--洗练
    EquipSys.EquipReRefine(self)
end

function Equip:Strength(isBuyCD , isUseProp)					--强化
	EquipSys.StrengthEquip(UIEquip.ClickEquipItem , isBuyCD , isUseProp)
end

function Equip:GetAtk()											--得到攻击属性值
	local normal = CalculateRoleProp.CalculationAttr(self.UpGradeAttList, self.QualityLvl ,self.Lvl)
	local value = self.AttackAdd*self.Lvl + normal
	return value
end

function Equip:GetHp()											--得到生命属性值
	local normal =  CalculateRoleProp.CalculationAttr(self.UpGradeHpList, self.QualityLvl ,self.Lvl)
	local value = self.HpAdd *self.Lvl +normal
	return value
end

function Equip:GetAtkSpeed()									--得到攻速属性值
	local normal =  CalculateRoleProp.CalculationAttr(self.UpGradeSpeedList, self.QualityLvl ,self.Lvl)
	local value = self.AttackSpeedAdd *self.Lvl + normal
	return value
end

function Equip:GetPurifyHp()
	local value = self.HpAdd *self.Lvl
	return value
end
function Equip:GetPurifyAtk()
	local value = self.AttackAdd*self.Lvl
	return value
end
function Equip:GetPurifyAtkSpeed()
	local value = self.AttackSpeedAdd *self.Lvl
	return value
end

function Equip:GetNoPurifyHp()
	return  CalculateRoleProp.CalculationAttr(self.UpGradeHpList, self.QualityLvl ,self.Lvl)
end

function Equip:GetNoPurifyAtkSpeed()
	return  CalculateRoleProp.CalculationAttr(self.UpGradeSpeedList, self.QualityLvl ,self.Lvl)
end

function Equip:GetNoPurfyAtk()
	return  CalculateRoleProp.CalculationAttr(self.UpGradeAttList, self.QualityLvl ,self.Lvl)
end

function Equip:GetAtkNextLvl()									--得到下一级攻击属性值
	return CalculateRoleProp.CalculationAttr(self.UpGradeAttList, self.QualityLvl ,self.Lvl+1)
end

function Equip:GetHpNextLvl()									--得到下一级生命属性值
	return CalculateRoleProp.CalculationAttr(self.UpGradeHpList, self.QualityLvl ,self.Lvl+1)
end

function Equip:GetAtkSpeedNextLvl()								--得到下一级攻速属性值
	return CalculateRoleProp.CalculationAttr(self.UpGradeSpeedList, self.QualityLvl ,self.Lvl +1)
end

function Equip:GetBattlePower()
	return self.Lvl*CalculateRoleProp.FightTypes.EquipBasicValue[tonumber(self.Quality)]
end
return Equip