using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
//当前战斗类型
public enum bttype_
{
    fuben=1,        //普通副本  
    pvp =2,         //玩家对战 看电影模式
	bosspvp =3,		//boss站

	pvp_jinjichang =4,	//pvp竞技场 对手数据下发 像本地副本一样打
	//CWarpvp =4,		//国战pvp

}

public enum btstate_
{
    snull = 0,        //
    jiazaibt = 1,   //加载场景物件
    pload =2,       //预加载玩家数据等
    eveini =3,      //启动事件系统
    uiini =4,       //初始化界面
    guochang =5,    //过场动画
    waitstart =6,   //等待开始
    fighting =7,    //战斗中
    waitresult = 8, //等待结果
    showresult =9,  //显示结果
    endbt =10,      //结束战斗

	pvpwaitshow =90,//pvp观战等待
}


public struct btdatap_
{
    //public string btmapname;    //使用的地图场景

    //public string btmapcfgname; //地图上物件 配置文件

    public bttype_ maptype;        //当前战斗类型
	public int mapDbid;			//地图信息
	public bool firstblood;		//第一次打本
}

public struct FuwenData_
{

	public float AddAttack;			//全体的

	public float AddAttack1;		//D_Gong =1,	// 弓系
	public float AddAttack2;		//D_Dun =2,	//盾系
	public float AddAttack3;		//D_Qang =3,	//枪系

	public float AddHp;       	//全体的
	public float AddHp1;		//D_Gong =1,	// 弓系
	public float AddHp2;		//D_Dun =2,	//盾系
	public float AddHp3;		//D_Qang =3,	//枪系

	//减伤符文
	public roleDepartment_ ReduceDamDepart ;
	public float ReduceDamNum ; //减伤百分比
	public void SetNull()
	{
		this.AddAttack = 0f;			//全体的
		this.AddAttack1= 0f;		//D_Dun =1,	//盾系
		this.AddAttack2= 0f;		//D_Gong =2,	// 弓系
		this.AddAttack3= 0f;		//D_Qang =3,	//枪系
		
		this.AddHp= 0f;       	//全体的
		this.AddHp1= 0f;		//D_Dun =1,	//盾系
		this.AddHp2= 0f;		//D_Gong =2,	// 弓系
		this.AddHp3= 0f;		//D_Qang =3,	//枪系
		
		//减伤符文
		this.ReduceDamDepart = roleDepartment_.D_Null;
		this.ReduceDamNum = 0f; //减伤百分比
	}
}


public struct PlayInfo_
{
	//还要添加符文信息
	public List<FightRoleInfo_> HeroList ;		//玩家带到副本战斗 英雄列表 (需要排序)
	public List<FightRoleInfo_> SoldierList ;	//玩家带到副本战斗 小兵列表 (需要排序)

	public FuwenData_ MyFuwenData;
}
public struct PvpInfo_
{
	//还要添加符文信息
	public List<pvpzhanzhenginfo> camp1roles;		//pvp 阵营1 角色列表	
	public List<pvpzhanzhenginfo> camp2roles;		//pvp 阵营2 角色列表	
		
	public FuwenData_ FuwenData1;
	public FuwenData_ FuwenData2;

	public btroleinfo_ role1;		//pvp对战2遍角色信息
	public btroleinfo_ role2;

	public int role1attadd;       //阵营1攻击加成  百分比
	public int role1hpadd;        //阵营1血量加成  百分比
	public int role2attadd;       //阵营2攻击加成  百分比
	public int role2hpadd;        //阵营2血量加成  百分比
}

public struct Pvp_RoleList_
{

	public int countryid ;		//国家
	public string name ;	//名字

}

//战斗流程管理类
public class lgbtmag  {

    btdatap_ btp;   //当前战斗参数
    btstate_ btstate;
    bool nextchangeEnter = false;

    public tBtNpcmag MyBtNpcmag = null;

    lgbtTimemag MybtTimemag=null;
	lgCreateRoleMag MyCreateRoleMag =null;

	public int maplength =108;		//地图格子大小  策划配置
	public int maphigh =54;
	public int camp1createposx = 1;			//阵营1角色在第几列生成
	public int camp1createposzmin = 2;			//阵营1角色在第几列生成
	public int camp1createposzmax = 10;			//阵营1角色在第几列生成

	public int camp2createposx = 40;			//阵营2角色在第几列生成
	public int camp2createposzmin = 2;			//阵营2角色在第几列生成
	public int camp2createposzmax = 10;			//阵营2角色在第几列生成

	private static lgbtmag _ins =null ;

	private mapInfo_ MyMapinfo;
	lgSceneLoad MySceneLoad;
	public lgBtUiMag MyBtUiMag;
	int win=0;
	//等待开始
	private float waitstarttime =3f;
	private float usewaitstarttime =0f;

	//显示结果
	float showResultTime =2f;
	float useshowResultTime =0f;

	PlayInfo_ MyPlayInfo;
	public void GetMyPlayInfo()
	{
		//MyPlayInfo;
		MyPlayInfo = lgCfgMag.Ins.GetMyPlayInfo ();
	}
	PvpInfo_ MyPvpInfo;

	public int PvpShowNum = 0;//1 1次观看就结束的  -1 无限等待观看的 直到玩家退出 或者设置为0   -2 下一场战斗数据准备好了
	public void SetPvpShowNum(int num)
	{
		PvpShowNum = num;
	}
	/*
	public void GetMyPvpInfo()
	{
		MyPvpInfo = lgCfgMag.Ins.GetPvpTeam ();
		//MyPvpInfo;
		//MyPvpInfo.camp1roles = lgCfgMag.Ins.camp1roles;
		//MyPvpInfo.camp2roles = lgCfgMag.Ins.camp2roles;
	}
	*/

	public void GetMyBossPvpInfo()
	{
		//MyPvpInfo;
		MyPvpInfo = lgCfgMag.Ins.GetBossPvpInfo ();
		//MyPvpInfo.camp1roles = lgCfgMag.Ins.camp1roles;
		//MyPvpInfo.camp2roles = lgCfgMag.Ins.camp2roles; //snbug
		MyPvpInfo.camp2roles = MyMapinfo.BossPvp_Info;
		MyPvpInfo.FuwenData2.SetNull ();
	}

