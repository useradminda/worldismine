using UnityEngine;
using System.Collections;

/// <summary> 类型编号 角色身上特效 
/// 中心  1
/// 脚 2
/// 攻击 3 
/// 武器 4
///  头 5
///  其他 6 
/// </summary>

public struct TxData_
{
	public int DBid;
	public string pname;
	public int type;	//0 角色身上特效  1 场景特效
	public int mounttype;
	public int mountid;
	public float lifetime;	//生存时间
}

public class lgTxbase  {

	public int dbid;
	TxData_ MyData;
	testdybroleai Mytar;
	Vector3 Mytarpos;
	GameObject MyObj;
	bool createobj=false;
	float uselifetime;
	lgTxMag MyTxMag;
	ParticleSystem mParticleSystem ;
	int state;
	// Use this for initialization
	public void IniSome (TxData_ data,Vector3 tarpos,testdybroleai tar,lgTxMag TxMag) 
	{
		MyData = data;
		dbid = MyData.DBid;
		Mytar = tar;
		Mytarpos = tarpos;
		MyTxMag = TxMag;
		state = 0;
		if (createobj == false) {

			//请求物件
			bool getresult = tModleFactory.Ins.GetOneObj (MyData.pname, GetOneObjCB);

		} else {
			CreateFinish();
		}
	}
	public void CreateFinish()
	{
		if (MyData.type == 0) {
			GameObject parentobj = Mytar.GetMountObj (MyData.mounttype, MyData.mountid);
			if (parentobj != null) {
				MyObj.transform.parent = parentobj.transform;
			}
			MyObj.transform.localPosition = Vector3.zero;
			MyObj.transform.localRotation = Quaternion.identity;
			//通知对方增加特效
			Mytar.AddTx(this);
		} else {
			MyObj.transform.localPosition = Mytarpos;
			MyObj.transform.localRotation = Quaternion.identity;
		}
		MyObj.SetActive (true);
		if(mParticleSystem!=null)
		{
		mParticleSystem.Play ();
		}
		uselifetime = 0f;
		state = 1;
		MyTxMag.TxbaseCreateFinish (this);
	}
	public void TarDie()
	{
		Quit ();
	}

	public void GetOneObjCB(GameObject obj)
	{
		if(obj==null)
		{
			Debug.LogError("No Tx pname = "+MyData.pname);
			Quit();
			return;
		}
		MyObj = obj;
		createobj = true;
		mParticleSystem = MyObj.GetComponent ("ParticleSystem") as ParticleSystem;
		if(mParticleSystem==null)
		{
			Debug.LogError("Error GetOneObjCB  mParticleSystem==null  MyData.pname="+MyData.pname);
		}
		CreateFinish ();
	}
	
	// Update is called once per frame
	public int update (float dt)
	{
		if(state==1)
		{
			uselifetime+=dt;
			if(uselifetime>=MyData.lifetime)
			{
				if (MyData.type == 0)
				{
					//通知对方特效消失
					Mytar.DieTx(this);
				}
				Quit();
			}
		}
		return state;
	}

	public void Quit()
	{
		state = -1;
		if(mParticleSystem!=null)
		{
			mParticleSystem.Stop ();
		}
		MyObj.transform.parent = null;
		MyObj.SetActive (false);
	}
}
