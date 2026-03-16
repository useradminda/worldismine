#define MinMap1
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public struct HeroInfo
{
	public int DBid;
	public int Order;		//序号
	public string HeadAtlasName;
	public string HeadSpriteName;
	public string SkillAtlasName;
	public string SkillSpriteName;
	public string Name;
	public int lvl;
	public int qulity;
}
public enum BtUIState_
{
	s_null=0,
	s_321=1,
	s_fight=2,
	s_showResult =3,
}

//战斗里UI 管理
public class lgBtUiMag:MonoBehaviour
{
	BtUIState_ MyState = BtUIState_.s_null;
	public int[] HeroNeedLvl = {1,3,5,7,9};
	//public UILabel BtName_L;
	public UILabel RoundNum_L;
	public UILabel RoundTime_L;
	public GameObject VS;
	public UILabel PvpTime_L;
	public UILabel Population_L;


	public GameObject ChooseRoleObj;
	public GameObject PopulationObj;

	public BtUIEventListener[] HeroEventListener; 
	public UISprite[] HeroHead_S;  //英雄头像
	public UISprite[] HeroSkill_S;	//英雄技能
	public GameObject[] HeroDie_S;	//英雄死亡
	public GameObject[] HeroLocked_S;//英雄格子未开放
	public GameObject[] HeroChoose_S; //英雄被选中
	public UILabel[] HeroName_L;
	HeroInfo[] HeroInfoList = new HeroInfo[5];
	testdybroleai[] HeroAi = new testdybroleai[5];

	public GameObject[] SkillChoose_S; //技能被选中
	UISprite[] SkillChoose_Sprite; //技能被选中
	string Skillshanstr = "tishikuang";		//技能闪烁spname
	string SkillChoosestr = "dangqianxuanzhong";		//技能选中spname
	public UISprite[] SkillCD_S; //技能CD蒙板

	int[] HeroState = new int[5];	//5个英雄状态  0未选中 1选中 2创建完成改成了技能 -1 死亡 -2被锁住未开放
	int[] MonsterState = new int[15];	//15个小兵状态  0未选中 1选中 
	HeroInfo[] MonsterInfoList = new HeroInfo[15];
	public GameObject[] Monster_Obj;	//15个小兵
	public UISprite[] MonsterHead_S;
	public GameObject[] MonsterChoose_S;
	public BtUIEventListener[] MonsterEventListener; 
	public UILabel[] MonsterName_L;
	bttype_ NowBtType;	//当前战斗类型

	int HeroMaxNum = 5;
	int RoleMaxNum =15;

	public float StartTime =3f;	//开始的倒计时时间



	public GameObject UICame;
	//public GameObject GmCame;
	Camera uicamera;
	Camera Gmcamera;
	int HasHeroNum =0;	//已有英雄数量
	int HasMonsterNum =0;	//已有小兵数量
	int playerlvl =0;
	public BtUIEventListener bglistener;
	lgBtCameMag GmCameMag;
	//void Start()
	//{

		//HeroEventListener [0].onClick = HeroBtClick;
	//}
	//血条相关
	public int camp1HpBase = 0;
	public int camp1Hp = 0;
	public int camp2HpBase = 0;
	public int camp2Hp = 0;

	float camp1Hpf= 0f;
	float camp2Hpf= 0f;
	public UISlider camp1slider;
	public UISlider camp2slider;


	//小兵最多选中3个
	int MonsterChooseMax = 3;
	int useMonsterChoose = 0;
	int[] useMonsterChooseOrder = {-1,-1,-1};


	public GameObject StartTipObj;
	public ParticleSystem[] StartPs;

	lgUiTipNumMag MyUiTipNumMag;
	public GameObject UiTipFa;

	lgUiTipHpMag MyUiTipHpMag;
	public GameObject UiTipHpFa;

	lgRoleTalkMag MyRoleTalkMag;
	public GameObject UiRoleTalkFa;

	public GameObject JiangliRoot;
	public lgJiangliMag MyJiangliMag;

	Vector3 outpos = new Vector3 (-1000f,-1000f,1000f);
#if MinMap
	lgSmallMapMag MyUiSmallMapMag;
	public GameObject UiTipRolePosFa;
#endif
	float pvpfighttime =0f;
	int oldpvpfighttime =0;
	bool pvpfight = false;

	public BtUIEventListener Quitlistener;	//退出战斗 

	//添加一个英雄
	public void AddOneHero(HeroInfo thisinfo)
	{

		//设置头像 
		//HeroHead_S[thisinfo.Order].atlas = ;  // snbug
		//HeroHead_S[thisinfo.Order].spriteName = thisinfo.HeadSpriteName;
		lgNoDelCsFun.Ins.SetIcon(HeroHead_S[thisinfo.Order] , thisinfo.HeadAtlasName , thisinfo.HeadSpriteName);
		HeroHead_S[thisinfo.Order].gameObject.SetActive(true);
		//设置技能
		//HeroSkill_S[thisinfo.Order].atlas = ;
		//HeroSkill_S[thisinfo.Order].spriteName = thisinfo.SkillSpriteName;
		lgNoDelCsFun.Ins.SetIcon(HeroSkill_S[thisinfo.Order] , thisinfo.SkillAtlasName , thisinfo.SkillSpriteName);
		HeroSkill_S[thisinfo.Order].gameObject.SetActive(false);

		//更新状态
		HeroState [thisinfo.Order] = 0;
		HeroLocked_S[thisinfo.Order].SetActive(false);//英雄格子未开放
		HeroChoose_S[thisinfo.Order].SetActive(false); //英雄被选中
		//添加按钮回调信息

		HeroEventListener [thisinfo.Order].GexingP_i = thisinfo.Order;
		HeroEventListener [thisinfo.Order].onClick = HeroBtClick;
		HeroInfoList [thisinfo.Order] = thisinfo;
		HeroName_L[thisinfo.Order].gameObject.SetActive(true);
		HeroName_L[thisinfo.Order].text=thisinfo.Name;

		HasHeroNum++;

	}
	bool LockCreateHero_b =false;

