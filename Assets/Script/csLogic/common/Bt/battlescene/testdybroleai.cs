#define UseLookAt

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//using System;
public enum roleDepartment_
{
	D_Null = 0,
	D_Gong =1,	// 弓系
	D_Dun =2,	//盾系
	D_Qang =3,	//枪系
	D_Te =4,	//特系

}
public enum roletype_
{
	typenull =0,  //
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
}
public struct FightRoleInfo_	//玩家带的宝宝
{
	public int Dbid;		//
	public int Lvl;        //等级
	public int QualityLvl;        //品阶
	public string UUID;			//本地副本 英雄 用
	public string nowsitzuoqipname;  //本地副本 英雄 用
}
public struct RolePvpAiInfo_
{
	public int eveid;
	public float starttime;
	public List<string> plist;

}
public struct pvproleinfo_
{
	public int RoleDbid;			//创建角色DBid
	public tPoint_ CreatePos;		//创建位置
	public int lvl;					//等级
	public int qulitylvl;			//品阶
	public string uuid;				//pvp英雄需要  计算属性用
	public string nowsitzuoqipname; //pvp英雄需要

}
public struct pvpzhanzhenginfo
{
	public int HeroDbid;			//创建角色DBid
	public int Herolvl;					//等级
	public int Heroqulitylvl;			//品阶
	public string Herouuid;				//pvp英雄需要  计算属性用
	public string Heronowsitzuoqipname; //pvp英雄需要
	
	public int SoldierDbid;			//创建角色DBid
	public int Soldierlvl;					//等级
	public int Soldierqulitylvl;			//品阶
	
	public int CreatePosX;		//创建位置  中心点
	public int CreatePosZ;		//创建位置  中心点
	public int HeroHp;			//英雄血量 0 死亡  -1用原始计算血量  >0 设置
	public int SoldierNum;		//当前存活小兵数量  0 全部死亡  -1用原始计算数量  >0 设置
	public List<int> SoldierHpList; //小兵血量 列表  
}
public struct Roledata_
{
    public int DBid;
    public string name;
    public string prefabname;

    //public int hp;                      //血量
   // public int att;                     //攻击力
    //public int normalattspeed;          //攻击速度
    //public float movespeed;             //移动速度

	//public rolepop_ basepop;

    public int skillNormalDBid;         //普攻技能
    public int skillDBid;               //特殊技能

    public int attrange;	//角色攻击距离 策划用 配置
    public int alertrange; 	//角色警戒距离 策划用 配置
    public roletype_ roletype;	//角色类型  根据这个判定攻击优先级
	public roleDepartment_ roleDepart;		//角色所属系别  用于计算攻击伤害加成和减免
	public string nowsitzuoqipname;			//默认坐骑  比如工兵什么的
	public int qulity;			//品质
	 
	public string HeadAtlasName;   //头像
	public string HeadSpriteName;
	public string Description;
}
public struct IniRoleP_
{
	public string UUID;
	public string pvpuuid;		//pvp用
	public int lvl;						//等级
	public int qulitylvl;				//品质等级  绿色+2
	public string nowsitzuoqipname; //当前坐骑名
	//public string name;
	//public string prefabname;
	//public int DBid;

    //public int skillNormalDBid;         //普攻技能
    //public int skillDBid;               //特殊技能

	//public int InBsId;
	public int camp; //阵营 1 或 2

	public tPoint_ MyInimapPoint; //生成位置 策划用 配置
    public Roledata_ MyRoledata;
	public int IniHp;	//-1 初始  >0 设置
	public FuwenData_ MyFuwenData;
	public float HpAdd;		//副本血量加成
	public float AttAdd;	//副本攻击加成
}

public class testdybroleai  {

	// Use this for initialization
	//测试用属性
	//public int hp=100; //血量
	//public int att=20;  //攻击力
	
	public int lvl;						//等级
	public int qulitylvl;				//品质等级  绿色+2
	public roleDepartment_ MyDepart;	//所属系别

	//public float movespeedmax = 5f;		//移动速度最大
	//public float movespeedmin = 2f;		//移动速度最小
	//public float atttime = 1.5f;   //攻击时间
	//public float useatttime = 0f;   //攻击时间
	private Animation myani;
	private Animation myzuoqiani;
	private float oncemovetime = 0f;
	private float usemovetime = 0f;
	private float mspeed = 0f;

	private float randx = 0f;
	private float randy = 0f;
	private float randz = 0f;
	private int nowstate = 0;
	private GameObject MyObj;		//如果有坐骑 则指坐骑obj 没有就是角色obj
	private GameObject MyRoleObj;
	public string name = "";

	public roletype_ roletype = 0;	//角色类型  根据这个判定攻击优先级
	List<roletype_> attpriority = new List<roletype_>(); //角色攻击优先级
	
	public int attrange = 1;	//角色攻击距离 策划用 配置
	public int alertrange = 1;	//角色警戒距离 策划用 配置
	public int attrangeCell = 1;	//角色攻击距离 地图格子
	public int alertrangeCell = 1;	//角色警戒距离 地图格子
	public testdybroleai atttar ;	//角色攻击目标
	
	public int camp =1;//阵营 1 或 2
	
	//角色格子相关
	public tPoint_ MyInimapPoint;
	public tPoint_ MymapPoint;


	//public tPoint_ MyLandH;	
	
	public int celllength= 1; //长宽占用格子数
	public int cellhigh =1;	 //长宽占用格子数
	
	public int mapcelllength= 1; //地图中长宽占用格子数
	public int mapcellhigh =1;	 //地图中长宽占用格子数

	//public int halfmapcelllength= 1; //地图中长宽占用格子数
	//public int halfmapcellhigh =1;	 //地图中长宽占用格子数
	
	public float f_updatemovedis = 0f;//角色移动x/z 多少时更新自己的位置单元格
    public tMapPointInfo Mymapmag;
	private tBtNpcmag Mynpcmag;
	
	//private List<tPoint_> oldPosList = new List<tPoint_> ();
	private List<tPoint_> nowPosList = new List<tPoint_> ();
	//private tPoint_ oldPos ;
	
	
	
	private IniRoleP_ MyInip;

	private skillbase mynormalskill;
    private skillbase myskill1;

	public List<testdybroleai> attmerolelist = new List<testdybroleai>(); //攻击者列表

	private bool pauseAi=false; 


	private string nowplayani ="";

	//移动相关
	private Vector3 tar;		//移动目标点
	private Vector3 inipos;		//移动起始位置
	private Vector3 oldpos =Vector3.zero;
	private float sumx =0f;
	private float dx =0f;
	private float dz =0f;
	private float sumz =0f;
	
	private int movex =0;
	private int movez =0;
	private List<tPoint_> leavelist=new List<tPoint_>();
	private List<tPoint_> addlist=new List<tPoint_>();


	private bool useSkill = false;			//正在使用技能标志
	public testdybroleai nowattrole =null; //当前正在攻击的目标
	public bool b_nowattroledie =false;	//当前攻击的目标死亡标志
	private bool b_nowattroleoutatt =false;	//当前攻击的目标超过攻击范围
	public bool IsDie = false; 	//角色死亡标志

	private GetOneObjCB myGetOneObjCB;

	public bool haspriorityatt=false;		//角色是否有优先级攻击目标类型
	public List<roletype_> MyPriorityattList;	 //角色优先级攻击目标类型列表

	public int FaceType = 0;  //朝向方式


    public rolebuffmag Myrolebuffmag;

    public string MyUUID = "";
	public string MyPvpUUID = "";
	public lgRoleMountList MyMountList;

	public List<lgTxbase> AddTxList = new List<lgTxbase> (); //加在角色身上的特效

	public Vector3 diepos; //死亡的时候坐标

	//坐骑相关  英雄才有
	//public int nowsitzuoqiid;   //当前坐骑编号
	public string nowsitzuoqipname;	//当前坐骑模型名字
	public bool haszuoqi = false;

