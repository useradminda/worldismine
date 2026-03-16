//
//
//Author : scy
#define debug_scy
#define UiTip
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using SLua;
using System.IO;


public enum CheckState_S_
{
    S_Null = -1,
    ReadVersionRecord = 0,
    CheckSerVer =1,
    CheckLocalUp =2,
    CheckFileComplete =3,
    //CheckBigVerUp = 1,
    //CheckSmallVerUp = 2,
   // DelNoUseFile = 3,
    UpFinish = 4
}
public struct UpdataZiyuanInfo_
{
    public string ziyuanVer;
    public string Md5;
    public string Size;
}
public class lgAutoUpMag : MonoBehaviour {

    public string GameConfig_LuaPath = "GameConfig.lua";
   // public string InstallZiyuan = "InstallZiyuan.zip";
    public string UpdataZiyuan = "UpdataZiyuan.zip";
    public LuaTable GameConfig_table;
	//public MovieTexture _Move;
	public GameObject _MoveGob;
	public GameObject SkipButton;
    string filePath =  "";
#if debug_scy
#endif
    //Application.temporaryCachePath  =  C:\Users\Administrator\AppData\Local\Temp\DefaultCompany\HZ
    void Start () 
	{
      // string rootpath = Application.temporaryCachePath;
       // Debug.Log("rootpath" + rootpath);
      //  filePath = Application.streamingAssetsPath + "/";
		Debug.Log("Application.persistentDataPath= " + Application.persistentDataPath);
		
		
		
		int _HaveMove = PlayerPrefs.GetInt("HavePlay");
		if(_HaveMove==null||_HaveMove==0)				//没播放过
	    {			
			#if UNITY_IPHONE
			bool tt= Handheld.PlayFullScreenMovie("222.mp4" , Color.black , FullScreenMovieControlMode.CancelOnInput);
			#endif
				
			#if UNITY_ANDROID
			bool tt= Handheld.PlayFullScreenMovie("222.mp4" , Color.black , FullScreenMovieControlMode.CancelOnInput);
			#endif
			PlayerPrefs.SetInt("HavePlay" , 1);
	    }
		if(_HaveMove==1)
		{
			#if UNITY_IPHONE
			bool tt= Handheld.PlayFullScreenMovie("222.mp4" , Color.black , FullScreenMovieControlMode.CancelOnInput);
			#endif
				
			#if UNITY_ANDROID
			bool tt= Handheld.PlayFullScreenMovie("222.mp4" , Color.black , FullScreenMovieControlMode.CancelOnInput);
			#endif
			PlayerPrefs.SetInt("HavePlay" , 2);
		}
		if(_HaveMove==2)
		{
			#if UNITY_IPHONE
			bool tt= Handheld.PlayFullScreenMovie("222.mp4" , Color.black , FullScreenMovieControlMode.CancelOnInput);
			#endif
				
			#if UNITY_ANDROID
			bool tt= Handheld.PlayFullScreenMovie("222.mp4" , Color.black , FullScreenMovieControlMode.CancelOnInput);
			#endif
			PlayerPrefs.SetInt("HavePlay" , 3);
		}
		/*if(_Move!=null)
		{

			
			if(SkipButton.GetComponent<UIEventListener>()==null)
			{
			    SkipButton.AddComponent<UIEventListener>();
			}
			SkipButton.GetComponent<UIEventListener>().onClick = ClickSkip;
			
			#if UNITY_EDITOR
			int _HaveMove = 0;//PlayerPrefs.GetInt("HavePlay");
			if(_HaveMove==null||_HaveMove==0)				//每播放过
			{	
				//Handheld.PlayFullScreenMovie("222.mp4" , Color.black , FullScreenMovieControlMode.Full);
			   
				playState = true;
			    _MoveGob.gameObject.SetActive(true);
			  	_Move.Play();
				PlayerPrefs.SetInt("HavePlay" , 1);
			}
			else
			{
				playState = false;
				_MoveGob.gameObject.SetActive(false);
				IniSome();
			}
			
			#endif
		}
        */
		IniSome();
	}
	
	bool playState = false;	//true 正在播放 false 播放结束
    void ClickSkip(GameObject _Gob)
	{
		/*playState = false;
		_Move.Stop();
		_MoveGob.gameObject.SetActive(false);
		IniSome();*/
	}