	public void LockCreateHero()
	{
		LockCreateHero_b = true;

	}
	//英雄创建完毕
	public void CreateHeroFinish(testdybroleai thishreo)
	{

		//UI改成英雄的技能
		HeroState [nowchooseheroOrder] = 2;
		HeroHead_S[nowchooseheroOrder].gameObject.SetActive(false); 
		HeroSkill_S[nowchooseheroOrder].gameObject.SetActive(true);
		HeroName_L[nowchooseheroOrder].gameObject.SetActive(false);
		HeroChoose_S[nowchooseheroOrder].gameObject.SetActive(false);
		SkillChoose_S[nowchooseheroOrder].gameObject.SetActive(false);
		HeroEventListener [nowchooseheroOrder].onPress = HeroBtOnPress;
		HeroAi[nowchooseheroOrder] = thishreo;
		LockCreateHero_b = false;
		thishreo.InUiOrder = nowchooseheroOrder;
		nowchooseheroOrder = -1;

	}
	int nowchooseheroOrder=-1;
	int nowChooseSkillOrder =-1;
	//英雄头像或者技能被点击
	public void HeroBtClick(GameObject thisobj, int Order,string key)
	{
		//Debug.Log ("HeroBtClick name="+thisobj.name+" Order="+Order);
		if(MyState!= BtUIState_.s_fight)	//如果战斗没开始
		{

			return;
		}

		if (HeroState [Order] == 0) {
			if(LockCreateHero_b==true)
			{
				return;
			}
			HeroChoose_S [Order].SetActive (true);
			HeroState [Order] = 1;
			lgbtmag.Ins.UI_ChangeHero(HeroInfoList[Order].DBid);
			if(nowchooseheroOrder!=-1&&nowchooseheroOrder!=Order)
			{
				HeroChoose_S [nowchooseheroOrder].SetActive (false);
				HeroState [nowchooseheroOrder] = 0;
			}
			nowchooseheroOrder = Order;
		}else if (HeroState [Order] == 1) {
			if(LockCreateHero_b==true)
			{
				return;
			}
			HeroChoose_S [Order].SetActive (false);
			HeroState [Order] = 0;
			nowchooseheroOrder =-1;
			lgbtmag.Ins.UI_ChangeHero(-1);		//取消选中

		}
		/*
		else if (HeroState [Order] == 2) {
			//出现提示

			//开始等待玩家 点击地面

			//如果没有选中该技能 则选中该技能
			if(nowChooseSkillOrder!=-1)
			{
				//取消原来选中的技能
				SkillChoose_S [nowChooseSkillOrder].SetActive (false);

				if(Order!=nowChooseSkillOrder)
				{
					nowChooseSkillOrder = Order;
					SkillChoose_S [nowChooseSkillOrder].SetActive (true);
				}
				else
				{
					nowChooseSkillOrder =-1;
				}
			}
			else
			{
				nowChooseSkillOrder = Order;
				SkillChoose_S [nowChooseSkillOrder].SetActive (true);
			}
		}
*/
	}
	bool showskilltiping = false;
	string nowskilltippnam ;
	GameObject nowSkillTipObj;
	//public UISprite SkillTip_s;
	Vector3 SkillTipObjPos;
	bool click2 = false;
	public void HeroBtOnPress(GameObject thisobj,bool onpress, int Order,string key)
	{
		//if(true)
		//{
		//	return;
		//}
		//如果技能被按下
		if(MyState!= BtUIState_.s_fight)	//如果战斗没开始
		{
			return;
		}
		if (onpress == true) {
			//如果当前选中技能 可以释放  按下中间战场区域 
			if(Order==-999)
			{
			  	if(nowChooseSkillOrder!=-1&&HeroAi[nowChooseSkillOrder].IsDie==false&& HeroAi[nowChooseSkillOrder].CheckUseHeroSkill()==true)
				{
					SetShowSkillTip(true);
					return;
				}
			}
			else
			{
				if(HeroAi[Order].IsDie==false&& HeroAi[Order].CheckUseHeroSkill()==true)
				{
					//出现提示

					//如果没有选中技能 则选中该技能 并且出现提示
					if(nowChooseSkillOrder!=-1)
					{
						if(nowChooseSkillOrder==Order)
						{
							click2 = true;
						}
						else
						{
							//取消原来选中的技能
							//SkillChoose_S [nowChooseSkillOrder].SetActive (false);
							CancelChooseSkill(nowChooseSkillOrder);
							click2 = false;
							nowChooseSkillOrder = Order;
							ChooseSkill(nowChooseSkillOrder);
							//SkillChoose_S [nowChooseSkillOrder].SetActive (true);
							SetShowSkillTip(true);
						}
					}
					else
					{
						click2 = false;
						nowChooseSkillOrder = Order;
						//SkillChoose_S [nowChooseSkillOrder].SetActive (true);
						ChooseSkill(nowChooseSkillOrder);
						SetShowSkillTip(true);
					}
				}

			}
		} else {		//当抬起时
			//Debug.Log("Order="+Order);
			if(nowChooseSkillOrder!=-1)
			{
				if(Order==-999||nowChooseSkillOrder==Order)	//在背景板上抬起  计算场景地面坐标  释放技能
				{
					SetShowSkillTip(false);
					//Vector3 pos = new Vector3(60f,1f,20f);
					bool use = UIUseSkill(SkillTipObjPos);
					if(use==true)//||use==false&&click2==true)
					{
						click2 = false;

						SkillChoose_S [nowChooseSkillOrder].SetActive (false);
						nowChooseSkillOrder =-1;
					}
					else 
					{
						if(click2==true)
						{
							click2 = false;
							CancelChooseSkill(nowChooseSkillOrder);
							nowChooseSkillOrder =-1;
						}
					}


				}
				else{
					SetShowSkillTip(false);
					//if(nowChooseSkillOrder==Order&&click2 == true)	//如果在选中的技能上  取消提示
					//{
					//	SkillChoose_S [nowChooseSkillOrder].SetActive (false);
					//	nowChooseSkillOrder = -1;
					//	click2 = false;
						//SkillTipObj.SetActive(false);
					//}
					//else {  //如果在其他技能上
					//	SkillTipObj.SetActive(false);
					//}

				}
			}

		}
	}
	private RaycastHit objhit;
	private Ray _ray;

