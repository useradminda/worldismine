using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
using LitJson;
using Mono.Data.Sqlite;
//配置管理
public class lgCfgMag  {

    private static lgCfgMag _ins = null;

    public static lgCfgMag Ins
    {
        get
        {
            if (_ins == null)
            {
                _ins = new lgCfgMag();
                //_ins.IniSome();
            }
            return _ins;
        }
    }

	/*
	typedun = 1,	//盾兵
	typechui =2,//锤兵
	typetengjia =3,//藤甲兵
	typexueren =4,//雪人
	typelianche =5,//碾车
	typegong =6,//弓兵
	typepao =7,//炮兵
	typelu =8,//弩兵
	typeluche =9,//弩车
	typetoushiche =10,//投石车
	typeqiangchui =11,//锤兵
	typejiugui =12,//酒鬼
	typeqiang =13,//枪兵
	typeqi =14,//骑兵
	typeyeren =15,//野人
	typeshengshou =98,//神兽
	typeyinxiong =99,//英雄
	typechengbao =100,//城堡
	*/
	public string Attprioritystr;// = "1:1,2;2:1,2;3:1,2;4:1,3;5:1,4;6:1,6;7:1,4;8:1,8;9:2,1;10:1,6;11:5,1;12:1,7;13:1,1;14:1,1;15:1,1;98:1,1;99:1,1;100:1,1";
	public string RoleCellCfgstr;// = "1:1,1;2:2,2;3:2,2;4:3,2;5:4,2;6:1,1;7:2,2;8:2,2;9:3,2;10:4,2;11:1,1;12:2,2;13:2,2;14:3,2;15:4,2;98:2,2;99:3,3;100:2,25";

    //攻击优先级列表
    public Dictionary<roletype_, List<roletype_>> attpriority = new Dictionary<roletype_, List<roletype_>>();
    //角色占用格子数  策划配置的  
    public Dictionary<roletype_, tPoint_> RoleCellCfg = new Dictionary<roletype_, tPoint_>();

	public string DepartAddDamStr;// = "1:0,0.1,-0.1,0;2:-0.1,0,0.1,0;3:0.1,-0.1,0,0;4:0.1,-0.1,0.1,0";

	public float[,]DepartAddDam = new float[4,4];

	public int Herobinlin = 20;						//英雄兵力
	string SoldierBinlinStr="";
	public int[] SoldierBinlin = {8,4,2,2};				//小兵兵力
	public int[] CreateRoleNum = {8,4,2,2};			//x 轴占用格子 对应战阵生成角色数量  占用1格 生成8个角色 一次类推
	string SkillRangeStr ;
	public string[] SkillTipStr ;//= {"","","","","",""};  //改成3D模型了 //技能提示用图片的 AtlasName , SpriteName


	public List<talkinfo_> TalkInfoList = new  List<talkinfo_>();
	public List<talkinfo_> DieTalkInfoList = new  List<talkinfo_>();
	public lgRoleAnimaKu MyRoleAnimaKu;
	public Dictionary<string ,int> RoleAnimaInfo = new Dictionary<string, int>();

	public Dictionary<int ,Vector2> AmmoSendPosAddInfo = new Dictionary<int, Vector2>();

    //加载各种配置
    public void IniSome()
    {

        //加载测试数据
        testdata mytestdata = new testdata();
        mytestdata.IniSome();

        //end
		LoadRoleInfoConfig ();
		//LoadTalkInfoConfig ();
		ReadTalkInfoDB ();

		ReadRoleAnimaInfoDB ();

		ReadAmmoSendPosAddInfo ();

        //attpriority 加载攻击优先级
        AnalyzeAttprioritystr(Attprioritystr);

        //RoleCellCfg 加载角色占用格子
        AnalyzeRoleCellCfgstr(RoleCellCfgstr);
		AnalyzeDepartAddDamStr(DepartAddDamStr);
		AnalyzeSoldierBinlinStr (SoldierBinlinStr);
		AnalyzeSkillTipStr (SkillRangeStr);
	
		//Debug.LogError ("lgCfgMag IniSome end");
		//if(MyRoleAnimaKu==null)
		//{
		//	GameObject RoleAnimaRoot =  GameObject.Find ("RoleAnimaRoot");
		//	MyRoleAnimaKu = RoleAnimaRoot.GetComponent<lgRoleAnimaKu>() as lgRoleAnimaKu;
		//}
    }

	void LoadRoleInfoConfig()
	{
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("RoleInfo",-1);
		if(info!=null)
		{
			Attprioritystr = System.Convert.ToString(info["AttackPriority"]);
			RoleCellCfgstr = System.Convert.ToString(info["RoleCellCfg"]);                 	
			DepartAddDamStr = System.Convert.ToString(info["DepartAddDam"]);     
			Herobinlin =System.Convert.ToInt32(info["HeroTroops"]);	             
			SoldierBinlinStr =System.Convert.ToString(info["SoldierTroops"]);
			SkillRangeStr	=System.Convert.ToString(info["Skill_Range"]);
		}
	}

