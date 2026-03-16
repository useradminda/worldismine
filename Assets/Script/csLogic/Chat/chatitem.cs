using UnityEngine;
using System.Collections;
using gotye;


public class chatitem : MonoBehaviour {
	public UIChatMag MyUIChatMag;
	public int type =-1;
	
	public UISprite head;
	public UISprite countrysp;
	public UILabel country;
	public UILabel lvl;
	public UILabel name;
	
	public int id;
	public UILabel saylab;
	public GameObject yuyingobj;
	public GameObject txtobj;
	//public int yuyingid;
	
	public BtUIEventListener headbt;
	public BtUIEventListener saybt;
	
	private GotyeMessage Mymessage;
	MyRoleInfoData_ data;
	/*
	public void IniShow(chatitemdata_ data)
	{
		name.text = data.name;
		id = data.id;
		lvl.text = "Lv" + data.lvl.ToString ();

		headbt.onClick = headBtClick;
		if (data.type == 1)
		{
			saylab.text = data.say;
			yuyingobj.SetActive(false);
			txtobj.SetActive(true);

		} 
		else if (data.type == 2)
		{
			yuyingobj.SetActive(true);
			txtobj.SetActive(false);
			yuyingid = data.yuyingid;
			saybt.onClick = sayBtClick;
		}
	}
	*/
	public void IniShowByMsg(GotyeMessage message)
	{
		Mymessage = message;
		if(Mymessage.Type == GotyeMessageType.Audio)
		{
			
			yuyingobj.SetActive(true);
			txtobj.SetActive(false);
			
			saybt.onClick = sayBtClick;
		}
		else if(Mymessage.Type == GotyeMessageType.Text)
		{
			
			saylab.text = message.Text;
			yuyingobj.SetActive(false);
			txtobj.SetActive(true);
		}
		name.text = Mymessage.Sender.Name;
		headbt.onClick = headBtClick;
		string str= System.Text.Encoding.UTF8.GetString(Mymessage.ExtraData);
		data= lgChatMag.Ins.stringToMyRoleInfoData(str);
		//lgNoDelCsFun.Ins.SetIcon(head, data.head_atlas, data.head_sp);
		Debug.LogError ("data.headspid ="+data.headspid);
		lgNoDelCsFun.Ins.SetHeadIconById (head, data.headspid);
		lvl.text = data.lvl.ToString ();
		string countroyName = "";
		switch(lgChatMag.Ins.MyIniChatData.Country)
		{
		case -1:country.text = "无"; countroyName = ""; break;
		case 1:country.text = "蜀"; countroyName = "shu"; break;
		case 2:country.text = "魏"; countroyName = "wei"; break;
		case 3:country.text = "吴"; countroyName = "wu"; break;
		}
		string atlasName = "WordPicture";
		lgNoDelCsFun.Ins.SetIcon(countrysp, atlasName, countroyName);
		//lgNoDelCsFun.Ins.SetIcon(countrysp, data.country_atlas, data.country_sp);
	}
	
	//显示头像菜单
	public void headBtClick(GameObject thisobj, int Order,string key)
	{
		Debug.LogError ("headBtClick ~~ "+thisobj.name);
		MyUIChatMag.ShowRoleTipPlan( data);
	}
	//开始播放语音
	public void sayBtClick(GameObject thisobj, int Order,string key)
	{
		Debug.LogError ("sayBtClick ~~ "+thisobj.name);
		MyUIChatMag._PlayAudio (Mymessage);
	}
}