	public void SetShowSkillTip(bool isshow)
	{
		//通知手势关闭
		GmCameMag.PauseFg (isshow);
		showskilltiping = isshow;


		if (showskilltiping == true)
		{
			string tempstr ="";
			HeroAi [nowChooseSkillOrder].GetHeroSkillTipInfo (ref tempstr);

			if(nowskilltippnam!=tempstr)
			{
				if(nowSkillTipObj!=null&&nowskilltippnam!="")
				{
					tModleFactory.Ins.TempRecoveryObj (nowskilltippnam,nowSkillTipObj);
					nowSkillTipObj=null;
				}
				nowskilltippnam =tempstr;
				tModleFactory.Ins.GetOneObj(nowskilltippnam,GetSkillTipObjCB);
			}
			else if(nowSkillTipObj!=null)
			{
			//if((Input.touchCount>0&&Input.GetTouch(0).phase==TouchPhase.Moved)) //[如果点击手指touch了  并且手指touch的状态为移动的
			//{
#if UNITY_STANDALONE_WIN
			SkillTipObjPos.x = Input.mousePosition.x;
			SkillTipObjPos.y = Input.mousePosition.y;
#else
#if UNITY_EDITOR
            SkillTipObjPos.x = Input.mousePosition.x;
            SkillTipObjPos.y = Input.mousePosition.y;
#else
            SkillTipObjPos.x = Input.GetTouch(0).position.x;
			SkillTipObjPos.y= Input.GetTouch(0).position.y;
#endif
#endif
				_ray=Gmcamera.ScreenPointToRay(SkillTipObjPos);//从摄像机发出一条射线,到点击的坐标	
				if (Physics.Raycast (_ray, out objhit, 100)) 
				{
					nowSkillTipObj.gameObject.transform.position = objhit.point;
				}
				else
				{
					nowSkillTipObj.gameObject.transform.position = outpos ;
				}
				nowSkillTipObj.SetActive(true);
			}
		} else {
			//nowskilltippnam ="";
			//SkillTipObj.SetActive(showskilltiping);
			if(nowSkillTipObj!=null)
			{
				nowSkillTipObj.SetActive(false);
			}
		}
	}

	public void GetSkillTipObjCB(GameObject obj)
	{
		nowSkillTipObj = obj;
		if (showskilltiping == true)
		{
#if UNITY_STANDALONE_WIN
			SkillTipObjPos.x = Input.mousePosition.x;
			SkillTipObjPos.y = Input.mousePosition.y;
#else
	#if UNITY_EDITOR
			SkillTipObjPos.x = Input.mousePosition.x;
			SkillTipObjPos.y = Input.mousePosition.y;
	#else
			SkillTipObjPos.x = Input.GetTouch(0).position.x;
			SkillTipObjPos.y= Input.GetTouch(0).position.y;
	#endif
#endif
			_ray=Gmcamera.ScreenPointToRay(SkillTipObjPos);//从摄像机发出一条射线,到点击的坐标	
			if (Physics.Raycast (_ray, out objhit, 100)) 
			{
				nowSkillTipObj.gameObject.transform.position = objhit.point;
			}
			nowSkillTipObj.SetActive(true);
		} 
		else
		{
			nowSkillTipObj.SetActive (false);
		}
	}

