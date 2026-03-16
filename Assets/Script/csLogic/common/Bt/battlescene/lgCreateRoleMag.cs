using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//角色占用人口表



//本地副本 人口 出怪 管理
//15个出口轮一遍 后才开始下一轮出
//每100毫秒出个 符合人口的 怪 不符合人口 则跳过这次
public class lgCreateRoleMag 
{
	public int Camp1Renkou = 0;  //阵营1当前人口
	public float luntime = 10f;	//每轮时间 10秒
	private float useluntime=0f;
	float olduseluntime=0f;
	public int lun = 10;  //战斗10轮
	private int uselun=0;
	public int[] camp1renkouzenjia = {30,40,60,60,60,60,60,60,60,60};	//阵营1 每轮开始设置人口到上限的值
	//public int[] camp1renkouzenjia = {5,5,5,5,5,5,5,5,5,5};	//阵营1 每轮开始设置人口到上限的值

	public int camp1chukou = 12;		//阵营1 出兵口 数量  玩家
	public int camp2chukou = 12;		//阵营2 出兵口 数量   副本怪物

	//private int usecamp1chukounum = 0;		//阵营1 出兵口 数量  玩家
	//private int usecamp2chukounum = 0;		//阵营2 出兵口 数量   副本怪物

	//public Dictionary<roletype_,float> renkouzhanyongbiao;// = new Dictionary<roletype_, float>(); //人口占用表
	public List<tPoint_> camp1chubingpos = new List<tPoint_> ();
	public List<tPoint_> camp2chubingpos = new List<tPoint_> ();
	public int[] camp1randomchukou = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
	public int[] camp2randomchukou = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
	private int nowusechukou1 = 0;	//阵营1当前使用出口出兵
	private int nowusechukou2 = 0;   //阵营2当前使用出口出兵

	public int xmax;
	public int zmax;

	public int camp1createx = 1;
	public int camp2createx = 1;
	public bool startbt =false;
	public bool pausebt =false;
	public float createoneroletime = 0.1f; //100毫秒出一个角色
	public float usecreateoneroletime = 0f; //100毫秒出一个角色

	//创建怪物相关
	public List<CreateWaveInfo_> MonsterInfoList ;//= new List<CreateWaveInfo_>();
	public CreateWaveInfo_ NowMonsterInfo;
	int[] NowMonsterInfoNum = new int[4];
	public int NowMonsterid = 0;
	public float usechangeMonstertime = 0f;
	public int CreateCamp2RoleOrder = 0;


	//Ui设置 创建camp1相关
	public int MyHeroDbid;
	//public string MyHerouuid;
	public List<int> MyRoleDbid=new List<int>() ;
	private int usecreatemyroleid =0;
	private Roledata_ herodata;
	private int heroneedrenkou = 0;
	private List<Roledata_> myrolesdata=new List<Roledata_>();
	private List<int> myrolesneedrenkou=new List<int>();

	PlayInfo_ MyPlayInfo;

	public float HpAdd;		//副本血量加成
	public float AttAdd;	//副本攻击加成



	public void IniSome(mapInfo_ thismapInfo_,PlayInfo_ tempMyPlayInfo)
	{
		MyPlayInfo = tempMyPlayInfo;
		startbt =false;
		pausebt =false;
		int xmax=thismapInfo_.Length;
		int zmax= thismapInfo_.Wide;
		MonsterInfoList = thismapInfo_.Wave_Info;

		HpAdd = thismapInfo_.HpAdd;		//副本血量加成
		AttAdd= thismapInfo_.AttAdd;	//副本攻击加成

		//初始化人口占用表
		//renkouzhanyongbiao = thisrenkouzhanyongbiao;
		camp1createx = thismapInfo_.Camp1CreateX;//thiscamp1createx;
		camp2createx = thismapInfo_.Camp2CreateX;
		int jiange1 = (int)(zmax/camp1chukou);
		int jiange2 = (int)(zmax/camp2chukou);
		int tempz = 0;
		//计算出兵格子位置
		for(int i=0;i<camp1chukou;i++)
		{
			tPoint_ temp= new tPoint_();
			temp.x = camp1createx;
			tempz = i*jiange1+1;
			if(tempz>zmax)
			{
				temp.z = zmax;
			}
			else{
				temp.z = tempz;
			}
			//Debug.LogError("camp1  i="+i+" pos= "+temp.x+"  "+temp.z);
			camp1chubingpos.Add(temp);
		}
		for(int i=0;i<camp2chukou;i++)
		{
			tPoint_ temp= new tPoint_();
			temp.x = camp2createx;
			tempz = i*jiange2+1;
			if(tempz>zmax)
			{
				temp.z = zmax;
			}
			else{
				temp.z = tempz;
			}
			//Debug.LogError("camp2  i="+i+" pos= "+temp.x+"  "+temp.z);
			camp2chubingpos.Add(temp);
		}


		RandomChukouId(1);
		RandomChukouId(2);

		MyHeroDbid = -1;

		MyRoleDbid.Clear ();
		myrolesdata.Clear ();
		myrolesneedrenkou.Clear ();
		//初始化副本10波怪物信息
		//MonsterInfoList.Add ();
	}



