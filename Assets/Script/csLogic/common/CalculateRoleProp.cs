using UnityEngine;
using System.Collections;

public struct RolePropData
{
	public int[] Life;
	public int[] Attack;
	public int[] AttackSpeed;
	public int[] MoveSpeed;
	public int[] Defence;
}

public struct RoleProp
{
	public int Life;
	public int Attack;
	public int AttackSpeed;
	public int MoveSpeed;
	public int Defence;
}

public class CalculateRoleProp  
{
	private static CalculateRoleProp _Ins = null;
	public static CalculateRoleProp Ins
	{
		get
		{
			if(_Ins==null)
			{
				_Ins = new CalculateRoleProp();
			}
			return _Ins;
		}
	}
	
	public RoleProp CalculateProp(RolePropData _RoleProp , int _Lvl , int _QualityLvl)
	{
		RoleProp _Prop = new RoleProp();
		int Life =  _RoleProp.Life[1] + _QualityLvl*_RoleProp.Life[2] + _RoleProp.Life[3] + _Lvl*_RoleProp.Life[4];
		int Attack =  _RoleProp.Attack[1] + _QualityLvl*_RoleProp.Attack[2] + _RoleProp.Attack[3] + _Lvl*_RoleProp.Attack[4];
		int AttackSpeed = _RoleProp.AttackSpeed[1] + _QualityLvl*_RoleProp.AttackSpeed[2] + _RoleProp.AttackSpeed[3] + _Lvl*_RoleProp.AttackSpeed[4];
		int MoveSpeed = _RoleProp.MoveSpeed[1] + _QualityLvl*_RoleProp.MoveSpeed[2] + _RoleProp.MoveSpeed[3] + _Lvl*_RoleProp.MoveSpeed[4];
		int Defence = _RoleProp.Defence[1] + _QualityLvl*_RoleProp.Defence[2] + _RoleProp.Defence[3] + _Lvl*_RoleProp.Defence[4];
		_Prop.Life = Life;
		_Prop.Attack = Attack;
		_Prop.AttackSpeed = AttackSpeed;
		_Prop.MoveSpeed = MoveSpeed;
		_Prop.Defence = Defence;
		return _Prop;
	}
	
	
}