	//使用技能
	public bool UIUseSkill(Vector3 pos)
	{

		if(HeroAi[nowChooseSkillOrder].IsDie==false&& HeroAi[nowChooseSkillOrder].CheckUseHeroSkill()==true)
		{
			//Vector3 testpos = new Vector3(60f,1f,20f);

			_ray=Gmcamera.ScreenPointToRay(pos);//从摄像机发出一条射线,到点击的坐标
			
			//Debug.DrawLine(_ray.origin,objhit.point,Color.red,2);//显示一条射线，只有在scene视图中才能看到
			
			if (Physics.Raycast (_ray, out objhit, 100)) 
			{
				GameObject gameObj = objhit.collider.gameObject;
				
				//Debug.Log("Hit objname:"+gameObj.name+"Hit objlayer:"+gameObj.layer+" point="+objhit.point.ToString());

				HeroAi[nowChooseSkillOrder].UseHeroSkill(objhit.point);

				//将选中技能取消掉
				//SkillChoose_S [nowChooseSkillOrder].SetActive (false);
				//nowChooseSkillOrder =-1;
				return true;
			}



			//HeroAi[nowChooseSkillOrder].UseHeroSkill(pos);
		}
		return false;
	}
	//更新英雄技能CD
	public void UpdataSkillCd (testdybroleai thishero,int order, float skillcdkey)
	{
		if(thishero.IsDie==true)
		{
			return;
		}
		if (skillcdkey == -1) {
			SkillCD_S [order].fillAmount = 0;
			//通知显示技能CD完成闪烁
			SkillCDTx(order);
		} else {
			//Debug.LogError ("UpdataSkillCd skillcdkey="+skillcdkey.ToString()+" Time.time="+Time.time.ToString());
			SkillCD_S [order].gameObject.SetActive (true);
			SkillCD_S [order].fillAmount = skillcdkey;
		}
	}


	//显示技能CD完成闪烁
	public void SkillCDTx(int order)
	{
		SkillChoose_S [order].SetActive (true);
		//修改sprite
		SkillChoose_Sprite [order].spriteName = Skillshanstr;
		//TweenAlpha altw = SkillChoose_S [order].GetComponent<TweenAlpha>() as TweenAlpha;
		//altw.ResetToBeginning ();

	}
	public void StopSkillCDTx(int order)
	{
		
		
	}
	//选中技能
	public void ChooseSkill(int order)
	{
		StopSkillCDTx (order);
		SkillChoose_S [order].SetActive (true);
		//修改sprite
		SkillChoose_Sprite [order].spriteName = SkillChoosestr;
	}
	//取消选中技能
	public void CancelChooseSkill(int order)
	{
		//修改sprite
		SkillChoose_Sprite [order].spriteName = Skillshanstr;
	}
	//检查英雄被锁情况
	public void CheckHeroBeLock()
	{
		for(int i=0;i<HeroMaxNum;i++)
		{
			if(playerlvl<HeroNeedLvl[i])
			{
				//设置锁
				HeroState [i] = -2;
				HeroLocked_S[i].SetActive(true);
			}
		}
	}
	// 
	public void  HeroDie(testdybroleai thishreo)
	{
		//检查是不是临时帮助英雄
		//Debug.Log("HeroDie");
		int order = -1;
		for(int i=0;i<HeroAi.Length;i++)
		{
			if(HeroAi[i]==thishreo)
			{
				order= i;
				break;
			}
		}
		if(order!=-1)
		{
			HeroState [order]=-1;
			HeroDie_S[order].SetActive(true);
			HeroSkill_S[order].gameObject.SetActive(false);
			HeroHead_S[order].gameObject.SetActive(true);
			HeroEventListener [order].onPress = null;
			HeroEventListener [order].onClick = null;
			HeroChoose_S[order].gameObject.SetActive(false);
			SkillCD_S [order].gameObject.SetActive (false);
			SkillChoose_S[order].gameObject.SetActive(false);
			if(nowChooseSkillOrder==order)
			{
				nowChooseSkillOrder = -1;
				if(showskilltiping==true)
				{
					SetShowSkillTip(false);
				}
			}
		}
	}

	//添加一个小兵
	public void AddOneMonster(HeroInfo thisinfo)
	{
		if(thisinfo.Order>=Monster_Obj.Length)
		{
			Debug.LogError("Error AddOneMonster thisinfo.Order ="+thisinfo.Order.ToString());
			return;
		}
		Monster_Obj[thisinfo.Order].SetActive(true);
		//MonsterHead_S[thisinfo.Order].atlas = ;
		//MonsterHead_S[thisinfo.Order].spriteName = thisinfo.HeadSpriteName;
		lgNoDelCsFun.Ins.SetIcon(MonsterHead_S[thisinfo.Order] , thisinfo.HeadAtlasName , thisinfo.HeadSpriteName);
		MonsterChoose_S[thisinfo.Order].SetActive(false);
		MonsterState[thisinfo.Order] =0;
		//添加回调信息

		MonsterEventListener [thisinfo.Order].GexingP_i = thisinfo.Order;
		MonsterEventListener [thisinfo.Order].onClick = MonsterBtClick;

		MonsterInfoList [thisinfo.Order] = thisinfo;
		MonsterName_L[thisinfo.Order].text=thisinfo.Name;
		HasMonsterNum++;
	}