	public void AnalyzeSoldierBinlinStr(string str)
	{
		string[] temp = str.Split (',');
		for(int i=0;i<4;i++)
		{
			SoldierBinlin[i] = int.Parse(temp[i]);
		}
	}
    public void AnalyzeAttprioritystr(string str)
    {
        string[] str1 = str.Split(';');
        for (int i = 0; i < str1.Length; i++)
        {
            tPoint_ temppoint;
            string[] str2 = str1[i].Split(':');
            int keyint = int.Parse(str2[0]);

            roletype_ key = (roletype_)(keyint);
            string[] str3 = str2[1].Split(',');
            List<roletype_> priority = new List<roletype_>();
            for (int k = 0; k < str3.Length; k++)
            {
                int temp = int.Parse(str3[k]);
                priority.Add((roletype_)(temp));
            }

            attpriority.Add(key, priority);
        }
    }
    public bool GetAttpriorityCfg(roletype_ thistype, out List<roletype_> prioritylist)
    {
        return attpriority.TryGetValue(thistype, out prioritylist);
    }
    public void AnalyzeRoleCellCfgstr(string str)
    {
        string[] str1 = str.Split(';');
        for (int i = 0; i < str1.Length; i++)
        {
            tPoint_ temppoint;
            string[] str2 = str1[i].Split(':');
            int keyint = int.Parse(str2[0]);

            roletype_ key = (roletype_)(keyint);
            string[] str3 = str2[1].Split(',');
            temppoint.x = int.Parse(str3[0]);
            temppoint.z = int.Parse(str3[1]);
            RoleCellCfg.Add(key, temppoint);
        }

    }
    public bool GetRoleCellCfg(roletype_ thistype, out tPoint_ temppoint)
    {
        return RoleCellCfg.TryGetValue(thistype, out temppoint);
    }

	public void AnalyzeDepartAddDamStr(string str)
	{
		string[] str1 = str.Split(';');
		for (int i = 0; i < str1.Length; i++)
		{
			tPoint_ temppoint;
			string[] str2 = str1[i].Split(':');
			int keyint = int.Parse(str2[0]);
			string[] str3 = str2[1].Split(',');
			for (int k = 0; k < str3.Length; k++)
			{
				DepartAddDam[keyint-1,k]=float.Parse(str3[k]);
			}
		}
		
	}
	public float GetDepartAddDam(roleDepartment_ att, roleDepartment_ attto)
	{
		return DepartAddDam[(int)att,(int)attto];
	}
	public void AnalyzeSkillTipStr(string str)
	{
		SkillTipStr = str.Split (',');
	}



	public Dictionary<int, Roledata_> RoledataCfg = new Dictionary<int, Roledata_>();
	public Dictionary<int, skilldata_> SkilldataCfg = new Dictionary<int,skilldata_>();

    public void Set_RoleData(int roledbid, Roledata_ thisdata)
    {
        if (RoledataCfg.ContainsKey(roledbid) == false)
        {
            RoledataCfg.Add(roledbid, thisdata);
        }

    }
    public void Set_SkillData(int skilldbid,skilldata_ thisdata)
    {
        if (SkilldataCfg.ContainsKey(skilldbid) == false)
        {

            //解析弹药 
            AnalyzeAmmoCfg(ref thisdata);
            //解析特效

            //解析buff
            AnalyzeBuffCfg(ref thisdata);


            SkilldataCfg.Add(skilldbid, thisdata);
        }

    }



	public Roledata_ Get_RoleData(int roledbid)
    {
        //Roledata_ thisdata;
        //RoledataCfg.TryGetValue(roledbid, out thisdata);
        //return thisdata;
	
		Roledata_ result;
		if(RoledataCfg.TryGetValue(roledbid,out result)==true)
		{
			return result;
		}
		
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("RoleData",roledbid);
		if(info!=null)
		{
			result = new Roledata_();
			result.DBid = System.Convert.ToInt32(info["Id"]);// ID    
			result.name = System.Convert.ToString(info["Name"]);      //    名字             	
			result.prefabname = System.Convert.ToString(info["FbxName"]);      //    模型名字  	
			result.skillDBid =System.Convert.ToInt32(info["Spell_Id"]);// 技能  		             
			result.skillNormalDBid =System.Convert.ToInt32(info["Attack_Id"]);// 普攻技能  

			result.alertrange	=System.Convert.ToInt32(info["WarningRange"]);// 警戒范围
			result.attrange= System.Convert.ToInt32(info["AttackRange"]);// 攻击范围 

			result.roletype = (roletype_)(System.Convert.ToInt32(info["RoleType"])); //人物类型
			result.roleDepart = (roleDepartment_)(System.Convert.ToInt32(info["RoleSeries"])); //人物所属系别

			result.qulity =System.Convert.ToInt32(info["Quality"]);// 品质
			result.nowsitzuoqipname =System.Convert.ToString(info["Mount"]);//默认坐骑  比如工兵什么的

			
			string icon =  System.Convert.ToString(info["Icon"]); //头像
			string[] str = icon.Split(',');
			result.HeadAtlasName=str[0];
			result.HeadSpriteName=str[1];

			result.Description =  System.Convert.ToString(info["Description"]); //介绍
			RoledataCfg.Add(roledbid ,result);
		}
		
		return result;
	}
	Dictionary<string,rolepop_> btrolepoplist = new Dictionary<string, rolepop_>();
	public rolepop_ GetRolePop(int dbid,int lvl,int qulitylvl)
	{
		string key = dbid + "_" + lvl + "_" + qulitylvl;
		rolepop_ result;
		if(btrolepoplist.TryGetValue(key,out result)==true)
		{
			return result;
		}

		LuaTable info =  lgNoDelCsFun.Ins.GetRoleData (dbid,lvl,qulitylvl);
		if(info!=null)
		{
			result = new rolepop_();

			result.Life = System.Convert.ToInt32(info["life"]);// 生命
			result.Attack = System.Convert.ToInt32(info["Attack"]); //攻击	
			result.MoveSpeed= System.Convert.ToSingle(info["MoveSpeed"]);//移动速度
			result.AttackSpeed = System.Convert.ToSingle(info["AttackSpeed"]);//攻击速度
			result.Defense= System.Convert.ToInt32(info["Defence"]);//防御	
			//result.FuwenDepart = roleDepartment_.D_Null;	//所带符文系别
			//result.FuwenDepartAdd = 0f;  //符文减伤值


			btrolepoplist.Add(key ,result);
		}

		return result;
	}
	public Dictionary<string, rolepop_> PvpRolePopList;
	public rolepop_ GetRolePvpPop_ByUUID(string UUID)
	{
		rolepop_ result;
		 PvpRolePopList.TryGetValue (UUID,out result);
		return result;
	}


