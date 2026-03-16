using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public struct skilldata_
{
    public int DBid;
	public string name;
	public float SkillCD ;

	public float SkillTime ;

	public float Baofa1Time ;		//第一阶段爆发 比如生成弹药 平砍计算伤害点 	
	public float Baofa2Time ;		//第二阶段爆发 比如弹药到达目的地  计算目标伤害  

	public bool NeedPlayerChoosePos;	//如果玩家控制 该技能是否需要选择屏幕中释放的目标点 1 是  0 立即释放
	//public bool DanTiGongJi;			//是否是单体攻击 还是群攻
    public string skillCsName;          //技能脚本名字
	public string GeXingP;				//个性化参数

	public string Baofa1Emo;			//爆发点1弹药列表
	public string Baofa2Emo;			//爆发点2弹药列表

	public string Baofa1Buff;			//爆发点1 Buff列表
	public string Baofa2Buff;			//爆发点2 Buff列表

	public int StartTx;			//起始 特效列表 给角色自己家的
	public int GexinTx;			//个性化 特效列表  炮弹爆炸什么的

	public string PlayMusic;		//使用技能时播放音乐

	//public List<int> StartTxlist;
	//public List<int> GexinTxlist;

	//public string Baofa1Tx;			//爆发点1 特效列表
	//public string Baofa2Tx;			//爆发点2 特效列表

    public List<CreateAmmoInfo_> baofaammo1list; //= new List<CreateAmmoInfo_> ();
    public List<CreateAmmoInfo_> baofaammo2list;
    public List<int> baofabuff1list; //= new List<CreateAmmoInfo_> ();
    public List<int> baofabuff2list;

	public string SkillAtlasName; //技能图标
	public string SkillSpriteName;

	public int skilltipid;		//0 没有  1 2 3  小 中 大

}

public struct CreateAmmoInfo_
{
	public int ammodbid;	//创建弹药DBID
	public int num;			//创建数量
}
public struct CreateBuffInfo_
{
    public int ammodbid;	//创建弹药DBID
    public int num;			//创建数量
}
public class skillbase  {


	public testdybroleai myrole;
	public float SkillCD = 2f;
	public float useSkillCD = 0f;
	
	//public float SkillTime = 1.2f;
	public float useSkillTime = 0f;
	
	//public float Baofa1Time = 0.8f;
	public float useBaofa1Time = 0f;

	//public float Baofa2Time = 0.8f;
	public float useBaofa2Time = 0f;

	public bool Useing = false;

	public bool b_baofa1 = false;
	public bool b_baofa2 = false;
	//public bool m_NeedPlayerChoosePos;

	public testdybroleai m_tarrole;
	public Vector3 m_tarpos;

	public skilldata_ my_inidata;

	//protected List<CreateAmmoInfo_> baofaammo1list; //= new List<CreateAmmoInfo_> ();
	//protected List<CreateAmmoInfo_> baofaammo2list;


	protected List<buffdata_> baofabuff1list_a; //= new List<CreateAmmoInfo_> ();
	protected List<buffdata_> baofabuff2list_a;

	protected int usetoRoleOrPos = 0; //1 对目标使用技能  -1对地点使用技能

	public string SkillTipAtlasName; //技能图标
	public string SkillTipSpriteName;

	public bool CB_SkillDam = false;
	public bool DamToChengbao = true;	//是否对城堡造成伤害

	public bool IsNormalskill = false;
	public void IniSome (testdybroleai thisrole,skilldata_ thisdata,bool isnormalskill) 
	{
		IsNormalskill = isnormalskill;
		BaseIniSome ( thisrole, thisdata) ;
		SonIniSome ();
	}
	public void BaseIniSome (testdybroleai thisrole,skilldata_ thisdata) 
	{
		myrole = thisrole;
		b_baofa1 = false;
		b_baofa2 = false;
		//m_NeedPlayerChoosePos = thisdata.NeedPlayerChoosePos;
		my_inidata = thisdata;
		SkillCD = my_inidata.SkillCD;
        useSkillCD = 0f;
	    useSkillTime = 0f;
	    useBaofa1Time = 0f;
	    useBaofa2Time = 0f;
        AnalyzeBuffCfg();
		if (thisdata.skilltipid == 0) {
			SkillTipAtlasName="";
			//SkillTipSpriteName="";
			
		} else {
			int id = (thisdata.skilltipid-1);
			SkillTipAtlasName=lgCfgMag.Ins.SkillTipStr[id];
			//SkillTipSpriteName=lgCfgMag.Ins.SkillTipStr[id+1];
		}
	}
	virtual public void SonIniSome () 
	{

	}