    private float curDownLoadingZIPSize = 0;
	private float CurLoaderProcess = 0;
    private float DownLoaderProces = 0;
    public bool OpFinishi = false;
	private string curUpVersionStr = "";
	UIUpdate uitipupdate;
	void Update () 
	{
		/*if(_Move!=null&&_Move.isPlaying==false&&playState==true)
		{
			playState = false;
			_Move.Stop();
			_MoveGob.gameObject.SetActive(false);
			IniSome();
		}*/
//		Debug.Log ("UseVersionRecord.UpState:" + UseVersionRecord.UpState);
       // if (Input.GetKeyDown(KeyCode.E) == true)
       // {
        //    Application.LoadLevelAsync("MainGame");
        //}
       
        if (CheckNewVersion == true)
        {
            if (CheckStateId == CheckState_S_.S_Null)
            {
                CheckStateId = CheckState_S_.ReadVersionRecord;
				Debug.Log("************ReadLocalVersionRecord");
                ReadLocalVersionRecord();
                return;
            }
            if (CheckStateId == CheckState_S_.ReadVersionRecord && lgNoDelCsFun.Ins.HasReadVersionRecord == true)
            {
                CheckStateId = CheckState_S_.CheckSerVer;
                UseVersionRecord = lgNoDelCsFun.Ins.MyVersionRecord;
                OpFinishi = true;
                return;
            }
            if (CheckStateId == CheckState_S_.CheckSerVer && OpFinishi == true)
            {
                //检查服务器最新版本-
                OpFinishi = false;
				Debug.Log("**************CheckSerHasNewVersion");
                CheckSerHasNewVersion();
				return;
            }

            if (CheckStateId == CheckState_S_.CheckLocalUp)
            {
                if (OpFinishi == true)
                {

					//if(UIUpdate.Ins!=null && nextUpsmallver.Count > 0)
					//{
					//	UIUpdate.Ins.processCur.gameObject.SetActive(true);
					//	UIUpdate.Ins.SetUpdateTipText("正在下载 " + nextUpsmallver[0].ziyuanVer + "...");
					//}
					#if UiTip
					if(uitipupdate!=null && nextUpsmallver.Count > 0)
					{
						uitipupdate.processCur.gameObject.SetActive(true);
						uitipupdate.SetUpdateTipText("正在下载 " + nextUpsmallver[0].ziyuanVer + "...");
					}
					#endif
                    Debug.Log("***********CheckLocalUp");

                    if (UseVersionRecord.UpState == UpState_S_.S_Null)
                    {
                        UseVersionRecord.UpState = UpState_S_.DownUpFile;
                    }
                    if (UseVersionRecord.UpState == UpState_S_.DownUpFile)
                    {
                        //请求下载跟新包-
                        OpFinishi = false;
						if(nextUpsmallver.Count > 0)
						{
							curDownLoadingZIPSize = float.Parse(nextUpsmallver[0].Size);
						}
                        AskDownUpPackage(UseVersionRecord.NowVer);

                    }
                    if (UseVersionRecord.UpState == UpState_S_.UnZipIng)
                    {
                        Debug.Log("***************UnZipIng");
                        //解压缩跟新包-
                        OpFinishi = false;
                        UnzipUpPackage();

                    }
                    if (UseVersionRecord.UpState == UpState_S_.DelNoUseFile)
                    {
                        Debug.Log("****************DelNoUseFile");
                        //删除多余文件-
                        OpFinishi = false;
                        DelNoUseFile();

                    }

                    if (UseVersionRecord.UpState == UpState_S_.UpFinish)
                    {
                        //检查服务器最新版本-
                        Debug.Log("**********UpFinish");
                        OpFinishi = false;
                        //CheckUpFun();
                        if (UseVersionRecord.NowVer != server)
                        {
                            UseVersionRecord.UpState = UpState_S_.DownUpFile;
                        }
                        else
                        {
                            CheckStateId = CheckState_S_.CheckFileComplete;
                        }
                    }
                }

				if(curDownLoadingZIPSize != 0)
				{
                    float curProcess = lgNoDelCsFun.Ins.GetNowWWWProgressValue();
					CurLoaderProcess = curProcess * curDownLoadingZIPSize;
                    float allProcess = (CurLoaderProcess + DownLoaderProces) / allUpPackSize;
                    /*
                    System.Object[] args = new System.Object[1];
                    args[0] = lgNoDelCsFun.Ins.GetNowWWWProgressValue();
                    args[0] = (CurLoaderProcess + DownLoaderProces) / allUpPackSize;
                    lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.SetProcess", args);
                    */

					//if(UIUpdate.Ins != null)
					//{
					//	UIUpdate.Ins.SetProcess(curProcess, allProcess);
					//}						
					#if UiTip
					//uitipupdate.SetProcess(curProcess, allProcess);
					uitipupdate.SetCurProcess(allProcess);
					#endif
					if(lgNoDelCsFun.Ins.GetNowWWWProgressValue() == 1)
					{
						DownLoaderProces += CurLoaderProcess;
						curDownLoadingZIPSize = 0;
					}
				}         
            }
            if (CheckStateId == CheckState_S_.CheckFileComplete  && OpFinishi == true)
            {
				Debug.Log ("*************CheckFileComplete");
                //开始检查完整性-
                OpFinishi = false;
                CheckFileComplete();
            }
            if (CheckStateId == CheckState_S_.UpFinish && OpFinishi == true)
            {
				Debug.Log ("************UpFinish");
                EndCheckUpdata();
            }
        }

	}
	
