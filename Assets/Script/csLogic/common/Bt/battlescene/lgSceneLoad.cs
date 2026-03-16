#define UiTip
using UnityEngine;
using System.Collections;

public enum LoadState_
{
	Loading =1,
	MainToBt =2,
	BtToMain =3,

}
public class lgSceneLoad 
{
	public void IniSome()
	{

	}
	AsyncOperation async;
	string LoadBtname = "";
	int type =0;		//1 MainToBt  -1 BtToMain
	LoadState_ state;
	UIUpdate uitipupdate;
	public void LoadBtScene(string scname)
	{
		type = 1;
		LoadBtname = scname;
		state = LoadState_.Loading;
		//async = Application.LoadLevelAsync(scname);
		async = Application.LoadLevelAsync ("Loading");
	}

	public void LoadMainScene()
	{
		type = -1;
		//LoadBtname = scname;
		//async = Application.LoadLevelAsync(scname);
		LoadBtname = "MainGame";
		state = LoadState_.Loading;
		async = Application.LoadLevelAsync ("Loading");
	}

	public void update(float dt)
	{
		if(type!=0)
		{
			if(async.isDone==true)
			{
				switch(state)
				{
					case LoadState_.Loading:
						//取得loading管理器
						#if UiTip
						GameObject uiloadingobj = GameObject.Find("LoadingGamePanel");
						uitipupdate = uiloadingobj.GetComponent<UIUpdate>() as UIUpdate;
						
						#endif
						async = Application.LoadLevelAsync (LoadBtname);
						
						if(type==1)
						{
							state = LoadState_.MainToBt;
						}
						else
						{
							state = LoadState_.BtToMain;
						}
					break;
					case LoadState_.MainToBt:
						//通知场景管理器 场景加载完成
						lgbtmag.Ins.JiazaiFinish(type);
						type =0;
					break;
					case LoadState_.BtToMain:
						//通知场景管理器 场景加载完成
						lgbtmag.Ins.JiazaiFinish(type);
						type =0;
					break;
					
				}
			}
			else
			{
				switch(state)
				{
				
					case LoadState_.MainToBt:
					//通知LOADING界面进度
					//Loading.Updatejindu(async.progress);
					#if UiTip
					if(uitipupdate!=null)
					{
						uitipupdate.SetUpdateTipText("加载中.."+async.progress.ToString()+"%");
						uitipupdate.SetCurProcess(async.progress);
					}
					#endif
					break;
					case LoadState_.BtToMain:
					//通知LOADING界面进度
					//Loading.Updatejindu(async.progress);
					#if UiTip
					if(uitipupdate!=null)
					{
						uitipupdate.SetUpdateTipText("加载中.."+async.progress.ToString()+"%");
						uitipupdate.SetCurProcess(async.progress);
					}
					#endif

					break;
					
				}

			}
		}

	}
}