	public void GetTwoRolePvpInfo()
	{

		MyPvpInfo = lgCfgMag.Ins.GetTwoRolePvpInfo ();

	}
	//public void SetPvpRoleListInfo(List<pvproleinfo_> tempcamp1roles,List<pvproleinfo_> tempcamp2roles)
	//{
	//	camp1roles = tempcamp1roles;
	//	camp2roles = tempcamp2roles;
	//}
	public static lgbtmag Ins
	{
		get
		{
			if (_ins == null)
			{
				_ins =new lgbtmag();
				
			}
			return _ins;
		}
	}
	public float pvpendtime;
	float usepvpendtime;
	public int pvpwincamp;
	public string[] pvpstr;
	public Dictionary<string,string> Rolepvpstr = new Dictionary<string, string> ();


	public void SetPvpInfo(string serverpvpstr)
	{
		string[] tempstr =  serverpvpstr.Split ('!');
		//MyPvpInfo.camp1roles = JsonMapper.ToObject<List<pvproleinfo_>>(tempstr[0]);
		//MyPvpInfo.camp2roles = JsonMapper.ToObject<List<pvproleinfo_>>(tempstr[1]);
		//lgCfgMag.Ins.PvpRolePopList = JsonMapper.ToObject<Dictionary<string, rolepop_>>(tempstr[2]);
		MyPvpInfo.camp1roles = lgCfgMag.Ins.C_PvpRoleInfo (tempstr [0]);
		MyPvpInfo.camp2roles = lgCfgMag.Ins.C_PvpRoleInfo (tempstr [1]);

		C_PvpRolePop (tempstr [2]);
		Rolepvpstr.Clear ();
		pvpstr = tempstr[7].Split ('|');
		string[] tempstr2 = pvpstr[0].Split (',');
		pvpendtime = float.Parse (tempstr2[1]);
		pvpwincamp = int.Parse (tempstr2[2]);
		for(int i=1;i<pvpstr.Length;i++)
		{
			string[] temp = pvpstr[i].Split(':');
			Rolepvpstr.Add(temp[0],temp[1]);
		}

		MyPvpInfo.FuwenData1 = C_PvpRoleFuwen(tempstr [3]);
		MyPvpInfo.FuwenData2 = C_PvpRoleFuwen(tempstr [4]);
		//if (tempstr.Length > 6) {
			MyPvpInfo.role1 = C_PvpRoleInfo (tempstr [5]);
			MyPvpInfo.role2 = C_PvpRoleInfo (tempstr [6]);
		//} else {
		//	MyPvpInfo.role1.SetNull();
		//	MyPvpInfo.role2.SetNull();
		//}
		if (tempstr.Length > 8) {
			string addpop = tempstr [8];
			string[] temppop = addpop.Split (',');
			MyPvpInfo.role1attadd = int.Parse (temppop [1]);       //阵营1攻击加成  百分比
			MyPvpInfo.role1hpadd = int.Parse (temppop [0]);        //阵营1血量加成  百分比
			MyPvpInfo.role2attadd = int.Parse (temppop [3]);       //阵营2攻击加成  百分比
			MyPvpInfo.role2hpadd = int.Parse (temppop [2]);        //阵营2血量加成  百分比
		} else {
			MyPvpInfo.role1attadd = 100;       //阵营1攻击加成  百分比
			MyPvpInfo.role1hpadd = 100;        //阵营1血量加成  百分比
			MyPvpInfo.role2attadd = 100;       //阵营2攻击加成  百分比
			MyPvpInfo.role2hpadd = 100;        //阵营2血量加成  百分比
		}

	}
	public FuwenData_ C_PvpRoleFuwen(string str)
	{
		FuwenData_ result = new FuwenData_ ();
		if (str == "0") {
			result.SetNull();
		} else {

			string[] temp = str.Split(',');
			result.AddAttack = float.Parse(temp[0]) ;
			result.AddAttack1 = float.Parse(temp[1]) ;
			result.AddAttack2 = float.Parse(temp[2]) ;
			result.AddAttack3 = float.Parse(temp[3]) ;
			result.AddHp = float.Parse(temp[4]) ;
			result.AddHp1 = float.Parse(temp[5]);
			result.AddHp2 = float.Parse(temp[6]) ;
			result.AddHp3 = float.Parse(temp[7]) ;
			result.ReduceDamDepart = (roleDepartment_)(int.Parse(temp[8]));
			result.ReduceDamNum = float.Parse(temp[9]);
		}
		return result;
	}
	public void C_PvpRolePop(string  str)
	{
		if(lgCfgMag.Ins.PvpRolePopList==null)
		{
			lgCfgMag.Ins.PvpRolePopList = new Dictionary<string, rolepop_>();
		}
		lgCfgMag.Ins.PvpRolePopList.Clear ();

		if(str!="")
		{
			rolepop_ temppop;
			string[] temp = str.Split(';');
			for(int i=0;i< temp.Length&&temp[i]!="";i++)
			{
				string[] temp1 = temp[i].Split(',');
				//string, rolepop_> PvpRolePopList
				string key = temp1[0];
				temppop = new rolepop_();
				temppop.DBid = int.Parse(temp1[1]);
				temppop.Life = int.Parse(temp1[2]);
				temppop.Attack = int.Parse(temp1[3]);
				temppop.MoveSpeed = float.Parse(temp1[4]);
				temppop.AttackSpeed = float.Parse(temp1[5]);
				temppop.Defense = int.Parse(temp1[6]);
				lgCfgMag.Ins.PvpRolePopList.Add(key,temppop);
			}
		}
	}
	public btroleinfo_ C_PvpRoleInfo(string str)
	{
		btroleinfo_ result = new btroleinfo_ ();
		if (str == "0") {
			//result.SetNull();
			Debug.LogError("Error  C_PvpRoleInfo str ="+str);
		} else {

			string[] temp = str.Split(',');
			result.uuid = temp[0] ;
			result.lvl = int.Parse(temp[1]) ;
			result.name = temp[2] ;
			result.vip = int.Parse(temp[3]) ;
			result.country = int.Parse(temp[4]) ;
			result.headid = int.Parse(temp[5]);

		}
		return result;
	}
	//得到pvp角色AI
	public string GetRolePvpInfo(string uuid)
	{
		string result;
		if(Rolepvpstr.TryGetValue(uuid,out result)==true)
		{
			return result;
		}
		return "";
	}