	int CallUi = 0;  //是否要通知UI 1 要 0不要
	public int InUiOrder = -1;	//在UI中位置


	public lgRoleBtPop MyPop;

	//减伤系别
	public roleDepartment_ MyReduceDamDepart;	//减伤系别
	public float ReduceDamNum;				//减伤系数

    public void SetUUID(string va)
    {
        MyUUID = va;
    }
    public string GetUUID()
    {
        return MyUUID;
    }
	public void IniSome () {
		//mspeed = Random.Range(movespeedmin,movespeedmax);
		myani=MyRoleObj.GetComponent<Animation>();
		if(haszuoqi==true)
		{
			myzuoqiani=MyObj.GetComponent<Animation>();
		}
		//myani=MyObj.GetComponent<Animation>();

		/* 2016.10.20 又改回每个角色自带动作 不用添加了
		if(myani!=null&&MyInip.MyRoledata.roletype == roletype_.typeyinxiong)
		{
			int animaid = lgCfgMag.Ins.GetRoleAnimaId(MyInip.MyRoledata.prefabname);
			//Debug.Log("animaid ="+animaid.ToString());
			//animaid =1;//snbug -2016.09.02
			if(animaid>0)
			{
				myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.waitList[animaid],"wait");
				myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.walkList[animaid],"walk");
				myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.dieList[animaid],"die");
				myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.attackList[animaid],"attack");
			}
		}
		*/
        IniSkill();

		//检查如果是英雄 则创建血条显示
		if (MyInip.MyRoledata.roletype == roletype_.typeyinxiong)
		{
			lgbtmag.Ins.Call_UI_GetOneHeroHpTip(this);
		}
#if MinMap
		b_haspostip = false;
		if (MyInip.MyRoledata.roletype != roletype_.typechengbao)
		{
			b_haspostip = true;
			//请求小地图
			lgbtmag.Ins.Call_UI_GetOneMapPosTip(this);
		}
#endif
		MyReduceDamDepart =MyInip.MyFuwenData.ReduceDamDepart;	//减伤系别
		ReduceDamNum=MyInip.MyFuwenData.ReduceDamNum;				//减伤系数

		CreateFinish ();
        if (Myrolebuffmag==null)
        {
            Myrolebuffmag = new rolebuffmag();
        }
        Myrolebuffmag.IniSome(this);
	}
	
	float skillcdkey =-1f;
	bool CDCold = false;
	public void update (float dt) {
		//if(pauseAi==false)
		//{
		//	updateAi(dt);
		//}
        //Debug.Log("updateupdateupdateupdateupdate");
		starttime += dt;
		if (IsDie == false) {
			if (roletype != roletype_.typechengbao) {

				if (nowstate == 0) {
					//chooseaction();
					if (StopMelfAi == false) {
						standAi (dt);
					}
				} else if (nowstate == 1) {
					updatemove (dt);
				} else if (nowstate == 2) {
					updateFight (dt);
				}
				//更新技能
				if (mynormalskill != null) {
					mynormalskill.update (dt);
				}
				if (myskill1 != null) {
					myskill1.update (dt);
					if (CallUi == 1) {
						if (myskill1.useSkillCD > 0) {
							CDCold = false;
							skillcdkey = myskill1.useSkillCD / myskill1.SkillCD;
							//Debug.Log("Call_UI_UpdataSkillCd");
							lgbtmag.Ins.Call_UI_UpdataSkillCd (this, InUiOrder, skillcdkey);
						} else {
							if (CDCold == false) {
								CDCold = true;
								lgbtmag.Ins.Call_UI_UpdataSkillCd (this, InUiOrder, -1);
							}
						}
					}
				}
				if (StopMelfAi == true) {
					
					CheckPvpAi ();

				}
			}
		} else {
			if(waitRecovery == true)
			{
				usedieanimetime = usedieanimetime+dt;
				if(usedieanimetime>=dieanimetime)
				{
					waitRecovery = false;
					Recovery();
				}

			}
		}
	}


	void dostand()
	{
		lastactiontype = -1;
		nowstate = 0;
		//清除目标
		if(nowattrole!=null)
		{
			nowattrole.CancleBeSetAttRole(this);
			nowattrole = null;
		}

		PlayAnim ("wait");

	}


	void domove()
	{
		randx = Random.Range(-30f,30f);
		randy = 0;//Random.Range(-30,30);
		randz = Random.Range(-50f,0f);
		tar = new Vector3 (randx,randy,randz);
		inipos = MyObj.transform.position;
		float dis = Vector3.Distance (inipos,tar);

		oncemovetime = dis / mspeed;
		usemovetime = 0f;

		//PlayAnim ("walk");
		PlayAnim ("run");
		//gameObject.transform.LookAt (tar);
#if UseLookAt
		MyObj.transform.LookAt (tar);
#endif
		nowstate = 1;
	}
	//向前移动
	void domove_pvp(float inix,float iniz,float tarx,float tarz)
	{
		randy = MyObj.transform.position.y;
		tar = new Vector3 (tarx,randy,tarz);
		inipos = new Vector3 (inix,randy,iniz);
		float dis = Vector3.Distance (inipos,tar);
		
		oncemovetime = dis / mspeed;
		usemovetime = 0f;
		//PlayAnim ("walk");
		PlayAnim ("run");

		//gameObject.transform.LookAt (tar);
		#if UseLookAt
		MyObj.transform.LookAt (tar);
		#endif
		nowstate = 1;
	}
	int lastactiontype = -1;		//1 向前移动  2 向角色移动  3使用技能
	Vector3 lastmovetarpos = Vector3.zero;
	void domove_forward()
	{
		if (lastactiontype == 1) {
			return;
		} else {
			lastactiontype =1;
		}
		if(camp==1)
		{
			randx = MyObj.transform.position.x+100;
		}
		else
		{
			randx = MyObj.transform.position.x-100;
		}
		randy = MyObj.transform.position.y;
		randz = MyObj.transform.position.z;
		tar = new Vector3 (randx,randy,randz);
		inipos = MyObj.transform.position;
		float dis = Vector3.Distance (inipos,tar);

		oncemovetime = dis / mspeed;
		usemovetime = 0f;
		//PlayAnim ("walk");
		PlayAnim ("run");
		//gameObject.transform.LookAt (tar);
		#if UseLookAt
		MyObj.transform.LookAt (tar);
		#endif
		nowstate = 1;
	}
	void domove_toRole(testdybroleai thisrole)
	{
		if (lastactiontype == 2) {
			if(Vector3.Distance(lastmovetarpos,thisrole.MyObj.transform.position)<0.005f)	//目的地一致  则返回
			{
				return;
			}
			else
			{
				lastactiontype =2;
				lastmovetarpos = thisrole.MyObj.transform.position;
			}
			
		} else {
			lastactiontype =2;
			lastmovetarpos = thisrole.MyObj.transform.position;
		}

		tar = thisrole.MyObj.transform.position;
		inipos = MyObj.transform.position;

		float dis = Vector3.Distance (inipos,tar);
		
		oncemovetime = dis / mspeed;
		usemovetime = 0f;
		//PlayAnim ("walk");
		PlayAnim ("run");
		//gameObject.transform.LookAt (tar);
		#if UseLookAt
		MyObj.transform.LookAt (tar);
		#endif
		nowstate = 1;
	}