	public void IniSome () 
	{
#if UiTip
		GameObject uiloadingobj = GameObject.Find("LoadingGamePanel");
		uitipupdate = uiloadingobj.GetComponent<UIUpdate>() as UIUpdate;

#endif

		Debug.Log ("lgAutoUpMag.IniSome");
        ReadGameConfig();
		Debug.Log ("lgNoDelCsFun.Ins.ReadPathConfig");
        lgNoDelCsFun.Ins.ReadPathConfig();
	}
    public void ReadGameConfig()
    {
		Debug.Log ("ReadGameConfig");
        //lgNoDelCsFun.Ins.LoadAssets(false,"", GameConfig_LuaPath, ReadGameConfigCB);
        string path = lgNoDelCsFun.Ins.GetStreamingPath();
#if UNITY_EDITOR
        path = path.Replace('/', '\\');
        path ="file://"+ path;

#elif UNITY_STANDALONE_WIN
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#elif UNITY_IPHONE 
       

#elif UNITY_ANDROID
       
#endif
        path = path + GameConfig_LuaPath;
        lgNoDelCsFun.Ins.LoadAssets_New(path, ReadGameConfigCB);
    }
    public void ReadGameConfigCB(byte[] result)
    {
		Debug.Log ("ReadGameConfigCB");
        if (result == null)
        {
            //报错-
            Debug.LogError("No GameConfig.lua File");
            Application.Quit();
        }
        else
        {
            LuaState GameConfig_lua = new LuaState();
            object obj;
            bool chunk = GameConfig_lua.doBuffer(result,"GameConfig",out obj);
            if (chunk ==true )
            {
                GameConfig_table = (LuaTable)obj;
                lgNoDelCsFun.Ins.GameConfig_table = GameConfig_table;
              
            }
            //开始检查版本-
            //snbug
            CheckNewVersion = true;
          
        }
       
    }

    //检查版本相关-
    public bool CheckNewVersion = false;

	private CheckState_S_ checkStateId = CheckState_S_.S_Null;
    public CheckState_S_ CheckStateId 
	{
		get
		{
			return checkStateId;
		}
		set
		{
			if(checkStateId != value)
			{
				checkStateId = value;
			}				
		}
	}
   