    //初始化战斗
    public void IniSome(btdatap_ thisp)
    {
		//string teststr =  File.ReadAllText (Application.streamingAssetsPath+ "/log4.txt");
		//lgCfgMag.Ins.AddPvpResult (teststr);
		//thisp.maptype =bttype_.pvp;// bttype_.bosspvp;  //snvxv bug



		thisp.firstblood = true;

        btp = thisp;

		win=0;
        if (MybtTimemag==null)
        {
            MybtTimemag = new lgbtTimemag();
        }
        if (MyBtNpcmag == null)
        {
            MyBtNpcmag = new tBtNpcmag();
        }
        MybtTimemag.IniSome();

		if(MyCreateRoleMag==null)
		{
			MyCreateRoleMag =new lgCreateRoleMag();
		}
		if(MySceneLoad==null)
		{
			MySceneLoad=new lgSceneLoad();
		}
		uiquit =false;
		//取副本数据
		MyMapinfo = lgCfgMag.Ins.Get_MapInfo (thisp.mapDbid,thisp.maptype);
		//MyMapinfo.TipOpenRoleDbid = 90041;
		MyBtNpcmag.IniSome (MyMapinfo.Length, MyMapinfo.Wide);
		if (thisp.maptype == bttype_.fuben)
		{
			//取得玩家 英雄 和小兵的数据
			GetMyPlayInfo();
			MyCreateRoleMag.IniSome (MyMapinfo,MyPlayInfo);
		}
		else if(thisp.maptype == bttype_.pvp) //如果pvp 战斗 创建角色
		{
			usepvpendtime = 0f;
			//初始化对战角色ai
			SetPvpInfo(lgCfgMag.Ins.GetPvpResult());
			pvptime = 0f;
			pvpupdatenum =1;
			//GetMyPvpInfo();
			//SetPvpRoleListInfo(lgCfgMag.Ins.camp1roles,lgCfgMag.Ins.camp2roles);
		}
		else if(thisp.maptype == bttype_.bosspvp) //如果pvp 战斗 创建角色
		{
			GetMyBossPvpInfo();
		}
		else if(thisp.maptype == bttype_.pvp_jinjichang) //pvp 竞技场
		{
			GetTwoRolePvpInfo();
		}

        //创建测试数据


		ChangeState(btstate_.jiazaibt); 
		//ChangeState(btstate_.fighting); 
	}
	
	//继续播放下一场国战PVP
	public void ContinueCWar()
	{
		win=0;
		MybtTimemag.IniSome();
		//MyMapinfo = lgCfgMag.Ins.Get_MapInfo (btp.mapDbid,btp.maptype);
		MyBtNpcmag.IniSome (MyMapinfo.Length, MyMapinfo.Wide);
		
		usepvpendtime = 0f;
		//初始化对战角色ai
		SetPvpInfo(lgCfgMag.Ins.GetPvpResult());
		
		ChangeState(btstate_.jiazaibt); 
	}

    public void ChangeState(btstate_ thisstate)
    {
        if (btstate != thisstate)
        {
            nextchangeEnter = true;
            btstate = thisstate;
        }

    }
    public void EnterState()
	{
        switch(btstate)
        {
            //加载场景物件
            case btstate_.jiazaibt :  
				enterjiazaibt();
            break;
                
            //预加载玩家数据等
            case btstate_.pload : 
			enterpload();
            break;
             
            //启动事件系统
            case btstate_.eveini :  
			entereveini();
            break;

            //初始化界面
            case btstate_.uiini :
			enteruiini();
            break;
                
            //过场动画
            case btstate_.guochang : 
			enterguochang();
            break;
               
            //等待开始
            case btstate_.waitstart : 
			enterwaitstart();
            break;
              
            //战斗中
            case btstate_.fighting :
                enterfighting();
            break;
                 
            //等待结果
            case btstate_.waitresult :  
			enterwaitresult();
            break;
            
            //显示结果
            case btstate_.showresult :  
			entershowresult();
            break;

            //结束战斗  
            case btstate_.endbt :  
			enterendbt();
            break;
       
			case btstate_.pvpwaitshow:
			enterpvpWait();
			break;
       
        }
    }
    public void UpdateState(float dt)
    {
		
       // Debug.Log("!!!!!!" + btstate);
        //时间更新
        MybtTimemag.update(dt);
        //事件更新
		if(MyBtUiMag!=null)
		{
			MyBtUiMag.update(dt);
		}
        if(nextchangeEnter == true)
        {
            nextchangeEnter = false;
            EnterState();
            return;
        }


         switch(btstate)
        {
            //加载场景物件
            case btstate_.jiazaibt : 
			updatejiazaibt(dt);
            break;
                
            //预加载玩家数据等
            case btstate_.pload :  
			updatepload(dt);
            break;
             
            //启动事件系统
            case btstate_.eveini :  
			updateeveini(dt);
            break;

                
            //初始化界面
            case btstate_.uiini :  
			updateuiini(dt);
            break;
                
            //过场动画
            case btstate_.guochang :  
			updateguochang(dt);
            break;
               
            //等待开始
            case btstate_.waitstart : 
			updatewaitstart(dt);
            break;
              
            //战斗中
            case btstate_.fighting :  
                 updatefighting(dt);
            break;
                 
            //等待结果
            case btstate_.waitresult :  
			updatewaitresult(dt);
            break;
            
            //显示结果
            case btstate_.showresult : 
			updateshowresult(dt);
            break;

            //结束战斗  
            case btstate_.endbt :  
			updateendbt(dt);
            break;

			case btstate_.pvpwaitshow:
				updatapvpWait(dt);
			break;
         }
    }
	//加载场景物件
	public void enterjiazaibt()
	{
		//加载场景
		MySceneLoad.LoadBtScene (MyMapinfo.BtSceneName);
	}
	public void updatejiazaibt(float dt)
	{
		MySceneLoad.update (dt);
	}
	public GameObject GmCameOBj = null;
	//场景切换完成回调
	public void JiazaiFinish(int type)
	{
		//1 MainToBt  -1 BtToMain
		if(type==1)
		{
			GmCameOBj = GameObject.Find("GmCame");

			if(MyBtUiMag==null)
			{
				tModleFactory.Ins.GetOneObj("BtUIRoot",LoadUICB,true);
			}
			else
			{
				MyBtUiMag.gameObject.SetActive(true);
				MyBtUiMag.IniSome (btp.maptype);
				ChangeState(btstate_.pload); 
			}
		}
		else
		{
			ChangeState(btstate_.snull); 
			//通知主场景 加载完成
			//取消loading界面由主场景做

			lgNoDelCsFun.Ins.QuitBattle();
			
		}

	}