	public rolepop_ GetRolePop_ByUUID(bttype_ bttype,int camp,string UUID)
	{

		rolepop_ result=new rolepop_();
		LuaTable info =  lgNoDelCsFun.Ins.GetRoleData_ByUUID (bttype,camp,UUID);
		if(info!=null)
		{
			result.Life = System.Convert.ToInt32(info["life"]);// 生命
			result.Attack = System.Convert.ToInt32(info["Attack"]); //攻击	
			result.MoveSpeed= System.Convert.ToSingle(info["MoveSpeed"]);//移动速度
			result.AttackSpeed = System.Convert.ToSingle(info["AttackSpeed"]);//攻击速度
			result.Defense= System.Convert.ToInt32(info["Defence"]);//防御	

			//result.FuwenDepart = roleDepartment_.D_Null;	//所带符文系别
			//result.FuwenDepartAdd = 0f;  //符文减伤值

		}
		
		return result;
	}


    public skilldata_ Get_SkillData(int skilldbid)
    {
       // skilldata_ thisdata;
        //SkilldataCfg.TryGetValue(skilldbid, out thisdata);
       // return thisdata;

		skilldata_ result;
		if(SkilldataCfg.TryGetValue(skilldbid,out result)==true)
		{
			return result;
		}
		
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("Skill",skilldbid);
		if(info!=null)
		{
			result = new skilldata_();

			result.DBid = System.Convert.ToInt32(info["Id"]);
			result.name = System.Convert.ToString(info["Name"]);                 	
			result.SkillCD = System.Convert.ToSingle(info["ColdTime"]); 	
			result.SkillTime =System.Convert.ToSingle(info["SkillTime"]);	             
			result.Baofa1Time =System.Convert.ToSingle(info["Start1_Time"]);
			result.Baofa2Time	=System.Convert.ToSingle(info["Start2_Time"]);

			result.NeedPlayerChoosePos= System.Convert.ToBoolean(info["ChosePos"]);
			
			result.skillCsName = System.Convert.ToString(info["LogicName"]); 
			result.GeXingP = System.Convert.ToString(info["Param"]); 
			
			result.Baofa1Emo =System.Convert.ToString(info["Ammo1_id"]);
			result.Baofa2Emo =System.Convert.ToString(info["Ammo2_id"]);
			
			result.Baofa1Buff =System.Convert.ToString(info["Buff1_id"]);
			result.Baofa2Buff =System.Convert.ToString(info["Buff2_id"]);

			result.StartTx =System.Convert.ToInt32(info["Start1_Effect"]);
			result.GexinTx =System.Convert.ToInt32(info["Start2_Effect"]);
			string icon =  System.Convert.ToString(info["Icon"]); //头像
			string[] str = icon.Split(',');
			result.SkillAtlasName=str[0];
			result.SkillSpriteName=str[1];
			result.skilltipid = System.Convert.ToInt32(info["SkillTipid"]);
			result.PlayMusic = System.Convert.ToString(info["PlayMusic"]);

			//解析弹药 
			AnalyzeAmmoCfg(ref result);
			//解析特效
			
			//解析buff
			AnalyzeBuffCfg(ref result);
			
			SkilldataCfg.Add(skilldbid ,result);
		}
		
		return result;
    }
    public void AnalyzeAmmoCfg( ref skilldata_ thisdata)
    {
		if (thisdata.Baofa1Emo != ""&&thisdata.Baofa1Emo != "0")
		{
            thisdata.baofaammo1list = new List<CreateAmmoInfo_>();

            string[] str1 = thisdata.Baofa1Emo.Split(';');
            for (int i = 0; i < str1.Length; i++)
            {
                CreateAmmoInfo_ ammoinfo;
                string[] str2 = str1[i].Split(',');
                ammoinfo.ammodbid = int.Parse(str2[0]);
                ammoinfo.num = int.Parse(str2[1]);
                thisdata.baofaammo1list.Add(ammoinfo);
            }
        }
		if (thisdata.Baofa2Emo != ""&&thisdata.Baofa2Emo != "0")
		{
            thisdata.baofaammo2list = new List<CreateAmmoInfo_>();

            string[] str1 = thisdata.Baofa2Emo.Split(';');
            for (int i = 0; i < str1.Length; i++)
            {
                CreateAmmoInfo_ ammoinfo;
                string[] str2 = str1[i].Split(',');
                ammoinfo.ammodbid = int.Parse(str2[0]);
                ammoinfo.num = int.Parse(str2[1]);
                thisdata.baofaammo2list.Add(ammoinfo);
            }
        }

    }

    //分析buff 将直接伤害记录下来
    public void AnalyzeBuffCfg(ref skilldata_ thisdata)
    {
		if (thisdata.Baofa1Buff != ""&&thisdata.Baofa1Buff != "0")
		{
            thisdata.baofabuff1list = new List<int>();
            string[] str1 = thisdata.Baofa1Buff.Split(',');
            for (int i = 0; i < str1.Length; i++)
            {
                int dbid = int.Parse(str1[i]);
                thisdata.baofabuff1list.Add(dbid);
            }
        }
		if (thisdata.Baofa2Buff != ""&&thisdata.Baofa2Buff != "0")
		{
            thisdata.baofabuff2list = new List<int>();
            string[] str1 = thisdata.Baofa2Buff.Split(',');
            for (int i = 0; i < str1.Length; i++)
            {
                int dbid = int.Parse(str1[i]);
                thisdata.baofabuff2list.Add(dbid);
            }
        }

    }

    //buff相关
    public Dictionary<int, buffdata_> BuffdataCfg = new Dictionary<int, buffdata_>();
    public void Set_BuffData(int buffdbid, buffdata_ thisbuff)
    {
        if (BuffdataCfg.ContainsKey(buffdbid) == false)
        {
            BuffdataCfg.Add(buffdbid, thisbuff);
        }
    }