	//开始副本战斗
	public void StartBt()
	{

		startbt =true;
		pausebt =false;



		nowusechukou1 = 0;	//阵营1当前使用出口出兵
		nowusechukou2 = 0;   //阵营2当前使用出口出兵
		//usecamp1chukounum=0;
		//usecamp2chukounum=0;

		usecreateoneroletime = 0f;
		NowMonsterid = 0;
		//NowMonsterInfo = MonsterInfoList [0];
		usechangeMonstertime = 0f;
		uselun=1;
		usecreatemyroleid =0;
		StartLun (uselun);

		//测试数据
		//ChangeHero(1003);
		//ChooseRole(1001);
		//ChooseRole(1002);
		//ChooseRole(1004);
	}
	public void StartLun(int lunnum)
	{
		//设置阵营1人口
		//if(lunnum<2)
		//{
		Camp1Renkou = camp1renkouzenjia [uselun - 1];
		//}
		//通知UI修改 人口 显示
		lgbtmag.Ins.Set_UI_Renkou (Camp1Renkou);

		//通知UI修改 
		lgbtmag.Ins.Set_UI_RoundNum (lunnum);

		useluntime = luntime;
		olduseluntime = useluntime;
		lgbtmag.Ins.SetRoundTime ((int)useluntime);

	}
	//暂停战斗
	//public void PauseBt(bool pause)
	//{
	//	pausebt =pause;
	//}

	public void update(float dt)
	{
		if(startbt==true)//&&pausebt==false)
		{
			if(uselun<=lun)
			{
				useluntime-=dt;

				if(olduseluntime-useluntime>1)
				{
					olduseluntime=olduseluntime-1;
					lgbtmag.Ins.SetRoundTime ((int)olduseluntime);
				}


				if(useluntime<=0f)
				{
					uselun++;
					if(uselun<=lun)
					{

						StartLun(uselun);
					}
					//else if(uselun==lun)
					//{
					//	StartLun(uselun);
						//开始检查胜利失败了  因为第10轮开始了
					//}
				}

			}

			if(NowMonsterid<MonsterInfoList.Count)
			{
				//if(NowMonsterid<2)
				//{

				
				usechangeMonstertime+=dt;
				if(usechangeMonstertime>=MonsterInfoList[NowMonsterid].WaveCreateTime)
				{

					NowMonsterInfo = MonsterInfoList [NowMonsterid];
					for(int i=0;i<4;i++)
					{
						NowMonsterInfoNum[i] =  NowMonsterInfo.Num[i];
					}
					NowMonsterid++;
					CreateCamp2RoleOrder = 0;
				}
				//}
			}

			usecreateoneroletime-=dt;
			if(usecreateoneroletime<=0)
			{
				usecreateoneroletime =createoneroletime;
				//创建一个阵营1的怪
				CreateCamp1Role();
				//创建一个阵营2的怪
				CreateCamp2Role();
			}
		}

	}
	//退出战斗
	public void ExitBt()
	{
		startbt =false;
		Setheroneedrenkou = -1;
		//pausebt =false;
	}

	//玩家选中英雄
	public void ChangeHero(int changeid)
	{
		MyHeroDbid = changeid;
		if (MyHeroDbid != -1) {
			herodata = lgCfgMag.Ins.Get_RoleData (MyHeroDbid);
			heroneedrenkou = lgCfgMag.Ins.Get_renkouzhanyong(herodata.roletype);
		}
	}
	//玩家选中小兵
	public void ChooseRole(int changeid)
	{

		if (MyRoleDbid.Count > 3) {
			MyRoleDbid.RemoveAt(0);
			myrolesdata.RemoveAt(0);
			myrolesneedrenkou.RemoveAt(0);
		}
		MyRoleDbid.Add (changeid);
		Roledata_ thisdata = lgCfgMag.Ins.Get_RoleData (changeid);
		myrolesdata.Add (thisdata);
		myrolesneedrenkou.Add (lgCfgMag.Ins.Get_renkouzhanyong (thisdata.roletype));

	}