	public void LoadUICB(GameObject uiroot)
	{
		uiroot.SetActive(true);
		MyBtUiMag = uiroot.GetComponent<lgBtUiMag> () as lgBtUiMag;
		MyBtUiMag.IniSome (btp.maptype);
		ChangeState(btstate_.pload); 
	}


	//场景加载 物件加载完成回调
	//public void ChangjingjiazaiCB()
	//{
	//	Exitjiazaibt ();
	//}
	//public void Exitjiazaibt()
	//{
	//	ChangeState(btstate_.pload); 
	//}

	//预加载玩家数据等
	public void enterpload()
	{
		MyBtUiMag.ShowPvpRoleInfo(false);
		MyBtUiMag.ShowPvpRolelist(false);
		if (btp.maptype == bttype_.fuben) {
			//加载 双方城堡


			IniRoleP_ inip = new IniRoleP_ ();//,int num
			inip.camp = 1;
			inip.lvl =1;
			inip.qulitylvl = 0;
			inip.nowsitzuoqipname ="";
			//inip.InBsId = -2;
			inip.UUID = tModleFactory.Ins.GetBtUuid ().ToString ();
			inip.MyRoledata = lgCfgMag.Ins.Get_RoleData (MyMapinfo.Camp1ChengbaoDbid);

			inip.MyInimapPoint.x = MyMapinfo.Camp1ChengbaoPosX;
			inip.MyInimapPoint.z = MyMapinfo.Camp1ChengbaoPosZ;
			inip.IniHp =-1;

			inip.MyFuwenData.SetNull();
			inip.HpAdd = 0f;		//副本血量加成
			inip.AttAdd = 0f;	//副本攻击加成
			testdybroleai chengboa1= lgbtmag.Ins.MyBtNpcmag.CreateRole (inip);
			chengboa1.SetBaseHp(MyMapinfo.Camp1ChengbaoHp);


			IniRoleP_ inip2 = new IniRoleP_ ();//,int num
			inip2.camp = 2;
			inip2.lvl =1;
			inip2.qulitylvl = 0;
			inip2.nowsitzuoqipname ="";
			//inip.InBsId = -2;
			inip2.UUID = tModleFactory.Ins.GetBtUuid ().ToString ();
			inip2.MyRoledata = lgCfgMag.Ins.Get_RoleData (MyMapinfo.Camp2ChengbaoDbid);
			
			//inip2.MyInimapPoint=camp1chubingpos[id];
			inip2.MyInimapPoint.x = MyMapinfo.Camp2ChengbaoPosX;
			inip2.MyInimapPoint.z = MyMapinfo.Camp2ChengbaoPosZ;
			inip2.IniHp =-1;
			inip.MyFuwenData.SetNull();
			inip.HpAdd = 0f;		//副本血量加成
			inip.AttAdd = 0f;	//副本攻击加成
			testdybroleai chengboa2=lgbtmag.Ins.MyBtNpcmag.CreateRole (inip2);
			chengboa2.SetBaseHp(MyMapinfo.Camp2ChengbaoHp);
			//开始创建UI
			MyBtUiMag.IniHp(MyMapinfo.Camp1ChengbaoHp,MyMapinfo.Camp2ChengbaoHp);
			//得到玩家带的英雄
			Roledata_ 	herodata ;
			skilldata_ thisskilldata;

			for(int i =0;i<MyPlayInfo.HeroList.Count;i++)
			{
				HeroInfo thishero=new HeroInfo();
				thishero.DBid = MyPlayInfo.HeroList[i].Dbid;
				thishero.Order = i;
				thishero.lvl = MyPlayInfo.HeroList[i].Lvl;
				herodata = lgCfgMag.Ins.Get_RoleData (thishero.DBid );
				thishero.HeadAtlasName = herodata.HeadAtlasName;
				thishero.HeadSpriteName = herodata.HeadSpriteName;
				thishero.qulity = herodata.qulity;
				thisskilldata = lgCfgMag.Ins.Get_SkillData(herodata.skillDBid);
				
				thishero.SkillAtlasName =thisskilldata.SkillAtlasName;
				thishero.SkillSpriteName=thisskilldata.SkillSpriteName;
				thishero.Name = herodata.name;

				MyBtUiMag.AddOneHero(thishero);

				//同时预加载 模型 技能弹药等

			}

			for(int i =0;i<MyPlayInfo.SoldierList.Count;i++)
			{
				HeroInfo thishero=new HeroInfo();
				thishero.DBid = MyPlayInfo.SoldierList[i].Dbid;
				thishero.Order = i;
				thishero.lvl = MyPlayInfo.SoldierList[i].Lvl;
				herodata = lgCfgMag.Ins.Get_RoleData (thishero.DBid );
				thishero.HeadAtlasName = herodata.HeadAtlasName;
				thishero.HeadSpriteName = herodata.HeadSpriteName;
				thishero.qulity = herodata.qulity;
				//thisskilldata = lgCfgMag.Ins.Get_SkillData(herodata.skillDBid);

				thishero.SkillAtlasName ="";//thisskilldata.SkillAtlasName;
				thishero.SkillSpriteName="";//thisskilldata.SkillSpriteName;
				
				thishero.Name = herodata.name;
				MyBtUiMag.AddOneMonster(thishero);
				
				//同时预加载 模型 技能弹药等

				
			}
			//计算城堡血量

		} else if(btp.maptype == bttype_.pvp) {
			//开始创建UI
			int rolenum =0;
			//计算战力
			int zhanli1sum =0;
			int zhanli2sum =0;
			float role1hpadd =(MyPvpInfo.role1hpadd-100f)/100f;
			float role1attadd =(MyPvpInfo.role1hpadd-100f)/100f;

			float role2hpadd =(MyPvpInfo.role2hpadd-100f)/100f;
			float role2attadd =(MyPvpInfo.role2hpadd-100f)/100f;


			for(int i=0;i<MyPvpInfo.camp1roles.Count;i++)
			{
				//加载一个战阵
				int zhanli=CreateOneZhanzheng(MyPvpInfo.camp1roles[i], 1,ref rolenum,MyPvpInfo.FuwenData1,role1hpadd,role1attadd);
				zhanli1sum =zhanli1sum+zhanli;
			}
			rolenum = 0;
			for (int i = 0; i < MyPvpInfo.camp2roles.Count; i++)
			{
				//加载一个战阵
				int zhanli=CreateOneZhanzheng(MyPvpInfo.camp2roles[i], 2,ref rolenum,MyPvpInfo.FuwenData2,role2hpadd,role2attadd);
				zhanli2sum =zhanli2sum+zhanli;
			}
			MyBtUiMag.IniHp(zhanli1sum,zhanli2sum);

			MyBtUiMag.SetPvpRoleInfo(MyPvpInfo.role1,MyPvpInfo.role2);
			MyBtUiMag.ShowPvpRoleInfo(true);
			if(PvpShowNum==-1)
			{
				MyBtUiMag.Setpvprolelist(pvp_RoleList1,pvp_RoleList2);
				MyBtUiMag.ShowPvpRolelist(true);
			}

		}
		else if(btp.maptype == bttype_.bosspvp||btp.maptype == bttype_.pvp_jinjichang) {
			//开始创建UI
			int rolenum =0;
			int zhanli1sum =0;
			int zhanli2sum =0;
			for(int i=0;i<MyPvpInfo.camp1roles.Count;i++)
			{
				//加载一个战阵
				int zhanli= CreateOneZhanzheng(MyPvpInfo.camp1roles[i], 1,ref rolenum,MyPvpInfo.FuwenData1,0f,0f);
				zhanli1sum =zhanli1sum+zhanli;
			}
			rolenum = 0;
			for (int i = 0; i < MyPvpInfo.camp2roles.Count; i++)
			{
				//加载一个战阵
				int zhanli=CreateOneZhanzheng(MyPvpInfo.camp2roles[i], 2,ref rolenum,MyPvpInfo.FuwenData2,0f,0f);
				zhanli2sum =zhanli2sum+zhanli;
			}
			MyBtUiMag.IniHp(zhanli1sum,zhanli2sum);
		}
		Exitpload ();
	}



