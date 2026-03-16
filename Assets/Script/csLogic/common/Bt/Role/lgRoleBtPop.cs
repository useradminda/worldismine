using UnityEngine;
using System.Collections;
//战斗角色属性管理

public struct rolepop_
{
	public int DBid;
	public int	Life;// 生命
	public int	Attack ;//攻击	
	public float MoveSpeed;//移动速度
	public float AttackSpeed ;//攻击速度
	public int  Defense;//防御	

	//public roleDepartment_ FuwenDepart;	//所带符文系别
	//public float FuwenDepartAdd ;		//符文减伤值

	public void Copy(rolepop_ basepop,ref rolepop_ topop)
	{
		topop.DBid = basepop.DBid;
		topop.Life = basepop.Life;
		topop.Attack = basepop.Attack;
		topop.MoveSpeed = basepop.MoveSpeed;
		topop.AttackSpeed = basepop.AttackSpeed;
		topop.Defense = basepop.Defense;
		//topop.FuwenDepart = basepop.FuwenDepart;
		//topop.FuwenDepartAdd = basepop.FuwenDepartAdd;

	}

}

public class lgRoleBtPop  {

	rolepop_ MyBasePop;	//基础属性	引用 不能修改值
	rolepop_ MyNowPop;	//当前属性
	testdybroleai MyRole;

	float movespeedadd;
	float attspeedadd;

	public void IniSome(testdybroleai thisrole, rolepop_ basepop)
	{
		MyRole = thisrole;
		MyBasePop = basepop;
		basepop.Copy (basepop,ref MyNowPop);
		movespeedadd = 0f;
		attspeedadd = 0f;
	}
	public void CheckPopAdd(FuwenData_ MyFuwenData,roleDepartment_ MyDepart)
	{
		float AddAttack = 0f;
		float AddHp = 0f;
		switch(MyDepart)
		{
			case roleDepartment_.D_Gong: 
				AddAttack = MyFuwenData.AddAttack+MyFuwenData.AddAttack1;
				AddHp = MyFuwenData.AddHp+MyFuwenData.AddHp1;
			break;
			case roleDepartment_.D_Dun:
				AddAttack = MyFuwenData.AddAttack+MyFuwenData.AddAttack2;
				AddHp = MyFuwenData.AddHp+MyFuwenData.AddHp2;
			break;
			case roleDepartment_.D_Qang: 
				AddAttack = MyFuwenData.AddAttack+MyFuwenData.AddAttack3;
				AddHp = MyFuwenData.AddHp+MyFuwenData.AddHp3;
			break;
		}
		if(AddAttack>0)
		{
			int Attack =  (int)(MyBasePop.Attack*(1f+AddAttack));
			MyBasePop.Attack = Attack;
			MyNowPop.Attack = Attack;
		}
		if(AddHp>0)
		{
			int hp =  (int)(MyBasePop.Life*(1f+AddHp));
			MyBasePop.Life = hp;
			MyNowPop.Life = hp;
		}
	}
	/*
	public float GetFuwenAdd(roleDepartment_ attdepart)
	{
		if(attdepart!= roleDepartment_.D_Null&&attdepart==MyNowPop.FuwenDepart)
		{
			return MyNowPop.FuwenDepartAdd;
		}
		return 0f;
	}
	*/
	//dam 敌方攻击力  damadd 伤害克制关系 减免系数   damadd2  天罚符文免伤
	public int BeDam(int dam,float damadd,float damadd2)	
	{
		//if(true)
		//{
		//	return 0;
		//}
		int basedam = dam;//log use 
		int baselife = MyNowPop.Life;//log use 

		if(dam<MyNowPop.Defense)
		{
			return 0;
		}
		int hurtnum = (int)((dam - MyNowPop.Defense) * (1 + damadd) - dam * damadd2);
		if(hurtnum<0)
		{
			return 0;
		}
		MyNowPop.Life -= hurtnum; 



		//如果是城堡 通知UI
		MyRole.CB_ReduceHp (hurtnum);

		//Debug.LogError ("uuid= "+MyRole.MyUUID +" bedam  dam = "+basedam.ToString()+ " damadd= "+damadd.ToString()+" hurtnum = "+hurtnum.ToString()+" beforelife ="+baselife.ToString()+" damlife = "+MyNowPop.Life.ToString());


		if(MyNowPop.Life<=0)
		{
			MyNowPop.Life = 0;

			//Debug.LogError ("uuid= "+MyRole.MyUUID+" die");

			MyRole.SoMeDie();
		}
		return hurtnum;
	}
	public float GetNowPop(int id)
	{
		switch(id)
		{
			case 1: return MyNowPop.Life;
			case 2: return MyNowPop.Attack;
			case 3: return MyNowPop.MoveSpeed;
		case 4: return MyNowPop.AttackSpeed;
			case 5: return MyNowPop.Defense;
		}
		return -1;
	}

