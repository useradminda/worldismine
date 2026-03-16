using UnityEngine;
using System.Collections;

//远程单体 发射弹药 普攻
public class farNormalSkill : skillbase {

	override public void SonUseSkill()
    {
		//Debug.Log("farNormalSkill UseSkill" + myrole.MyUUID);
        UseSkillToRole(myrole.nowattrole);

    }
	override public void SonUseSkillToRole(testdybroleai tarrole)
	{
		myrole.PlayAnim("attack");
	}
	override public void SonskillBaofa1()
	{
		//开始生成弹药
        CreateBaofa1Ammo();
	}

	override public void SonammoFlyFinCB(testdybroleai tar,Vector3 luodipos)
	{
		//对目标执行一次BUFF
		if (tar.IsDie == false)
        {
            //myrole.nowattrole.DoBuff(myrole.att);
			CreateBaofa1buff(tar);
        }
	}
}