	//创建一个战阵角色 int返回战力
	public int CreateOneZhanzheng(pvpzhanzhenginfo zhanzhenginfo, int campid ,ref int rolenum,FuwenData_ MyFuwenData, float rolehpadd, float roleattadd)
	{
		int resultzhanli =0;
		if(zhanzhenginfo.HeroHp==-1||zhanzhenginfo.HeroHp>0)
		{
			IniRoleP_ inip = new IniRoleP_();//,int num
			inip.camp = campid;
			
			inip.UUID = zhanzhenginfo.Herouuid;
			inip.pvpuuid = campid.ToString() + "_" + rolenum;
			inip.lvl = zhanzhenginfo.Herolvl;
			inip.qulitylvl = zhanzhenginfo.Heroqulitylvl;
			inip.MyRoledata = lgCfgMag.Ins.Get_RoleData(zhanzhenginfo.HeroDbid);
			inip.nowsitzuoqipname = zhanzhenginfo.Heronowsitzuoqipname;
			inip.MyInimapPoint = GetZhanzhenHeroPos(zhanzhenginfo.CreatePosX, zhanzhenginfo.CreatePosZ, campid);
			inip.IniHp = zhanzhenginfo.HeroHp;


			inip.MyFuwenData.SetNull();

			if(btp.maptype == bttype_.bosspvp||btp.maptype == bttype_.fuben)
			{
				inip.HpAdd = MyMapinfo.HpAdd;		//副本血量加成
				inip.AttAdd = MyMapinfo.AttAdd;	//副本攻击加成
			}
			else if(btp.maptype == bttype_.pvp)
			{
				inip.HpAdd =rolehpadd;
				inip.AttAdd =roleattadd;
			}
			else
			{
				inip.HpAdd = 0f;		//副本血量加成
				inip.AttAdd = 0f;	//副本攻击加成
			}
			lgbtmag.Ins.MyBtNpcmag.CreateRole(inip);
			resultzhanli = resultzhanli + lgCfgMag.Ins.Herobinlin;
			rolenum++;
		}
		//createrolenum++;
		
		//创建小兵
		if (zhanzhenginfo.SoldierDbid > 0&&zhanzhenginfo.SoldierNum!=0)
		{
			Roledata_ solddata = lgCfgMag.Ins.Get_RoleData(zhanzhenginfo.SoldierDbid);
			tPoint_ temppoint;
			lgCfgMag.Ins.GetRoleCellCfg(solddata.roletype, out temppoint);
			int createnum = lgCfgMag.Ins.CreateRoleNum[temppoint.x - 1];

			resultzhanli = resultzhanli + lgCfgMag.Ins.SoldierBinlin[temppoint.x - 1]*createnum;
			if(zhanzhenginfo.SoldierNum>0)
			{
				createnum = zhanzhenginfo.SoldierNum;
			}
			for (int Soldieri = 0; Soldieri < createnum; Soldieri++)
			{
				IniRoleP_ inip = new IniRoleP_();//,int num
				inip.camp = campid;
				inip.UUID = "";
				inip.pvpuuid = campid.ToString() + "_" + rolenum;
				inip.lvl = zhanzhenginfo.Soldierlvl;
				inip.qulitylvl = zhanzhenginfo.Soldierqulitylvl;
				inip.MyRoledata = solddata;
				inip.nowsitzuoqipname ="";
				inip.MyInimapPoint = GetZhanzhenSoldierPos(zhanzhenginfo.CreatePosX, zhanzhenginfo.CreatePosZ, campid, temppoint.x, Soldieri);
				if(zhanzhenginfo.SoldierNum>0)
				{
					inip.IniHp = zhanzhenginfo.SoldierHpList[Soldieri];
				}
				else
				{
					inip.IniHp = -1;
				}
				if(btp.maptype == bttype_.bosspvp||btp.maptype == bttype_.fuben)
				{
					inip.HpAdd = MyMapinfo.HpAdd;		//副本血量加成
					inip.AttAdd = MyMapinfo.AttAdd;	//副本攻击加成
				}
				else if(btp.maptype == bttype_.pvp)
				{
					inip.HpAdd =rolehpadd;
					inip.AttAdd =roleattadd;
				}
				else
				{
					inip.HpAdd = 0f;		//副本血量加成
					inip.AttAdd = 0f;	//副本攻击加成
				}
				inip.MyFuwenData = MyFuwenData;
				lgbtmag.Ins.MyBtNpcmag.CreateRole(inip);
				rolenum++;
				// createrolenum++;
			}
			
		}
		return resultzhanli;
	}
	//得到战阵英雄位置
	public tPoint_ GetZhanzhenHeroPos(int zhanzhenposx, int zhanzhenposz, int campid)//, int rolesizex =3
	{
		tPoint_ result = new tPoint_();
		result.x = zhanzhenposx + 1;
		result.z = zhanzhenposz - 2;
		if (campid==2)
		{
			result.x = MyMapinfo.Length - result.x - 1; // + 1 - rolesizex+1;
		}
		return result;
	}
	//得到战阵小兵位置
	public tPoint_ GetZhanzhenSoldierPos(int zhanzhenposx, int zhanzhenposz, int campid, int rolesizex,int order)
	{
		tPoint_ result = new tPoint_();
		if (rolesizex==1)
		{
			if (order == 0)
			{
				result.x = zhanzhenposx - 2;
				result.z = zhanzhenposz - 2;
			}
			if (order == 1)
			{
				result.x = zhanzhenposx - 2;
				result.z = zhanzhenposz -1;
			}
			if (order == 2)
			{
				result.x = zhanzhenposx - 2;
				result.z = zhanzhenposz ;
			}
			if (order == 3)
			{
				result.x = zhanzhenposx - 2;
				result.z = zhanzhenposz +1;
			}
			if (order == 4)
			{
				result.x = zhanzhenposx;
				result.z = zhanzhenposz - 2;
			}
			if (order == 5)
			{
				result.x = zhanzhenposx ;
				result.z = zhanzhenposz - 1;
			}
			if (order == 6)
			{
				result.x = zhanzhenposx;
				result.z = zhanzhenposz;
			}
			if (order == 7)
			{
				result.x = zhanzhenposx;
				result.z = zhanzhenposz + 1;
			}
			
		}
		else if (rolesizex == 2)
		{
			if (order==0)
			{
				result.x = zhanzhenposx -3;
				result.z = zhanzhenposz - 2;
			}
			if (order == 1)
			{
				result.x = zhanzhenposx - 3;
				result.z = zhanzhenposz;
			}
			if (order == 2)
			{
				result.x = zhanzhenposx - 1;
				result.z = zhanzhenposz - 2;
			}
			if (order == 3)
			{
				result.x = zhanzhenposx - 1;
				result.z = zhanzhenposz ;
			}
		}
		else if (rolesizex == 3)
		{
			if (order == 0)
			{
				result.x = zhanzhenposx - 2;
				result.z = zhanzhenposz - 2;
			}
			if (order == 1)
			{
				result.x = zhanzhenposx - 2;
				result.z = zhanzhenposz;
			}
			
		}
		else if (rolesizex == 4)
		{
			if (order == 0)
			{
				result.x = zhanzhenposx - 3;
				result.z = zhanzhenposz - 2;
			}
			if (order == 1)
			{
				result.x = zhanzhenposx - 3;
				result.z = zhanzhenposz;
			}
		}
		if (campid == 2)
		{
			result.x = MyMapinfo.Length - result.x - rolesizex+2;
		}
		return result;
	}



