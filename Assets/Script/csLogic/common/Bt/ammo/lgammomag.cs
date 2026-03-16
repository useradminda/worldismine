using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//弹药管理器  弹药模型不归还  弹药脚本重复使用

public struct ammodata_
{
    public int DBid;
    public string ammoCsName;
    public string pname;
	public string gexingp;//个性化参数
	public string[] gexingjiexi;
}



public class lgammomag  {

	public Dictionary<int, List<ammobase>> AmmoFactory = new Dictionary<int, List<ammobase>>();
	public List<ammobase> useingammo = new List<ammobase> ();
	public List<ammobase> Nouseingammo = new List<ammobase> ();

	public void IniSome()
	{

	}
	public bool GetOneAmmo(int ammodbid,skillbase thisskill,Vector3 Inipos,Vector3 Tarpos,testdybroleai thistar)
	{
		ammobase result=null;
		List<ammobase> list;
		if (AmmoFactory.TryGetValue (ammodbid, out list) == true) {
			if(list.Count>0)
			{
				result = list[0];
				list.RemoveAt(0);
				//thiscb(result);
				//return true;
			}
			
		} 
		if(result==null)
		{
			result=new ammo1();
		}
		result.IniSome ( ammodbid, thisskill, Inipos, Tarpos,thistar);

		return true;
		
	}
	public void TempRecoveryAmmo(int ammodbid,ammobase obj)
	{
		Nouseingammo.Add (obj);
	}
	
	public void ClearObj()
	{
		for(int i=0;i<useingammo.Count;i++)
		{
			useingammo[i].Exit();
		}
		useingammo.Clear ();


		List<int> keylist = new List<int>(AmmoFactory.Keys);
		List<ammobase> list;
		for(int i=0;i<keylist.Count;i++)
		{
			if(AmmoFactory.TryGetValue(keylist[i], out list)==true)
			{
				
				for(int k=0;k<list.Count;k++)
				{
					list[k].Exit();
				}
				list.Clear();
			}
			
		}
		AmmoFactory.Clear ();
		Nouseingammo.Clear ();
	}

	public void ammoCreateFinish(ammobase thisammo)
	{
		useingammo.Add (thisammo);
	}
	
	public void update(float dt)
	{
		if(Nouseingammo.Count>0)
		{
			for(int i=0;i<Nouseingammo.Count;i++)
			{
				List<ammobase> list;
				if (AmmoFactory.TryGetValue (Nouseingammo[i].dbid, out list) == true) {
					list.Add (Nouseingammo[i]);
				} else {
					list = new List<ammobase>();
					list.Add(Nouseingammo[i]);
					
					AmmoFactory.Add(Nouseingammo[i].dbid,list);
				}
				useingammo.Remove(Nouseingammo[i]);
			}
			Nouseingammo.Clear();
		}

		for(int i=0;i<useingammo.Count;i++)
		{
			useingammo[i].update(dt);
		}
	}

}