	//小兵被点击
	public void MonsterBtClick(GameObject thisobj, int Order,string key)
	{
		if(MyState!= BtUIState_.s_fight)	//如果战斗没开始
		{
			return;
		}
		if (MonsterState [Order] == 0) {	//选中
			useMonsterChoose++;
			if(useMonsterChoose>3)
			{
				int temporder= useMonsterChooseOrder[0];
				MonsterChoose_S [temporder].SetActive (false);
				MonsterState [temporder] = 0;
				//通知创建器
				lgbtmag.Ins.UI_CancelChooseRole(MonsterInfoList [temporder].DBid);
				useMonsterChooseOrder[0] =useMonsterChooseOrder[1];
				useMonsterChooseOrder[1] =useMonsterChooseOrder[2];
				useMonsterChooseOrder[2] = Order;
				useMonsterChoose =3;
			}
			else
			{
				useMonsterChooseOrder[useMonsterChoose-1] = Order;
			}


			MonsterChoose_S [Order].SetActive (true);
			MonsterState [Order] = 1;
			//通知创建器
			lgbtmag.Ins.UI_ChooseRole(MonsterInfoList [Order].DBid);

		} else if (MonsterState [Order] == 1) {	//取消选中
			useMonsterChoose--;
			if(useMonsterChooseOrder[0]==Order)
			{
				useMonsterChooseOrder[0] =useMonsterChooseOrder[1];
				useMonsterChooseOrder[1] =useMonsterChooseOrder[2];
				useMonsterChooseOrder[2] = -1;
			}
			else if(useMonsterChooseOrder[1]==Order)
			{
				//useMonsterChooseOrder[0] =useMonsterChooseOrder[1];
				useMonsterChooseOrder[1] =useMonsterChooseOrder[2];
				useMonsterChooseOrder[2] = -1;
			}
			else if(useMonsterChooseOrder[2]==Order)
			{
				//useMonsterChooseOrder[0] =useMonsterChooseOrder[1];
				//useMonsterChooseOrder[1] =useMonsterChooseOrder[2];
				useMonsterChooseOrder[2] = -1;
			}

			MonsterChoose_S [Order].SetActive (false);
			MonsterState [Order] = 0;
			//通知创建器
			lgbtmag.Ins.UI_CancelChooseRole(MonsterInfoList [Order].DBid);
		}
	}


	//初始化
	public void IniSome(bttype_ mytype)
	{
		if(MyUiTipNumMag==null)
		{
			MyUiTipNumMag = new lgUiTipNumMag();
		}
		MyUiTipNumMag.IniSome (UiTipFa);


		if(MyUiTipHpMag==null)
		{
			MyUiTipHpMag = new lgUiTipHpMag();
		}
		MyUiTipHpMag.IniSome (UiTipHpFa,this);




		if(MyRoleTalkMag==null)
		{
			MyRoleTalkMag = new lgRoleTalkMag();
		}
		MyRoleTalkMag.IniSome (UiRoleTalkFa,this);

#if MinMap	
		if(MyUiSmallMapMag==null)
		{
			MyUiSmallMapMag = new lgSmallMapMag();
		}
#endif
		tPoint_ mapcell;
		lgbtmag.Ins.GetMapCell(out mapcell);
#if MinMap
		MyUiSmallMapMag.IniSome (UiTipRolePosFa,this,mapcell.x,mapcell.z);
#endif

		if(SkillChoose_Sprite==null)
		{
			SkillChoose_Sprite = new UISprite[SkillChoose_S.Length];
			for(int i=0;i<SkillChoose_S.Length;i++)
			{
				SkillChoose_Sprite[i] = SkillChoose_S[i].GetComponent<UISprite>() as UISprite;
			}
		}
		MyState = BtUIState_.s_null;
		NowBtType = mytype;
		UICame.SetActive (false);
		JiangliRoot.SetActive (false);
		uicamera = UICame.GetComponent<Camera>() as Camera;
		Gmcamera =lgbtmag.Ins.GmCameOBj.GetComponent<Camera>() as Camera;
		GmCameMag =lgbtmag.Ins.GmCameOBj.GetComponent<lgBtCameMag>() as lgBtCameMag;
		ClearHero ();
		ClearMonster();
		HasHeroNum =0;	//已有英雄数量
		HasMonsterNum =0;	//已有小兵数量
		//根据副本类型来打开关闭一些节点

		pvpfighttime =0f;
		oldpvpfighttime =0;
		pvpfight = false;

		Population_L.text = "0";
		PvpTime_L.text = "00:00";
		switch(NowBtType)
		{
			case bttype_.fuben:
				Population_L.gameObject.SetActive(true);
				ChooseRoleObj.SetActive(true);
				PopulationObj.SetActive(true);

				RoundNum_L.gameObject.SetActive(true);
				RoundTime_L.gameObject.SetActive(true);
				RoundNum_L.text="0";
				RoundNum_L.text = "回合";
				//RoundTime_L.text ="";
				VS.SetActive(false);
				PvpTime_L.gameObject.SetActive(false);

				playerlvl= 99 ;//取玩家数据 snbug
				
			break;
			case bttype_.pvp:
				Population_L.gameObject.SetActive(false);
				ChooseRoleObj.SetActive(false);
				PopulationObj.SetActive(false);
				RoundNum_L.gameObject.SetActive(false);
				RoundTime_L.gameObject.SetActive(false);
				VS.SetActive(true);
				PvpTime_L.gameObject.SetActive(true);
				pvpfight = true;
			break;
		case bttype_.bosspvp:
				Population_L.gameObject.SetActive(false);
				ChooseRoleObj.SetActive(false);
				PopulationObj.SetActive(false);
				RoundNum_L.gameObject.SetActive(false);
				RoundTime_L.gameObject.SetActive(false);
				VS.SetActive(true);
				PvpTime_L.gameObject.SetActive(true);
				pvpfight = true;
			break;
		case bttype_.pvp_jinjichang:
			Population_L.gameObject.SetActive(false);
			ChooseRoleObj.SetActive(false);
			PopulationObj.SetActive(false);
			RoundNum_L.gameObject.SetActive(false);
			RoundTime_L.gameObject.SetActive(false);
			VS.SetActive(true);
			PvpTime_L.gameObject.SetActive(true);
			pvpfight = true;
			break;
		}

		//bglistener.onClick = BgOnClick;
		bglistener.onPress = HeroBtOnPress;
		//SkillTipObjPos = SkillTipObj.gameObject.transform.localPosition;

		//小兵最多选中3个

		useMonsterChoose = 0;
		useMonsterChooseOrder[0] = -1;
		useMonsterChooseOrder[1] = -1;
		useMonsterChooseOrder[2] = -1;

		StartTipObj.SetActive (false);
		IniJIangli ();
		click2 = false;

		if(Quitlistener!=null)
		{
			Quitlistener.GexingP_i = -1;
			Quitlistener.onClick = QuitBtClick;
			Quitlistener.gameObject.SetActive (false);
		}
	}