	int Listfind(List<int> thislist,int v1)
	{
		int result = -1;
		for(int i=0;i<thislist.Count;i++)
		{
			if(thislist[i]==v1)
			{
				result = i;
				break;
			}
		}
		return result;
	}
	//玩家取消选中小兵
	public void CancelChooseRole(int changeid)
	{
		int pos= Listfind(MyRoleDbid,changeid);
		if(pos!=-1)
		{
			MyRoleDbid.RemoveAt(pos);
			myrolesdata.RemoveAt(pos);
			myrolesneedrenkou.RemoveAt(pos);
		}

	}
	int tempheroneedrenkou = 0;
	public int Setheroneedrenkou = -1;		//设置英雄所要人口  新手引导用
	public void CreateCamp1Role()
	{
		if(Camp1Renkou>0||Setheroneedrenkou!=-1)
		{
			//根据UI选择 来判定创建哪个怪

			//如果有英雄要创建  创建
			if(MyHeroDbid>0)
			{

				if(Setheroneedrenkou!=-1)
				{
					tempheroneedrenkou = Setheroneedrenkou;
				}
				else
				{
					tempheroneedrenkou = heroneedrenkou;
				}
				if(Camp1Renkou>=tempheroneedrenkou)
				{
					lgbtmag.Ins.Call_UI_LockCreateHero();
					int id =camp1randomchukou[nowusechukou1];
					IniRoleP_ inip = new IniRoleP_();//,int num
					inip.camp = 1;
					FightRoleInfo_ thisroleinfo =  GetFightRoleInfo(1,MyHeroDbid);
					//inip.InBsId = -2;
					inip.UUID = thisroleinfo.UUID;//MyHerouuid;//tModleFactory.Ins.GetBtUuid().ToString();
					inip.lvl = thisroleinfo.Lvl;
					inip.qulitylvl = thisroleinfo.QualityLvl;
					inip.nowsitzuoqipname = thisroleinfo.nowsitzuoqipname;
					inip.MyRoledata = herodata;
	
					inip.MyInimapPoint=camp1chubingpos[id];
					inip.IniHp =-1;
					inip.MyFuwenData.SetNull();

					lgbtmag.Ins.MyBtNpcmag.CreateRole(inip,1);

					//通知英雄创建  UI改成技能

					//如果创建成功
					//usecamp1chukounum++;
					nowusechukou1++;
					if(nowusechukou1>=camp1chukou)
					{
						//usecamp1chukounum=0;
						nowusechukou1 = 0; 
						RandomChukouId(1);
					}
					Camp1Renkou=Camp1Renkou-tempheroneedrenkou;	//扣除人口
					//通知UI修改 人口 显示
					lgbtmag.Ins.Set_UI_Renkou (Camp1Renkou);
					MyHeroDbid =-1;

					return;
				}
			}
			//在小兵里找个出 没有 则空轮

			//轮流创建小怪 如果当前小怪 占用人口不足 则空着轮 不创建任何怪

			if(usecreatemyroleid<MyRoleDbid.Count && MyRoleDbid[usecreatemyroleid]!=-1)
			{

				if(Camp1Renkou>=myrolesneedrenkou[usecreatemyroleid])
				{
					int id =camp1randomchukou[nowusechukou1];
					IniRoleP_ inip = new IniRoleP_();//,int num
					inip.camp = 1;
					inip.MyRoledata = myrolesdata[usecreatemyroleid];
					//inip.InBsId = -2;
					FightRoleInfo_ thisroleinfo =  GetFightRoleInfo(0,inip.MyRoledata.DBid);
					inip.lvl = thisroleinfo.Lvl;
					inip.qulitylvl = thisroleinfo.QualityLvl;

					inip.UUID = tModleFactory.Ins.GetBtUuid().ToString();
					inip.nowsitzuoqipname = inip.MyRoledata.nowsitzuoqipname;
					
					inip.MyInimapPoint=camp1chubingpos[id];
					inip.IniHp =-1;

					//inip.ReduceDamDepart = MyPlayInfo.ReduceDamDepart;
					//inip.ReduceDamNum = MyPlayInfo.ReduceDamNum;
					inip.MyFuwenData=MyPlayInfo.MyFuwenData; 
					lgbtmag.Ins.MyBtNpcmag.CreateRole(inip);

					//如果创建成功

					//usecamp1chukounum++;
					nowusechukou1++;
					if(nowusechukou1>=camp1chukou)
					{
						//usecamp1chukounum=0;
						nowusechukou1 = 0; 
						RandomChukouId(1);
					}
					Camp1Renkou=Camp1Renkou-myrolesneedrenkou[usecreatemyroleid];	//扣除人口
					//通知UI修改 人口 显示
					lgbtmag.Ins.Set_UI_Renkou (Camp1Renkou);
				}

			}
			usecreatemyroleid++;
			if(usecreatemyroleid>=MyRoleDbid.Count)
			{
				usecreatemyroleid =0;
			}

		}
	}


