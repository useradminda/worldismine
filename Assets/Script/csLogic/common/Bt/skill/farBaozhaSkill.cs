using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//远程发射爆炸弹药 群攻技能
//public string GeXingP;				//个性化参数 3,3 表示爆炸范围为3*3的范围
//override
public class farBaozhaSkill : skillbase 
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
         UseSkillToRole(myrole.nowattrole);

     }


	override public void SonUseSkillToRole(testdybroleai tarrole)
	{
		myrole.PlayAnim("attack");
	}
	/*
	//对目标点释放技能
	override public void SonUseSkillToPos(Vector3 tarpos)
	{
		myrole.PlayAnim("attack");
	}
	*/
	override public void SonskillBaofa1()
	{
		//开始生成弹药
        CreateBaofa1Ammo();
	}
	
	override public void SonammoFlyFinCB(testdybroleai tar,Vector3 luodipos)
	{
		//生成特效
        //int camp =1;
        //if( myrole.camp==1)
       // {
        //    camp =2;
       // }
		//查找范围内所有敌人
		List<testdybroleai> rolelist = Luodianfanwei(myrole.camp, luodipos, x, z);

        CreateBaofa1buff_2(rolelist);

		CreateGexinTx (luodipos, null);
		
		//对目标执行一次BUFF
		//if(myrole.b_nowattroledie==false)
		//{
		//	myrole.nowattrole.DoBuff(myrole.att);
		//}
	}

    
}
