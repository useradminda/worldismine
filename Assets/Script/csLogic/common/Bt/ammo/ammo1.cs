using UnityEngine;
using System.Collections;

//普通飞行弹药
public class ammo1 :ammobase {


	public bool startfly = false;

	public AnimationCurve m_HighMoveCurveid ;	//垂直方向移动曲线  水平方向不考虑曲线


	private Vector3 moveInipos;
	private Vector3 moveTarpos;
	public float dis;
	public float movespeed=2;
	public float movetime;
	private float HighDivLength =0.3f;
	private float m_Highdis;

	// Update is called once per frame
	private float usemovetime = 0f;
	private float key = 0f;
	private Vector3 nowpos;
	private float y2 = 0f;
	private float y0 = 0f;
	private float fole =0f;
	private testdybroleai tar;

	private string pname;
	override public void IniSome(int ammodbid, skillbase thisskill,Vector3 Inipos,Vector3 Tarpos,testdybroleai thistar)
	{
		ammodata_ thisdata= lgCfgMag.Ins.Get_AmmoData(ammodbid);
		pname = thisdata.pname;
		if (thisdata.gexingjiexi.Length > 2) {
			HighDivLength = float.Parse( thisdata.gexingjiexi [2]);
		} else {
			HighDivLength = 0.3f;
			Debug.LogError("Error ammo IniSome ammodbid = "+ammodbid.ToString()+" gexingjiexi.Length <= 2");
		}
		//pname = thispname;
		dbid = ammodbid;
		CreateSkill = thisskill;
		tar = thistar;
		startfly = false;
		moveInipos = Inipos;
		moveTarpos = Tarpos;
		//检查起点 终点高度 
		if (moveInipos.y < 1f) {
			moveInipos.y =1f;
		}
		if (moveTarpos.y < 1f) {
			moveTarpos.y =1f;
		}


		dis = Vector3.Distance (moveInipos,moveTarpos);

		m_Highdis = dis * HighDivLength;
		y2 = moveTarpos.y;
		y0 = moveInipos.y;



		if (mObj == null) {
			//请求加载物件
            
            
			int id = int.Parse(thisdata.gexingjiexi[1]);
			m_HighMoveCurveid = tModleFactory.Ins.MyAnimationCurveList.MyAnimationCurveList[id];
			movespeed = float.Parse(thisdata.gexingjiexi[0]);
			movetime = dis / movespeed;
			bool getresult = tModleFactory.Ins.GetOneObj(pname, GetOneObjCB);
		} else {
			movetime = dis / movespeed;
			CreateFinish();
		}
	}
	override public void GetOneObjCB(GameObject obj)
	{
		mObj= obj;

		CreateFinish();
	}
	override public void CreateFinish()
	{
		mObj.transform.position = moveInipos;
		mObj.transform.LookAt (moveTarpos);
		//设置弹药位置 方向 等
		mObj.SetActive (true);
		usemovetime = 0f;
		startfly = true;
		tModleFactory.Ins.MyammoFactory.ammoCreateFinish(this);
	}


	override public void update (float dt)
	{
		if(startfly==true)
		{
			usemovetime = usemovetime+dt;
			if(usemovetime<movetime)
			{
				key = usemovetime/movetime;

				fole = m_HighMoveCurveid.Evaluate(key);

				nowpos = Vector3.Lerp(moveInipos,moveTarpos,key);
				nowpos.y =y0 + fole*m_Highdis;// +(y2-y0)*key;
				mObj.transform.position = nowpos;
			}
			else
			{
				FlyFinish();
			}
		}

	}

	override public void FlyFinish()
	{
		startfly = false;
		if(mObj!=null)
		{
			mObj.SetActive(false);
		}
		moveTarpos.y = 0f;	//认为落地
		//回调技能
		if(CreateSkill!=null)
		{
			CreateSkill.ammoFlyFinCB(tar,moveTarpos);
		}
		tModleFactory.Ins.MyammoFactory.TempRecoveryAmmo (dbid,this);
	}
	override public void Exit()
	{
		startfly = false;
		//弹药回收
		tModleFactory.Ins.TempRecoveryObj (pname,mObj); 
		mObj = null;
	}
}
