using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class btrolelistui : MonoBehaviour {
	public UILabel num;
	public List<btrolelistitem> listitem = new List<btrolelistitem>();
	public GameObject listobj;
	public UIGrid listgrid;
	public GameObject itemp;

	public BtUIEventListener showlistbt;
	bool Nowshowlist = true;
	void Start()
	{
		showlistbt.onClick = showlistBtClick;
		listgrid.onCustomSort = Comparison_list;
	}
	int Comparison_list (Transform x, Transform y)
	{
		string xname = x.gameObject.name;
		string yname = y.gameObject.name;
		int xint = int.Parse (xname);
		int yint = int.Parse (yname);
		return xint-yint;
	}
	public void SetList(List<Pvp_RoleList_> pvp_RoleList)
	{
		int shownum = pvp_RoleList.Count;
		num.text = shownum.ToString ();

		for(int i=0;i<listitem.Count;i++)
		{
			listitem[i].gameObject.transform.parent = null;
			listitem[i].gameObject.SetActive(false);
		}

		if(listitem.Count < shownum)
		{
			int tempnum = shownum-listitem.Count;
			for(int i = 0;i<tempnum;i++)
			{
				GameObject temp = GameObject.Instantiate(itemp);
				temp.SetActive(false);
				btrolelistitem tempcs = temp.GetComponent<btrolelistitem>() as btrolelistitem;
				listitem.Add(tempcs);
			}
		}
		for (int i=0; i<shownum; i++) {
			listitem [i].Set (pvp_RoleList [i], i);
			listitem [i].gameObject.transform.parent = listgrid.gameObject.transform;
			listitem [i].gameObject.transform.localScale = Vector3.one;
			listitem [i].gameObject.SetActive (true);
		}
		listgrid.Reposition ();

		listobj.SetActive(Nowshowlist);

	}
	public void showlistBtClick(GameObject thisobj, int Order,string key)
	{
		Nowshowlist = !Nowshowlist;
		listobj.SetActive(Nowshowlist);
	}
	public void Show(bool isshow)
	{
		gameObject.SetActive (isshow);
	}
}