	public void updatepload(float dt)
	{
		
		
		
	}

	public void Exitpload()
	{
		ChangeState(btstate_.eveini); 
	}

	
	//开始事件系统
	public void entereveini()
	{
		//初始化事件系统 加载地图事件
		
		if (btp.maptype == bttype_.fuben)
		{
			
			
			MybtTimemag.StartEve();
			Exiteveini();
		}
		else if(btp.maptype == bttype_.pvp)
		{
			Exiteveini();
		}
		else if(btp.maptype == bttype_.bosspvp||btp.maptype == bttype_.pvp_jinjichang)
		{
			Exiteveini();
		}
	}
	public void updateeveini(float dt)
	{
		
		
		
	}
	
	public void Exiteveini()
	{
		ChangeState(btstate_.uiini); 
	}

	//初始化界面
	public void enteruiini()
	{
		MyBtUiMag.ShowUI (true);
		Exituiini ();
	}
	public void updateuiini(float dt)
	{
		
		
		
	}

	public void Exituiini()
	{
		ChangeState(btstate_.guochang); 
	}

	//过场动画
	public void enterguochang()
	{
		//Exitguochang ();
		//检查副本是否有角色解锁 
		if (btp.firstblood == true&&btp.maptype== bttype_.fuben&&MyMapinfo.TipOpenRoleDbid>0) {
			MyBtUiMag.JiesuoRoleTip (MyMapinfo.TipOpenRoleDbid);
		} else {
			Exitguochang ();
		}
	}
	public void updateguochang(float dt)
	{
		
		
		
	}
	public void JiesuoRoleTipFinish()
	{
		Exitguochang ();
	}
	public void Exitguochang()
	{
		ChangeState(btstate_.waitstart); 
	}