	public float C_BuffDam(int lvl ,int qulitylvl,float basepopnum ,string LvlModify,string SpellModify)
	{
		float result = 0f;
		//int lvl = myrole.lvl;
		//int qulitylvl = myrole.qulitylvl;
		//public int PropertyId; // 修正属性
		//public string LvlModify;	//属性修正值
		//public string SpellModify; //技能修正值
		string[] tempstr1 =  LvlModify.Split(',');
		string[] tempstr2 =  SpellModify.Split(',');

		float tempLvl_f1 = float.Parse (tempstr1 [0]);
		float tempLvl_f2 = float.Parse (tempstr1 [1]);
		float tempLvl_f3 = float.Parse (tempstr1 [2]);
		float tempLvl_f4 = float.Parse (tempstr1 [3]);

		float tempspell_f1 = float.Parse (tempstr2 [0]);
		float tempspell_f2 = float.Parse (tempstr2 [1]);
		float tempspell_f3 = float.Parse (tempstr2 [2]);
		float tempspell_f4 = float.Parse (tempstr2 [3]);

		//float basepopnum = myrole.MyPop.GetNowPop (PropertyId);
		result = basepopnum * (tempspell_f1 + qulitylvl * tempspell_f2 + tempspell_f3 + tempspell_f4 * lvl) / 100;
		result = result + tempLvl_f1 + qulitylvl * tempLvl_f2 + tempLvl_f3 + tempLvl_f4 * lvl;
		return result;
	}


	//分析buff 将直接伤害记录下来
	public void AnalyzeBuffCfg()
	{
        //int lvl = myrole.lvl;
       // int qulity = myrole.qulity;

       
      
        if (my_inidata.baofabuff1list!=null)
        {
            if (baofabuff1list_a==null)
            {
                baofabuff1list_a = new List<buffdata_>();
            }
            baofabuff1list_a.Clear();
		    for(int i=0;i<my_inidata.baofabuff1list.Count;i++)
            {
                //得到buff配置
                buffdata_ thisbuff = lgCfgMag.Ins.Get_BuffData( my_inidata.baofabuff1list[i]);
                buffdata_ newbuffdata =new buffdata_();
                newbuffdata.type = thisbuff.type;
                //newbuffdata.useDam = thisbuff.useDam; //根据等级品质来计算
                //if (thisbuff.type != bufftype_.bfDamage)
                //{
                newbuffdata.DoTimeSum = thisbuff.DoTimeSum;
                    //newbuffdata.DoTimeType = thisbuff.DoTimeType;
                   // newbuffdata.IntervalTime = thisbuff.IntervalTime;
                //newbuffdata.useDam = thisbuff.useDam;  //根据等级品质来计算
				float basepopnum = myrole.MyPop.GetNowPop (thisbuff.PropertyId);
				newbuffdata.useDam = C_BuffDam(myrole.lvl ,myrole.qulitylvl,basepopnum,thisbuff.LvlModify,thisbuff.SpellModify);

               // }
                baofabuff1list_a.Add(newbuffdata);
            }
        }
        if (my_inidata.baofabuff2list!=null)
        {
            if (baofabuff2list_a == null)
            {
                baofabuff2list_a = new List<buffdata_>();
            }
            baofabuff2list_a.Clear();
            for (int i = 0; i < my_inidata.baofabuff2list.Count; i++)
            {
                //得到buff配置
                buffdata_ thisbuff = lgCfgMag.Ins.Get_BuffData(my_inidata.baofabuff2list[i]);
                buffdata_ newbuffdata = new buffdata_();
                newbuffdata.type = thisbuff.type;
                newbuffdata.useDam = thisbuff.useDam; //根据等级品质来计算
               // if (thisbuff.type != bufftype_.bfDamage)
                //{
                    newbuffdata.DoTimeSum = thisbuff.DoTimeSum;
                    //newbuffdata.DoTimeType = thisbuff.DoTimeType;
                    //newbuffdata.IntervalTime = thisbuff.IntervalTime;
                 //   newbuffdata.useDam = thisbuff.useDam;  //根据等级品质来计算
					float basepopnum = myrole.MyPop.GetNowPop (thisbuff.PropertyId);
					newbuffdata.useDam = C_BuffDam(myrole.lvl ,myrole.qulitylvl,basepopnum,thisbuff.LvlModify,thisbuff.SpellModify);


               // }
                baofabuff2list_a.Add(newbuffdata);

            }
        }
	}
	public bool CheckUse()
	{
		return Useing==false&&useSkillCD <= 0f&&SonCheckUse ();
	}
	virtual public bool SonCheckUse () 
	{
		return true;
	}


