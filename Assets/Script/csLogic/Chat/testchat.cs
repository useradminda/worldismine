using UnityEngine;
using System.Collections;

public class testchat : MonoBehaviour {
	public GameObject chatroot;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKey(KeyCode.A)==true)
		{

			//public long chatid;	//GotyeChatTarget.ID
			//public string name	;	//名字
			//public string  uuid ;		//账号ID  防止查找用
			//public int Country	;//所属国家 -1 还没有加入国家
			//public long countrychatid	;//国家聊天房间id
			//public long worldchatid;	//世界聊天室id
			//public int lvl	;		//等级
			//public int qulity	;	//品质
			//public bool countrychatfb;	//国家频道禁言
			//public int chatfblvl;		//禁言权限等级  高的禁言低级的

			IniChatData_ inidata =new IniChatData_();
			inidata.name = "测试001";
			//inidata.chatid =-1;	//GotyeChatTarget.ID

			inidata.uuid ="sdfowiejfuhsiudf001" ;		//账号ID  防止查找用
			inidata.Country	 =1;//所属国家 -1 还没有加入国家
			inidata.countrychatid = 472110	;//国家聊天房间id
			inidata.worldchatid = 476672 ;	//世界聊天室id
			inidata.lvl = 25	;		//等级
			inidata.qulity	=1;	//品质
			inidata.countrychatfb = false;	//国家频道禁言
			inidata.chatfblvl = 10;		//禁言权限等级  高的禁言低级的


			lgChatMag.Ins.IniChat(inidata);
		}

		if(Input.GetKey(KeyCode.D)==true)
		{

			lgChatMag.Ins.OpenChat(chatroot,0);
		}
	}
}
