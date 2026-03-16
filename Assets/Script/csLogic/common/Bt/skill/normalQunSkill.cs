using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//近战群攻 对一定范围内敌人造成伤害的 角色前面范围内 要注意阵营朝向
public class normalQunSkill : skillbase {
	public int x = 0;
	public int z = 0;


	override public void SonIniSome()
	{
		//解析个性化参数
		string[] strlist =  my_inidata.GeXingP.Split(',');
		x = int.Parse(strlist[0]) * myrole.Mymapmag.i_rolecellbimapcell;
		z = int.Parse(strlist[1]) * myrole.Mymapmag.i_rolecellbimapcell;
	}

	override public void SonUseSkill()
	{
		//Debug.Log("tnormalskill UseSkill" + myrole.MyUUID);
		UseSkillToRole(myrole.nowattrole);
		
	}
	
	override public void SonUseSkillToRole(testdybroleai tarrole)
	{
		myrole.PlayAnim("attack");
	}
	
	override public void SonskillBaofa1()
	{
		//对目标造成伤害计算
		//if (m_tarrole .IsDie== false)
		//{
			//myrole.nowattrole.DoBuff(myrole.att);
		//	CreateBaofa1buff(m_tarrole);
		//}

		//得到角色前面基点
		int posx1 = 0;
		int posx2 = 0;
		int posz1 = 0;
		int posz2 = 0;
		myrole.GetFaceIniPos (ref posx1,ref posx2,ref posz1,ref posz2, x, z);

		List<testdybroleai> rolelist = GetfanweiRole(myrole.camp, posx2,posx1, posz2, posz1);
		
		CreateBaofa1buff_2(rolelist);
	}
	/*
	public void UseSkill()
	{
		if(useSkillCD <= 0f&&Useing==false)
		{
			
			
			useSkillTime = 0f;
			Useing = true;
			b_baofa1 = false;
			b_baofa2 = false;
			myrole.PlayAnim("attack");
			
		}
		
	}
	 public void UseSkillToRole(testdybroleai tarrole)
	{
		if(useSkillCD <= 0f&&Useing==false)
		{
			m_tarrole = tarrole;
			
			useSkillTime = 0f;
			Useing = true;
			b_baofa1 = false;
			b_baofa2 = false;
			myrole.PlayAnim("attack");
			
		}
		
	}
	 public void skillBaofa1()
	{
		b_baofa1 = true;
		//查找范围内所有敌人

       // List<testdybroleai> rolelist;

        //CreateBaofa1buff(rolelist);
       


		//对目标造成伤害计算
		//if(myrole.b_nowattroledie==false)
		//{
		//	myrole.nowattrole.DoBuff(myrole.att);
		//}
		
	}
	*/
}