	//清理资源
	public void Clear()
	{
		if(MyUiTipNumMag!=null)
		{
			MyUiTipNumMag.Exit();
			MyUiTipNumMag = null;
		}
		if(MyUiTipHpMag!=null)
		{
			MyUiTipHpMag.Exit();
			MyUiTipHpMag = null;
		}
		MyState = BtUIState_.s_null;
		MyRoleTalkMag.Exit ();
	}


	//退出
	public void Quit()
	{
		if(MyUiTipNumMag!=null)
		{
			MyUiTipNumMag.Exit();
			MyUiTipNumMag = null;
		}
		if(MyUiTipHpMag!=null)
		{
			MyUiTipHpMag.Exit();
			MyUiTipHpMag = null;
		}

		GmCameMag = null;
		MyState = BtUIState_.s_null;
		gameObject.SetActive (false);
		GameObject.Destroy (gameObject);

	}

	public void ShowUI(bool show)
	{
		if(NowBtType== bttype_.fuben)
		{
			CheckHeroBeLock ();
		}
		UICame.SetActive (show);
	}



	//设置场景名
	//public void SetBtName(string name)
	//{
	//	BtName_L.text = name;

	//}

	//设置第几回合
	public void SetRoundNum(int round)
	{
		RoundNum_L.text = "第"+round+"回合";
	}
	//设置回合时间
	public void SetRoundTime(int time)
	{
		RoundTime_L.text = time.ToString();
	}

	//设置人口
	public void SetPopulation(int renkou)
	{
		Population_L.text = renkou.ToString();
	}

	//开始游戏
	public void StartGame()
	{

		SetRoundTime ((int)waitstarttime);
		usewaitstarttime = waitstarttime;
		oldusewaitstarttime = usewaitstarttime;
		//开始321倒计时
		MyState = BtUIState_.s_321;
		//开始提示
		StartTipObj.SetActive (true);
		UITweener[] uitweens = StartTipObj.transform.GetComponentsInChildren<UITweener>();
		for(int i =0;i<uitweens.Length;i++)
		{
			uitweens[i].ResetToBeginning ();
			uitweens[i].Play(true);
		}
		for(int i =0;i<StartPs.Length;i++)
		{
			StartPs[i].Play();
		}

	}
	public void Finish321()
	{

		//结束提示
		StartTipObj.SetActive (false);
		SetRoundNum (1);
		//通知场景切换成战斗状态  开始出兵
		MyState = BtUIState_.s_fight;
		lgbtmag.Ins.Ui321Finish ();
		MyRoleTalkMag.StartGame();
		if(Quitlistener!=null&&NowBtType== bttype_.pvp)
		{
			Quitlistener.gameObject.SetActive (true);
		}
	}
	public float waitstarttime = 3f;
	float usewaitstarttime = 0f;
	float oldusewaitstarttime = 0f;
	public void update(float dt)
	{

		switch( MyState)
		{
		case BtUIState_.s_321:
			usewaitstarttime-=dt;

			if(oldusewaitstarttime-usewaitstarttime>1)
			{
				oldusewaitstarttime=oldusewaitstarttime-1;
				SetRoundTime ((int)oldusewaitstarttime);
			}

			if(usewaitstarttime<=0)
			{
				Finish321();
			}
			break;
		case BtUIState_.s_fight:
			if(showskilltiping==true&&nowSkillTipObj!=null) //当前显示技能提示图标
			{
				//Debug.Log (Input.mousePosition);
				#if UNITY_STANDALONE_WIN
				SkillTipObjPos.x = Input.mousePosition.x;
				SkillTipObjPos.y= Input.mousePosition.y;
				#else
				if((Input.touchCount>0&&Input.GetTouch(0).phase==TouchPhase.Moved)) //[如果点击手指touch了  并且手指touch的状态为移动的
				{
					SkillTipObjPos.x = Input.GetTouch(0).position.x;
					SkillTipObjPos.y= Input.GetTouch(0).position.y;
					
				}
				#endif
				//Debug.Log (SkillTipObjPos);
				_ray=Gmcamera.ScreenPointToRay(SkillTipObjPos);//从摄像机发出一条射线,到点击的坐标	
				if (Physics.Raycast (_ray, out objhit, 100)) 
				{
					nowSkillTipObj.gameObject.transform.position = objhit.point;
				}

				//nowSkillTipObj.SetActive(true);
				//SkillTipObj.gameObject.transform.localPosition=SkillTipObjPos;
			}
			if(MyUiTipNumMag!=null)
			{
				MyUiTipNumMag.updata(dt);
			}
			if(MyRoleTalkMag!=null)
			{
				MyRoleTalkMag.updata(dt);
			}
			if(pvpfight==true)
			{
				pvpfighttime +=dt;
				if(pvpfighttime-oldpvpfighttime>1f)
				{
					oldpvpfighttime = (int)pvpfighttime;
					updatapvpfighttime(oldpvpfighttime);
				}

			}

			break;
		case BtUIState_.s_showResult:
			break;
		}
	}