	//玩家选中当前技能
	public void ChooseSkill()
	{

        if (my_inidata.NeedPlayerChoosePos == true)	//如果需要玩家选择目标点
		{
			//提示目标点
		}
	}
	//取消当前技能
	public void CancleChooseSkill()
	{

        if (my_inidata.NeedPlayerChoosePos == true)	//如果需要玩家选择目标点
		{
			//关闭提示目标点
		}
	}

	public void UseSkill()
	{
		SonUseSkill ();
		//加载给自己的特效
		if(my_inidata.StartTx!=0)
		{
			tModleFactory.Ins.MyTxFactory.GetOneTx(my_inidata.StartTx,Vector3.zero,myrole);
		}
		//播放使用技能声音
		if(my_inidata.PlayMusic!=""&&my_inidata.PlayMusic!="0")
		{
			AudioManager.Instance.Play(my_inidata.PlayMusic, false, 0);  
		}

	}
	public void CreateGexinTx(Vector3 tarpos,List<testdybroleai> rolelist)
	{
		if(my_inidata.GexinTx!=0)
		{
			if(rolelist!=null)
			{
				for(int i=0;i<rolelist.Count;i++)
				{
					tModleFactory.Ins.MyTxFactory.GetOneTx(my_inidata.GexinTx,tarpos,rolelist[i]);
				}
			}
			else
			{
				tModleFactory.Ins.MyTxFactory.GetOneTx(my_inidata.GexinTx,tarpos,null);
			}
		}
	}
	virtual public void SonUseSkill()
	{

	}
	//对目标释放技能
	public void UseSkillToRole(testdybroleai tarrole)
	{

		if (useSkillCD <= 0f && Useing == false||myrole.StopMelfAi==true) {
			m_tarrole = tarrole;
			
			useSkillTime = 0f;
			Useing = true;
			b_baofa1 = false;
			b_baofa2 = false;
			usetoRoleOrPos = 1;
			//myrole.PlayAnim("attack");
			SonUseSkillToRole (tarrole);
		} else {
			Debug.Log(useSkillCD);
		}

		
		
	}
	virtual public void SonUseSkillToRole(testdybroleai tarrole)
	{
	}
	//对目标点释放技能
	public void UseSkillToPos(Vector3 tarpos)
	{

		if(useSkillCD <= 0f&&Useing==false||myrole.StopMelfAi==true)
		{
			
			m_tarpos = tarpos;
			useSkillTime = 0f;
			Useing = true;
			b_baofa1 = false;
			b_baofa2 = false;
			//myrole.PlayAnim("attack");
            usetoRoleOrPos = -1;
            SonUseSkillToPos (tarpos);
		}


	}
	virtual public void SonUseSkillToPos(Vector3 tarpos)
	{
	}
	public void update(float dt)
	{
		if(useSkillCD>0f)
		{
			useSkillCD-=dt;
		}
		if(Useing == true)
		{
			if(b_baofa1 == false)
			{
				useBaofa1Time+=dt;
                if (useBaofa1Time >= my_inidata.Baofa1Time)
				{
					skillBaofa1();
				}

			}
            if (my_inidata.Baofa2Time > 0 && b_baofa2 == false)
			{
				useBaofa2Time+=dt;
                if (useBaofa2Time >= my_inidata.Baofa2Time)
				{
					skillBaofa2();
				}
				
			}
			useSkillTime+=dt;
            if (useSkillTime >= my_inidata.SkillTime)
			{
				skillFinish();
			}
			
		}
	}
	public void skillBaofa1()
	{
		b_baofa1 = true;
		//对目标造成伤害计算
		//if(myrole.b_nowattroledie==false)
		//{
		//	myrole.nowattrole.DoBuff(myrole.att);
		//}

		//创建弹药

		//创建特效

		//创建buff

		SonskillBaofa1 ();
	}
	virtual public void SonskillBaofa1()
	{

	}

