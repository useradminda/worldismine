using UnityEngine;
using System.Collections;


//近战普通攻击  单体
public class tnormalskill:skillbase 
{
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
        if (m_tarrole .IsDie== false)
		{
			//myrole.nowattrole.DoBuff(myrole.att);
            CreateBaofa1buff(m_tarrole);
		}

	}
}