	public void CreateCamp2Role()
	{
		if (NowMonsterInfoNum[CreateCamp2RoleOrder] > 0) {

			int id =camp2randomchukou[nowusechukou2];


			IniRoleP_ inip = new IniRoleP_();//,int num
			inip.camp = 2;
			//inip.InBsId = -2;
			inip.UUID = tModleFactory.Ins.GetBtUuid().ToString();
			inip.MyRoledata = lgCfgMag.Ins.Get_RoleData(NowMonsterInfo.Dbid[CreateCamp2RoleOrder]);
			inip.nowsitzuoqipname = inip.MyRoledata.nowsitzuoqipname;

			inip.lvl = NowMonsterInfo.lvl[CreateCamp2RoleOrder];
			inip.qulitylvl = NowMonsterInfo.qulitylvl[CreateCamp2RoleOrder];
			inip.nowsitzuoqipname = inip.MyRoledata.nowsitzuoqipname;
			//inip.MyInimapPoint.x = 40;
			//inip.MyInimapPoint.z = 1;
			inip.MyInimapPoint=camp2chubingpos[id];
			inip.IniHp =-1;


			inip.MyFuwenData.SetNull();

			inip.HpAdd = HpAdd;		//副本血量加成
			inip.AttAdd = AttAdd;	//副本攻击加成


			lgbtmag.Ins.MyBtNpcmag.CreateRole(inip);

			//usecamp2chukounum++;
			nowusechukou2++;
			if (nowusechukou2 >= camp2chukou) {
				//usecamp2chukounum = 0;
				nowusechukou2 = 0; 
				RandomChukouId (2);
			}
			NowMonsterInfoNum[CreateCamp2RoleOrder]--;

		}
		CreateCamp2RoleOrder++;
		if(CreateCamp2RoleOrder>=4)
		{
			CreateCamp2RoleOrder =0;
		}
	}


	//随机一次出口顺序
	public void RandomChukouId(int id)
	{
		int temp = 0;
		int randomid = 0;
		if(id==1)
		{
			for(int i=0;i<camp1chukou;i++)
			{
				randomid =Random.Range(0,camp1chukou);
				temp = camp1randomchukou[i];
				camp1randomchukou[i] = camp1randomchukou[randomid];
				camp1randomchukou[randomid] = temp;
			}
		}
		else
		{
			for(int i=0;i<camp2chukou;i++)
			{
				randomid =Random.Range(0,camp2chukou);
				temp = camp2randomchukou[i];
				camp2randomchukou[i] = camp2randomchukou[randomid];
				camp2randomchukou[randomid] = temp;
			}
		}
	}
	//type =1 英雄 0 小兵 
	public FightRoleInfo_ GetFightRoleInfo(int type,int dbid)
	{

		if (type == 1) {
			for (int i=0; i<MyPlayInfo.HeroList.Count; i++) {
				if (MyPlayInfo.HeroList [i].Dbid == dbid) {
					return MyPlayInfo.HeroList [i];
				}
				
			}
			
		} else {
			for (int i=0; i<MyPlayInfo.SoldierList.Count; i++) {
				if (MyPlayInfo.SoldierList [i].Dbid == dbid) {
					return MyPlayInfo.SoldierList [i];
				}
				
			}
			
		}
		FightRoleInfo_ result = new FightRoleInfo_();
		return result;
	}
}