	//win -1 失败 0 平局 1胜利
	public void ShowResult(int win)
	{
		MyState = BtUIState_.s_showResult;
		MyJiangliMag.SetWin (win==1);

	}


	//清空小怪
	public void ClearMonster()
	{
		for(int i=0;i<Monster_Obj.Length;i++)
		{
			if(Monster_Obj[i]!=null)
			{
				Monster_Obj[i].SetActive(false);
			}
		}

	}
	//清空英雄
	public void ClearHero()
	{
		for(int i=0;i<HeroAi.Length;i++)
		{
			if(HeroAi[i]!=null)
			{
				HeroAi[i]=null;
			}
		}
		for(int i=0;i<HeroName_L.Length;i++)
		{
			if(HeroName_L[i]!=null)
			{
				HeroName_L[i].text="可出战";
			}
		}
		for(int i=0;i<HeroHead_S.Length;i++)
		{
			if(HeroHead_S[i]!=null)
			{
				HeroHead_S[i].gameObject.SetActive(false);
			}
		}
		for(int i=0;i<HeroSkill_S.Length;i++)
		{
			if(HeroSkill_S[i]!=null)
			{
				HeroSkill_S[i].gameObject.SetActive(false);
			}
		}
		for(int i=0;i<HeroDie_S.Length;i++)
		{
			if(HeroDie_S[i]!=null)
			{
				HeroDie_S[i].SetActive(false);
			}
		}
		for(int i=0;i<HeroLocked_S.Length;i++)
		{
			if(HeroLocked_S[i]!=null)
			{
				HeroLocked_S[i].SetActive(false);
			}
		}
		for(int i=0;i<HeroChoose_S.Length;i++)
		{
			if(HeroChoose_S[i]!=null)
			{
				HeroChoose_S[i].SetActive(false);
			}
		}
		for(int i=0;i<HeroEventListener.Length;i++)
		{
			if(HeroEventListener[i]!=null)
			{
				HeroEventListener [i].onClick = null;
			}
		}
		for(int i=0;i<SkillChoose_S.Length;i++)
		{
			if(SkillChoose_S[i]!=null)
			{
				SkillChoose_S [i].SetActive(false);
			}
		}
		for(int i=0;i<SkillCD_S.Length;i++)
		{
			if(SkillCD_S[i]!=null)
			{
				SkillCD_S [i].gameObject.SetActive(false);
			}
		}


	}

	//城堡血条相关

	public void IniHp(int camp1basehp,int camp2basehp)
	{
		camp1HpBase = camp2basehp;
		camp1Hp = camp2basehp;
		camp2HpBase = camp2basehp;
		camp2Hp = camp2basehp;
		camp1Hpf= 1f;
		camp2Hpf= 1f;
		//更新显示

		camp1slider.value = camp1Hpf;
		camp2slider.value = camp2Hpf;
	}
	public void Updatehp(int campid,int dame)
	{
		if(campid==1)
		{
			camp1Hp =camp1Hp-dame;
			camp1Hpf = (float)camp1Hp/camp1HpBase;
			//更新显示
			camp1slider.value = camp1Hpf;

		}
		else
		{
			camp2Hp =camp2Hp-dame;
			camp2Hpf = (float)camp2Hp/camp2HpBase;
			//更新显示

			camp2slider.value = camp2Hpf;
		}
	}

	//显示技能伤害
	public void ShowSkillDam(int dame,Vector3 tarpos)
	{
		Vector3 showpos=Gmcamera.WorldToScreenPoint (tarpos);
		MyUiTipNumMag.GetOneTip (dame, showpos,true);
	}