	public void skillBaofa2()
	{
		b_baofa2 = true;
		//对目标造成伤害计算
		//if(myrole.b_nowattroledie==false)
		//{
		//	myrole.nowattrole.DoBuff(myrole.att);
		//}
		//创建弹药
		
		//创建特效
		
		//创建buff
		SonskillBaofa2 ();
	}
	virtual public void SonskillBaofa2()
	{
		
	}

	//创建爆发1弹药
	public void CreateBaofa1Ammo()
	{
		if (my_inidata.baofaammo1list!=null)
        {

			Vector3 inipos = myrole.GetRoleAmmoSendPos(); //GetRolePos
            Vector3 tarpos ;
            if( usetoRoleOrPos ==1)
            {
                tarpos = m_tarrole.GetRolePos();
				for (int i = 0; i < my_inidata.baofaammo1list.Count;i++ )
				{
					tModleFactory.Ins.MyammoFactory.GetOneAmmo(my_inidata.baofaammo1list[i].ammodbid, this, inipos, tarpos,m_tarrole);
				}
			}
			else
            {
                tarpos = m_tarpos;
				for (int i = 0; i < my_inidata.baofaammo1list.Count;i++ )
				{
					tModleFactory.Ins.MyammoFactory.GetOneAmmo(my_inidata.baofaammo1list[i].ammodbid, this, inipos, tarpos,null);
				}
			}
			
		}
	}
	//创建爆发2弹药
	public void CreateBaofa2Ammo()
	{
		if (my_inidata.baofaammo2list != null)
        {

			Vector3 inipos = myrole.GetRoleAmmoSendPos(); //GetRolePos
			Vector3 tarpos;
            if (usetoRoleOrPos == 1)
            {
                tarpos = m_tarrole.GetRolePos();
				for (int i = 0; i < my_inidata.baofaammo1list.Count;i++ )
				{
					tModleFactory.Ins.MyammoFactory.GetOneAmmo(my_inidata.baofaammo1list[i].ammodbid, this, inipos, tarpos,m_tarrole);
				}
            }
            else
            {
                tarpos = m_tarpos;
				for (int i = 0; i < my_inidata.baofaammo1list.Count;i++ )
				{
					tModleFactory.Ins.MyammoFactory.GetOneAmmo(my_inidata.baofaammo1list[i].ammodbid, this, inipos, tarpos,null);
				}
            }

        }
	}

	public void CreateLuodianAmmo(Vector3 usetarpos ,float addh)
	{
		if (my_inidata.baofaammo1list!=null)
		{
			
			Vector3 inipos = usetarpos;
			inipos.y =inipos.y+addh;
			Vector3 tarpos =usetarpos;

			tarpos = m_tarpos;
			for (int i = 0; i < my_inidata.baofaammo1list.Count;i++ )
			{
				tModleFactory.Ins.MyammoFactory.GetOneAmmo(my_inidata.baofaammo1list[i].ammodbid, this, inipos, tarpos,null);
			}

			
		}
	}

