using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//特效管理器
public class lgTxMag  {
	public List<lgTxbase> MyTxList;
	public List<lgTxbase> dieTxList;
	public Dictionary<int,List<lgTxbase>> TxFactory;
	int txstate;
	// Use this for initialization
	public void IniSome () {
		if(MyTxList==null)
		{
			MyTxList = new List<lgTxbase> ();
		}
		if(dieTxList==null)
		{
			dieTxList = new List<lgTxbase> ();
		}
		if(TxFactory==null)
		{
			TxFactory = new Dictionary<int,List<lgTxbase>> ();
		}
		MyTxList.Clear ();
		dieTxList.Clear ();
		TxFactory.Clear ();
	}

	public bool GetOneTx(int txdbid ,Vector3 Tarpos,testdybroleai thistar)
	{
		lgTxbase result=null;
		List<lgTxbase> list;
		if (TxFactory.TryGetValue (txdbid, out list) == true) {
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
			result=new lgTxbase();
		}

		result.IniSome ( lgCfgMag.Ins.Get_TxData(txdbid), Tarpos,thistar,this);
		
		return true;
		
	}


	public void TxbaseCreateFinish(lgTxbase thistx)
	{
		MyTxList.Add (thistx);
	}
	// Update is called once per frame
	public void update (float dt) {
		for(int i=0;i<MyTxList.Count;i++)
		{
			txstate = MyTxList[i].update(dt);
			if(txstate==-1)
			{
				dieTxList.Add(MyTxList[i]);
			}
		}
		if(dieTxList.Count>0)
		{
			for(int i=0;i<dieTxList.Count;i++)
			{
				List<lgTxbase> list;
				if (TxFactory.TryGetValue (dieTxList[i].dbid, out list) == true) {
					list.Add (dieTxList[i]);
				} else {
					list = new List<lgTxbase>();
					list.Add(dieTxList[i]);
					
					TxFactory.Add(dieTxList[i].dbid,list);
				}

				MyTxList.Remove(dieTxList[i]);
			}
			dieTxList.Clear();
		}
	}
	//清除特效
	public void ClearObj()
	{
		for(int i=0;i<MyTxList.Count;i++)
		{
			MyTxList[i].Quit();
			dieTxList.Add(MyTxList[i]);
		}
		if(dieTxList.Count>0)
		{
			for(int i=0;i<dieTxList.Count;i++)
			{
				List<lgTxbase> list;
				if (TxFactory.TryGetValue (dieTxList[i].dbid, out list) == true) {
					list.Add (dieTxList[i]);
				} else {
					list = new List<lgTxbase>();
					list.Add(dieTxList[i]);
					
					TxFactory.Add(dieTxList[i].dbid,list);
				}
				
				MyTxList.Remove(dieTxList[i]);
			}
			dieTxList.Clear();
		}
	}
	public void Quit()
	{
		MyTxList.Clear ();
		dieTxList.Clear ();
		TxFactory.Clear ();
	}
}