	public Vector2 GetGm3DPosTo2D(Vector3 tarpos)
	{
		return Gmcamera.WorldToScreenPoint (tarpos);
	}


	//英雄血条相关
	public void GetOneHeroHpTip(testdybroleai thisrole)
	{
		if(MyUiTipHpMag!=null)
		{
			MyUiTipHpMag.GetOneTip(thisrole);
		}
	}

	//
	public void CameChangePos()
	{
		if(MyUiTipHpMag!=null)
		{
			MyUiTipHpMag.CameChangePos();
		}
#if MinMap
		if(MyUiSmallMapMag!=null)
		{
			MyUiSmallMapMag.CameChangePos();
		}
#endif
	}

	public void RoleDieTalk(testdybroleai thisrole)
	{
		if(MyRoleTalkMag!=null)
		{
			MyRoleTalkMag.RoleDieTalk(thisrole);
		}
	}



	public void IniJIangli()
	{
		bool isfuben = false;
		if(NowBtType == bttype_.fuben||NowBtType == bttype_.bosspvp||NowBtType == bttype_.pvp_jinjichang)
		{
			isfuben = true;
		}
		MyJiangliMag.IniSome (this,isfuben);
	}

	public void JIeshuShowResult()
	{
		lgbtmag.Ins.Exitwaitresult ();
	}

	public GameObject UiJiesuoRoleTipRoot;
	GameObject UiJiesuoRoleTipObj;
	lgUiJiesuoRoleTipMag MyUiJiesuoRoleTipMag;
	int showroledbid;
	string str_showrolejiesuo = "Tipaddroleroot";
	//开始个解锁角色提示
	public void JiesuoRoleTip(int thisshowroledbid)
	{
		showroledbid = thisshowroledbid;
		if(MyUiJiesuoRoleTipMag==null)
		{
			tModleFactory.Ins.GetOneObj (str_showrolejiesuo, GetJiesuoRoleTipRoot,true);
		}
		else
		{
			MyUiJiesuoRoleTipMag.IniSome(this,showroledbid);
		}
	}

	public void GetJiesuoRoleTipRoot(GameObject thistiproot)
	{
		UiJiesuoRoleTipObj = thistiproot;
		UiJiesuoRoleTipObj.transform.parent = UiJiesuoRoleTipRoot.transform;

		UiJiesuoRoleTipObj.transform.localScale = Vector3.one;
		UiJiesuoRoleTipObj.transform.localPosition = Vector3.zero;

		MyUiJiesuoRoleTipMag = UiJiesuoRoleTipObj.GetComponent<lgUiJiesuoRoleTipMag>() as lgUiJiesuoRoleTipMag;
		MyUiJiesuoRoleTipMag.IniSome(this,showroledbid);
		UiJiesuoRoleTipObj.SetActive (true);

	}


	public void JiesuoRoleTipFinish()
	{

		MyUiJiesuoRoleTipMag = null;
		UiJiesuoRoleTipObj.transform.parent = null;
		UiJiesuoRoleTipObj.SetActive (false);
		tModleFactory.Ins.TempRecoveryObj (str_showrolejiesuo, UiJiesuoRoleTipObj);
		UiJiesuoRoleTipObj = null;
		lgbtmag.Ins.JiesuoRoleTipFinish ();
	}

	public void updatapvpfighttime(int time)
	{
		int min = time / 60;
		int second = time % 60;
		string showtime="";
		if(min<10)
		{
			showtime="0";
		}
		showtime = showtime + min.ToString() + ":";
		if(second<10)
		{
			showtime+="0";
		}
		showtime=showtime+second.ToString();
		PvpTime_L.text = showtime;

	}


#if MinMap
	//请求一个小地图位置显示
	public void GetOneMapPosTip(testdybroleai thisrole)
	{
		if(MyUiSmallMapMag!=null)
		{
			MyUiSmallMapMag.GetOneTip(thisrole);
		}
	}
#endif

	public void QuitBtClick(GameObject thisobj, int Order,string key)
	{
		if(Quitlistener!=null)
		{
			Quitlistener.GexingP_i = -1;
			Quitlistener.onClick = null;
			Quitlistener.gameObject.SetActive (false);
		}
		lgbtmag.Ins.UI_Call_QuitBt ();
	}

	//pvp 显示2边战斗角色信息
	public btroleui camp1roleui;
	public btroleui camp2roleui;
	public btrolelistui camp1rolelistui;
	public btrolelistui camp2rolelistui;
	public void SetPvpRoleInfo(btroleinfo_ thisinfo1,btroleinfo_ thisinfo2)
	{
		camp1roleui.SetInfo (thisinfo1);
		camp2roleui.SetInfo (thisinfo2);
	}
	public void ShowPvpRoleInfo(bool isshow)
	{
		camp1roleui.show (isshow);
		camp2roleui.show (isshow);
	}
	 
	public void Setpvprolelist(List<Pvp_RoleList_> temppvp_RoleList1,List<Pvp_RoleList_> temppvp_RoleList2)
	{
		camp1rolelistui.SetList (temppvp_RoleList1);
		camp2rolelistui.SetList (temppvp_RoleList2);

	}

	public void ShowPvpRolelist(bool isshow)
	{
		camp1rolelistui.Show (isshow);
		camp2rolelistui.Show (isshow);
	}

}