	void updatemove(float dt)
	{
		usemovetime += dt;
		if (usemovetime <= oncemovetime)
		{

			MyObj.transform.position = Vector3.Lerp(inipos,tar,usemovetime/oncemovetime);
			dx = MyObj.transform.position.x- oldpos.x;
			sumx+=dx;
			dz = MyObj.transform.position.z- oldpos.z;
			sumz+=dz;
			oldpos = MyObj.transform.position;
			if(MyHpTip!=null)
			{
				MyHpTip.updatapos(oldpos);
			}
			if(sumx>=f_updatemovedis||sumx<=-f_updatemovedis)
			{
				float temp = sumx/f_updatemovedis;
				movex = (int)temp;

				sumx=sumx-movex*f_updatemovedis;
			}
			if(sumz>=f_updatemovedis||sumz<=-f_updatemovedis)
			{
				float temp = sumz/f_updatemovedis;
				movez = (int)temp;

				sumz=sumz-movez*f_updatemovedis;
			}

			//移动超过限定值 则通知攻击目标  更新一次AI
			if(movez!=0||movex!=0)
			{

				moveOncemapPos(movex,movez ,ref leavelist,ref addlist);

				Mymapmag.MoveSetUse(camp,movex,this,leavelist,addlist);
				if(StopMelfAi==false)
				{
					moveAi();
				}
				for(int i=0;i<attmerolelist.Count;i++)
				{
					attmerolelist[i].attrolemoveCB(this,movex,movez);
					
				}
#if MinMap
				if(b_haspostip==true)
				{
					UpdataPosTip();
				}
#endif
				movez=0;
				movex=0;
				leavelist.Clear();
				addlist.Clear();
			}

		} 
		else 
		{
			//通知移动结束

			//nowstate = 0;
			dostand();
		}
		
	}

	//设置攻击目标
	void doFight(testdybroleai thisrole)
	{
		PlayAnim ("wait");
		//Debug.Log (MyObj.name+" doFight "+thisrole.MyObj.name);
		nowstate = 2;
		//检查有没有转换目标
		CheckChangeAtt (thisrole);
		b_nowattroledie =false;
		attackAi();
	}

	//检查有没有转换目标
	void CheckChangeAtt(testdybroleai thisrole)
	{
		if (nowattrole != null&&nowattrole!=thisrole)
		{
			nowattrole.CancleBeSetAttRole(this);
		}
		nowattrole = thisrole;
		nowattrole.BeSetAttRole (this);

	}
	void updateFight(float dt)
	{
		if(useSkill == false&&StopMelfAi==false)
		{
			attackAi();
		}


	}
	//角色使用技能完成回调
	public void UseSkillFinish(bool IsNormalskill)
	{
		if(IsNormalskill==true)	//只有普通技能走  英雄技能不走
		{
			useSkill = false;
			//切动画
			if (b_nowattroledie == true) {
				dostand ();
			} else {
				PlayAnim ("wait");
				//PlayAnim ("run");
				//PlayAnim ("die");
			}
		}
	}

	//Ai 逻辑相关

	//检测是否到达敌方队首
	bool checkAtduishou()
	{
		bool result = false;
		if(camp==1)
		{
			//+mapcelllength+alertrangeCell
			result = MymapPoint.x+mapcelllength+alertrangeCell>=Mymapmag.Head_x_2;
			if(result==true)
			{
				int i =0;
			}
			return result;
		}
		else
		{

			//return MymapPoint.x-alertrangeCell<=Mymapmag.Head_x_1;
			result = MymapPoint.x-alertrangeCell<=Mymapmag.Head_x_1;
			if(result==true)
			{
				int i =0;
			}
			return result;
		}

	}
	//检测是否到达敌方队首  超过队尾算true
	bool checkAtduiwei()
	{
		if(camp==1)
		{
			return MymapPoint.x+mapcelllength>=Mymapmag.Rear_x_2;
		}
		else
		{
			
			return MymapPoint.x<=Mymapmag.Rear_x_1;
		}
		
	}
	public void standAi(float dt)
	{
		//没有对手 直接返回
		if(camp==1&&Mynpcmag.cmap2Rolelist.Count<=0||camp==2&&Mynpcmag.cmap1Rolelist.Count<=0) //没有对手
		{
			return;
		}
		bool atpos = checkAtduishou();
		if(atpos==true)	//到达敌方队首
		{
			atpos = checkAtduiwei();
			if(atpos==true)	//到达敌方队尾  
			{

				testdybroleai thisrole =GetOneNearEm();
				if(thisrole!=null) //查找最近目标
				{
					int dis = GetRoleDis( this,thisrole);
					if(dis>attrangeCell)	//大于攻击范围 
					{
						//设置向目标移动  城堡也算攻击目标
						domove_toRole(thisrole);
					}
					else
					{
						//开始攻击
						doFight(thisrole);
					}
				}
			}
			else //没到队尾 
			{
				testdybroleai thisrole =GetOneInAttEm();
				if(thisrole==null)
				{
					thisrole =GetOneInAlertEm();
					
					if(thisrole!=null) //警戒范围内有目标 则向目标移动 城堡也算攻击目标
					{
						domove_toRole(thisrole);
					}
					else
					{
						domove_forward();
					}
				}
				else
				{
					//开始攻击目标
					doFight(thisrole);
				}

			}
		}
		else{//没到队首 向前移动
			
			domove_forward();
		}

	}