    public buffdata_ Get_BuffData(int buffdbid)
    {
       // buffdata_ thisdata;
       // BuffdataCfg.TryGetValue(buffdbid, out thisdata);
       // return thisdata;


		buffdata_ result;
		if(BuffdataCfg.TryGetValue(buffdbid,out result)==true)
		{
			return result;
		}
		
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("Buff",buffdbid);
		if(info!=null)
		{
			result = new buffdata_();
			
			result.DBid = System.Convert.ToInt32(info["Id"]);
			               	
			result.type =(bufftype_) (System.Convert.ToInt32(info["Type"])); 	
			result.DoTimeSum =System.Convert.ToSingle(info["SustainTime"]);	             
			result.useDam =0f;//System.Convert.ToSingle(info["Start1_Time"].ToString());
			result.PropertyId	=System.Convert.ToInt32(info["PropertyId"]);
			result.LvlModify= System.Convert.ToString(info["LvlModify"]);
			result.SpellModify = System.Convert.ToString(info["SpellModify"]); 
			BuffdataCfg.Add(buffdbid ,result);
		}
		
		return result;
    }


    //弹药相关
    public Dictionary<int, ammodata_> AmmodataCfg = new Dictionary<int, ammodata_>();
    public void Set_AmmoData(int ammodbid, ammodata_ thisammo)
    {
        if (AmmodataCfg.ContainsKey(ammodbid) == false)
        {
			thisammo.gexingjiexi = thisammo.gexingp.Split(',');
            AmmodataCfg.Add(ammodbid, thisammo);
        }
    }

    public ammodata_ Get_AmmoData(int ammodbid)
    {
        //ammodata_ thisdata;
       // AmmodataCfg.TryGetValue(ammodbid, out thisdata);
        //return thisdata;

		ammodata_ result;
		if(AmmodataCfg.TryGetValue(ammodbid,out result)==true)
		{
			return result;
		}
		
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("Ammo",ammodbid);
		if(info!=null)
		{
			result = new ammodata_();
			
			result.DBid = System.Convert.ToInt32(info["Id"]);
			
			result.ammoCsName =System.Convert.ToString(info["LogicName"]); 	
			result.pname =System.Convert.ToString(info["PrefabName"]);	             
			result.gexingp =System.Convert.ToString(info["Param"]);
			result.gexingjiexi = result.gexingp.Split(',');
			AmmodataCfg.Add(ammodbid ,result);
		}
		
		return result;
		
	}
	
	//特效相关
	public Dictionary<int, TxData_> TxdataCfg = new Dictionary<int, TxData_>();
	public void Set_TxData(int Txdbid, TxData_ thisTx)
	{
		if (TxdataCfg.ContainsKey(Txdbid) == false)
		{
			//thisammo.gexingjiexi = thisammo.gexingp.Split(',');
			TxdataCfg.Add(Txdbid, thisTx);
		}
	}
	
	public TxData_ Get_TxData(int Txdbid)
	{
		//TxData_ thisdata;
		//TxdataCfg.TryGetValue(Txdbid, out thisdata);
		//return thisdata;

		TxData_ result;
		if(TxdataCfg.TryGetValue(Txdbid,out result)==true)
		{
			return result;
		}
		
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("Tx",Txdbid);
		if(info!=null)
		{
			result = new TxData_();
			
			result.DBid = System.Convert.ToInt32(info["Id"]);
			
			result.type =System.Convert.ToInt32(info["Type"]);
			result.pname =System.Convert.ToString(info["PrefabName"]);	             
			result.mounttype =System.Convert.ToInt32(info["mounttype"]);
			result.mountid = System.Convert.ToInt32(info["mountid"]);
			result.lifetime = System.Convert.ToSingle(info["LifeTime"]);

			TxdataCfg.Add(Txdbid ,result);
		}
		
		return result;

	}

	//人口占用表
	public Dictionary<roletype_,int> thisrenkouzhanyongbiao = new Dictionary<roletype_, int> ();
	public void Set_renkouzhanyong(roletype_ thistype, int va)
	{
		if (thisrenkouzhanyongbiao.ContainsKey(thistype) == false)
		{
			thisrenkouzhanyongbiao.Add(thistype, va);
		}
	}
	
	public int Get_renkouzhanyong(roletype_ thistype)
	{
		int thisdata;
		thisrenkouzhanyongbiao.TryGetValue(thistype, out thisdata);
		return thisdata;
	}

	//副本配置信息
	public Dictionary<int,mapInfo_> thismapinfo =new Dictionary<int, mapInfo_>();
	public void Set_MapInfo(int mapid,mapInfo_ thisinfo)
	{
		if (thismapinfo.ContainsKey(mapid) == false)
		{
			thismapinfo.Add(mapid, thisinfo);
		}
	}
	public mapInfo_ Get_MapInfo(int mapid, bttype_ maptype)
	{
		//mapInfo_ thisdata;
		//thismapinfo.TryGetValue(mapid, out thisdata);
		//return thisdata;

		mapInfo_ result;
		if(thismapinfo.TryGetValue(mapid,out result)==true)
		{
			return result;
		}
		
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("Map",mapid);
		if(info!=null)
		{
			result = new mapInfo_();

			result.mapid = System.Convert.ToInt32(info["Id"]);

			result.BtSceneName =System.Convert.ToString(info["Scene"]);	

			result.Length =System.Convert.ToInt32(info["Map_Length"]);
			result.Wide =System.Convert.ToInt32(info["Map_Wide"]);

			result.Camp1CreateX =System.Convert.ToInt32(info["My_Pos"]);
			result.Camp2CreateX =System.Convert.ToInt32(info["Ememy_Pos"]);

			result.Camp1ChengbaoDbid =System.Convert.ToInt32(info["MyCamp_Id"]);
			result.Camp1ChengbaoPosX =System.Convert.ToInt32(info["MyCamp_PosX"]);
			result.Camp1ChengbaoPosZ =System.Convert.ToInt32(info["MyCamp_PosZ"]);
			result.Camp1ChengbaoHp =System.Convert.ToInt32(info["Camp1ChengbaoHp"]);

			result.Camp2ChengbaoDbid =System.Convert.ToInt32(info["EnemyCamp_Id"]);
			result.Camp2ChengbaoPosX =System.Convert.ToInt32(info["EnemyCamp_PosX"]);
			result.Camp2ChengbaoPosZ =System.Convert.ToInt32(info["EnemyCamp_PosZ"]);
			result.Camp2ChengbaoHp =System.Convert.ToInt32(info["Camp2ChengbaoHp"]);
			result.TipOpenRoleDbid  =System.Convert.ToInt32(info["TipOpenRoleDbid"]);

			result.HpAdd =System.Convert.ToSingle(info["HpAdd"]);
			result.AttAdd  =System.Convert.ToSingle(info["AttAdd"]);

			string Config =System.Convert.ToString( info["Config"]);

			if (maptype == bttype_.fuben)
			{
				result.Wave_Info = JsonMapper.ToObject<List<CreateWaveInfo_>>(Config);	
			}
			else if(maptype==bttype_.bosspvp)
			{
				result.BossPvp_Info =JsonMapper.ToObject<List<pvpzhanzhenginfo>>(Config);	//  C_PvpRoleInfo(Config);//JsonMapper.ToObject<List<pvproleinfo_>>(Config);	
			}
			thismapinfo.Add(mapid ,result);
		}
		
		return result;

	}