    public void ReadLocalVersionRecord()
    {
        lgNoDelCsFun.Ins.ReadLocalVersionRecord();
    }
    private string downver ="";
    public void AskDownUpPackage(string nowver )
    {
       //snbug
        downver = "";
        if (nowver != server&&nextUpsmallver.Count>0)
        {
//            downver = lgNoDelCsFun.Ins.getNextVer(nowver);
            downver = nextUpsmallver[0].ziyuanVer;
            lgNoDelCsFun.Ins.GetThisFileFromServer(DownVerIp + "/" + downver + ".zip?" + nextUpsmallver[0].Md5, AskDownUpPackageCB);
//          AskDownUpPackage(downver);
        }
        else
        {
            OpFinishi = true;
            CheckStateId = CheckState_S_.CheckFileComplete;
        }
    }
    private byte[] hashValue;
    public void AskDownUpPackageCB(WWW result)
    {
        //取得下载跟新包的版本号-
        smallver = downver;
        if (smallver == null)
        {
            //提示没有跟新包-
            return;
        }
        if (result.error != null)
        {
            //提示网络错误-
            return;
        }
        byte[] str = result.bytes;

        MD5 myRIPEMD5 = MD5.Create();
        hashValue = myRIPEMD5.ComputeHash(str);
        string resulthash = "";
        for (int i = 0; i < hashValue.Length; i++)
        {
            resulthash += string.Format("{0:X2}", hashValue[i]);
        }
		if (resulthash.ToLower() == nextUpsmallver[0].Md5.ToLower() && smallver == nextUpsmallver[0].ziyuanVer)
        {
            lgNoDelCsFun.Ins.WriteOneFile(lgNoDelCsFun.Ins.GetGameLocalPath(), UpdataZiyuan, str);
            UseVersionRecord.TarVer = smallver;
            UseVersionRecord.UpState = UpState_S_.UnZipIng;
            lgNoDelCsFun.Ins.MyVersionRecord.Set(UseVersionRecord);
            lgNoDelCsFun.Ins.SaveNowVersionRecord();
			curUpVersionStr = nextUpsmallver[0].ziyuanVer;
			//UIUpdate.Ins.SetVersionText(curUpVersionStr, server);
			#if UiTip
			uitipupdate.SetVersionText(curUpVersionStr, server);
			#endif
            nextUpsmallver.RemoveAt(0);
            OpFinishi = true;
        }
        else
        {
            //重新下载-
            UseVersionRecord.UpState = UpState_S_.DownUpFile;
            OpFinishi = true;
        }
       
    }

