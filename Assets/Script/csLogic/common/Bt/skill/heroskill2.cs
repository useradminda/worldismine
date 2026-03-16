using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class heroskill2 : skillbase 
{

	public int x = 0;
	public int z = 0;
	public float addh = 0f;
	override public void SonIniSome()
	{
		//解析个性化参数
		string[] strlist =  my_inidata.GeXingP.Split(',');
		x = int.Parse(strlist[0]) * myrole.Mymapmag.i_rolecellbimapcell;
		z = int.Parse(strlist[1]) * myrole.Mymapmag.i_rolecellbimapcell;
		addh = float.Parse(strlist[1]);
		
	}
	override public void SonUseSkill()
	{
		UseSkillToPos(m_tarpos);

	}

	override public void SonUseSkillToPos(Vector3 pos)
	{
		//开始生成弹药
		CreateLuodianAmmo(pos,addh);
	}


	override public void SonammoFlyFinCB(testdybroleai tar,Vector3 luodipos)
	{
		//查找范围内所有敌人
		List<testdybroleai> rolelist = Luodianfanwei(myrole.camp, luodipos, x, z);
		
		CreateBaofa1buff_2(rolelist);
		
		CreateGexinTx (luodipos, null);
		

	}
}