    public List<testdybroleai> tarlist = new List<testdybroleai>();
    //创建爆发1buff
	public int CreateBaofa1buff(testdybroleai tar)
	{
		bool hasdam = false;
		int result = 0;
        tarlist.Clear();
        tarlist.Add(tar);
        for (int i = 0; i < baofabuff1list_a.Count;i++ )
        {
            if (baofabuff1list_a[i].type == bufftype_.bfDamage)
            {
				hasdam = true;
				if(!(DamToChengbao==false&&tar.roletype== roletype_.typechengbao))
				{
					result = tar.BeDam((int)(baofabuff1list_a[i].useDam),myrole.MyDepart);
				}

            }
            else  //创建buff 放入场景buff管理器
            {
               buffbase thisbuff =  myrole.CreateOnebuff();
               //thisbuff.IniSome(baofabuff1list_a[i].type, baofabuff1list_a[i].DoTimeType, baofabuff1list_a[i].DoTimeSum, baofabuff1list_a[i].IntervalTime, baofabuff1list_a[i].useDam, this, tarlist);
				thisbuff.IniSome(baofabuff1list_a[i].type, baofabuff1list_a[i].DoTimeSum,  baofabuff1list_a[i].useDam, this, tarlist);

			}
		}
		if(hasdam = true)
		{
			if(CB_SkillDam ==true)
			{
				myrole.SkillDamCB(result,m_tarpos);
			}

			return result;
		}
		return -1;
	}
	//创建爆发1buff
	public int CreateBaofa1buff_2(List<testdybroleai> tar)
	{
		bool hasdam = false;
		int result = 0;
       // tarlist.Clear();
        //tarlist.Add(tar);
        for (int i = 0; i < baofabuff1list_a.Count; i++)
        {
            if (baofabuff1list_a[i].type == bufftype_.bfDamage)
            {
				hasdam = true;

				for (int k = 0; k < tar.Count; k++)
                {
					if(!(DamToChengbao==false&&tar[k].roletype== roletype_.typechengbao))
					{
						result = result + tar[k].BeDam((int)(baofabuff1list_a[i].useDam),myrole.MyDepart);
					}
                 }
            }
            else  //创建buff 放入场景buff管理器
            {
                buffbase thisbuff = myrole.CreateOnebuff();
                //thisbuff.IniSome(baofabuff1list_a[i].type, baofabuff1list_a[i].DoTimeType, baofabuff1list_a[i].DoTimeSum, baofabuff1list_a[i].IntervalTime, baofabuff1list_a[i].useDam, this, tar);
				thisbuff.IniSome(baofabuff1list_a[i].type,  baofabuff1list_a[i].DoTimeSum,  baofabuff1list_a[i].useDam, this, tar);

			}
		}
		if(hasdam = true)
		{
			if(CB_SkillDam ==true)
			{
				myrole.SkillDamCB(result,m_tarpos);
			}
			return result;
		}
		return -1;
	}
	//创建爆发2buff
	public int CreateBaofa2buff(testdybroleai tar)
	{
		bool hasdam = false;
		int result = 0;

        tarlist.Clear();
        tarlist.Add(tar);
        for (int i = 0; i < baofabuff2list_a.Count; i++)
        {
            if (baofabuff2list_a[i].type == bufftype_.bfDamage)
            {
				hasdam = true;
				if(!(DamToChengbao==false&&tar.roletype== roletype_.typechengbao))
				{
					result = tar.BeDam((int)(baofabuff2list_a[i].useDam),myrole.MyDepart);
				}
            }
            else  //创建buff 放入场景buff管理器
            {
                buffbase thisbuff = myrole.CreateOnebuff();
                //thisbuff.IniSome(baofabuff2list_a[i].type, baofabuff2list_a[i].DoTimeType, baofabuff2list_a[i].DoTimeSum, baofabuff2list_a[i].IntervalTime, baofabuff2list_a[i].useDam, this, tarlist);
				thisbuff.IniSome(baofabuff2list_a[i].type,  baofabuff2list_a[i].DoTimeSum,  baofabuff2list_a[i].useDam, this, tarlist);

			}
		}
		if(hasdam = true)
		{
			if(CB_SkillDam ==true)
			{
				myrole.SkillDamCB(result,m_tarpos);
			}
			return result;
		}
		return -1;
	}
	//创建爆发2buff
	public int CreateBaofa2buff_2(List<testdybroleai> tar)
	{
		bool hasdam = false;
		int result = 0;
        for (int i = 0; i < baofabuff2list_a.Count; i++)
        {
            if (baofabuff2list_a[i].type == bufftype_.bfDamage)
            {
				hasdam = true;
				for (int k = 0; k < tar.Count; k++)
                {
					if(!(DamToChengbao==false&&tar[k].roletype== roletype_.typechengbao))
					{
						result = result+tar[k].BeDam((int)(baofabuff2list_a[i].useDam),myrole.MyDepart);
					}
                }
            }
            else  //创建buff 放入场景buff管理器
            {
                buffbase thisbuff = myrole.CreateOnebuff();
				//thisbuff.IniSome(baofabuff2list_a[i].type, baofabuff2list_a[i].DoTimeType, baofabuff2list_a[i].DoTimeSum, baofabuff2list_a[i].IntervalTime, baofabuff2list_a[i].useDam, this, tar);

				thisbuff.IniSome(baofabuff2list_a[i].type,  baofabuff2list_a[i].DoTimeSum,  baofabuff2list_a[i].useDam, this, tar);
            }
        }
		if(hasdam = true)
		{
			if(CB_SkillDam ==true)
			{
				myrole.SkillDamCB(result,m_tarpos);
			}
			return result;
		}
		return -1;
	}
	//弹药飞行结束 回调
	public void ammoFlyFinCB(testdybroleai tar,Vector3 luodipos)
	{

		SonammoFlyFinCB (tar,luodipos);
	}
	virtual public void SonammoFlyFinCB(testdybroleai tar,Vector3 luodipos)
	{
		
	}
	public void skillFinish()
	{
		Useing = false;
        usetoRoleOrPos = 0;
		m_tarpos = Vector3.zero;
		m_tarrole = null;

        useSkillCD = SkillCD;
		SonskillFinish ();

		myrole.UseSkillFinish (IsNormalskill);
	}
	virtual public void SonskillFinish()
	{
		
	}
	public void Exit()
	{
        Useing = false;
        usetoRoleOrPos = 0;
        m_tarpos = Vector3.zero;
        m_tarrole = null;

        useSkillCD = SkillCD;
		SonExit ();
	}
	virtual public void SonExit()
	{
		
	}
    //计算落点范围内敌人
    public List<testdybroleai> Luodianfanwei(int checkcamp,Vector3 tar,int x,int z)
    {
       // List<testdybroleai> result=null;
		int posx =(int) (tar.x/  myrole.Mymapmag.u_mapcell);
		int posz =(int) (tar.z/  myrole.Mymapmag.u_mapcell);

		return myrole.Mymapmag.GetRolesInArea(checkcamp, posx + x, posx - x, posz + z, posz-z);
    }

	public List<testdybroleai> GetfanweiRole(int checkcamp,int x1,int x2 ,int z1,int z2)
	{
		return myrole.Mymapmag.GetRolesInArea(checkcamp, x1, x2, z1, z2);
	}

	public void SetSkillCD(float cd)
	{
		SkillCD = cd;//my_inidata.SkillCD * (1 - add);
		if(useSkillCD>SkillCD)
		{
			useSkillCD=SkillCD;
		}
	}
	public void GetSkillTipInfo(ref string at)//,ref string sp)
	{
		//Debug.LogError ("my_inidata DBid = "+my_inidata.DBid+" SkillTipAtlasName="+SkillTipAtlasName);
		at = SkillTipAtlasName;
		//sp = SkillTipSpriteName;
	}
}