	public void enterwaitstart()
	{
		//通知界面开始321
		usewaitstarttime =0f;
		MyBtUiMag.StartGame ();
	}
	public void updatewaitstart(float dt)
	{
		usewaitstarttime +=dt;
		if(usewaitstarttime>=waitstarttime)
		{
			//Exitwaitstart();
		}
		
	}
	public void Ui321Finish()
	{
		
		Exitwaitstart ();
	}
	public void Exitwaitstart()
	{
		ChangeState(btstate_.fighting); 
	}


    //进入战斗
    public void enterfighting()
    {

        MybtTimemag.StartFight();
		if (btp.maptype == bttype_.fuben) 
		{
			MyCreateRoleMag.StartBt();
		}
		MyBtNpcmag.StartGame ();
		//如果有新手引导
		if(hasYindao == true)
		{
			lgNoDelCsFun.Ins.BattleReady();
		}
    }
	private float pvptime = 0f;
	private int pvpupdatenum =1;
    public void updatefighting(float dt)
    {
		if (btp.maptype == bttype_.pvp) {
			//dt = 0.011f;
			if(usepvpendtime+dt>= pvpendtime)
			{
				pvpupdatenum = (int)((pvpendtime -  pvptime)/ 0.011f);
			}
			else
			{
				pvpupdatenum = (int)((usepvpendtime+dt -  pvptime)/ 0.011f);
			}

			for(int i=0;i<pvpupdatenum;i++)
			{
				MyBtNpcmag.update (0.011f);
			}
			pvptime+=pvpupdatenum*0.011f;

		} else {
			MyBtNpcmag.update (dt);
		}
		if (btp.maptype == bttype_.fuben) 
		{
			if(MyBtNpcmag.pausegame==false)
			{
				MyCreateRoleMag.update(dt);
			}
		}
		else if(btp.maptype == bttype_.pvp)	//pvp 到达时间 退出战斗
		{
			usepvpendtime+=dt;
			if( usepvpendtime>= pvpendtime)
			{
				Exitfighting();
			}
		}
    }
	public void Exitfighting()
	{
		//发送服务器战斗结果 等待服务器回传奖励


		//ChangeState(btstate_.waitresult); 

		if (btp.maptype == bttype_.fuben) 
		{
			ChangeState(btstate_.waitresult); 
		}
		else if(btp.maptype == bttype_.pvp)
		{
			ChangeState(btstate_.endbt); 	//pvp战斗都不显示结果
			//ChangeState(btstate_.waitresult); 
		}
		else if(btp.maptype == bttype_.bosspvp||btp.maptype == bttype_.pvp_jinjichang)
		{
			//ChangeState(btstate_.endbt); 
			ChangeState(btstate_.waitresult); 

		}
		//ChangeState(btstate_.endbt);
	}
	//等待结果
	public void enterwaitresult()
	{
		//
		MyBtUiMag.ShowResult (win);
		lgNoDelCsFun.Ins.MapOver (win,MyBtUiMag.JiangliRoot);
	}
	public void updatewaitresult(float dt)
	{
		
		//Debug.LogError ("");
		
	}
	public void Exitwaitresult()
	{
		//ChangeState(btstate_.showresult); 
		if(btstate != btstate_.endbt)
		{
			ChangeState(btstate_.endbt); 
		}
	}

	//显示结果
	public void entershowresult()
	{
		//通知UI显示结果
		useshowResultTime = 0f;
		MyBtUiMag.ShowResult (win);
	}
	public void updateshowresult(float dt)
	{
		useshowResultTime += dt;
		if(useshowResultTime>=showResultTime)
		{

			Exitshowresult();
		}
		
		
	}
	public void Exitshowresult()
	{
		ChangeState(btstate_.endbt); 
	}
	private bool uiquit =false;
	//结束战斗  
	public void enterendbt()
	{
		if(btp.maptype == bttype_.pvp&& uiquit ==false&&PvpShowNum==-1)	//如果是观看pvp检查是否还有下一场战斗要看  没有则结束
		{
			MyBtUiMag.Clear();
			QuitBt();
			//请求下一场pvp战斗
			lgNoDelCsFun.Ins.GetWorldBattleInfo();

			ChangeState(btstate_.pvpwaitshow); 

			return;
		}
		lgCfgMag.Ins.ClearPvpResultList ();
		//开始清理过程
		//清除场景物件 
		
		//清理资源
		QuitBt ();
		tModleFactory.Ins.MyTxFactory.Quit ();
		MyBtUiMag.Quit ();
		MyBtUiMag = null;
		hasYindao = false;
		//开始加载loading场景
		MySceneLoad.LoadMainScene ();
	}
	public void updateendbt(float dt)
	{
		
		MySceneLoad.update (dt);
		
	}
	public void Exitendbt()
	{

	}


    //游戏所有的暂停战斗部分  不包括UI逻辑
    public void pauseGameAll()
    {
        MybtTimemag.PauseAll();
        MyBtNpcmag.SetPauseOnce();

    }

	//阵营1城堡 死亡
	public void Camp1ChengbaoDie()
	{
		if(btp.maptype== bttype_.fuben)
		{
			win=-1;
			//失败
			Debug.LogError("Game Lose ");
			Exitfighting();
		}
	}
	//阵营2城堡 死亡
	public void Camp2ChengbaoDie()
	{
		if(btp.maptype== bttype_.fuben)
		{
			win=1;
			//胜利
			Debug.LogError("Game Win ");
			Exitfighting();
		}
	}
	public void BossPvpEnd(int campid)
	{
		if(btstate!= btstate_.fighting)
		{
			return;
		}
		if (campid == 1) {
			win = 1;
			//胜利
			Debug.LogError ("Game Win ");
			Exitfighting ();
		} else {
			win=-1;
			//失败
			Debug.LogError("Game Lose ");
			Exitfighting();
		}
	}
	//退出战斗
	public void QuitBt()
	{
		pvpstr=null;
		Rolepvpstr.Clear ();
		MyPvpInfo.camp1roles=null;
		MyPvpInfo.camp2roles=null;
		MyPlayInfo.HeroList=null;
		MyPlayInfo.SoldierList=null;
		tModleFactory.Ins.ClearBtUuid();
		MyBtNpcmag.Exit ();
	}

