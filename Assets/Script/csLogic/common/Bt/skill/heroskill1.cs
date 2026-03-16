using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//英雄技能  点击地面 直接对地方释放
//个性参数 3,4 爆炸范围 
//个性化特效



public class heroskill1:skillbase 
{
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
		//myrole.PlayAnim("attack");
		//Debug.Log("tnormalskill UseSkill" + myrole.MyUUID);
		//UseSkillToRole(myrole.nowattrole);
		UseSkillToPos(m_tarpos);

	}

	override public void SonUseSkillToPos(Vector3 pos)
	{
		List<testdybroleai> rolelist = Luodianfanwei(myrole.camp, pos, x, z);
		
		CreateBaofa1buff_2(rolelist);
		
		CreateGexinTx (pos, null);
	}

	

}