	//查找警戒范围内目标
	public testdybroleai GetOneInAlertEm()
	{
       // Debug.Log("haspriorityatt=" + haspriorityatt + "  uuid=" + MyUUID);
		//警戒范围内分成4块  顺序 上面 前面 下面 后面 但是不包括攻击范围
		if(haspriorityatt==true)//有攻击优先级
		{

			testdybroleai result;
			int d1 = 0;
			int d2 = 0;
			int d3 = 0;
			int d4 = 0;
			testdybroleai role1 = Mymapmag.GetRoleInAreaNearAndPriority (this,MymapPoint.x+mapcelllength+attrangeCell,MymapPoint.x-attrangeCell, MymapPoint.z+mapcellhigh+alertrangeCell,MymapPoint.z+mapcellhigh+attrangeCell,out d1);
			testdybroleai role2 = Mymapmag.GetRoleInAreaNearAndPriority (this,MymapPoint.x+mapcelllength+alertrangeCell,MymapPoint.x+mapcelllength+attrangeCell, MymapPoint.z+mapcellhigh+alertrangeCell,MymapPoint.z-alertrangeCell,out d2);
			testdybroleai role3 = Mymapmag.GetRoleInAreaNearAndPriority (this,MymapPoint.x+mapcelllength+attrangeCell,MymapPoint.x-attrangeCell, MymapPoint.z-attrangeCell,MymapPoint.z-alertrangeCell,out d3);
			testdybroleai role4 = Mymapmag.GetRoleInAreaNearAndPriority (this,MymapPoint.x-attrangeCell,MymapPoint.x-alertrangeCell,  MymapPoint.z+mapcellhigh+alertrangeCell,MymapPoint.z-alertrangeCell,out d4);
			int d = d1;
			result = role1;
			if(d2<d)
			{
				d =d2;
				result = role2;
			}
			if(d3<d)
			{
				d =d3;
				result = role3;
			}
			if(d4<d)
			{
				d =d4;
				result = role4;
			}
			return result;

		}
		else //没有攻击优先级 则找最近的
		{
			testdybroleai result;
			int d1 = 0;
			int d2 = 0;
			int d3 = 0;
			int d4 = 0;
			//攻击范围内分成4块  顺序 上面 前面 下面 后面
			testdybroleai role1 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+mapcelllength+attrangeCell,MymapPoint.x-attrangeCell, MymapPoint.z+mapcellhigh+alertrangeCell,MymapPoint.z+mapcellhigh+attrangeCell,out d1);
			testdybroleai role2 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+mapcelllength+alertrangeCell,MymapPoint.x+mapcelllength+attrangeCell, MymapPoint.z+mapcellhigh+alertrangeCell,MymapPoint.z-alertrangeCell,out d2);
			testdybroleai role3 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+mapcelllength+attrangeCell,MymapPoint.x-attrangeCell, MymapPoint.z-attrangeCell,MymapPoint.z-alertrangeCell,out d3);
			testdybroleai role4 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x-attrangeCell,MymapPoint.x-alertrangeCell,  MymapPoint.z+mapcellhigh+alertrangeCell,MymapPoint.z-alertrangeCell,out d4);

			int d = d1;
			result = role1;
			if(d2<d)
			{
				d =d2;
				result = role2;
			}
			if(d3<d)
			{
				d =d3;
				result = role3;
			}
			if(d4<d)
			{
				d =d4;
				result = role4;
			}
			return result;
		}
		return null;
	}
	//查找攻击范围内目标
	public testdybroleai GetOneInAttEm()
	{
		testdybroleai result;
		int d0 = 0;
		int d1 = 0;
		int d2 = 0;
		int d3 = 0;
		int d4 = 0;
		//攻击范围内分成5块  顺序 上面 前面 下面 后面

		//自己占用格子
		testdybroleai role0 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+mapcelllength,MymapPoint.x, MymapPoint.z+mapcellhigh,MymapPoint.z,out d1);
		if(role0!=null)
		{
			return role0;
		}
		testdybroleai role1 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+mapcelllength,MymapPoint.x, MymapPoint.z+mapcellhigh+attrangeCell,MymapPoint.z+mapcellhigh,out d1);
		testdybroleai role2 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+mapcelllength+attrangeCell,MymapPoint.x+mapcelllength, MymapPoint.z+mapcellhigh+attrangeCell,MymapPoint.z-attrangeCell,out d2);
		testdybroleai role3 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+mapcelllength,MymapPoint.x, MymapPoint.z,MymapPoint.z-attrangeCell,out d3);
		testdybroleai role4 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x,MymapPoint.x-attrangeCell,  MymapPoint.z+mapcellhigh+attrangeCell,MymapPoint.z-attrangeCell,out d4);
		//int d1 = GetRoleDis (this, role1);
		//int d2 = GetRoleDis (this, role2);
		//int d3 = GetRoleDis (this, role3);
		//int d4 = GetRoleDis (this, role4);
		int d = d1;
		result = role1;
		if(d2<d)
		{
			d =d2;
			result = role2;
		}
		if(d3<d)
		{
			d =d3;
			result = role3;
		}
		if(d4<d)
		{
			d =d4;
			result = role4;
		}

		return result;
	}
	//查找最近的目标 找对尾 或者城堡
	public testdybroleai GetOneNearEm()
	{
		int d1 = 0;
		testdybroleai role1 = Mymapmag.GetRoleInAreaNear (this,MymapPoint.x+100,MymapPoint.x-100, MymapPoint.z+100,MymapPoint.z-100,out d1);
		return role1;

	}
	//判定2个角色之间格子数距离  算xz中最大的
	public int GetRoleDis(testdybroleai role1,testdybroleai role2)
	{
		if(role2==null)
		{
			return 99999;
		}
		bool xjiaoji = false;
		bool zjiaoji = false;
		int dx = 0;
		int dz =0;
		if(role1.MymapPoint.x>=role2.MymapPoint.x&&role1.MymapPoint.x<=role2.MymapPoint.x+role2.mapcelllength||role2.MymapPoint.x>=role1.MymapPoint.x&&role2.MymapPoint.x<=role1.MymapPoint.x+role1.mapcelllength)
		{
			xjiaoji = true;
		}
		if(role1.MymapPoint.z>=role2.MymapPoint.z&&role1.MymapPoint.z<=role2.MymapPoint.z+role2.mapcellhigh||role2.MymapPoint.z>=role1.MymapPoint.z&&role2.MymapPoint.z<=role1.MymapPoint.z+role1.mapcellhigh)
		{
			zjiaoji = true;
		}
		if (xjiaoji == true ) 
		{
			if(zjiaoji ==true)
			{
				return 0;
			}
			else
			{
				if(role2.MymapPoint.z>role1.MymapPoint.z+role1.mapcellhigh)
				{
					dz = role2.MymapPoint.z-role1.MymapPoint.z-role1.mapcellhigh;
				}
				else
				{
					dz = role1.MymapPoint.z-role2.MymapPoint.z-role2.mapcellhigh;
					
				}
				return dz;
			}


		} else {
			if(role2.MymapPoint.x>role1.MymapPoint.x+role1.mapcelllength)
			{
				dx = role2.MymapPoint.x-role1.MymapPoint.x-role1.mapcelllength;
			}
			else
			{
				dx = role1.MymapPoint.x-role2.MymapPoint.x-role2.mapcelllength;

			}
			if(zjiaoji ==true)
			{
				return dx;
			}
			else
			{
				if(role2.MymapPoint.z>role1.MymapPoint.z+role1.mapcellhigh)
				{
					dz = role2.MymapPoint.z-role1.MymapPoint.z-role1.mapcellhigh;
				}
				else
				{
					dz = role1.MymapPoint.z-role2.MymapPoint.z-role2.mapcellhigh;
					
				}

				if(dz>dx)
				{
					return dz;
				}
				else
				{
					return dx;
				}

			}
		}

	/* 这是按中间值算
		int dx= role2.MymapPoint.x - role1.MymapPoint.x;
		if(dx<0)
		{
			dx=dx;
		}
		dx = dx - (role1.halfmapcelllength + role2.halfmapcelllength);
		int dz= role1.MymapPoint.z - role2.MymapPoint.z;
		if(dz<0)
		{
			dz=-dz;
		}
		dz = dz - (role1.halfmapcellhigh + role2.halfmapcellhigh);
		if(dz>dx)
		{
			return dz;
		}
		return dx;
		*/
	}
	public void moveAi()
	{
		//没有对手 
		if(camp==1&&Mynpcmag.cmap2Rolelist.Count<=0||camp==2&&Mynpcmag.cmap1Rolelist.Count<=0) //没有对手
		{
			//转为站立状态
			dostand();
			return;
		}
		bool atpos = checkAtduishou();
		if (atpos == true) {	//到达敌方队首
			testdybroleai thisrole = GetOneInAttEm ();
			if (thisrole != null) {  //攻击范围内查找有没优先的怪
				//有目标直接开始攻击
				//thisrole =GetOneInAttEm();
				doFight (thisrole);
				//清除移动
				return;
			} else {
				thisrole = GetOneInAlertEm ();

				if (thisrole != null) {  //警戒范围内查找有没优先的怪
					domove_toRole (thisrole);
					return;
				} else {
					atpos = checkAtduiwei ();
					if (atpos == true) {	//到达敌方队尾
						thisrole = GetOneNearEm ();
						if (thisrole != null) { //查找最近目标
							int dis = GetRoleDis (this, thisrole);
							if (dis > attrangeCell) {	//大于攻击范围
								//设置向目标移动  城堡也算攻击目标
								domove_toRole (thisrole);
							} else {
								//开始攻击
								//dis =GetRoleDis( this,thisrole);
								doFight (thisrole);
							}
						}
					}
				}
				
			}

		} else {
			if (lastactiontype == 2)
			{
				domove_forward();
			}
		}
		
	}
	
	public void attackAi()
	{
		//攻击目标死亡或者不在攻击范围内
		//这里改成被攻击者回调 死亡事件 和移动事件 来规避每帧检测
		
		if(chooseOneSkill()==true) //可以使用技能 或者普攻
		{
			useSkill = true;
			UseThisSkill();
			#if UseLookAt
			if(nowattrole!=null)
			{
				MyObj.transform.LookAt (nowattrole.GetRolePos());
			}
			#endif
		}

	}
	//选择个可以使用的技能
	public bool chooseOneSkill()
	{
        if (mynormalskill==null)
        {
            Debug.Log("chooseOneSkill mynormalskill==null MyUUID=" + MyUUID);


            return false;
        }
		return mynormalskill.CheckUse();
	}
	public void doPvpUseSkill()
	{
		nowstate = 2;
		useSkill = true;
		mynormalskill.UseSkill ();
	}
	//使用技能
	public void UseThisSkill()
	{
		lastactiontype = 3;
		//return false;
		mynormalskill.UseSkill ();

	}
	public bool CheckUseHeroSkill()
	{
		if(myskill1!=null)
		{
			return myskill1.CheckUse();
		}
		return false;
	}
	//UI 通知调用使用英雄技能
	public void UseHeroSkill(Vector3 pos)
	{
		if(myskill1!=null)
		{
			myskill1.m_tarpos = pos;
			myskill1.UseSkill();
		}
	}
	//被对方攻击设置为攻击目标了
	public void BeSetAttRole(testdybroleai thisrole)
	{
		if(attmerolelist.Contains(thisrole)==false)
		{
			//Debug.Log(name+" BeSetAttRole  "+ thisrole.name);
			attmerolelist.Add(thisrole);
		}
		
	}

	//对方取消设置为攻击目标了
	public void CancleBeSetAttRole(testdybroleai thisrole)
	{
		//Debug.Log (name + " CancleBeSetAttRole " + thisrole.name);
		if(attmerolelist.Contains(thisrole)==true)
		{
			attmerolelist.Remove(thisrole);
		}
		
	}
	//被攻击者移动了
	public void attrolemoveCB(testdybroleai thisrole,int xmove,int zmove)
	{
		//检查是否超过攻击距离 超过
		int dis = GetRoleDis( this,thisrole);
		if(dis>attrangeCell)	//大于攻击范围 
		{
			if(useSkill==true) //当前在使用技能
			{
				b_nowattroleoutatt=true;
			}
			else
			{
				//转到站立
				dostand();
			}
		}



	}

	//被攻击者死亡回调
	public void attroledieCB(testdybroleai thisrole)
	{
		//Debug.Log (MyObj.name+" roledieCB  "+thisrole.MyObj.name);

		//清除攻击者列表中该角色
		if (attmerolelist.Contains (thisrole) == true) {

			attmerolelist.Remove(thisrole);
		}

		//如果正在攻击 使用技能中  等待技能使用完 在切换
		if(useSkill==true)
		{
			b_nowattroledie = true;
			
		}
		else
		{
			nowattrole = null;
			dostand();
		}

	}
	float dieanimetime =1f;
	float usedieanimetime =0f;
	bool waitRecovery = false;
	public void SoMeDie()
	{
		//Debug.Log ("SoMeDie name="+MyObj.name+" camp="+camp);
		//if(MyPvpInfo.Count>0)
		//{
		//	Debug.Log ("SoMeDie name="+MyObj.name+" MyPvpInfo.Count="+MyPvpInfo.Count.ToString());
		//}
		IsDie = true;
		if(CallUi==1)
		{
			lgbtmag.Ins.Call_UI_HeroDie(this);
		}
		if(MyHpTip!=null)
		{
			MyHpTip.RoleDie();
			MyHpTip = null;
		}
		//如果非普通副本 要通知UI减少兵力
		if(MyBtType!= bttype_.fuben)
		{
			if(MyInip.MyRoledata.roletype == roletype_.typeyinxiong)
			{
				lgbtmag.Ins.Call_UI_Updatehp( camp,lgCfgMag.Ins.Herobinlin);
			}
			else if(MyInip.MyRoledata.roletype != roletype_.typechengbao)
			{
				lgbtmag.Ins.Call_UI_Updatehp( camp, lgCfgMag.Ins.SoldierBinlin[celllength - 1]);
			}
		}
#if MinMap
		if(b_haspostip ==true)
		{
			MyPosTip.RoleDie();
			MyPosTip = null;
			b_haspostip =false;
		}
#endif
		diepos = MyObj.transform.position;
		//停止技能
		if(mynormalskill!=null)
		{
			mynormalskill.Exit();
		}
		mynormalskill = null;
		//将模型还给工厂

		//数据不清空 防止有用 复活等

		//通知攻击者回调 死亡事件  来规避每帧检测
		for(int i=0;i<attmerolelist.Count;i++)
		{
			if(attmerolelist[i]!=null)
			{
				attmerolelist[i].attroledieCB(this);
			}

		}

		//通知特效删除
		for(int i=0;i<AddTxList.Count;i++)
		{
			AddTxList[i].TarDie();
		}

		attmerolelist.Clear ();
		useSkill = false;			//正在使用技能标志
		nowattrole =null; 
		nowstate = 0;
		Mynpcmag.RoleDie (this);

		/*
		if (haszuoqi == true) {
			tModleFactory.Ins.TempRecoveryObj (MyInip.MyRoledata.prefabname, MyRoleObj);
			MyRoleObj=null;
			tModleFactory.Ins.TempRecoveryObj(nowsitzuoqipname,MyObj);
			MyObj = null;
			haszuoqi =false;

		} else {
			tModleFactory.Ins.TempRecoveryObj(MyInip.MyRoledata.prefabname,MyObj);
			MyObj = null;
		}
		*/
		//开始播放死亡动画
		PlayAnim ("die");
		usedieanimetime = 0f;
		waitRecovery = true;
	}

	public void Recovery()
	{
		//Mynpcmag.RoleDie (this);
		Mynpcmag.RecoveryRole (this);
		//MyObj.SetActive (false);
		//Mynpcmag.testdybcs.MyModleFactory.TempRecoveryObj ("FOOTMAN3_2_p",MyObj);
		
		if (haszuoqi == true) {
			tModleFactory.Ins.TempRecoveryObj (MyInip.MyRoledata.prefabname, MyRoleObj);
			MyRoleObj=null;
			tModleFactory.Ins.TempRecoveryObj(nowsitzuoqipname,MyObj);
			MyObj = null;
			haszuoqi =false;
			
		} else {
			tModleFactory.Ins.TempRecoveryObj(MyInip.MyRoledata.prefabname,MyObj);
			MyObj = null;
		}
	}

	public void Exit()
	{
		//将模型还给工厂


		//清除占用的数据
		if (IsDie == false) {
			IsDie = true;
			diepos = MyObj.transform.position;
			//停止技能
			if (mynormalskill != null) {
				mynormalskill.Exit ();
			}
			mynormalskill = null;
			attmerolelist.Clear ();
			useSkill = false;			//正在使用技能标志
			nowattrole = null; 
			nowstate = -1;

			if (haszuoqi == true) {
				tModleFactory.Ins.TempRecoveryObj (MyInip.MyRoledata.prefabname, MyRoleObj);
				MyRoleObj = null;
				tModleFactory.Ins.TempRecoveryObj (nowsitzuoqipname, MyObj);
				MyObj = null;
				haszuoqi = false;
				
			} else {
				tModleFactory.Ins.TempRecoveryObj (MyInip.MyRoledata.prefabname, MyObj);
				MyObj = null;
			}


			//GameObject.Destroy(MyObj);
			//MyObj = null;
			//if (haszuoqi == true) {
			//	GameObject.Destroy(MyRoleObj);
			//}
			//MyRoleObj=null;
		} else {

			if (haszuoqi == true) {
				if(MyRoleObj!=null)
				{
					tModleFactory.Ins.TempRecoveryObj (MyInip.MyRoledata.prefabname, MyRoleObj);
					MyRoleObj = null;
				}
				if(MyObj != null)
				{
					tModleFactory.Ins.TempRecoveryObj (nowsitzuoqipname, MyObj);
					MyObj = null;
				}
				haszuoqi = false;
				
			} else {
				if(MyObj != null)
				{
					tModleFactory.Ins.TempRecoveryObj (MyInip.MyRoledata.prefabname, MyObj);
					MyObj = null;
				}
			}
		}
	}
	//角色AI相关
	bttype_ MyBtType;
	public bool StopMelfAi = false;
	bool SkillDamCBUI =false;
	int qulity = -1;
	public void Pcreate(IniRoleP_ inip,tMapPointInfo mapmag,tBtNpcmag npcmag)
	{

		MyInip = inip;
		MyHpTip = null;
		lvl=MyInip.lvl;						//等级
		qulitylvl=MyInip.qulitylvl;				//品质等级  绿色+2
		MyDepart=MyInip.MyRoledata.roleDepart;	//所属系别
		roletype = MyInip.MyRoledata.roletype;
		int dbid = MyInip.MyRoledata.DBid;
		qulity = dbid % 10;
		//public int nowsitzuoqiid;   //当前坐骑编号
		haszuoqi = false;
		nowsitzuoqipname=MyInip.nowsitzuoqipname;	//当前坐骑模型名字


		MyUUID = inip.UUID;
		if(MyUUID==null||MyUUID=="")
		{
			MyUUID = tModleFactory.Ins.GetBtUuid ().ToString ();
		}
		MyInimapPoint = inip.MyInimapPoint;
		Mymapmag = mapmag;
		Mynpcmag = npcmag;
		f_updatemovedis = mapmag.f_updatemovedis;
		camp = MyInip.camp;
		name = MyInip.MyRoledata.name;

		//hp = MyInip.MyRoledata.hp;	//测试数据
		//att = MyInip.MyRoledata.att;

		attrange = MyInip.MyRoledata.attrange;	//角色攻击距离 策划用 配置
		alertrange = MyInip.MyRoledata.alertrange;	//角色警戒距离 策划用 配置
		attrangeCell = attrange*Mymapmag.i_rolecellbimapcell;	//角色攻击距离 地图格子
		alertrangeCell = alertrange*Mymapmag.i_rolecellbimapcell;	//角色警戒距离 地图格子
		if(alertrange<attrange)
		{
			Debug.LogError("Error  alertrange<attrange DBID= "+MyInip.MyRoledata.DBid.ToString());
		}
		//mspeed = MyInip.MyRoledata.movespeed;

		//oldPosList.Clear ();
		//nowPosList.Clear ();

		//根据 thisroletype 查找 占用格子数
		tPoint_ lh;
        lgCfgMag.Ins.GetRoleCellCfg(roletype, out lh);
		celllength = lh.x;
		cellhigh = lh.z;
		mapcelllength = celllength * Mymapmag.i_rolecellbimapcell-1;
		mapcellhigh = cellhigh * Mymapmag.i_rolecellbimapcell-1;
		//halfmapcelllength = mapcelllength/2;
		//halfmapcellhigh = mapcellhigh/2;
		
		
		MymapPoint.x = (MyInimapPoint.x-1) * Mymapmag.i_rolecellbimapcell +1;
		MymapPoint.z = (MyInimapPoint.z-1) * Mymapmag.i_rolecellbimapcell + 1;
		//oldPos.x = MymapPoint.x;
		//oldPos.z = MymapPoint.z;

		nowPosList = GetOncemapPos ();

		useSkill = false;			//正在使用技能标志
		nowattrole =null; 
		nowstate = 0;
		IsDie = false;
		starttime = 0f;
		lastactiontype = -1;
		//角色是否有优先级攻击目标类型
        haspriorityatt = lgCfgMag.Ins.GetAttpriorityCfg(roletype, out MyPriorityattList);
		StopMelfAi = false;
		MyBtType = lgbtmag.Ins.GetMapType ();
		if(MyBtType==bttype_.pvp)
		{

			MyPvpUUID = inip.pvpuuid;
			//去取AI 控制
			string pvpinfo = lgbtmag.Ins.GetRolePvpInfo(MyPvpUUID);
			fenxipvpinfo(pvpinfo);
			StopMelfAi = true;
		}
		if(MyBtType==bttype_.bosspvp)
		{
			MyPvpUUID = inip.pvpuuid;
		}
		if(MyPop==null)
		{
			MyPop = new lgRoleBtPop();

		}
		SkillDamCBUI =false;
		//如果是英雄 并且有UUID 则查询属性要包括装备的 其它小兵 都是计算属性
		rolepop_ basepop;
		if (MyInip.MyRoledata.roletype == roletype_.typeyinxiong)
		{
			if(MyBtType==bttype_.pvp)
			{
				basepop = lgCfgMag.Ins.GetRolePvpPop_ByUUID (MyUUID);
				//basepop = lgCfgMag.Ins.GetRolePop (MyInip.MyRoledata.DBid, lvl, qulitylvl);  //snbug
			}
			else if(  MyBtType==bttype_.fuben&&MyInip.camp==1)//本地副本  阵营1 或者pvp副本
			{
				SkillDamCBUI =true;
				basepop = lgCfgMag.Ins.GetRolePop_ByUUID (MyBtType,camp,MyUUID);
			}
			else
			{
				//本地副本  阵营2 的英雄 
				basepop = lgCfgMag.Ins.GetRolePop (MyInip.MyRoledata.DBid, lvl, qulitylvl);  //snbug
			}
			if(nowsitzuoqipname==""||nowsitzuoqipname=="0")
			{
				nowsitzuoqipname = MyInip.MyRoledata.nowsitzuoqipname;
				//if(nowsitzuoqipname=="ma_01")
				//{
				//	nowsitzuoqipname="Mount1_1";
				//}
			}
		} else 
		{	//小兵 城堡
			basepop = lgCfgMag.Ins.GetRolePop (MyInip.MyRoledata.DBid, lvl, qulitylvl);  //snbug
		}
		/*
		if (MyInip.MyRoledata.roletype == roletype_.typetoushiche) {
			needammosendposadd=true;
			ammosendposaddx = 3f;
			ammosendposaddy =4f;
		} else {
			needammosendposadd=false;
			ammosendposaddx = 0f;
			ammosendposaddy = 0f;
		}
		*/
		Vector2 addposinfo;
		needammosendposadd = lgCfgMag.Ins.GetAmmoSendPosAddInfo (MyInip.MyRoledata.roletype,out addposinfo);
		if(needammosendposadd==true)
		{
			ammosendposaddx = addposinfo.x;
			ammosendposaddy = addposinfo.y;
		}
		MyPop.IniSome (this, basepop);
		//计算符文增加血量和攻击
		CheckPopAdd(MyInip.MyFuwenData,MyDepart);

		//计算副本增加属性  血量和攻击
		if(MyInip.HpAdd!=0f)
		{
			MyPop.FubenHpAdd(MyInip.HpAdd);
		}
		if(MyInip.AttAdd!=0f)
		{
			MyPop.FubenAttAdd(MyInip.AttAdd);
		}
		if(MyInip.IniHp>0)
		{
			MyPop.SetIniNowHp(MyInip.IniHp);
		}
		//Debug.LogError ("uuid = "+MyUUID+" dbid= "+MyInip.MyRoledata.DBid.ToString() +" inihp = "+MyPop.GetNowPop_Life().ToString()+" attack ="+MyPop.GetNowPop_Attack().ToString());
		MyPop.GetMoveSpeed ();
		myGetOneObjCB = LoadModleCB;
		//加载模型 
		//LoadModleCB(Mynpcmag.testrolemodle);
		//Mynpcmag.testdybcs.MyModleFactory.GetOneObj ("FOOTMAN3_2_p",myGetOneObjCB);
		if (MyInip.MyRoledata.roletype == roletype_.typechengbao) {
			tModleFactory.Ins.GetOneObj ("chengbao", myGetOneObjCB);
		} else {
			tModleFactory.Ins.GetOneObj (MyInip.MyRoledata.prefabname, myGetOneObjCB);
		}
	}
	//
	public void CheckPopAdd(FuwenData_ MyFuwenData,roleDepartment_ MyDepart)
	{
		MyPop.CheckPopAdd (MyFuwenData,MyDepart);
	}
	List<RolePvpAiInfo_> MyPvpInfo = new List<RolePvpAiInfo_>();
	public void fenxipvpinfo(string pvpinfo)
	{
		MyPvpInfo.Clear();
		string[] temp= pvpinfo.Split (';');
		for(int i=0;i<temp.Length&&temp[i]!="";i++)
		{
			string[] temp1 = temp[i].Split(',');
			RolePvpAiInfo_ info = new RolePvpAiInfo_();
			info.eveid = int.Parse(temp1[0]);
			info.starttime = float.Parse(temp1[1]);
			info.plist = new List<string>();
			for(int k=2;k<temp1.Length;k++)
			{
				info.plist.Add(temp1[k]);
			}
			MyPvpInfo.Add (info);
		}
	}
	float starttime;
	void CheckPvpAi()
	{
		if(MyPvpInfo.Count>0&&(starttime>=MyPvpInfo[0].starttime||MyPvpInfo[0].starttime-starttime<0.002f))
		{
			DoPvpAi();
		}
	}
	void DoPvpAi()
	{
		//
		switch(MyPvpInfo[0].eveid)
		{
			case 1:
			float inix= float.Parse(MyPvpInfo[0].plist[0]);
			float iniz= float.Parse(MyPvpInfo[0].plist[1]);
			float tarx= float.Parse(MyPvpInfo[0].plist[2]);
			float tarz= float.Parse(MyPvpInfo[0].plist[3]);
			domove_pvp(inix,iniz,tarx,tarz);


			break;
			case 2:
			string tarrole= MyPvpInfo[0].plist[0];
			nowattrole = Mynpcmag.GetThisRoleByUUid(tarrole);
			//UseThisSkill();
			doPvpUseSkill();
			break;


		}

		MyPvpInfo.RemoveAt(0);
	}

	public void LoadModleCB(GameObject prefab_)
	{
		//MyObj = GameObject.Instantiate(prefab_) as GameObject;
		prefab_.transform.localScale = Vector3.one;
		MyObj = prefab_;
		MyRoleObj = prefab_;
		float posx = (MyInimapPoint.x - 1 + celllength / 2) * Mymapmag.cu_mapcell;
		float posy = 0f;
		float posz = (MyInimapPoint.z - 1 + cellhigh / 2) * Mymapmag.cu_mapcell;
		MyObj.transform.localPosition = new Vector3(posx,posy,posz);
		oldpos = MyObj.transform.position;
        //MyObj.name = MyInip.MyRoledata.name;
		MyObj.name = MyUUID;
		//设置朝向  根据阵营
		if(camp==1)
		{

			MyObj.transform.LookAt(new Vector3(posx+10,posy,posz));
		}
		else
		{
			MyObj.transform.LookAt(new Vector3(posx-10,posy,posz));
		}
		MyMountList = MyObj.GetComponent<lgRoleMountList>();
		//IniSome ();
		bool showweaponps = false;
		if(qulity>=6&&MyInip.MyRoledata.roletype == roletype_.typeyinxiong)
		{
			showweaponps = true;
		}
		if(MyMountList!=null)
		{
			for (int i=0; i<MyMountList.WeaponPsList.Length; i++)
			{
				if(MyMountList.WeaponPsList[i]!=null)
				{
					if(showweaponps==true)
					{
						MyMountList.WeaponPsList[i].Play();
					}
					else
					{
						MyMountList.WeaponPsList[i].Stop();
					}
				}
			}
		}
		if (nowsitzuoqipname != "0"&&nowsitzuoqipname!="") {

			myGetOneObjCB = LoadHorseCB;
			tModleFactory.Ins.GetOneObj(nowsitzuoqipname, myGetOneObjCB);
		} else {
			IniSome ();
		}

	}

	public void LoadHorseCB(GameObject prefab_)
	{

		Animation horseani=prefab_.GetComponent<Animation>();
		//2016.10.20 又改回每个角色自带动作 不用添加了
		//horseani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.waitList[0],"wait");
		//horseani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.walkList[0],"walk");
		//horseani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.dieList[0],"die");
		//horseani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.attackList[0],"attack");


		lgRoleMountList zuoqimounts = prefab_.GetComponent<lgRoleMountList> ();
		GameObject obj = zuoqimounts.ZuojiMountList[0];
		if (obj != null) {

			prefab_.transform.position = MyRoleObj.transform.position;
			prefab_.transform.rotation = MyRoleObj.transform.rotation;

			MyRoleObj.transform.parent = obj.transform;
			MyRoleObj.transform.localPosition = Vector3.zero;
			MyRoleObj.transform.localRotation = Quaternion.identity;
		} else {
			Debug.LogError("Error No MountOBj "+MyInip.MyRoledata.prefabname);
		}
		MyObj = prefab_;
		haszuoqi = true;
		IniSome ();
	}
	public void CreateFinish()
	{
		MyObj.SetActive (true);
		if(haszuoqi == true)
		{
			MyRoleObj.SetActive (true);
		}
		Mynpcmag.CreateFinish (this);
		//向地图更新角色占用格子
		//oldpos= 
		if(CallUi==1)
		{
			//通知界面
			lgbtmag.Ins.Call_UI_CreateHeroFinish(this);
		}
	}

	//得到当前位置的占用格子
	public List<tPoint_> GetOncemapPos()
	{
		List<tPoint_> addlist = new List<tPoint_> ();

		for(int i =0;i<=mapcellhigh;i++)
		{
			for(int k =0;k<=mapcelllength;k++)
			{
				tPoint_ temppos;
				temppos.x = MymapPoint.x+k;
				temppos.z = MymapPoint.z+i;
				addlist.Add(temppos);
			}
		}
		return addlist;
	}

	//角色移动格子更改了 计算离开格子 和进入格子
	public void moveOncemapPos(int xadd,int zadd ,ref List<tPoint_> leavelist,ref List<tPoint_> addlist)
	{
		//List<tPoint_> newlist = new List<tPoint_> ();
		int newx = 0;
		int newz = 0;

		int oldxmin = MymapPoint.x;
		int oldzmin = MymapPoint.z;

		int oldxmax = oldxmin+mapcelllength;
		int oldzmax = oldzmin+mapcellhigh;

		int newxmin = oldxmin+xadd;
		int newzmin = oldzmin+zadd;
		
		int newxmax = newxmin+mapcelllength;
		int newzmax = newzmin+mapcellhigh;

		for(int i =0;i<nowPosList.Count;i++)
		{
			tPoint_ temp;
			temp.x = nowPosList[i].x;
			temp.z= nowPosList[i].z;
			if(nowPosList[i].x<newxmin||nowPosList[i].x>newxmax||nowPosList[i].z<newzmin||nowPosList[i].z>newzmax) //如果老点 不在新的范围内 则是删除的
			{

				leavelist.Add(temp);
			}

			temp.x+=xadd;
			temp.z+=zadd;
			nowPosList[i] = temp;
			if(nowPosList[i].x<oldxmin||nowPosList[i].x>oldxmax||nowPosList[i].z<oldzmin||nowPosList[i].z>oldzmax) //如果新的点 不在老的范围内 则是新增加的
			{
				addlist.Add(temp);
			}
		}
		MymapPoint.x=newxmin;
		MymapPoint.z=newzmin;

	}

	public void PlayAnim(string anim)
	{
		//切换动作
		//if(nowplayani!=anim)
		//{	
		//	nowplayani = anim;
		//	myani.CrossFadeQueued(nowplayani,0.3f, QueueMode.PlayNow);
		//}
		if (myani!=null&&myani.IsPlaying (anim) == false) 
		{
			//myani.CrossFadeQueued(anim,0.3f, QueueMode.PlayNow);
			myani.Play(anim);
		}
		if (haszuoqi == true&&myzuoqiani.IsPlaying (anim) == false) {
			//myzuoqiani.CrossFadeQueued(anim,0.3f, QueueMode.PlayNow);
			myzuoqiani.Play(anim);
		}
	}

    public Vector3 GetRolePos()
    {
		//if(MyObj==null)
		//{
		//	Debug.LogError("GetRolePos MyObj==null "+ IsDie);
		//}
		if (IsDie == true) {
			return diepos;
		} else {
			return MyObj.transform.position;
		}
    }
	bool needammosendposadd = false;
	float ammosendposaddx = 0f;
	float ammosendposaddy = 0f;
	//得到角色弹药发射点位置
	public Vector3 GetRoleAmmoSendPos()//Vector3 tarpos)
	{
		Vector3 result;
		if (IsDie == true) {
			result= diepos;
		} else {
			result= MyObj.transform.position;
		}
		if(needammosendposadd==false)
		{
			return result;
		}
		//检查弹药发射偏移 比如投石车
		//设定角色不做旋转  只是左右朝向
		/*
		result.y = 0f;
		tarpos.y = 0f;

		Vector3 fangxiang = tarpos - result;
		fangxiang.Normalize ();
		fangxiang.x = -fangxiang.x;
		fangxiang.z = -fangxiang.z;
		result.x = result.x + ammosendposaddx*fangxiang.x ;
		result.z = result.z + ammosendposaddx*fangxiang.z ;
		*/
		if (MyObj.transform.forward.x > 0) {
			result.x = result.x - ammosendposaddx ;
			result.y = ammosendposaddy;
		} else {
			result.x = result.x + ammosendposaddx ;
			result.y = ammosendposaddy;
		}
		return result;
	}

    public skillbase CreateSkillCS(string csname)
    {
        switch (csname)
        {
            case "tnormalskill": return new tnormalskill();
            case "farBaozhaSkill": return new farBaozhaSkill();
            case "farNormalSkill": return new farNormalSkill();
            case "normalQunSkill": return new normalQunSkill();

			case "heroskill1": return new heroskill1();
			case "heroskill2": return new heroskill2();
        }
        return null;

    }
    public void IniSkill()
    {
        //根据 DBid 查找所带的技能
        skilldata_ thisskilldata;
        //Debug.Log("IniSkill--" + MyInip.MyRoledata.skillNormalDBid + "   " + MyInip.MyRoledata.skillDBid);

        if (MyInip.MyRoledata.skillNormalDBid != 0)
        {
            thisskilldata = lgCfgMag.Ins.Get_SkillData(MyInip.MyRoledata.skillNormalDBid);

            if (mynormalskill == null)
            {
               // Debug.Log("mynormalskill==null--" + thisskilldata.skillCsName + " MyUUID=" + MyUUID);

                mynormalskill = CreateSkillCS(thisskilldata.skillCsName);

            }
           
		    mynormalskill.IniSome (this,thisskilldata,true);
			mynormalskill.DamToChengbao =true;
			MyPop.GetNomalSkillCD();
        }else
        {
            mynormalskill = null;
        }
        if (MyInip.MyRoledata.skillDBid != 0)
        {
            thisskilldata = lgCfgMag.Ins.Get_SkillData(MyInip.MyRoledata.skillDBid);

            if(myskill1==null)
            {
                myskill1 = CreateSkillCS(thisskilldata.skillCsName);
            }
           
            myskill1.IniSome(this, thisskilldata,false);
			myskill1.DamToChengbao =false;
			if(SkillDamCBUI == true)
			{
				myskill1.CB_SkillDam=true;
			}
        }
        else
        {
            myskill1 = null;
        }

    }

    //造成伤害通知
    public int BeDam(int dam,roleDepartment_ attdepart)//,skillbase sk)
    {
        //通知属性管理器 由属性管理器来发送死亡事件 通知UI 血条显示等

		//hp -= dam;
		//if (hp <= 0)
       // {
			//if(MyPvpInfo.Count>0)
			//{
			//	Debug.LogError("MyPvpInfo.Count="+MyPvpInfo.Count);
			//}



         //   hp = 0;
         //   SoMeDie();
        //}
		float damadd = lgCfgMag.Ins.GetDepartAddDam (attdepart,MyDepart); //根据克制关系 得到伤害加成或者减免
		float damadd2 = 0f;
		if(MyReduceDamDepart!= roleDepartment_.D_Null&& attdepart==MyReduceDamDepart) //减伤系别
		{
			damadd2= ReduceDamNum;				//减伤系数
		}
		//float damadd2 = MyPop.GetFuwenAdd (attdepart);			//根据自己是否带了免伤符文 得到伤害减免
		return MyPop.BeDam (dam,damadd,damadd2);

    }

    //请求添加buff
    public void AskDoBuff(buffbase thisbuff )
    {
       //通知角色buff管理器
        Myrolebuffmag.AskDoBuff(thisbuff);
    }

    public void BuffQuit(buffbase thisbuff)
    {
        //通知角色buff管理器
        Myrolebuffmag.BuffQuit(thisbuff);
    }


    public buffbase CreateOnebuff()
    {
        return Mynpcmag.CreateOnebuff();
    }


	public GameObject GetMountObj(int mounttype,int mountid)
	{
		if(MyMountList!=null)
		{
			switch(mounttype)
			{
				case 1: //头  1
				return MyMountList.HeadMountList[mountid];
				break;
				case 2: //武器 2
				return MyMountList.WeaponMountList[mountid];
				break;
				case 3: //坐骑 3
				return MyMountList.ZuojiMountList[mountid];
				break;
			}
		}
		return null;
	}

	public void AddTx(lgTxbase thistx)
	{
		AddTxList.Add (thistx);
	}
	public void DieTx(lgTxbase thistx)
	{
		AddTxList.Remove (thistx);
	}

	public void CreateFinishCallUI(int callui)
	{
		CallUi = callui;
	}
	public void SetNomalSkillCD(float cd)
	{
		mynormalskill.SetSkillCD (cd);
	}
	public void SetMoveSpeed(float speed)
	{

		if(nowstate==1)	//如果正在移动 要更改剩余移动时间 snbug
		{
			//usemovetime/oncemovetime
			oncemovetime = oncemovetime-usemovetime;
			oncemovetime = oncemovetime*(mspeed/speed);
			inipos = MyObj.transform.position ;
			usemovetime = 0f;
		}
		mspeed = speed;
	}
	//城堡用设置血量
	public void SetBaseHp(int basehp)
	{
		MyPop.SetBaseHp (basehp);
	}

	//扣血回调
	public void CB_ReduceHp(int v)
	{
		//如果城堡  通知扣血
		if (MyInip.MyRoledata.roletype == roletype_.typechengbao) 
		{
			lgbtmag.Ins.Call_UI_Updatehp( camp, v);
		}
		if(MyHpTip!=null)
		{
			MyHpTip.updatahp(MyPop.GetNowPop_Life());
		}
	}
	public void GetHeroSkillTipInfo(ref string at)//,ref string sp)
	{
		if(myskill1!=null)
		{
			myskill1.GetSkillTipInfo (ref at);//,ref sp);
		}
	}

	public void SkillDamCB(int dam,Vector3 tarpos)
	{
		//如果需要提示UI伤害
		if(SkillDamCBUI ==true)
		{
			lgbtmag.Ins.Call_UI_SkillDam( dam,tarpos);
		}

	}
	//设置血条管理
	UiTipHp MyHpTip;
	public void SetHpTip(UiTipHp thistip)
	{
		MyHpTip = thistip;
	}
	public int GetBasePop_Life()
	{
		return MyPop.GetBasePop_Life();
	}
	public int GetNowPop_Life()
	{
		return MyPop.GetNowPop_Life();
	}
	public bool IsMoveing()
	{
		return nowstate==1;
	}
#if MinMap
	//设置小地图管理
	bool  b_haspostip = false;
	UiRolePos MyPosTip;
	public void SetPosTip(UiRolePos thistip)
	{
		MyPosTip = thistip;
	}

	public void UpdataPosTip()
	{
		if(MyPosTip!=null)
		{
			MyPosTip.updatapos (MymapPoint);
		}
	}
#endif

	//得到角色面前的起点
	public void GetFaceIniPos(ref int posx1,ref int posx2,ref int posz1,ref int posz2,int addx,int addz)
	{

		if (MyObj.transform.forward.x > 0) {
			posz1 = MymapPoint.z;
			posz2 = posz1+addz;
			posx1 = MymapPoint.x + mapcelllength;
			posx2 = posx1+addx;
		} else {
			posx2 = MymapPoint.x;
			posz1 = MymapPoint.z;

			posx1 = posx2-addx;
			posz2 = posz1+addz;
		}
	}
}