	public void enterpvpWait()
	{

	}
	public void updatapvpWait(float dt)
	{
		if (PvpShowNum == -2) {
			if (lgCfgMag.Ins.GetNeedShowPvpResultNum () > 0) {
				PvpShowNum =-1;
				MybtTimemag.IniSome ();
				MyBtNpcmag.IniSome (MyMapinfo.Length, MyMapinfo.Wide);
				usepvpendtime = 0f;
				//初始化对战角色ai
				SetPvpInfo (lgCfgMag.Ins.GetPvpResult ());
				pvptime = 0f;
				pvpupdatenum = 1;
				MyBtUiMag.IniSome (btp.maptype);
				ChangeState (btstate_.pload); 
			}
		} else if (PvpShowNum == 0)  {
			ChangeState(btstate_.endbt); 
		}
	}
	
	
	public bttype_ GetMapType()
	{
		return btp.maptype;
	}

	public testdybroleai GetAllRandRole()
	{
		return MyBtNpcmag.GetAllRandRole ();
	}


	//ui相关
	public void UI_ChangeHero(int changeid)
	{
		MyCreateRoleMag.ChangeHero (changeid);
	}
	public void UI_ChooseRole(int changeid)
	{
		MyCreateRoleMag.ChooseRole (changeid);

	}
	public void UI_CancelChooseRole(int changeid)
	{
		MyCreateRoleMag.CancelChooseRole (changeid);
	}

	public void Set_UI_Renkou(int renkou)
	{
		MyBtUiMag.SetPopulation (renkou);
	}
	//设置第几回合
	public void Set_UI_RoundNum(int round)
	{
		MyBtUiMag.SetRoundNum (round);
	}
	//设置回合时间
	public void SetRoundTime(int time)
	{
		MyBtUiMag.SetRoundTime (time);
	}

	public void  Call_UI_LockCreateHero()
	{
		MyBtUiMag.LockCreateHero ();
	}

	public void Call_UI_CreateHeroFinish(testdybroleai thishero)
	{
		MyBtUiMag.CreateHeroFinish (thishero);
	}
	public void Call_UI_HeroDie(testdybroleai thishero)
	{
		MyBtUiMag.HeroDie (thishero);
	}

	public void Call_UI_UpdataSkillCd(testdybroleai thishero,int order, float skillcdkey)
	{
		MyBtUiMag.UpdataSkillCd (thishero,order,skillcdkey);
	}
	public void Call_UI_Updatehp(int campid,int dame)
	{
		MyBtUiMag.Updatehp (campid,dame);
	}
	public void Call_UI_SkillDam(int dame,Vector3 tarpos)
	{
		MyBtUiMag.ShowSkillDam (dame,tarpos);
	}

	public void Call_UI_GetOneHeroHpTip(testdybroleai thishero)
	{
		MyBtUiMag.GetOneHeroHpTip (thishero);
	}
#if MinMap
	public void Call_UI_GetOneMapPosTip(testdybroleai thishero)
	{
		MyBtUiMag.GetOneMapPosTip (thishero);
	}
#endif


	//se
	public void Call_UI_CameChangePos()
	{
		MyBtUiMag.CameChangePos ();
	}
	public void Call_UI_RoleDieTalk(testdybroleai thisrole)
	{
		MyBtUiMag.RoleDieTalk (thisrole);
	}

	//取得当前地图单元个长宽
	public void GetMapCell(out tPoint_ mapcell)
	{
		MyBtNpcmag.GetMapCell (out mapcell);
	}


	public void UI_Call_QuitBt()
	{
		uiquit =true;
		btstate = btstate_.endbt;
		enterendbt ();
	}


	public List<Pvp_RoleList_> pvp_RoleList1 = new  List<Pvp_RoleList_> ();
	public List<Pvp_RoleList_> pvp_RoleList2 = new  List<Pvp_RoleList_> ();



	public void Setpvprolelist(List<Pvp_RoleList_> temppvp_RoleList1,List<Pvp_RoleList_> temppvp_RoleList2)
	{
		pvp_RoleList1.Clear ();
		pvp_RoleList2.Clear ();
		pvp_RoleList1 = temppvp_RoleList1;
		pvp_RoleList2 = temppvp_RoleList2;
		//MyBtUiMag.Updatapvprolelist (pvp_RoleList1,pvp_RoleList2);
	}


	//新手引导相关
	public bool hasYindao = false;

	//设置创建英雄所需要的人口 新手引导用
	public void SetFubenHeroNoRenkou(int rolenum )
	{
		if(MyCreateRoleMag!=null)
		{
			MyCreateRoleMag.Setheroneedrenkou = rolenum;
		}
	}

	/*
    public void ExitState()
    {
        switch (btstate)
        {
			//加载场景物件
		case btstate_.jiazaibt : 
			Exitjiazaibt();
			break;
			
			//预加载玩家数据等
		case btstate_.pload :  
			Exitpload();
			break;
			
			//启动事件系统
		case btstate_.eveini :  
			Exiteveini();
			break;
			
			
			//初始化界面
		case btstate_.uiini :  
			Exituiini();
			break;
			
			//过场动画
		case btstate_.guochang :  
			Exitguochang();
			break;
			
			//等待开始
		case btstate_.waitstart : 
			Exitwaitstart();
			break;
			
			//战斗中
		case btstate_.fighting :  
			Exitfighting();
			break;
			
			//等待结果
		case btstate_.waitresult :  
			Exitwaitresult();
			break;
			
			//显示结果
		case btstate_.showresult : 
			Exitshowresult();
			break;
			
			//结束战斗  
		case btstate_.endbt :  
			Exitendbt();
			break;
        }
    }
*/
   

   
}