	public PlayInfo_ GetMyPlayInfo()
	{
		PlayInfo_ result = new PlayInfo_ ();
		result.HeroList = new List<FightRoleInfo_> ();
		result.SoldierList = new List<FightRoleInfo_> ();

		LuaTable heroinfo = lgNoDelCsFun.Ins.GetHeros ();
		IEnumerator<LuaTable.TablePair> temp = heroinfo.GetEnumerator ();
		LuaTable.TablePair tempTablePair;
		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			FightRoleInfo_ Fightroleinfo = new FightRoleInfo_();
			Fightroleinfo.Dbid = System.Convert.ToInt32(roleinfo["Dbid"]);
			Fightroleinfo.Lvl = System.Convert.ToInt32(roleinfo["lvl"]);
			Fightroleinfo.QualityLvl = System.Convert.ToInt32(roleinfo["qualityLvl"]);
			Fightroleinfo.UUID = System.Convert.ToString(roleinfo["UUID"]);
			Fightroleinfo.nowsitzuoqipname = System.Convert.ToString(roleinfo["nowsitzuoqipname"]);
			result.HeroList.Add(Fightroleinfo);

		}

		heroinfo = lgNoDelCsFun.Ins.GetSoliders ();
		temp = heroinfo.GetEnumerator ();

		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			FightRoleInfo_ Fightroleinfo = new FightRoleInfo_();
			Fightroleinfo.Dbid = System.Convert.ToInt32(roleinfo["Dbid"]);
			Fightroleinfo.Lvl = System.Convert.ToInt32(roleinfo["lvl"]);
			Fightroleinfo.QualityLvl = System.Convert.ToInt32(roleinfo["qualityLvl"]);
			Fightroleinfo.UUID = System.Convert.ToString(roleinfo["UUID"]);
			Fightroleinfo.nowsitzuoqipname = System.Convert.ToString(roleinfo["nowsitzuoqipname"]);
			result.SoldierList.Add(Fightroleinfo);

		}
		//排序 2个列表 在lua 里面排序好
		LuaTable zhanqiinfo = lgNoDelCsFun.Ins.GetRole1FuWenInfo ();
		
		result.MyFuwenData= ChangeFuwenLuaToUse (zhanqiinfo);


		return result;
	}
	public PvpInfo_ GetPvpTeam()
	{
		PvpInfo_ result = new PvpInfo_ ();
		result.camp1roles = new List<pvpzhanzhenginfo> ();
		//result.camp2roles = new List<pvpzhanzhenginfo> ();
		
		LuaTable heroinfo = lgNoDelCsFun.Ins.GetPvpTeam ();
		IEnumerator<LuaTable.TablePair> temp = heroinfo.GetEnumerator ();
		LuaTable.TablePair tempTablePair;
		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			pvpzhanzhenginfo Fightroleinfo = new pvpzhanzhenginfo();



			Fightroleinfo.HeroDbid = System.Convert.ToInt32(roleinfo["HeroDbid"]);
			Fightroleinfo.Herolvl = System.Convert.ToInt32(roleinfo["Herolvl"]);
			Fightroleinfo.Heroqulitylvl = System.Convert.ToInt32(roleinfo["Heroqulitylvl"]);
			Fightroleinfo.Herouuid = System.Convert.ToString(roleinfo["Herouuid"]);
			Fightroleinfo.Heronowsitzuoqipname = System.Convert.ToString(roleinfo["Heronowsitzuoqipname"]);

			Fightroleinfo.SoldierDbid = System.Convert.ToInt32(roleinfo["SoldierDbid"]);
			Fightroleinfo.Soldierlvl = System.Convert.ToInt32(roleinfo["Soldierlvl"]);
			Fightroleinfo.Soldierqulitylvl = System.Convert.ToInt32(roleinfo["Soldierqulitylvl"]);

			Fightroleinfo.CreatePosX=System.Convert.ToInt32(roleinfo["PosX"]);
			Fightroleinfo.CreatePosZ=System.Convert.ToInt32(roleinfo["PosY"]);


			result.camp1roles.Add(Fightroleinfo);
			
		}
		/*
		heroinfo = lgNoDelCsFun.Ins.GetSoliders ();
		temp = heroinfo.GetEnumerator ();
		
		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			pvproleinfo_ Fightroleinfo = new pvproleinfo_();

			Fightroleinfo.RoleDbid = System.Convert.ToInt32(roleinfo["RoleDbid"]);
			Fightroleinfo.lvl = System.Convert.ToInt32(roleinfo["Lvl"]);
			Fightroleinfo.qulitylvl = System.Convert.ToInt32(roleinfo["QualityLvl"]);
			Fightroleinfo.uuid = System.Convert.ToString(roleinfo["UUID"]);
			Fightroleinfo.nowsitzuoqipname = System.Convert.ToString(roleinfo["Nowsitzuoqipname"]);
			Fightroleinfo.CreatePos.x=System.Convert.ToInt32(roleinfo["PosX"]);
			Fightroleinfo.CreatePos.z=System.Convert.ToInt32(roleinfo["PosY"]);
			
			result.camp2roles.Add(Fightroleinfo);
			
		}
		*/
		//排序 2个列表 在lua 里面排序好
		
		return result;

	}

	public PvpInfo_ GetBossPvpInfo()
	{
		PvpInfo_ result = new PvpInfo_ ();
		result.camp1roles = new List<pvpzhanzhenginfo> ();
		//result.camp2roles = new List<pvproleinfo_> ();
		
		LuaTable heroinfo = lgNoDelCsFun.Ins.GetPvpTeam ();
		IEnumerator<LuaTable.TablePair> temp = heroinfo.GetEnumerator ();
		LuaTable.TablePair tempTablePair;
		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			pvpzhanzhenginfo Fightroleinfo = new pvpzhanzhenginfo();

			Fightroleinfo.HeroDbid = System.Convert.ToInt32(roleinfo["HeroDbid"]);
			Fightroleinfo.Herolvl = System.Convert.ToInt32(roleinfo["Herolvl"]);
			Fightroleinfo.Heroqulitylvl = System.Convert.ToInt32(roleinfo["Heroqulitylvl"]);
			Fightroleinfo.Herouuid = System.Convert.ToString(roleinfo["Herouuid"]);
			Fightroleinfo.Heronowsitzuoqipname = System.Convert.ToString(roleinfo["Heronowsitzuoqipname"]);
			
			Fightroleinfo.SoldierDbid = System.Convert.ToInt32(roleinfo["SoldierDbid"]);
			Fightroleinfo.Soldierlvl = System.Convert.ToInt32(roleinfo["Soldierlvl"]);
			Fightroleinfo.Soldierqulitylvl = System.Convert.ToInt32(roleinfo["Soldierqulitylvl"]);
			
			Fightroleinfo.CreatePosX=System.Convert.ToInt32(roleinfo["PosX"]);
			Fightroleinfo.CreatePosZ=System.Convert.ToInt32(roleinfo["PosY"]);
			Fightroleinfo.HeroHp=-1;//System.Convert.ToInt32(roleinfo["HeroHp"]);
			Fightroleinfo.SoldierNum=-1;//System.Convert.ToInt32(roleinfo["SoldierNum"]);
			if(Fightroleinfo.SoldierNum>0)
			{
				//Fightroleinfo.SoldierHpList = new int[Fightroleinfo.SoldierNum];
				Fightroleinfo.SoldierHpList = new List<int>();
				LuaTable SoldierHpList_lua=(LuaTable)roleinfo["SoldierHpList"];
				for(int i=0;i<Fightroleinfo.SoldierNum;i++)
				{
					//Fightroleinfo.SoldierHpList[i] = System.Convert.ToInt32(SoldierHpList_lua[i]);
					Fightroleinfo.SoldierHpList.Add(System.Convert.ToInt32(SoldierHpList_lua[i]));
				}
			}
			result.camp1roles.Add(Fightroleinfo);
			
		}

		LuaTable zhanqiinfo = lgNoDelCsFun.Ins.GetRole1FuWenInfo ();

		result.FuwenData1= ChangeFuwenLuaToUse (zhanqiinfo);
		
		return result;
		
	}
	public FuwenData_ ChangeFuwenLuaToUse(LuaTable zhanqiinfo)
	{
		FuwenData_ FuwenDatainfo = new FuwenData_();
		FuwenDatainfo.AddAttack = System.Convert.ToInt32(zhanqiinfo["AddAttack"])/100f;
		FuwenDatainfo.AddAttack1 = System.Convert.ToInt32(zhanqiinfo["AddAttack1"])/100f;
		FuwenDatainfo.AddAttack2 = System.Convert.ToInt32(zhanqiinfo["AddAttack2"])/100f;
		FuwenDatainfo.AddAttack3 = System.Convert.ToInt32(zhanqiinfo["AddAttack3"])/100f;
		FuwenDatainfo.AddHp = System.Convert.ToInt32(zhanqiinfo["AddHp"])/100f;
		FuwenDatainfo.AddHp1 = System.Convert.ToInt32(zhanqiinfo["AddHp1"])/100f;
		FuwenDatainfo.AddHp2 = System.Convert.ToInt32(zhanqiinfo["AddHp2"])/100f;
		FuwenDatainfo.AddHp3 = System.Convert.ToInt32(zhanqiinfo["AddHp3"])/100f;
		FuwenDatainfo.ReduceDamDepart= (roleDepartment_)(System.Convert.ToInt32(zhanqiinfo["ReduceDamDepart"]));
		FuwenDatainfo.ReduceDamNum=System.Convert.ToInt32(zhanqiinfo["ReduceDamNum"])/100f; //减伤百分比
		return FuwenDatainfo;
	}
	public PvpInfo_ GetTwoRolePvpInfo()
	{
		PvpInfo_ result = new PvpInfo_ ();
		result.camp1roles = new List<pvpzhanzhenginfo> ();
		result.camp2roles = new List<pvpzhanzhenginfo> ();
		
		LuaTable heroinfo = lgNoDelCsFun.Ins.GetPvpTeam ();
		IEnumerator<LuaTable.TablePair> temp = heroinfo.GetEnumerator ();
		LuaTable.TablePair tempTablePair;
		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			pvpzhanzhenginfo Fightroleinfo = new pvpzhanzhenginfo();
			
			Fightroleinfo.HeroDbid = System.Convert.ToInt32(roleinfo["HeroDbid"]);
			Fightroleinfo.Herolvl = System.Convert.ToInt32(roleinfo["Herolvl"]);
			Fightroleinfo.Heroqulitylvl = System.Convert.ToInt32(roleinfo["Heroqulitylvl"]);
			Fightroleinfo.Herouuid = System.Convert.ToString(roleinfo["Herouuid"]);
			Fightroleinfo.Heronowsitzuoqipname = System.Convert.ToString(roleinfo["Heronowsitzuoqipname"]);
			
			Fightroleinfo.SoldierDbid = System.Convert.ToInt32(roleinfo["SoldierDbid"]);
			Fightroleinfo.Soldierlvl = System.Convert.ToInt32(roleinfo["Soldierlvl"]);
			Fightroleinfo.Soldierqulitylvl = System.Convert.ToInt32(roleinfo["Soldierqulitylvl"]);
			
			Fightroleinfo.CreatePosX=System.Convert.ToInt32(roleinfo["PosX"]);
			Fightroleinfo.CreatePosZ=System.Convert.ToInt32(roleinfo["PosY"]);

			Fightroleinfo.HeroHp=System.Convert.ToInt32(roleinfo["HeroHp"]);
			Fightroleinfo.SoldierNum=System.Convert.ToInt32(roleinfo["SoldierNum"]);
			if(Fightroleinfo.SoldierNum>0)
			{
				//Fightroleinfo.SoldierHpList = new int[Fightroleinfo.SoldierNum];
				Fightroleinfo.SoldierHpList = new List<int>();
				LuaTable SoldierHpList_lua=(LuaTable)roleinfo["SoldierHpList"];
				for(int i=0;i<Fightroleinfo.SoldierNum;i++)
				{
					//Fightroleinfo.SoldierHpList[i] = System.Convert.ToInt32(SoldierHpList_lua[i]);
					Fightroleinfo.SoldierHpList.Add(System.Convert.ToInt32(SoldierHpList_lua[i]));
				}
			}
			result.camp1roles.Add(Fightroleinfo);
			
		}
		heroinfo = lgNoDelCsFun.Ins.GetPvpTeam2 ();
		temp = heroinfo.GetEnumerator ();

		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			pvpzhanzhenginfo Fightroleinfo = new pvpzhanzhenginfo();
			
			Fightroleinfo.HeroDbid = System.Convert.ToInt32(roleinfo["HeroDbid"]);
			Fightroleinfo.Herolvl = System.Convert.ToInt32(roleinfo["Herolvl"]);
			Fightroleinfo.Heroqulitylvl = System.Convert.ToInt32(roleinfo["Heroqulitylvl"]);
			Fightroleinfo.Herouuid = System.Convert.ToString(roleinfo["Herouuid"]);
			Fightroleinfo.Heronowsitzuoqipname = System.Convert.ToString(roleinfo["Heronowsitzuoqipname"]);
			
			Fightroleinfo.SoldierDbid = System.Convert.ToInt32(roleinfo["SoldierDbid"]);
			Fightroleinfo.Soldierlvl = System.Convert.ToInt32(roleinfo["Soldierlvl"]);
			Fightroleinfo.Soldierqulitylvl = System.Convert.ToInt32(roleinfo["Soldierqulitylvl"]);
			
			Fightroleinfo.CreatePosX=System.Convert.ToInt32(roleinfo["PosX"]);
			Fightroleinfo.CreatePosZ=System.Convert.ToInt32(roleinfo["PosY"]);

			Fightroleinfo.HeroHp=System.Convert.ToInt32(roleinfo["HeroHp"]);
			Fightroleinfo.SoldierNum=System.Convert.ToInt32(roleinfo["SoldierNum"]);
			if(Fightroleinfo.SoldierNum>0)
			{
				//Fightroleinfo.SoldierHpList = new int[Fightroleinfo.SoldierNum];
				Fightroleinfo.SoldierHpList = new List<int>();
				LuaTable SoldierHpList_lua=(LuaTable)roleinfo["SoldierHpList"];
				for(int i=0;i<Fightroleinfo.SoldierNum;i++)
				{
					//Fightroleinfo.SoldierHpList[i] = System.Convert.ToInt32(SoldierHpList_lua[i]);
					Fightroleinfo.SoldierHpList.Add(System.Convert.ToInt32(SoldierHpList_lua[i]));
				}
			}

			result.camp2roles.Add(Fightroleinfo);
			
		}

		LuaTable zhanqiinfo = lgNoDelCsFun.Ins.GetRole1FuWenInfo ();
		
		result.FuwenData1= ChangeFuwenLuaToUse (zhanqiinfo);
		zhanqiinfo = lgNoDelCsFun.Ins.GetRole2FuWenInfo ();
		
		result.FuwenData2= ChangeFuwenLuaToUse (zhanqiinfo);

		return result;
		
	}

	public void AddPvpResult(string str)
	{
		pvpresultlist.Add (str);
	}

	public string GetPvpResult()
	{
		if (pvpresultlist.Count>0) {
			pvpresult = pvpresultlist [0];
			pvpresultlist.RemoveAt (0); //snbug 测试时候不删
			return pvpresult;
		} else {
			return "";
		}
	}
	public int GetNeedShowPvpResultNum()
	{
		return pvpresultlist.Count;
	}
	public void ClearPvpResultList()
	{
		pvpresultlist.Clear ();
	}
	//测试pvp临时数据
	public List<pvproleinfo_> camp1roles;
	public List<pvproleinfo_> camp2roles;
	public List<string> pvpresultlist = new List<string> ();	//pvp显示战斗列表
	public string pvpresult;


	public List<pvpzhanzhenginfo> C_PvpRoleInfo(string  str)
	{
		List<pvpzhanzhenginfo> result = new List<pvpzhanzhenginfo> ();
		if(str!="")
		{
			pvpzhanzhenginfo tempinfo;
			string[] temp = str.Split(';');
			for(int i=0;i< temp.Length&&temp[i]!="";i++)
			{
				string[] temp1 = temp[i].Split(',');
				
				tempinfo = new pvpzhanzhenginfo();
				tempinfo.HeroDbid = int.Parse(temp1[0]);
				tempinfo.Herolvl = int.Parse(temp1[1]);
				tempinfo.Heroqulitylvl = int.Parse(temp1[2]);
				tempinfo.Herouuid = temp1[3];
				tempinfo.Heronowsitzuoqipname = temp1[4];
				tempinfo.SoldierDbid = int.Parse(temp1[5]);
				tempinfo.Soldierlvl = int.Parse(temp1[6]);
				tempinfo.Soldierqulitylvl = int.Parse(temp1[7]);
				tempinfo.CreatePosX = int.Parse(temp1[8]);
				tempinfo.CreatePosZ = int.Parse(temp1[9]);
				tempinfo.HeroHp = int.Parse(temp1[10]);
				tempinfo.SoldierNum = int.Parse(temp1[11]);
				if(tempinfo.SoldierNum>0)
				{
					tempinfo.SoldierHpList = new List<int>();
					for(int ii=0,k=12;ii<tempinfo.SoldierNum;ii++,k++)
					{
						tempinfo.SoldierHpList.Add(int.Parse(temp1[k]));
					}
				}

				result.Add(tempinfo);
			}
		}
		return result;
		
	}


	void LoadTalkInfoConfig()
	{
		LuaTable info =  lgNoDelCsFun.Ins.GetConfigData ("TalkInfo",-1);
		IEnumerator<LuaTable.TablePair> temp = info.GetEnumerator ();
		LuaTable.TablePair tempTablePair;
		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable luainfo =  (LuaTable)(tempTablePair.value);
			talkinfo_ talkinfo = new talkinfo_();

			talkinfo.Dbid = System.Convert.ToInt32(luainfo["Dbid"]);
			talkinfo.Type = System.Convert.ToInt32(luainfo["Type"]);	//1 冲锋 2 死亡
			talkinfo.saywords = System.Convert.ToString(luainfo["saywords"]);
			talkinfo.colour1 = System.Convert.ToString(luainfo["colour1"]);
			talkinfo.colour2 = System.Convert.ToString(luainfo["colour2"]);
			if(talkinfo.Type==1)
			{
				TalkInfoList.Add(talkinfo);
			}
			else if(talkinfo.Type==2)
			{
				DieTalkInfoList.Add(talkinfo);
			}
		}
		//info.Dispose ();
		//tempTablePair = null;
		//temp = null;
		//info = null;
		//Debug.LogError ("LoadTalkInfoConfig end");
	}
	public int GetTalkNum()
	{
		return TalkInfoList.Count;
	}
	public int GetDieTalkNum()
	{
		return DieTalkInfoList.Count;
	}

	//1 冲锋 2 死亡
	public talkinfo_ GetTalkinfo(int type,int id)
	{
		if (type == 1) {
			if (id >= TalkInfoList.Count) {
				Debug.LogError ("Error  GetTalkinfo id=" + id + " TalkInfoList.Count=" + TalkInfoList.Count);
			}
			return TalkInfoList [id];
		} else {

			if (id >= DieTalkInfoList.Count) {
				Debug.LogError ("Error  GetTalkinfo id=" + id + " DieTalkInfoList.Count=" + TalkInfoList.Count);
			}
			return DieTalkInfoList [id];
		}
	}

	public void ReadTalkInfoDB()
	{
		DbAccess theDB = configDB.Ins.theDB;
		SqliteDataReader sqReader = theDB.ReadFullTable("BattleTalk");
				//TalkInfoConfig.Number = 1
		while (sqReader.Read() != false)
		{
					
			talkinfo_ talkinfo = new talkinfo_();
			
			talkinfo.Dbid = sqReader.GetInt32(0);  //ID
			talkinfo.Type = sqReader.GetInt32(1);	//1 冲锋 2 死亡
			talkinfo.saywords = sqReader.GetString(2);//说话内容
			talkinfo.colour1 = sqReader.GetString(3);//说话颜色
			talkinfo.colour2 = sqReader.GetString(4);//边框颜色
			if(talkinfo.Type==1)
			{
				TalkInfoList.Add(talkinfo);
			}
			else if(talkinfo.Type==2)
			{
				DieTalkInfoList.Add(talkinfo);
			}
		
		}

		
	}
	public void ReadRoleAnimaInfoDB()
	{
		DbAccess theDB = configDB.Ins.theDB;
		SqliteDataReader sqReader = theDB.ReadFullTable("Action");
		string name;
		int id;
		while (sqReader.Read() != false)
		{
			name = sqReader.GetString(0);  //角色模型名字
			id = sqReader.GetInt32(1);	//ID

			RoleAnimaInfo.Add(name,id);
		}
	}

	public int GetRoleAnimaId(string name)
	{
		int id = 0;
		RoleAnimaInfo.TryGetValue (name,out id);
		return id;
	}

	public void ReadAmmoSendPosAddInfo()
	{
		DbAccess theDB = configDB.Ins.theDB;
		SqliteDataReader sqReader = theDB.ReadFullTable("ShellParam");

		int id;
		int addx;
		int addy;
		while (sqReader.Read() != false)
		{
			id = sqReader.GetInt32(0);  	//roletype_
			addx = sqReader.GetInt32(1);	//增加的偏移值
			addy = sqReader.GetInt32(2);	//
			Vector2 addpos = new Vector2(addx,addy);
			AmmoSendPosAddInfo.Add(id,addpos);
		}
	}
	public bool GetAmmoSendPosAddInfo(roletype_ thistype, out Vector2 info)
	{
		return	AmmoSendPosAddInfo.TryGetValue ((int)thistype,out info);
	}


}