    public void UnzipUpPackage()
    {
        lgNoDelCsFun.Ins.UnpackFiles(lgNoDelCsFun.Ins.GetGameLocalPath() + UpdataZiyuan, lgNoDelCsFun.Ins.GetGameLocalPath(),1, UnzipUpPackageCB);
    }
    public void UnzipUpPackageCB()
    {
        //删除跟新的zip文件-
        lgNoDelCsFun.Ins.DelOneFile(lgNoDelCsFun.Ins.GetGameLocalPath(), UpdataZiyuan, null);
       
        UseVersionRecord.UpState = UpState_S_.DelNoUseFile;
        lgNoDelCsFun.Ins.MyVersionRecord.Set(UseVersionRecord);
        lgNoDelCsFun.Ins.SaveNowVersionRecord();
        OpFinishi = true;
    }
    public void DelNoUseFile()
    {
		UseVersionRecord.UpState = UpState_S_.DownUpFile;
		OpFinishi = true;
        //lgNoDelCsFun.Ins.DelFileS();
    }
    public void DelNoUseFileCB()
    {
        UseVersionRecord.NowVer = UseVersionRecord.TarVer;
        UseVersionRecord.UpState = UpState_S_.UpFinish;
        lgNoDelCsFun.Ins.MyVersionRecord.Set(UseVersionRecord);
        lgNoDelCsFun.Ins.SaveNowVersionRecord();
        OpFinishi = true;
    }
    public void CheckSerHasNewVersion()
    {
        highver = lgNoDelCsFun.Ins.MyInstallPackageVR.TarVer;
        //比较本地最高版本-
        if (UseVersionRecord.TarVer!="")
        {
            highver = lgNoDelCsFun.Ins.GetHigherVer(UseVersionRecord.TarVer, highver);
        }
        //发送本地最高版本给服务器 snbug-
        WWWForm f = new WWWForm();
       
        f.AddField("GameName", (string)GameConfig_table["GameName"]);
        f.AddField("ChannelName", (string)GameConfig_table["ChannelName"]);
        f.AddField("Language", (string)GameConfig_table["Language"]);
        f.AddField("Ver", highver);
       
        string url = (string)GameConfig_table["UpDataSer"];
        Debug.LogError("Auto Update Host = " + url);
        WebRequestManager.GetInstance().SendRequest(url, f, CheckSerHasNewVersionCB);

    }
    private string highver = "";
    private string server = "";
    private string smallver = "";
    private List<UpdataZiyuanInfo_> nextUpsmallver = new List<UpdataZiyuanInfo_>();
    private string DownVerIp = "";
    float allUpPackSize = 0;    //所有更新包的Size
    public void CheckSerHasNewVersionCB(string netReturnBuff, int errorID, string errInfo)
    {
        if (errorID!=0)
        {
            //提示报错-
            lgNoDelCsFun.Ins.DebugLogNetErr("CheckSerHasNewVersionCB " , errorID, errInfo);
            return;
        }
        //得到服务器最新版本 snbug-
        IDictionary objStr = (IDictionary)MiniJSON.Json.Deserialize(netReturnBuff);
        int re =System.Convert.ToInt32(objStr["r"]) ;
        if (re != 0)
        {
            //提示报错-
            lgNoDelCsFun.Ins.DebugLogNetErr("CheckSerHasNewVersionCB ", netReturnBuff);
            return;
        }
        IDictionary objd = objStr["d"] as IDictionary;

        server = System.Convert.ToString(objd["CurrentVer"]);

		//如果服务器版本比当前版本号还低 则跳过更新 或者报错 退出游戏
		//if (lgNoDelCsFun.Ins.GetHigherVer (highver, server) == highver)
		//{

		//return;
		//}

        DownVerIp = System.Convert.ToString(objd["DownloadUri"]);
		
        //设置界面当前/最新版本号
        //UIUpdate.Ins.SetVersionText(highver, server);
		#if UiTip
		uitipupdate.SetVersionText(highver, server);
		#endif
		//得到下次小版本跟新版本号-
        nextUpsmallver.Clear();
        List<object> objnextUpsmallver = objd["Tasks"] as List<object>;
        for (int i = 0; i < objnextUpsmallver.Count; i++)
        {
            IDictionary nextUpsmallverstr = objnextUpsmallver[i] as IDictionary;
            UpdataZiyuanInfo_ thisinfo = new UpdataZiyuanInfo_();
            thisinfo.ziyuanVer = System.Convert.ToString(nextUpsmallverstr["ver"]);
            thisinfo.Md5 = System.Convert.ToString(nextUpsmallverstr["md5"]);
            thisinfo.Size = System.Convert.ToString(nextUpsmallverstr["size"]);
            allUpPackSize += float.Parse(thisinfo.Size);
            nextUpsmallver.Add(thisinfo);
        }
       
        //OpFinishi = true;
        //检查一次-
        CheckUpFun();
    }

//snbug前往APPSTORE下载大版本
	private void BigVersionCheckCb(int isOk)
	{	
		Application.OpenURL ("https://www.baidu.com");
		//Application.Quit();
		//Debug.Log ("BigVersionCheckCb--------" + isOk);
	}
	
