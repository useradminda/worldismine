using UnityEngine;
using System.Collections;

public class ammobase  {

	public GameObject mObj=null;
	public skillbase CreateSkill;
	
	
	public int uuid;
	public int dbid;	//弹药配置编号
	virtual public void IniSome(int ammodbid, skillbase thisskill,Vector3 Inipos,Vector3 Tarpos,testdybroleai thistar)
	{


	}
	virtual public void GetOneObjCB(GameObject obj)
	{

	}
	virtual public void CreateFinish()
	{

	}

	virtual public void update (float dt)
	{

		
	}
	
	virtual public void FlyFinish()
	{

	}
	virtual public void Exit()
	{

		
	}
}
