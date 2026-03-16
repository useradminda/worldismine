using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//角色buff 管理器
public class rolebuffmag  
{
    public testdybroleai MyRole;
	//对除了 直接伤害  类型 的其他类型buff 做记录 只保留影响属性较大的 

    public Dictionary<bufftype_, List<buffbase>> usebufflist = new Dictionary<bufftype_, List<buffbase>>();

    public void IniSome(testdybroleai thisrole)
    {
        MyRole = thisrole;
    }

    //返回是否可以加这个buff
    public bool AskDoBuff(buffbase addthisbuff)
    {
        List<buffbase> oldbufflist;
        if (usebufflist.TryGetValue(addthisbuff.mytype, out oldbufflist) == true)
        {
            if (oldbufflist.Contains(addthisbuff) == false)
            {
                oldbufflist.Add(addthisbuff);

                //检查属性影响
				if(addthisbuff.Dam> MyRole.MyPop.Getpopadd(addthisbuff.mytype))
				{
					MyRole.MyPop.ChangePopadd(addthisbuff.mytype,addthisbuff.Dam);
				}
                return true;
            }
          
        }
        else
        {
            oldbufflist = new List<buffbase>();
            oldbufflist.Add(addthisbuff);
            usebufflist.Add(addthisbuff.mytype, oldbufflist);
			MyRole.MyPop.ChangePopadd(addthisbuff.mytype,addthisbuff.Dam);
            return true;
        }

        //检查属性影响

        return false;
    }
    /*
    public void CheckCanDoBuff(buffbase addthisbuff)
    {
        buffbase oldbuff;
        if (usebufflist.TryGetValue(addthisbuff.mytype, out oldbuff) == true)
        {
            oldbuff
        }
        else
        {
            
            return true;
        }
        return false;

    }
     * */

    public void BuffQuit(buffbase addthisbuff)
    {
        List<buffbase> oldbufflist;
        if (usebufflist.TryGetValue(addthisbuff.mytype, out oldbufflist) == true)
        {
            if (oldbufflist.Contains(addthisbuff) == true)
            {
                oldbufflist.Remove(addthisbuff);

                //检查属性影响
				buffbase maxbuff = GetMaxDamBuff(oldbufflist );
				if(maxbuff==null)
				{
					MyRole.MyPop.ChangePopadd(addthisbuff.mytype,1f);
				}
				else
				{
					MyRole.MyPop.ChangePopadd(addthisbuff.mytype,maxbuff.Dam);
				}
               
            }

        }
    }
	public buffbase GetMaxDamBuff( List<buffbase> thislist)
	{
		if(thislist==null || thislist.Count==0)
		{
			return null;
		}
		float tempdum = 0;
		buffbase result=null;
		for(int i=0;i<thislist.Count;i++)
		{
			if(thislist[i].Dam>tempdum)
			{
				tempdum = thislist[i].Dam;
				result = thislist[i];
			}
		}
		return result;
	}
}