    public void CheckUpFun()
    {
        bool neenUpdataBigVer = false;
       // bool neenUpdatasmallVer = false;

        if (server != highver)
        {
            string[] ver1list = server.Split('.');
            string[] ver2list = highver.Split('.');
            if (int.Parse(ver1list[0]) > int.Parse(ver2list[0]))
            {
                neenUpdataBigVer = true;
            }
            //else
            //{
            //    neenUpdatasmallVer = true;
            //}
        }
        if (neenUpdataBigVer == true)
        {
            //需要下载大版本跟新
			//UIUpdate.Ins.ShowPanel(BigVersionCheckCb, "OkPanel");
			#if UiTip
			uitipupdate.ShowPanel(BigVersionCheckCb, "OkPanel");
			#endif
			//提示跟新大版本-
            CheckNewVersion = false;
            return;

        }

        //检测是不是在安装包里资源是最新  如果是要解压开-
        if(highver!= UseVersionRecord.TarVer)
        {
//			lgNoDelCsFun.Ins.ShowTip ("second uninstalzip judge", highver + "!=" + UseVersionRecord.TarVer);
            //将原来Usedata文件夹下的文件移动到DEL里等待删除  实际是清空Usedata文件夹  -
            lgNoDelCsFun.Ins.MoveFileS(lgNoDelCsFun.Ins.GetGameLocalPath() + lgNoDelCsFun.Ins.usedata, lgNoDelCsFun.Ins.GetGameLocalPath() + lgNoDelCsFun.Ins.delfile,null);
            lgNoDelCsFun.Ins.DelFileS(true, lgNoDelCsFun.Ins.GetGameLocalPath() + lgNoDelCsFun.Ins.delfile, null);
            //开始解压缩安装包中的资源ZIP-

           // lgNoDelCsFun.Ins.UnpackFiles(lgNoDelCsFun.Ins.GetLocalstreamingAssetsPath(true) + lgNoDelCsFun.Ins.InstallZiyuan, lgNoDelCsFun.Ins.GetGameLocalPath(), 1, UnpackziyuanFinish);

            string streampath = lgNoDelCsFun.Ins.GetStreamingPath();
			#if UNITY_IPHONE

				streampath = "file://"+streampath;
			#endif
            lgNoDelCsFun.Ins.UnpackFiles(streampath + lgNoDelCsFun.Ins.InstallZiyuan, lgNoDelCsFun.Ins.GetGameLocalPath(), 1, UnpackziyuanFinish);

            return;
        }

        if (server == UseVersionRecord.TarVer)
        {
            //开始检查完整性-
            CheckStateId = CheckState_S_.CheckFileComplete;
            OpFinishi = true;
            
        }
        else 
        {
			if(nextUpsmallver.Count<=0)		//如果小版本也不需要更新 则直接更新完成
			{
				OpFinishi = true;
				CheckStateId = CheckState_S_.CheckFileComplete;
				return;
			}
//小版本更新前，检查若非wifi网络，提示用户。
			if(Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork)
			{
				//UIUpdate.Ins.ShowPanel(WifiCheckCb, "OkCancelPanel"); 
				#if UiTip
				//uitipupdate.ShowPanel(WifiCheckCb, "OkCancelPanel"); //没有OkCancelPanel这个panel 会报错
				#endif

				//小版本跟新-
				CheckStateId = CheckState_S_.CheckLocalUp;
				UseVersionRecord.UpState = UpState_S_.DownUpFile;
				OpFinishi = true; 

			}
			else
			{
				//小版本跟新-
				CheckStateId = CheckState_S_.CheckLocalUp;
				UseVersionRecord.UpState = UpState_S_.DownUpFile;
				OpFinishi = true; 
			}
        }        
    }

	public void WifiCheckCb(int isUpdate)
	{
		if (isUpdate == 1) 
		{
			//小版本跟新-
			CheckStateId = CheckState_S_.CheckLocalUp;
			UseVersionRecord.UpState = UpState_S_.DownUpFile;
			OpFinishi = true; 
		}
		else
		{
			Application.Quit();
			//Debug.Log ("operate: 退出游戏！");
		}
	}

    public void UnpackziyuanFinish()
    {
        UseVersionRecord.Set(lgNoDelCsFun.Ins.MyInstallPackageVR);
        lgNoDelCsFun.Ins.MyVersionRecord.Set(lgNoDelCsFun.Ins.MyInstallPackageVR);
        //lgNoDelCsFun.Ins.SaveNowVersionRecord();
        CheckUpFun();
    }
    
    public void CheckFileComplete()
    {
        //snbug
        CheckFileCompleteCB();
    }
    public void CheckFileCompleteCB()
    {
        OpFinishi = true;
        CheckStateId = CheckState_S_.UpFinish;
    }
    private VersionRecord_D_ UseVersionRecord;

    public void EndCheckUpdata()
    {
		//UIUpdate.Ins.UpdateFinish ();
		#if UiTip
		uitipupdate.UpdateFinish ();
		#endif
		CheckNewVersion = false;
       // CheckStateId = CheckState_S_.UpFinish;
       // OpFinishi = true;
        GameConfig_table = null;
        Debug.Log("Updata Complete! Enter Game Now!");
       // lgNoDelCsFun.Ins.InitAssetBundle();
        //开始进入游戏-
		lgNoDelCsFun.Ins.AutoupdatLoadMainSc ();
       // lgNoDelCsFun.Ins.LoadMainLua();
    }
}