	public int GetBasePop_Life()
	{
		return MyBasePop.Life;
	}

	public int GetNowPop_Life()
	{
		 return MyNowPop.Life;
	}
	public int GetNowPop_Attack()
	{
		return MyNowPop.Attack;
	}
	public float GetNowPop_MoveSpeed()
	{
		return MyNowPop.MoveSpeed;
	}
	public float GetNowPop_AttackSpeed()
	{
		return MyNowPop.AttackSpeed;
	}
	public int GetNowPop_Defense()
	{
		return MyNowPop.Defense;
	}
	public void ChangePopadd(bufftype_ thistype, float add)
	{
		if(thistype==bufftype_.bfDownatt)
		{
			Changeattspeedadd(add);
		}
		if(thistype==bufftype_.bfDownmovespeed)
		{
			Changemovespeedadd(add );
		}

	}
	void Changemovespeedadd(float usemovespeedadd)
	{
		if (usemovespeedadd != movespeedadd) 
		{
			movespeedadd = usemovespeedadd;
			//通知角色更改
			GetMoveSpeed();
		}
	}
	void Changeattspeedadd(float useattspeedadd)
	{
		if (useattspeedadd != attspeedadd)
		{
			attspeedadd = useattspeedadd;
			GetNomalSkillCD();
		}
	}
	public void GetNomalSkillCD()
	{
		//通知角色更改 普通技能CD
		float cd = 10000f/(MyNowPop.AttackSpeed+attspeedadd);
		MyRole.SetNomalSkillCD(cd);
	}
	public void GetMoveSpeed()
	{
		//通知角色更改 普通技能CD
		float speed = (MyNowPop.MoveSpeed+movespeedadd)/100f;
		MyRole.SetMoveSpeed(speed);
	}

	public float Getpopadd(bufftype_ bufftype)
	{
		if(bufftype==bufftype_.bfDownatt)
		{
			return attspeedadd;
		}
		if(bufftype==bufftype_.bfDownmovespeed)
		{
			return movespeedadd;
		}
		return 1;
	}

	//城堡用设置血量
	public void SetBaseHp(int basehp)
	{
		MyBasePop.Life =  basehp;	//基础属性	引用 不能修改值
		MyNowPop.Life =basehp ;	//当前属性
	}

	//设置初始化血量
	public void SetIniNowHp(int basehp)
	{
		MyNowPop.Life =basehp ;	//当前属性
	}
	// Update is called once per frame
	//void Update () {
	
	//}
	//副本怪物  增加强度计算

	public void FubenHpAdd(float HpAdd)
	{
		MyBasePop.Life =(int)(MyBasePop.Life * (1 + HpAdd));
		MyNowPop.Life = MyBasePop.Life;
	}
	public void FubenAttAdd(float AttAdd)
	{
		MyBasePop.Attack =(int)( MyBasePop.Attack * (1 + AttAdd));
		MyNowPop.Attack = MyBasePop.Attack;
	}

}
