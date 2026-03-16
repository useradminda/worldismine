using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum bufftype_
{
	bfnull=0,
	bfDamage,		//直接伤害类型
	//bfDotDam,		//dot 伤害
    bfDownatt,      //降低攻击速度
	bfDownmovespeed,      //降低移动速度
}

public struct buffdata_
{
    public int DBid;
    public bufftype_ type;
	//public int quality ;	//品质
	//public int lvl   ;			//等级
	//public int DoTimeType ;	//执行时间类型 - 0 持续BUFF不会消失  1 一定时间的BUFF 间隔时间生效一次 2 一定时间内一直执行 3 进入执行 一定时间后结束
	public float DoTimeSum  ;	//执行时间 生效总时间
	//public float IntervalTime   ;	//间隔时间
	//public skillbase CreateSkill;	//创建者技能
	public float useDam;			//-1 自己计算 -2 每次都要计算  >0用使用好的值
	//public float addp;			//根据克制关系 加成
	public int PropertyId; // 修正属性
	public string LvlModify;	//属性修正值
	public string SpellModify; //技能修正值
}


public class buffbase 
{
    //public btbuffmag Mybtbuffmag;
	public bufftype_ mytype;

	//public buffdata_ mIniData;

    //public int DoTimeType;	//执行时间类型 - 0 持续BUFF不会消失  1 一定时间的BUFF 间隔时间生效一次 2 一定时间内一直执行 3 进入执行 一定时间后结束
    public float DoTimeSum;	//执行时间 生效总时间
   // public float IntervalTime;	//间隔时间


    public float useDoTimeSum;
    //public float useIntervalTime;

	private bool useUpdate;

    public float Dam;
    private skillbase callskill;
    private List<testdybroleai> tarrolelist;//= new List<testdybroleai> ();

    public btbuffmag MyBtBuffMag = null;
    //public void IniSome(bufftype_ thistype, int thisDoTimeType, float thisDoTimeSum, float thisIntervalTime, int thisDam, skillbase thiscallskill, List<testdybroleai> thistarrolelist)
	public void IniSome(bufftype_ thistype, float thisDoTimeSum, float thisDam, skillbase thiscallskill, List<testdybroleai> thistarrolelist)
	{
		//mIniData = IniData;
		useUpdate = true;
        mytype = thistype;
       // DoTimeType = thisDoTimeType;
        DoTimeSum = thisDoTimeSum;
       // IntervalTime = thisIntervalTime;
        Dam = thisDam;
        callskill = thiscallskill;
        tarrolelist = thistarrolelist;
		//
        /*
		if(IniData.useDam==-1)
		{
            //根据策划公式计算
            Dam = JisuanDam();
		}
		else if(IniData.useDam>0)
		{
			Dam = IniData.useDam;
		}
         * */

        DoEffect();
        //放入更新
        if(MyBtBuffMag!=null)
        {
            MyBtBuffMag.CreateOnebuffCB(this);
        }
	}
    /*
    public int JisuanDam()
    {

        return 0;
    }
    */


	// Update is called once per frame
	public bool update (float dt)
	{
        if (useUpdate == true)
        {
			/*
            if (DoTimeType == 0)
            {
            }
            if (DoTimeType == 1)
            {
                useDoTimeSum = useDoTimeSum + dt;
                useIntervalTime = useIntervalTime + dt;
                if (useDoTimeSum >= DoTimeSum)
                {
                    BaseEnd();
                    return useUpdate;
                }
                if (useIntervalTime >= IntervalTime)
                {
                    useIntervalTime = 0;

                    DoEffect();
                }
            }
            if (DoTimeType == 2)
            {
                useDoTimeSum = useDoTimeSum + dt;
                if (useDoTimeSum >= DoTimeSum)
                {
                    BaseEnd();
                    return useUpdate;
                }
                else
                {
                    DoEffect();
                }
            }
            */
           // if (DoTimeType == 3)
            //{
                useDoTimeSum = useDoTimeSum + dt;
                if (useDoTimeSum >= DoTimeSum)
                {
                    BaseEnd();
                    return useUpdate;
                }
            //}
            return useUpdate;

        }
        else
        {
            return false;
        }

	}
	public void DoEffect ()
	{
		//伤害在初始化的时候就算好 不要每次都算一遍 或者在传进来的时候就算好
        //if (mytype == bufftype_.bfDotDam)
       // {
       //     for (int i = 0; i < tarrolelist.Count; i++)
       //     {
        //        tarrolelist[i].BeDam(Dam);
       //     }
       // }
        //else 
		if (mytype != bufftype_.bfnull)
        {
            for (int i = 0; i < tarrolelist.Count; i++)
            {
                tarrolelist[i].AskDoBuff(this);
            }
        }
	}

  //  public void 
    
	public void BaseEnd ()
	{
		
        callskill = null;
        if (tarrolelist!=null)
        {

            for (int i = 0; i < tarrolelist.Count; i++)
            {
                tarrolelist[i].BuffQuit(this);
            }
            
            tarrolelist.Clear();
        }
        //通知场景buff回收
        useUpdate = false;
	}

}
