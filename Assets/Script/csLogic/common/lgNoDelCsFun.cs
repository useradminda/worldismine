//
//不会删除 存放公用方法-
//Author : scy
#define bundletest1
#define loadbundlecycletest1
#define showonguitest1
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using SLua;
using MiniJSON;
using ICSharpCode.SharpZipLib.Zip;
using System.Text.RegularExpressions;

public delegate void LoadFinish(byte[] result);
public delegate void DelOneFileFinish();
public delegate void MoveFileFinish();
public delegate void DownLoadFinish(WWW result);

public delegate void PackFilesFinish();
public delegate void UnpackFilesFinish();

#pragma warning disable 0472
#pragma warning disable 0219

public enum AssetBundleState
{
   Bundle_Null = -1,
   OnLoadAssetBundle = 1,
   LoadAssetBundleOK = 2,
}

public enum UpState_S_
{
    S_Null =-1,
    CheckSerVer = 0,
    DownUpFile = 1,
    UnZipIng = 2,
    DelNoUseFile =3,
    UpFinish =4
}
public struct delFileS_
{
    public string path;
    public List<string> fileList;
}
public struct VersionRecord_D_
{
    public string NowVer;
    public string TarVer;
    public UpState_S_ UpState;
    public int UpProgress;
    // public int CheckFileMd5;
    public void IniSome(IDictionary data)
    {
		//Debug.Log ("VersionRecord_D_ IniSome:" + data ["UpState"] + "," + data ["TarVer"]);
        NowVer = System.Convert.ToString(data["NowVer"]);
        TarVer = System.Convert.ToString(data["TarVer"]);
        UpState = (UpState_S_)System.Convert.ToInt32(data["UpState"]);
        UpProgress = System.Convert.ToInt32(data["UpProgress"]);

    }
    public string GetToJsonStr()
    {
        Dictionary<object,object> thisdict2 = new Dictionary<object,object>();
        IDictionary thisdict = (IDictionary)thisdict2;
        thisdict.Add("NowVer", NowVer);
        thisdict.Add("TarVer", TarVer);
        thisdict.Add("UpState", (int)UpState);
        thisdict.Add("UpProgress", UpProgress);
        string result = Json.Serialize(thisdict);
        return result;
    }
    public void Set(VersionRecord_D_ newdata)
    {

        NowVer = newdata.NowVer;

        TarVer = newdata.TarVer;

        UpState = newdata.UpState;

        UpProgress = newdata.UpProgress;
       
    }
    public void Set(string ver,string tver,UpState_S_ s,int prog)
    {
        if (ver != null)
        {
            NowVer = ver;
        }
        if (tver != null)
        {
            TarVer = tver;
        }
        if (s != null)
        {
            UpState = s;
        }
        if (prog != null)
        {
            UpProgress = prog;
        }
    }

}
public struct LoadAssetCb_
{
	public LuaTable info; 
	public LuaFunction cb;
}

public struct LoadAssetP_
{
	public string assetBundleName; 
	public string assetName;
	public bool isui;
	public bool isCS;
}

public struct LoadLuaAssetP_
{
    public string assetBundleName;
    public string assetName;
    public LoadLuaBundleCb cb;
}


public delegate void LoadLuaBundleCb(string lua);

//public class CheckFileIntact_
[CustomLuaClass]
public class lgNoDelCsFun : BaseLoader {
	static int ammoLayer = 8; //炮弹层级
	public AssetBundleState BundleState = AssetBundleState.Bundle_Null;									//assetbundle的加载状态
	public string SceneName = "";
    public string prefabTestName = "label";
	public float scale = 2;
	public void SetAmmoLayer(GameObject go)
	{
		go.layer = ammoLayer;
	}

/// <summary>
/// test prop value
/// </summary>
	public string[] propName = new string[]{"life","attack","magicattack","phydefense","magicdefense","critprob","critpvalue","realattack","movespeed","cdreduce", "闪避", "attackspeed", "_canMove"};
	public Dictionary<string, float[]> propList = new Dictionary<string, float[]> ();

	public float[] propArr = new float[13];
	public void SetProp(float[] Battledata, string name)
	{
		if (propList.ContainsKey (name))
			propList.Remove (name);

		propList.Add (name, Battledata);
	}

    public string GetStringFromBytes(byte[] bytes)
    {
        return System.Text.Encoding.UTF8.GetString(bytes);
    }

    public Dictionary<string,string> tipDic = new Dictionary<string, string>();
    public void ShowTip(string key, string s)
    {
        if (!tipDic.ContainsKey(key))
        {
            tipDic.Add(key, s);
        }
        else
        {
            tipDic[key] = s;
        }
    }

	public string basicMapName = "BasicScene_2";
	public string dataConfigFileName = "Legend_";
	public string mapStartIndex = "1";
	public string mapEndIndex = "1";

	public string btType = "pve";
	public bool isNet = true;
	public string mapId = "1410101";
	public string Enviroment = "";

    //public Dictionary<string, string> LoadTempObjaAsset = new Dictionary<string, string>();
    //public Dictionary<string, string> LoadNoTempObjaAsset = new Dictionary<string, string>();
    private void GetElf_3_1Cb(string content)
    {
        Debug.Log("cb------" + content);
    }

	private int curIndex = 1;
	/*
	public void EnterPVPTest()
	{ 
		System.Object[] param = new System.Object[1];
		param [0] = curIndex;
		StartCoroutine (DelayToInvoke.DelayToInvokeDo (() =>{
			Call (mainlua, "GameMain.testxxx2", param);
		}, 3));
		StartCoroutine (DelayToInvoke.DelayToInvokeDo (() =>{
			Call (mainlua, "GameMain.EnterPVPTest", param);
		}, 5));
		curIndex++;
	}
	*/
#if showonguitest
	new void OnGUI()
	{
		base.OnGUI ();

		GUI.skin.label.normal.textColor = Color.black;  
		GUILayout.BeginHorizontal();
		foreach (var key in propList.Keys) {

			GUILayout.BeginVertical();
			GUILayout.Label(key.ToString());
			float[] item = propList[key];
			for (int p = 0; p < item.Length; p++) {
				GUILayout.Label(propName[p] + ":" + item[p].ToString());
			}
			GUILayout.EndVertical();
		}

        foreach (var key in tipDic.Keys)
        {

            GUILayout.BeginVertical();
            GUILayout.Label(key.ToString());
            GUILayout.Label(tipDic[key].ToString());
            GUILayout.EndVertical();
        }
        
		GUILayout.EndHorizontal ();


	
		/*
		GUILayout.BeginArea (new Rect(50, 200, 300, 300));
		GUILayout.BeginVertical ();
			isNet = GUILayout.Toggle (isNet, "网络战斗");
			GUILayout.BeginHorizontal ();
				GUILayout.Label ("基础场景：");
				basicMapName = GUILayout.TextField (basicMapName);				
			GUILayout.EndHorizontal ();

			GUILayout.BeginHorizontal ();			
				GUILayout.Label ("场景地图配置前缀：");
				dataConfigFileName = GUILayout.TextField (dataConfigFileName);
				GUILayout.Label (" ");
				mapStartIndex = GUILayout.TextField (mapStartIndex);
				GUILayout.Label ("-");
				mapEndIndex = GUILayout.TextField (mapEndIndex);
			GUILayout.EndHorizontal ();

			GUILayout.BeginHorizontal ();			
				GUILayout.Label ("DB地图编号(可选)：");
				mapId = GUILayout.TextField (mapId);
			GUILayout.EndHorizontal ();
			if (GUILayout.Button ("AutoRunGame")) {
				StartAutoRunGame();
			}
			
		GUILayout.EndVertical ();
		GUILayout.EndArea ();
		*/


	}

#endif    
/*
	public int GetCurFightIndex()
	{
		return curFightIndex;
	}

    private int curFightIndex = 0;
	public void StartAutoRunGame()
	{
		Debug.LogError ("StartAutoRunGame:" + curFightIndex);
		if (curFightIndex == 0) {
			curFightIndex = int.Parse (mapStartIndex);
		} else {
			curFightIndex++;
			mapId = (int.Parse (mapId) + 1).ToString ();
		}

		if (curFightIndex > int.Parse (mapEndIndex)) {
			return;
		}

		System.Object[] args = new System.Object[5];		
		args [0] = basicMapName;
		args [1] = btType;
		args [2] = isNet.ToString ();
		args [3] = dataConfigFileName + curFightIndex;        
		args [4] = mapId;

		StartCoroutine (DelayToInvoke.DelayToInvokeDo (() =>
		{
			Debug.Log ("GameMain.EnterBattleTest");
			lgNoDelCsFun.Ins.Call (lgNoDelCsFun.Ins.mainlua, "GameMain.EnterBattleTest", args);
		}, 2));
	}

	public void EnterSkillTestScene(string mapId)
	{
		System.Object[] args = new System.Object[5];		
		args [0] = "BasicScene_3";
		args [1] = "pve";
		args [2] = "false";
		args [3] = "Elf_1";        
		args [4] = mapId;
		
		StartCoroutine (DelayToInvoke.DelayToInvokeDo (() =>
		                                               {
			lgNoDelCsFun.Ins.Call (lgNoDelCsFun.Ins.mainlua, "GameMain.EnterBattleTest", args);
		}, 2));
	}
    */
	//
    private bool _luafileOpened = false;
    private static lgNoDelCsFun _ins = null;
    public static lgNoDelCsFun Ins
    {
        get
        {
            if (_ins == null)
            {
				Physics.IgnoreLayerCollision(ammoLayer, ammoLayer, true);
				GameObject NoDelCsFunObjAset =Resources.Load("Lgnodelcsfun", typeof(GameObject)) as GameObject;// Resources.Load("NeedPrefab/NoDelCsFunObj", typeof(GameObject)) as GameObject;
                GameObject MyObj = GameObject.Instantiate(NoDelCsFunObjAset, Vector3.zero, Quaternion.identity) as GameObject;

			}
			return _ins;
        }
    }
    public GameObject MyObj
    {
        get
        {
            return gameObject;
        }
    }
    void Awake()
    {
		CheapShadow.InitLight(new Vector3(-1, 1, 0), 0.1f);
        Debug.LogError("！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！");
		#if UNITY_ANDROID
        Debug.Log("这里是安卓设备^_^");
        
		
        #endif

		_ins = this;
        GameObject.DontDestroyOnLoad(gameObject);
		//Application.targetFrameRate = 30;
#if UNITY_EDITOR
//        Application.targetFrameRate = 300;
	#if bundletest
	        //InitLuaBundle();
	#else
			Enviroment = "EDITOR";
	#endif
#else
      Application.targetFrameRate = 30;
       //InitLuaBundle();
#endif

    }
	GameObject Fingerroot;
	void Start()
	{
		Fingerroot = GameObject.Find ("fingerroot");
		if(Fingerroot!=null)
		{
			Fingerroot.SetActive(false);
		}
	}
	//sn test 2016.04.27
	/*
	void Start()
    {

#if UNITY_EDITOR
		//ReadPathConfig ();
#else
        //string streampath = GetStreamingPath();
       // UnpackFiles(streampath + InstallZiyuan, GetGameLocalPath(), 1, UnpackziyuanFinish11);
#endif

		//string path1 = Application.dataPath + "/StreamingAssets/pc2.txt";
		//string teseee  = File.ReadAllText (path1);
		//lgCfgMag.Ins.pvpresult = teseee;

	}

    public void UnpackziyuanFinish11()
    {
        Debug.LogError("UnpackziyuanFinish11 finish");
        ReadPathConfig();
    }
    */
	//public GameObject abfather = null;
    new void Update()
    {

       // Debug.LogError("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
		if(checkIniBundleFinish==true && BundleState == AssetBundleState.LoadAssetBundleOK)
		{
            //Debug.LogError("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			if(AssetBundleManager.m_AssetBundleManifest ==null)
			{
				Debug.LogError("Update  AssetBundleManager.m_AssetBundleManifest no has done");
			}
           // Debug.LogError("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
            Startmainlua(mainluaData);	
			mainluaData = null;
			checkIniBundleFinish = false;
		}
        DotNetClient.hzClient hzclient = DotNetClient.hzClient.GetPtr();
        if (hzclient != null)
        {
            hzclient.update();
        }

        WebRequestManager.GetInstance().Update();
        if(mainlua!=null)
        {		
            Call(mainlua, "GameMain.Update", Time.deltaTime);
        }
		if(Gameupdatefun!=null)
		{
			Gameupdatefun.call();
		}

		base.Update ();

		if(IsInBattle ==true)
		{
			
			lgbtmag.Ins.UpdateState(Time.deltaTime);
		}

		if(LoadingMainSC==true&&async.isDone==true)
		{
			LoadingMainSC =false;
			InitAssetBundle();
		}
		if(MySdkMag!=null)
		{
			MySdkMag.updatacheck(Time.deltaTime);
		}
    }
/*
	public Texture testabtex = null;

	public bool testab =false;
	public GameObject testabobj =null;
	public GameObject testabobj2 =null;
	public void testabFun (GameObject ab)
	{
		Debug.LogError ("testabFun----"+ ab.name);
		GameObject testabobj3 = GameObject.Instantiate (ab);
		 testabobj3.name = "testobj1";
		//testabobj.transform.parent = abfather.transform;
		//testabobj.AddComponent<lgtestab>();
		//UISprite tex1 = testabobj.transform.FindChild("ItemIMG").GetComponent<UISprite> () as UISprite;
		//tex1.atlas
		//tex1.atlas
		//UIAtlas tis = SetAtlasGrayMask (tex1.atlas);
		//tex1.atlas = tis;
		//testabobj2 = tis.gameObject;
		//tex1.spriteName = "Icon_Equip_25";
		//testabtex = tex1.atlas.texture;
		//GameObject.Destroy (testabobj);
		//testabobj = null;
	}
*/
	public void LateUpdate()
	{
		/*for(int x = 0 ; x <= 30 ; x++)
		{
			Debug.DrawLine(new Vector3((float)x * 0.3f , 0 , 0) , new Vector3((float)x* 0.3f, 9 , 0) , Color.red);
		}
		for(int y = 0; y <= 30 ; y++)
		{
			Debug.DrawLine(new Vector3(0 , (float)y* 0.3f , 0) , new Vector3(9 , (float)y* 0.3f , 0) , Color.red);
		}*/
		
		//Debug.LogError ("lgNoDelCSFun lateupdate");
		//if(mainlua!=null)
		//{
		//	Call(mainlua, "GameMain.LateUpdate", Time.deltaTime);
		//}
		if(GameLateupdatefun!=null)
		{
			GameLateupdatefun.call();
		}
	}
	public LuaFunction GameLateupdatefun = null;
	public LuaFunction Gameupdatefun = null;

  
    public LuaTable GameConfig_table;
    //路径管理相关-
    public bool HasReadPathConfig = false;
    public string PathConfig_lua = "PathConfig.lua";
    public LuaTable PathConfig_table;
    private bool WriteToLoacl =false;
    public void ReadPathConfig()
	{
		Debug.Log ("------------------ReadPathConfig---------------------");
        //LoadAssets(false, "", PathConfig_lua, ReadPathConfigCB);
        string path = GetStreamingPath();
        path = path + PathConfig_lua;
#if UNITY_EDITOR
        path = path.Replace('/', '\\');
        path = "file://" + path;

#elif UNITY_STANDALONE_WIN
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#elif UNITY_IPHONE 
       

#elif UNITY_ANDROID
       
#endif
        
        LoadAssets_New(path, ReadPathConfigCB);
    }
    public void ReadPathConfigCB(byte[] result)
    {
		Debug.LogError ("ReadPathConfigCB" + result);
        if (result == null)
        {
            Debug.LogError("检查路径=================================");
            //string filePath = Application.persistentDataPath + "/";
            //LoadAssets(filePath, PathConfig_lua, ReadPathConfigCB);

            string path = GetTempPath();
            path = path + PathConfig_lua;
#if UNITY_EDITOR
            path = path.Replace('/', '\\');
            path = "file://" + path;

#elif UNITY_STANDALONE_WIN
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#elif UNITY_IPHONE 
       

#elif UNITY_ANDROID
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#endif
            LoadAssets_New(path, ReadPathConfigCB);
            WriteToLoacl =true;
        }
        else
        {
            LuaState GameConfig_lua = new LuaState();
            object chunk;
            bool get = GameConfig_lua.doBuffer(result,"GameConfig",out chunk);
            if (get == true )
            {
                PathConfig_table = (LuaTable)chunk;
                HasReadPathConfig = true;
            }
            if(WriteToLoacl == true)
            {
                WriteOneFile(GetGameLocalPath(), PathConfig_lua, result);
            }
         //snbug 2016.04.27
#if bundletest
			//InitAssetBundle();
#else
			//LoadMainLua();
#endif
          //  Debug.LogError("LoadMainLua=================================");
           
        }
    }
    

    //版本跟新记录文件相关-
    public string LocalVersionRecord_n = "VersionRecord.txt";
    private bool WriteVersionToLoacl = false;
    public bool HasReadVersionRecord = false;
    public VersionRecord_D_ MyVersionRecord = new VersionRecord_D_();
    public VersionRecord_D_ MyInstallPackageVR = new VersionRecord_D_();
   public void ReadLocalVersionRecord()
   {
	   Debug.Log ("%%%%%%%%%%%%%%%%%%%%ReadLocalVersionRecord");
       HasReadVersionRecord = false;
       WriteVersionToLoacl = false;
       ReadMyZiyuanVR();
       
   }
   public void ReadMyZiyuanVR()
   {
       //LoadAssets(false, "", LocalVersionRecord_n, ReadMyZiyuanVRCB);
       string path = GetStreamingPath();
       path = path + LocalVersionRecord_n;
#if UNITY_EDITOR
       path = path.Replace('/', '\\');
       path = "file://" + path;

#elif UNITY_STANDALONE_WIN
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#elif UNITY_IPHONE 
       

#elif UNITY_ANDROID
       
#endif
       LoadAssets_New(path, ReadMyZiyuanVRCB);
   }

   private string SETUP_FINISH_KEY = "SetupFinish";

   public string InstallZiyuan = "InstallZiyuan.zip";
   public void ReadMyZiyuanVRCB(byte[] result)
   {
		Debug.Log ("%%%%%%%%%%%%%%%%%%%%ReadMyZiyuanVRCB");
		if (result == null) {
			//提示报错-
			return;
		}
		string str = System.Text.Encoding.Default.GetString (result);
		//Debug.Log ("str:" + str);
		//str = "{\"NowVer\":\"1.3.1.0\",\"TarVer\":\"1.3.1.0\",\"UpState\":\"-1\",\"UpProgress\":\"-1\"}";
		IDictionary LocalVersion = (IDictionary)Json.Deserialize (str);
		MyInstallPackageVR.IniSome (LocalVersion);
		//ReadOneFile(GetGameLocalPath(), LocalVersionRecord_n, ReadLocalVersionRecordCB);
        //File.Exists (GetGameLocalPath () + LocalVersionRecord_n) == false
bool isSetup = false;
#if UNITY_EDITOR
	isSetup = true;
#else
	isSetup = PlayerPrefs.HasKey(SETUP_FINISH_KEY);
#endif
		//ShowTip (PlayerPrefs.GetInt (SETUP_FINISH_KEY));
		Debug.Log ("------------------FIRST UN_JUDGE-------------" + GetGameLocalPath() + " exists:" + Directory.Exists(GetGameLocalPath()).ToString() + "," + GetGameLocalPath () + LocalVersionRecord_n + " exists:" + File.Exists (GetGameLocalPath () + LocalVersionRecord_n));
#if UNITY_STANDALONE_WIN 
		if(Directory.Exists(GetGameLocalPath()) == false || File.Exists (GetGameLocalPath () + LocalVersionRecord_n) == false || !isSetup)
#else
		if (!isSetup)
#endif
        {
//			ShowTip ("fist uninstallzip judge", Directory.Exists(GetGameLocalPath()).ToString() + "," + File.Exists (GetGameLocalPath () + LocalVersionRecord_n).ToString() + "," + (!isSetup).ToString());
			Directory.CreateDirectory (GetGameLocalPath ());
			MoveFileS (lgNoDelCsFun.Ins.GetGameLocalPath () + usedata, GetGameLocalPath () + delfile, null);
			DelFileS (true, GetGameLocalPath () + delfile, null);
			//开始解压缩安装包中的资源ZIP-
			Debug.Log ("=============start UnpackFiles================");
            string streampath = GetStreamingPath();
			Debug.Log("start UnpackFiles:" + streampath + InstallZiyuan + "," + GetGameLocalPath());
            UnpackFiles(streampath + InstallZiyuan, GetGameLocalPath(), 1, UnpackziyuanFinish);
			//UnpackFiles (GetLocalstreamingAssetsPath (true) + InstallZiyuan, GetGameLocalPath (), 1, UnpackziyuanFinish);
		} else {
			Debug.Log ("%=============no UnpcakFiles===================");
			//LoadAssets (GetGameLocalPath (), LocalVersionRecord_n, ReadLocalVersionRecordCB);
			//InitAssetBundle();

            string path = GetTempPath();
            path = path + LocalVersionRecord_n;
#if UNITY_EDITOR
            path = path.Replace('/', '\\');
            path = "file://" + path;

#elif UNITY_STANDALONE_WIN
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#elif UNITY_IPHONE 
       

#elif UNITY_ANDROID
        path = path.Replace('/', '\\');
       path ="file://"+ path;
#endif
            //if (File.Exists(path) == true)
            //{
            //    Debug.Log("File.Exists(path) == true");
            //    string str112 = File.ReadAllText(path);
            //    Debug.Log(str112);
            //}
            //else
            //{
            //    Debug.Log("File.Exists(path) == false" + path);

            //}
            LoadAssets_New(path, ReadLocalVersionRecordCB);
		}
	}
   public void UnpackziyuanFinish()
   {
		//InitAssetBundle ();
		Debug.Log ("===============UnpackziyuanFinish========================");
//		ShowTip ("UnpackziyuanFinish SetInit=1 start", SETUP_FINISH_KEY + "=" + PlayerPrefs.HasKey (SETUP_FINISH_KEY).ToString ());
        PlayerPrefs.SetInt(SETUP_FINISH_KEY, 1);
//		ShowTip ("UnpackziyuanFinish SetInit=1 end", SETUP_FINISH_KEY + "=" + PlayerPrefs.HasKey (SETUP_FINISH_KEY).ToString ());
      // LoadAssets(GetGameLocalPath(), LocalVersionRecord_n, ReadLocalVersionRecordCB);
       string path = GetTempPath();
       path = path + LocalVersionRecord_n;
#if UNITY_EDITOR
       path = path.Replace('/', '\\');
       path = "file://" + path;

#elif UNITY_STANDALONE_WIN
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#elif UNITY_IPHONE 
       

#elif UNITY_ANDROID
       path = path.Replace('/', '\\');
       path = "file://" + path;

#endif
       LoadAssets_New(path, ReadLocalVersionRecordCB);
   }
   public string Usedatastr = "Usedata.zip";
   public void ReadLocalVersionRecordCB(byte[] result)
   {
       if (result != null)
       {
           string str = System.Text.Encoding.Default.GetString(result);
           IDictionary LocalVersion = (IDictionary)Json.Deserialize(str);
           MyVersionRecord.IniSome(LocalVersion);
          
       }
       HasReadVersionRecord = true;
   }

   public void SaveNowVersionRecord()
   {
      string result = MyVersionRecord.GetToJsonStr();
      WriteOneFile(GetGameLocalPath(), LocalVersionRecord_n, result);
   }

    //snbug 需要修改-
//   public string getNextVer(string thisver)
//   {
//      string[]  thisverlist = thisver.Split('.');
//      int small = int.Parse(thisverlist[2])+1;

//      string result = thisverlist[0] + thisverlist[1] + small.ToString();
//      return result;
//   }

    public string usedata = "Usedata";
    public string delfile = "DEL";
    //通用方法-
    private string rootpath = "";
	public string GetGameLocalPath()
    {
		#if UNITY_EDITOR
		rootpath = Application.dataPath + "/ziyuan/";
		#else
		rootpath = Application.persistentDataPath + "/ZQ/";
		#endif			
		return rootpath;
	}
    //snbug-
    public string GetLocalstreamingAssetsPath(bool isFileOperate = false)
    {
		string rootpath = "";
#if UNITY_EDITOR || UNITY_STANDALONE_WIN || UNITY_STANDALONE_OSX       
		rootpath = (isFileOperate ? "" : "file://") + Application.dataPath + "/StreamingAssets/";
#elif UNITY_IPHONE 
		rootpath = Application.dataPath +"/Raw/";
#elif UNITY_ANDROID 
		Debug.Log("android rootpath:" + Application.dataPath );
		rootpath = "jar:file://" + Application.dataPath + "!/assets/";
#endif
		return rootpath;
    }
    public void DelOneFile(string path, string filename, DelOneFileFinish DelOneFileFinishCB)
    {

        if ( path == string.Empty || Directory.Exists(path) == false)
        {
            if (DelOneFileFinishCB != null)
            {
                DelOneFileFinishCB();
            }
            return;
        }
        File.Delete(path + filename);
        if (DelOneFileFinishCB!=null)
        {
            DelOneFileFinishCB();
        }
    }
   
    public void DelFileS(bool useCoroutine, string path,  DelOneFileFinish DelOneFileFinishCB)
    {
        if (useCoroutine == false)
        {
            if (Directory.Exists(path) == false)
            {
                if (DelOneFileFinishCB != null)
                {
                    DelOneFileFinishCB();
                }
                return;
            }
            Directory.Delete(path, true);
            if (DelOneFileFinishCB != null)
            {
                DelOneFileFinishCB();
            }
        }
        else
        {
            StartCoroutine(delFileS(path, DelOneFileFinishCB));
        }
    }
    IEnumerator delFileS(string path, DelOneFileFinish DelOneFileFinishCB)
    {
        if (Directory.Exists(path) == false)
        {
            if (DelOneFileFinishCB != null)
            {
                DelOneFileFinishCB();
            }
            yield return 0;
        }
        else
        {
            Directory.Delete(path, true);
            if (DelOneFileFinishCB != null)
            {
                DelOneFileFinishCB();
            }
            yield return 0;
        }
    }
    public void DelFileS(List<delFileS_> delfilelist, MoveFileFinish cb)
    {
        StartCoroutine(delFileS( delfilelist,cb));
    }
    IEnumerator delFileS(List<delFileS_> delfilelist, MoveFileFinish cb)
    {
        if (delfilelist!=null)
        {
            int i =0;
            int k =0;
            for (i = 0; i < delfilelist.Count; i++ )
            {
                if (Directory.Exists(delfilelist[i].path) == false)
                {
                    for (k = 0; k < delfilelist[i].fileList.Count; k++)
                    {
                        File.Delete(delfilelist[i].path + delfilelist[i].fileList[k]);
                        yield return 0;
                    }
                }
            }
            
        }
        if (cb!=null)
        {
            cb();
        }
        
    }
    public void MoveFileS(string path, string pathto, MoveFileFinish MoveFileFinishCB)
    {
        if (Directory.Exists(path) == false)
        {
            if (MoveFileFinishCB != null)
            {
                MoveFileFinishCB();
            }
            return;
        }
		/*
        if (Directory.Exists(pathto) == false)
        {
            Directory.CreateDirectory(pathto);
        }
        */
        Directory.Move(path, pathto);
        if (MoveFileFinishCB != null)
        {
            MoveFileFinishCB();
        }
    }
    public void ReadOneFile(string path, string filename, LoadFinish LoadFinishCb)
    {
        byte[] file = null;
        if (LoadFinishCb == null||path == string.Empty || Directory.Exists(path) == false)
        {
            return;
        }
        file = File.ReadAllBytes(path + filename);
        LoadFinishCb(file);
    }
    public byte[] ReadOneFile(string path, string filename)
    {
        byte[] file = null;
        if (path == string.Empty || Directory.Exists(path) == false)
        {
            return file;
        }
        file = File.ReadAllBytes(path + filename);
        return file;
    }
    public void WriteOneFile(string path,string filename,byte[] file)
    {
       if (path != string.Empty&&Directory.Exists(path)==false)
       {
          Directory.CreateDirectory(path);
       }
       File.WriteAllBytes(path + filename,file);
    }
    public void WriteOneFile(string path, string filename,  string file)
    {
        if (path != string.Empty && Directory.Exists(path) == false)
        {
            Directory.CreateDirectory(path);
        }
        File.WriteAllText(path + filename, file);
    }
    
    public void LuaLoadAssets(string path, LuaFunction thisCb)
    {
        StartCoroutine(LualoadAssets(rootpath, thisCb));
    }
    IEnumerator LualoadAssets(string rootpath, LuaFunction thisCb)
    {
		Debug.Log ("LuaLoadAssets" + rootpath + "," + rootpath);
        WWW www = new WWW(rootpath);
        yield return www;
        if (www.error != null)
        {
            Debug.Log("Warning errow: " + "loadStreamingAssets   " + www.error);
            yield break;
        }
       
        if (thisCb != null)
        {
            thisCb.call(www);
        }

    }

    //persistentDataPath 
    public string GetTempPath()
    {
        string result = "";
#if UNITY_EDITOR
       result = Application.dataPath + "/ziyuan/";
#elif UNITY_STANDALONE_WIN
		result =  Application.persistentDataPath + "/ZQ/";
#elif UNITY_IPHONE 
		result = Application.persistentDataPath + "/ZQ/";

#elif UNITY_ANDROID
		result = Application.persistentDataPath + "/ZQ/";
#endif
       return result;
    }


    //StreamingAssets pathe
    public string GetStreamingPath()
    {
        string result = "";
#if UNITY_EDITOR
        result = Application.dataPath + "/StreamingAssets/";

#elif UNITY_STANDALONE_WIN
       result =  Application.dataPath + "/StreamingAssets/";
#elif UNITY_IPHONE 
        result = Application.dataPath +"/Raw/";

#elif UNITY_ANDROID
        result = "jar:file://" + Application.dataPath + "!/assets/";
#endif
        return result;
    }

    public void LoadAssets_New(string path, LoadFinish thisCb)
    {
		StartCoroutine(Coroutine_loadAssetsNew(path, thisCb));
    }
    IEnumerator Coroutine_loadAssetsNew(string path, LoadFinish thisCb)
    {

      
        byte[] bytes = null;
        string sourcepath = "";
        Debug.Log("Coroutine_loadAssetsNew-- path=" + path);
#if UNITY_EDITOR_OSX
        //sourcepath = "file://" + rootpath + ;
        WWW www = new WWW(path.Replace(@"\", "/"));
        yield return www;
        if (www.error != null)
        {
            Debug.Log("Warning errow: " + "Coroutine_loadAssetsNew   " + www.error);
            yield break;
        }
        bytes = www.bytes;


       

#elif UNITY_STANDALONE_WIN 
        // rootpath = rootpath.Replace('/', '\\');
       // sourcepath = "file://" + rootpath + sorucefilename;
        WWW www = new WWW(path);
        yield return www;
        if (www.error != null)
        {
            Debug.Log("Warning errow: path="+path + " Coroutine_loadAssetsNew   " + www.error);
            yield break;
        }
        bytes = www.bytes;

#elif UNITY_IPHONE 
		try{ 
			using ( FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read) ){ 
				bytes = new byte[fs.Length]; 
				fs.Read(bytes,0,(int)fs.Length); 
			}   
		} 
		finally
		{
			//yield return www;
		}
		yield return www;
#elif UNITY_ANDROID  
		WWW www = new WWW(path); 
        yield return www;
        if (www.error != null)
        {           
			Debug.Log("Warning errow: " + www.error);
			yield break;
        }
		bytes = www.bytes; 
#else 
		//Debug.Log("yyy");
		//sourcepath = "file://" + rootpath + ;
		WWW www = new WWW(path);
		yield return www;
		if (www.error != null)
		{
			Debug.Log("Warning errow: " + "Coroutine_loadAssetsNew   " + www.error);
			yield break;
		}
		bytes = www.bytes;
#endif

        if (thisCb != null)
        {
            thisCb(bytes);
        }

    }
    
    public void LoadAssets(string rootpath, string sorucefilename, LoadFinish thisCb)
    {
        StartCoroutine(loadAssets( rootpath,  sorucefilename,  thisCb));
    }
    public void LoadAssets(bool localpath, string midpath, string sorucefilename, LoadFinish thisCb)
    {
		Debug.Log ("LoadAssets");
        StartCoroutine(loadAssets( localpath, midpath,  sorucefilename,  thisCb));
    }

    IEnumerator loadAssets(string rootpath, string sorucefilename, LoadFinish thisCb)
    {

		Debug.Log ("((((((((((((((((loadAssets" + rootpath + "," + sorucefilename);
        byte[] bytes = null; 	
		string sourcepath = "";
#if UNITY_EDITOR || UNITY_STANDALONE_WIN || UNITY_STANDALONE_OSX
        rootpath = rootpath.Replace('/', '\\');
        sourcepath ="file://"+ rootpath + sorucefilename;
        WWW www = new WWW(sourcepath);
        yield return www;
        if (www.error != null)
        {
            Debug.Log("Warning errow: " + "loadStreamingAssets   " + www.error);
            yield break;
        }
        bytes = www.bytes;

#elif UNITY_IPHONE 
       
		sourcepath = rootpath  + sorucefilename;       
		try{ 
			using ( FileStream fs = new FileStream(sourcepath, FileMode.Open, FileAccess.Read, FileShare.Read) ){ 
				bytes = new byte[fs.Length]; 
				fs.Read(bytes,0,(int)fs.Length); 
			}   
		} 
		//catch (Exception e){ 
//			yield return www;
		//} 
		finally
		{
			//yield return www;
		}
		yield return www;
#elif UNITY_ANDROID  

		Debug.Log("UNITY_ANDROID:" + GetGameLocalPath() + sorucefilename);
		WWW www = new WWW(GetGameLocalPath() + sorucefilename); 
        yield return www;
        if (www.error != null)
        {           
			Debug.Log("Warning errow: " + www.error);
			yield break;
        }
		bytes = www.bytes; 
		
#endif
		Debug.Log ("LoadAssets1: " + sourcepath + " //////////////////////////");
        if (thisCb != null)
        {
            thisCb(bytes);
        }

	}
    
    //localpath = true 是 persistentDataPath  false 是streamingAssets文件夹下面-
	IEnumerator loadAssets(bool localpath,string midpath, string sorucefilename, LoadFinish thisCb)
	{
		Debug.Log ("loadAssets ture false");
		Debug.Log ("loadAssets:" + midpath + "-------------" + sorucefilename + "------------");
        byte[] bytes = null;
        string rootpath ="";
        if (localpath == true) {
			rootpath = "file://"+GetGameLocalPath ();
		} 
		else {
			rootpath = GetLocalstreamingAssetsPath();
		}

		string sp = rootpath + midpath + sorucefilename;
		//Debug.Log ("loadAssets111-- rootpath = " + rootpath + " sp = " + sp);
		string sourcepath = sp;// "file://" + sp;

#if UNITY_EDITOR || UNITY_STANDALONE_WIN || UNITY_STANDALONE_OSX
		//sourcepath = rootpath.Replace('/', '\\');
		//Debug.Log ("loadAssets111-- sourcepath = " + sourcepath);
        WWW www = new WWW(sourcepath);

        yield return www;
        if (www.error != null)
        {
			Debug.Log("Warning errow: " + www.error);
			yield break;
        }
        bytes = www.bytes;

#elif UNITY_IPHONE 
		try{ 
			using ( FileStream fs = new FileStream(sourcepath, FileMode.Open, FileAccess.Read, FileShare.Read) ){ 
				bytes = new byte[fs.Length]; 
				fs.Read(bytes,0,(int)fs.Length); 
				//yield return www;
			}   
		} 
		//catch (Exception e)
		//{ 
			//log +=  "\nTest Fail with Exception " + e.ToString(); 
			//log +=  "\n"; 
			//yield return www;
		//}
		finally
		{
		}
		yield return www;
#elif UNITY_ANDROID 
		Debug.Log("UNITY_ANDROID:" + sp);
		byte[] filebyte = File.ReadAllBytes (sp);
		string tempstr = System.Text.Encoding.Default.GetString(filebyte);
		Debug.Log("File.ReadAllBytes str = "+tempstr);
		WWW www = new WWW(sp); 
        yield return www;
        if (www.error != null)
        {           
			Debug.Log("Warning errow: " + "loadStreamingAssets"+ " www.error = "+www.error );
            yield break;
        }
		bytes = www.bytes; 

		
#endif
		//File.OpenRead(sp)
		//Debug.Log ("22222--- " +sp );
		//string str11 = Application.dataPath + "/StreamingAssets/"+sorucefilename;
		//byte[] filebyte = File.ReadAllBytes (str11);
		//string tempstr = System.Text.Encoding.Default.GetString(filebyte);
		//Debug.Log ("File.ReadAllBytes str = " + tempstr);

		//Debug.Log ("&&&&&&&&&&&&&&&&&&&thisCb&&&&&&&&&&&&&&&&&&&&&");
//		Debug.Log ("LoadAssets2: " + localpath + "|" + sourcepath + " //////////////////////////");
        if (thisCb != null)
        {
            thisCb(bytes);
        }

    }

    private WWW www;
    public string GetNowWWWProgress()
    {
        if (www!=null)
        {
            return (www.progress * 100).ToString("0.0") + "%";
        }
        return "0%";
    }

    public float GetNowWWWProgressValue()
    {
        if (www != null)
        {
            return www.progress;
        }
        return 0;
    }

    public void GetThisFileFromServer(string url, DownLoadFinish cb)
    {
		StartCoroutine (getThisFileFromServer(url, cb));
    }
    IEnumerator getThisFileFromServer(string url, DownLoadFinish cb)
    {
        www = new WWW(url);
        yield return www;
        if (cb != null )
        {
            cb(www);
        }
    }


    public void PackFiles(string filename, string directory, PackFilesFinish cb)
    {
        StartCoroutine(packFiles(filename, directory, cb));
    }
    //zip压缩-
    IEnumerator packFiles(string filename, string directory, PackFilesFinish cb)
    {
        FastZip fz = new FastZip();
        fz.CreateEmptyDirectories = true;
        fz.CreateZip(filename, directory, true, "");
        yield return fz;
        fz = null;
        if (cb!=null)
        {
            cb();
        }
       
    }
    public void UnpackFiles(string file, string dir, int waittime, UnpackFilesFinish cb)
    {
        StartCoroutine(unpackfiles( file,  dir, waittime, cb));
    }




    //zip解压-
    IEnumerator unpackfiles(string file, string dir,int waittime,UnpackFilesFinish cb)
    {       
		if (!Directory.Exists (dir))
			Directory.CreateDirectory (dir);
	    
		Debug.Log ("unpackfiles=====:" + file);
		#if UNITY_IPHONE
		file = "file://" + file;
		#endif
		WWW www = new WWW (file);
		yield return www;
		ZipInputStream s;			
			bool firstUnZip = false;
			float allUnZipSize = 0;
			#if UNITY_EDITOR || UNITY_STANDALONE_WIN
			FileStream fs = File.OpenRead (file);
			s = new ZipInputStream (fs);
			allUnZipSize = fs.Length;

			#elif UNITY_STANDALONE_OSX
			FileStream fs = File.OpenRead (file);
			s = new ZipInputStream(fs);
			allUnZipSize = fs.Length;
			#elif UNITY_IPHONE
			Stream thiszipstream = new MemoryStream(www.bytes) as Stream;
			s = new ZipInputStream(thiszipstream);
			int tmp = www.bytes.Length;
			allUnZipSize = tmp;
			#elif UNITY_ANDROID
			if(!file.Contains("jar"))
			{
				FileStream fs = File.OpenRead (file);
				s = new ZipInputStream(fs);	
				allUnZipSize = fs.Length;
			}
			else
			{
				Stream thiszipstream = new MemoryStream(www.bytes) as Stream;
				s = new ZipInputStream(thiszipstream);
				int tmp = www.bytes.Length;
				allUnZipSize = tmp;
			}
			#else
			FileStream fs = File.OpenRead (file);
			s = new ZipInputStream(fs);
			allUnZipSize = fs.Length;
			#endif
			if (file.Contains (InstallZiyuan)) {
				firstUnZip = true;
			}
			
			ZipEntry theEntry;
			ICSharpCode.SharpZipLib.Zip.ZipConstants.DefaultCodePage = System.Text.Encoding.UTF8.CodePage;
			float curUnZipSize = 0;
			while ((theEntry = s.GetNextEntry()) != null) {
				string directoryName = Path.GetDirectoryName (theEntry.Name);
				string fileName = Path.GetFileName (theEntry.Name);
				//UIUpdate.Ins.SetUpdateTipText("正在解压 " + fileName);
				if (directoryName != string.Empty)
					Directory.CreateDirectory (dir + directoryName);  
				if (fileName != string.Empty) {
					FileStream streamWriter = File.Create (dir + theEntry.Name);
					int size = 2048;
					byte[] data = new byte[2048];
					float readedLength = 0;
					while (true) {
						size = s.Read (data, 0, data.Length);
						if (size > 0) {
							streamWriter.Write (data, 0, size);
							if (firstUnZip) {
								curUnZipSize += size;
								float process = curUnZipSize / allUnZipSize;
								readedLength += size;
								//UIUpdate.Ins.SetProcess(readedLength / s.Length, process);
							}
							
						} else {
							break;
						}
					}
					
					streamWriter.Close ();
					yield return waittime;
				}
			}
			s.Close ();
			if (cb != null) {
				cb ();
			}
	}


    public string GetHigherVer(string ver1,string ver2)
    {
        string[] ver1list = ver1.Split('.');
        string[] ver2list = ver2.Split('.');
        if (ver1list.Length != 4 || ver2list.Length!=4)
        {
            return "";
        }
		for (int i = 0; i < ver1list.Length; i++) {
			if (int.Parse(ver1list[i]) > int.Parse(ver2list[i])) {
				return ver1;
			}
			else if(int.Parse(ver1list[i]) < int.Parse(ver2list[i])){
				return ver2;
			}
		}

		return ver1;
    }

    //test-
    public LuaState mainlua;
	
    public void AddComponent(Transform thisobj,string csname)
    {
        switch (csname)
        {
            //case "lgColliderCB": thisobj.gameObject.AddComponent<lgColliderCB>(); break;
			case "NavMeshAgent": 
			if(thisobj.gameObject.GetComponent<UnityEngine.AI.NavMeshAgent>()==null)
			{
			   thisobj.gameObject.AddComponent<UnityEngine.AI.NavMeshAgent>(); 
			}break;
			case "UIDragScrollView":
			if(thisobj.gameObject.GetComponent<UIDragScrollView>()==null)
			{
			   thisobj.gameObject.AddComponent<UIDragScrollView>(); 
			}break;
			case "TweenScale":
			if(thisobj.gameObject.GetComponent<TweenScale>()==null)
			{
			   thisobj.gameObject.AddComponent<TweenScale>(); 
			}
			break;
			//case "lgEffuse": 
			//if(thisobj.gameObject.GetComponent<lgEffuse>()==null)
			//{
			//	thisobj.gameObject.AddComponent<lgEffuse>(); 
			//}
			//break;
			//case "lgIniRoleParticleList": 
			//if(thisobj.gameObject.GetComponent<lgIniRoleParticleList>()==null)
			//{
			//	thisobj.gameObject.AddComponent<lgIniRoleParticleList>(); 
			//}
			//break;
        }
    }
   
    public void EnabledCollider(Collider thisobj, bool enable)
    {
       if (thisobj!=null)
       {
           thisobj.enabled = enable;
       }
       
    }
    public void EnabledBoxCollider(BoxCollider thisobj, bool enable)
    {
        if (thisobj != null)
        {
            thisobj.enabled = enable;
        }

    }

	public void EnabledObjCollider(Transform thisobj, bool enable)
	{
		if (thisobj != null )
		{
			Collider thiscollider =thisobj.gameObject.GetComponent<Collider>();
			if(thiscollider!=null)
			{
				thiscollider.enabled = enable;
			}
		}
		
	}
    //取碰撞点-
    public Vector3 GetCollisionPos(Collision thiscollision, int id)
    {
        return thiscollision.contacts[id].point;
    }
    public void LoadMainLua()
    {
       //LoadAssets(true, (string)PathConfig_table["UiLuaPath"]+"/", "GameMain.lua", Startmainlua);
        string path = GetTempPath();
        path = path + (string)PathConfig_table["UiLuaPath"] + "/GameMain.lua";
#if UNITY_EDITOR
        path = path.Replace('/', '\\');
        path = "file://" + path;

#elif UNITY_STANDALONE_WIN
       path = path.Replace('/', '\\');
       path ="file://"+ path;
#elif UNITY_IPHONE 
       

#elif UNITY_ANDROID
       path = path.Replace('/', '\\');
       path = "file://" + path;

#endif
        Debug.LogError(path);
        LoadAssets_New(path, Startmainlua);
    }
	public byte[] mainluaData = null;
	public bool checkIniBundleFinish = false;
	public void LoadmainluaCB(byte[] result)
	{
		if(AssetBundleManager.m_AssetBundleManifest ==null)
		{
			Debug.LogError("LoadmainluaCB  AssetBundleManager.m_AssetBundleManifest no has done");
		}
		if(BundleState != AssetBundleState.LoadAssetBundleOK)
		{
            Debug.LogError("LoadmainluaCBLoadmainluaCBLoadmainluaCBLoadmainluaCBLoadmainluaCBLoadmainluaCBLoadmainluaCB");
			mainluaData = result;
			checkIniBundleFinish = true;
		}
		else
		{
            Debug.LogError("StartmainluaStartmainluaStartmainluaStartmainluaStartmainluaStartmainluaStartmainlua");
			Startmainlua(result);	
		}
	}

	public void Startmainlua(byte[] result)
    {
		//Debug.LogError ("Startmainlua");
		//return;
		//PT_M.Builder m = PT_M.CreateBuilder ();

		Resources.UnloadUnusedAssets();

		Debug.LogError ("********************Startmainlua************************");
        LuaSvr inilua = new LuaSvr();
        inilua.start2(result);
		//mainlua = new LuaState();
        mainlua = inilua.luaState;
       // LuaState.pcall(mainlua.L, LuaSvr.Equals init);
       // mainlua.LoadCLRPackage();
       	if (true) 
		{
            //object obj;
            //mainlua.doBuffer(result,"Gamemain",out obj);
            mainlua["package.path"] = mainlua["package.path"] + ";" + GetGameLocalPath() + PathConfig_table["UiLuaPath"] + "/?.lua";
            mainlua["package.path"] = mainlua["package.path"] + ";" + GetGameLocalPath() + PathConfig_table["GmLuaPath"] + "/?.lua";
            mainlua["package.path"] = mainlua["package.path"] + ";" + GetGameLocalPath() + PathConfig_table["CommonPath"] + "/?.lua";
            //mainlua["package.path"] = mainlua["package.path"] + ";" + GetGameLocalPath() + "Usedata/Gm/UiLua/Skill" + "/?.lua";

            LuaTable skill = PathConfig_table["AddLuaPath"] as LuaTable;
            //string[] arr = new string[skill.Values.Count];
            //skill.Values.CopyTo(arr, 0);
           
            //for (int i = 0; i < arr.Length; i++)
            //{
            //    mainlua["package.path"] = mainlua["package.path"] + ";" + GetGameLocalPath() + arr[i] + "/?.lua";
            //}
            IEnumerator<LuaTable.TablePair> e = skill.GetEnumerator();
            while (e.MoveNext())
            {
                 mainlua["package.path"] = mainlua["package.path"] + ";" + GetGameLocalPath() +  e.Current.value.ToString() + "/?.lua";
        
            }
            mainlua["this"] = this; // Give the script access to the gameobject.
            mainlua["transform"] = transform;
            mainlua["PathConfig"] = PathConfig_table;
            mainlua["UiLuaPath"] = GetGameLocalPath() + PathConfig_table["UiLuaPath"];
            mainlua["UiLuaPathPc"] = Application.dataPath + "/ziyuan/" + PathConfig_table["UiLuaPath"];

            mainlua["GmLuaPath"] = GetGameLocalPath() + PathConfig_table["GmLuaPath"];
            mainlua["GmLuaPathPc"] = Application.dataPath +"/ziyuan/"+ PathConfig_table["GmLuaPath"];

            mainlua["ComLuaPath"] = GetGameLocalPath() + PathConfig_table["CommonPath"];
            mainlua["ComLuaPathPc"] = Application.dataPath + "/ziyuan/" + PathConfig_table["CommonPath"];


            mainlua["isPctest"] = false;
			Debug.Log ("-============================GameMain.IniSome Call=========================");
            Call(mainlua,"GameMain.IniSome");
			Debug.Log ("call after");
            //Call(mainlua, "GameMain.EnterTestBattle");
			//curBunldType = "gm";  
			//LuaTable info =null;
			//LoadAssetByObject (info, "boss1_1", null); //boss1_1
			Gameupdatefun = mainlua.getFunction("GameMain.Update");
			GameLateupdatefun = mainlua.getFunction("GameMain.LateUpdate");

        }

		//sn add 2016.05.25
		lgCfgMag.Ins.IniSome();
		tModleFactory.Ins.IniSome ();

		//IniSdk(1, 0);
		//end
    }
	AsyncOperation async;
	bool LoadingMainSC = false;

	public void AutoupdatLoadMainSc()
	{
		//Debug.LogError ("LoadLevelAsync(MainGame");
		LoadingMainSC = true;
		async= Application.LoadLevelAsync("MainGame");
	}

	/*
	public void GetColliderHitRay (Collider collider, Ray ray, double far, string thiscb)
	{
		RaycastHit hitInfo;
		System.Object[] args = new System.Object[3];
	
		bool terHit = collider.Raycast (ray, out hitInfo, (float)far);
		if (thiscb != "")
		{
			
			args[0] = thiscb;
			args[1] = (System.Object)terHit;
			args[2] = (System.Object)hitInfo;
			Call(mainlua, "GameMain.CallBack", args);			
		}
	}
	 */
	public void GetHitRay (Ray ray, double far, string thiscb)
	{
		
		RaycastHit hitInfo;
		System.Object[] args = new System.Object[3];
		bool terHit = Physics.Raycast (ray, out hitInfo, (float)far);
		
		if (thiscb != "")
		{

			args[0] = thiscb;
			args[1] = (System.Object)terHit;
			args[2] = (System.Object)hitInfo;
			Call(mainlua, "GameMain.CallBack", args);			
		}
	}
	 /*
   //设置粒子相关-
    public void SetThisParticleEmitterOpen(ParticleEmitter thispar,bool isopen)
    {
        if (thispar != null)
        {
            thispar.emit = isopen;
        }
    }
	*/


    public void debuglog(string name,string  thiscb)
    {
        System.Object[] args = new System.Object[3];

        if (thiscb!="")
        {
            args[0] = "LoadSceneCB";
            args[1] = "93848834";
            args[2] = "34sdfsdfs";
            Call(mainlua, "GameMain.CallBack", args);
          
        }
    }
	public void ClickEvent(GameObject _Gob)
	{
		System.Object[] args = new System.Object[1];

        if (_Gob!=null)
        {
            args[0] = _Gob;
            Call(mainlua, "GameMain.ClickEvent", args);
          
        }
	}
   
	//ui ListenEvent 点击事件
	public void GetUIEvent(GameObject _Gob , string _Lua)
	{
		System.Object[] args = new System.Object[2];

        if (_Lua!=""&&_Gob!=null)
        {
            args[0] = _Lua;
            args[1] = _Gob;
            Call(mainlua, "GameMain.UIHandleEvent", args);
          
        }
	}
	
	//UI 物件按下  抬起事件
	public void GetUIPressItemEvent(GameObject _Gob ,string _Lua, bool ispress )
	{
		System.Object[] args = new System.Object[3];
		
		if (_Lua!=""&&_Gob!=null)
		{
			args[0] = _Lua;
			args[1] = _Gob;
			args[2] = ispress;
			Call(mainlua, "GameMain.UIPressItemEvent", args);
			
		}
	}


	//UI 抬起事件
	public void GetUIDragUpEvent(GameObject _Gob , string _Lua , GameObject _go)
	{
		System.Object[] args = new System.Object[3];

        if (_Lua!=""&&_Gob!=null)
        {
            args[0] = _Lua;
            args[1] = _Gob;
			args[2] = _go;
            Call(mainlua, "GameMain.UIDragUpEvent", args);
          
        }
	}
	
	//UI 拖动事件
	public void GetUIDragEvent(GameObject _Gob , string _Lua , Vector2 _Detal)
	{
		System.Object[] args = new System.Object[3];
       
        if (_Lua!=""&&_Gob!=null)
        {
            args[0] = _Lua;
            args[1] = _Gob;
			args[2] = _Detal;
            Call(mainlua, "GameMain.UIDragEvent", args);
          
        }
        
	}
	
	public void UpdateWrapItem(Transform _Item , string _Lua)
	{
		System.Object[] args = new System.Object[2];

        if (_Lua!=""&&_Item!=null)
        {
            args[0] = _Lua;
            args[1] = _Item;
            Call(mainlua, "GameMain.UpdateItems", args);
          
        }
	}
	
	public LuaTable GetConfigData(string _Type , int _Id)
	{
		System.Object[] args = new System.Object[2];
       
        if (_Type!=""&&_Id!=0)
        {
            args[0] = _Type;
            args[1] = _Id;
            LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetConfigData", args); 
			return t;
        }
		return null;
		
	}
	
	public LuaTable GetRoleData(int _Id , int _Lvl , int _QualityLvl)
	{
		System.Object[] args = new System.Object[3];
         
        args[0] = _Id;
        args[1] = _Lvl;
		args[2] = _QualityLvl;
        LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetRoleProp", args); 
		return t;
        
	}
	public LuaTable GetRoleData_ByUUID(bttype_ bttype,int camp,string UUID)
	{
		System.Object[] args = new System.Object[3];
		
		if (UUID!="")
		{
			args[0] = (int)bttype;
			args[1] = camp;
			args[2] = UUID;
			LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetHeroProp", args); 	//snbug
			return t;
		}
		return null;
	}
	
	
	public LuaTable GetSoliders()
	{
		System.Object[] args = new System.Object[1];
		args[0] = "1";
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetSoliders", args); 	//snbug
		return t;	
	}
	
	public LuaTable GetHeros()
	{
		System.Object[] args = new System.Object[1];	
		args[0] = "1";
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetHero", args); 	//snbug
		return t;
	}
	
	public LuaTable GetPvpTeam()
	{
		System.Object[] args = new System.Object[1];	
		args[0] = "1";
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetPvpTeam", args); 	//snbug
		return t;
	}
	public LuaTable GetPvpTeam2()
	{
		System.Object[] args = new System.Object[1];	
		args[0] = "2";
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetPvpTeam2", args); 	//snbug
		return t;
	}
	public void SetPvpResult(string _PvpResult)
	{
		lgCfgMag.Ins.AddPvpResult(_PvpResult);
	}
	
	public void SetPvpShowNum(int _Type)	//0 退出 -2 数据准备好了 -1 开始进战斗前
	{
		lgbtmag.Ins.SetPvpShowNum(_Type);
	}
	
	public void GetWorldBattleInfo()
	{
		System.Object[] args = new System.Object[1];	
		args[0] = "1";
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetWorldBattleInfo", args); 	//snbug					
	}
	
	
	public void SetIcon(UISprite _Sprite , string _AtlasName , string _SpriteName)
	{
		System.Object[] args = new System.Object[3];	
		args[0] = _Sprite;
		args[1] = _AtlasName;
		args[2] = _SpriteName;
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.SetIcon", args); 	//snbug					
	}
	
	public void SetHeadIconById(UISprite _Sprite , int _Id)
	{

		if(_Sprite!=null&&_Id!=0)
		{
			System.Object[] args = new System.Object[2];	
			args[0] = _Sprite;
			args[1] = _Id;
			LuaTable t= (LuaTable)Call(mainlua, "GameMain.SetIconById", args); 	//snbug		
		}
		else
		{
			return;
		}
	}
	
	public void MapOver(int _Win , GameObject _SpriteFather)		//0失败 1 成功   
	{
		Debug.LogError ("MapOver  win ="+_Win.ToString());
		System.Object[] args = new System.Object[2];
		float fwin=(float)(_Win);
		args[0] = fwin;
		args[1] = _SpriteFather;
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.MapOver", args); 	//snbug	
	}
	
	public void JumpToPanel(int _Type)
	{ 		
		System.Object[] args = new System.Object[1];	
		args[0] = _Type;
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.JumpToPanel", args); 	//snbug	
	}
	
	public void SendWeb( string _M , string _A  , string _p)											//Cs
	{
		System.Object[] args = new System.Object[3];	
		args[0] = _M;
		args[1] = _A;
		args[2] = _p;
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.CSSendWeb", args); 	//snbug	
	}
	
	public void SendWebCallBack(int _returnId)
	{
		Debug.LogError ("SendWebCallBack _returnId="+_returnId.ToString());
	}
	
	public void BattleReady()											//战斗流程创建完毕
	{
		System.Object[] args = new System.Object[1];	
		args[0] = 1;
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.BattleReady", args); 	//snbug	
	}
	
	public void PauseGameAll()
	{
		lgbtmag.Ins.pauseGameAll();		
	}
	
	public GameObject GetBattleUI()
	{	
		return lgbtmag.Ins.MyBtUiMag.gameObject;
	}
	
	public void SetYindao()
	{
		lgbtmag.Ins.hasYindao = true;
	}
	
	public void CancelYindao()
	{
		lgbtmag.Ins.hasYindao = true;
	}
	
	public void SetNoHumanHero(int _type)				//0 不需要人口 -1 默认人口
	{
		lgbtmag.Ins.SetFubenHeroNoRenkou(0);
	}
	
	public void OutSoldier(int _Index)
	{
		lgbtmag.Ins.MyBtUiMag.MonsterBtClick(lgbtmag.Ins.MyBtUiMag.Monster_Obj[_Index - 1] , _Index - 1, "");
	}
	
	public void QuitB()
	{
		lgbtmag.Ins.UI_Call_QuitBt();
	}
	
	public void OutHero(int _Index)
	{
		lgbtmag.Ins.MyBtUiMag.HeroBtClick(lgbtmag.Ins.MyBtUiMag.HeroEventListener[_Index - 1].gameObject , _Index - 1 , "");
	}
	
	//处理网络掉线处理
	public void WebEvent(int _EventId)
	{
		packMgr.Ins.removeAllPack();
		System.Object[] args = new System.Object[1];

        if (_EventId!=0)
        {
            args[0] = _EventId;         
            Call(mainlua, "GameMain.WebEvent", args);        
        }
	}
    public object Call(LuaState env, string function, params object[] args)
    {
       // Debug.Log("function =" + function);
        object result = null;
        if (env == null) return result;
        LuaFunction lf = env.getFunction(function);
        if (lf == null) return result;   
        if (args != null)
        {
            result = lf.call(args);
        }
        else
        {
            result = lf.call();
        }
        return result;
    }

  	//获取数据库的值
	
   
    //网络相关-
    
    //网络报错-
    public void DebugLogNetErr(string funname,int errorID, string errInfo)
    {
        //提示报错-
        Debug.Log(funname+ " errorID=" + errorID.ToString() + " errInfo =" + errInfo);
    }
    public void DebugLogNetErr(string funname, string errInfo)
    {
        //提示报错-
        Debug.Log(funname + " errInfo =" + errInfo);
    }
   
    void OnApplicationQuit()
    {
        DotNetClient.hzClient.Destroy();
    }

	public void WaitFire()
	{
		//StartCoroutine (DoWaitFire());
		Debug.Log ("lg 2" +  Time.time);
	}

	IEnumerator DoWaitFire () {
		Debug.Log ("lg 1" + Time.time);
		yield return new WaitForSeconds(5.0f); 
	}
	public Dictionary<string, GameObject> GmHasLoadObjList = new Dictionary<string, GameObject> (); //战斗资源
	public List<string> GmLoadObjAbList = new List<string>(); //战斗资源AB名字
	public Dictionary<string, GameObject> UiHasLoadObjList = new Dictionary<string, GameObject> ();	//UI资源

	//public Dictionary<string, float[]> LoadingObjList = new Dictionary<string, float[]> ();
	public Dictionary<string, List<LoadAssetCb_>> LoadObjCBList = new Dictionary<string, List<LoadAssetCb_>>();

	/*
	public struct LoadAssetCb_
	{
		public LuaTable info; 
		public LuaFunction cb;
	}
	*/
	public int nowLoadingAssetNum = 0;

	/// 给lua调用方法
	public void LoadAssetByObject(LuaTable infodata, string prefabName, LuaFunction cbfun)
	{
		if (curBunldType == "ui") 
		{
			LoadAssetBundle (infodata, prefabName, cbfun, true);
		}
		if(curBunldType == "gm")
		{
			LoadAssetBundle (infodata, prefabName, cbfun, false);
		}
	}

	public void LoadAsset(string prefabName, LuaFunction cbfun)
	{
		if (curBunldType == "ui") 
		{
			LoadAssetBundle (null, prefabName, cbfun, true);
		}
		if(curBunldType == "gm")
		{
			LoadAssetBundle (null, prefabName, cbfun, false );
		}
    }

    #region load_lua_bundle
    //解密lua脚本字符串
    string InencrptLua(string luaContent)
    {
        return luaContent;
    }

    private AssetBundle luaBundle = null;
    private Dictionary<string, string> luaDic = new Dictionary<string, string>();
    private void InitLuaBundle()
    {
        LoadLuaAssetP_ thisp = new LoadLuaAssetP_();
        thisp.assetBundleName = prefabNameToAssetName2(false, "lua");
        StartCoroutine("DoInitLuaBundle", thisp);
    }
    IEnumerator DoInitLuaBundle(LoadLuaAssetP_ thisp)
    {
        string url = AssetBundleManager.GetBaseDownLoadingURL() + thisp.assetBundleName;
        WWW www = new WWW(url);
        yield return www;
        if (string.IsNullOrEmpty(www.error))
        {
            luaBundle = www.assetBundle;
            www.Dispose();
        }
    }
    public string LoadLuaStr(string luaName)
    {
        string text = "";
        if (luaDic.ContainsKey(luaName))
        {
            text = luaDic[luaName];
        }
        else
        {
            TextAsset txtAsset = luaBundle.LoadAsset<TextAsset>(luaName);
            if (txtAsset != null)
            {
                text = InencrptLua(txtAsset.text);
                luaDic.Add(luaName, text);
            }
        }

        return text;
    }
    #endregion


    public void LoadAssetByObject1(LuaTable infodata, string prefabName, LuaFunction cbfun,bool isui)
	{
		LoadAssetBundle (infodata, prefabName, cbfun,isui);
	}
	public void LoadAsset1(string prefabName, LuaFunction cbfun,bool isui)
	{
		LoadAssetBundle (null, prefabName, cbfun,isui);
	}
	///

	public void LoadAssetBundle(LuaTable infodata, string prefabName, LuaFunction cbfun,bool isui)//,bool tempasset)
	{
        //string localPrefabPath = "ArtResources/" + (isui == false ? "Gm" : "Ui") + "/Prefab/" + prefabName;// + ".prefab";
        //GameObject prefab = Resources.Load(localPrefabPath) as GameObject;// UnityEditor.AssetDatabase.LoadAssetAtPath(localPrefabPath, typeof(GameObject)) as GameObject;
        //if (infodata == null)
        //{
        //    cbfun.call(prefab);
        //}
        //else
        //{
        //    cbfun.call(infodata, prefab);
        //}

//#if UNITY_EDITOR
#if bundletest
        	LoadAssetAsset(infodata,prefabName, cbfun,isui);
#else
		string localPrefabPath = "Assets/ArtResources/" + (isui == false ? "Gm" : "Ui") + "/Prefab/" + prefabName + ".prefab";//"ArtResources/" + (isui == false ? "Gm" : "Ui") + "/Prefab/" + prefabName;//
		GameObject prefab =UnityEditor.AssetDatabase.LoadAssetAtPath(localPrefabPath, typeof(GameObject)) as GameObject; //Resources.Load(localPrefabPath) as GameObject;//
        		if(infodata==null)
        		{
        			cbfun.call(prefab);
        		}else
        		{
        			cbfun.call(infodata,prefab);
        		}
#endif
//#else
       // LoadAssetAsset(infodata, prefabName, cbfun, isui);
//#endif
        /*
		string bundlename = prefabNameToAssetName2 (isui,prefabName);
		if(tempasset==true) //零时资源 在切场景时候会 卸载资源
		{
			string result ="";
			if(LoadNoTempObjaAsset.TryGetValue(bundlename,out result)==false && LoadTempObjaAsset.TryGetValue(bundlename,out result)==false)
			{
				LoadTempObjaAsset.Add(bundlename,prefabName);
			}
		}
		else         //游戏运行过程中不卸载的资源
		{
			string result ="";
			if(LoadNoTempObjaAsset.TryGetValue(bundlename,out result)==false)
			{
				if(LoadTempObjaAsset.TryGetValue(bundlename,out result)==true)
				{
					LoadTempObjaAsset.Remove(bundlename);
				}
				LoadNoTempObjaAsset.Add(bundlename,prefabName);
			}
		}
		*/
    }

    void LoadAssetAsset(LuaTable infodata,string prefabName, LuaFunction cbfun,bool isui)
	{

        if (prefabName == "" || prefabName == "0")
        {
            Debug.LogError("LoadAssetByObject prefabName==''  " + prefabName);
            return;
        }
        if ( prefabName == null)
        {
            Debug.LogError("LoadAssetByObject prefabName==null " );
            return;
        }
		//查找如果已经有资源了 直接回调-
		
		//LoadedAssetBundle result = null;
		//result = AssetBundleManager.TryGetAsBundle (prefabNameToAssetName2 (isui, prefabName));
		string needassetBundleName = prefabNameToAssetName2 (isui, prefabName);
        if (needassetBundleName == "")
        {
            if (cbfun != null)
            {
                if (infodata == null)
                {
                    cbfun.call(null);
                }
                else
                {
                    cbfun.call(infodata, null);
                }
            }
            return;
        }
        GameObject result = null;
		if(isui==false)
		{
		//	UiHasLoadObjList.TryGetValue (needassetBundleName,out result);
		//}
		//else
		//{
			GmHasLoadObjList.TryGetValue (prefabName, out result);
		}
		if(result!=null)
		{
			if(infodata==null)
			{
				//GameObject obj = result.m_AssetBundle.LoadAssetAsync (prefabName, typeof(GameObject)).asset as GameObject;
				//cbfun.call(obj);
				if(cbfun!=null)
				{
					cbfun.call(result);
				}
			}else
			{
				//GameObject obj = result.m_AssetBundle.LoadAssetAsync (prefabName, typeof(GameObject)).asset as GameObject;
				//cbfun.call(infodata,obj);
				if(cbfun!=null)
				{
					cbfun.call(infodata,result);
				}
			}
		}
		else
		{
			LoadAssetCb_ onecb = new LoadAssetCb_();
			onecb.cb =cbfun;
			onecb.info =infodata;
			
			List<LoadAssetCb_> cblist = null;
			if (LoadObjCBList.TryGetValue (prefabName, out cblist) == false) {
				cblist = new List<LoadAssetCb_>();
				LoadObjCBList.Add(prefabName,cblist);
				LoadAssetP_ thisp = new LoadAssetP_();
				thisp.assetBundleName = needassetBundleName;// prefabNameToAssetName2 (isui,prefabName);
				thisp.assetName = prefabName;
				thisp.isui= isui;
				thisp.isCS= false;
				//Debug.LogError ("LoadAssetAsset--prefabName -name = "+prefabName+" BundleName="+needassetBundleName);
				//if(b_clearafter==true)
				//{
				//	AddLoadAssetTask(thisp);
				//}
				//else
				//{
					StartCoroutine ("LoadThisObj",  thisp);
				//}
				//AddLoadAssetTask(thisp);
				nowLoadingAssetNum ++;
			}
			cblist.Add(onecb);
		}		
		//}
	}

	//加载资源后回调
	public void LoadAssetCB(LoadAssetP_ thisp, GameObject prefabobj)
	{
/*
		if(testab ==true)
		{
			testabFun(prefabobj);
			return;
		}
*/
		if(prefabobj==null)
		{
			Debug.LogError ("assetName="+thisp.assetName+"   assetBundleName="+thisp.assetBundleName+" isCS="+thisp.isCS.ToString());
		}
		//Debug.LogError (thisp.assetName+"   "+prefabobj.name);
		if(thisp.isui==false && GmHasLoadObjList.ContainsKey(thisp.assetName)==false)
		{
			//Debug.LogError(" gam asset "+thisp.assetName+" assetBundleName= "+thisp.assetBundleName);
			GmHasLoadObjList.Add (thisp.assetName, prefabobj);
		}
		if (thisp.isui == false) 
		{
			GmLoadObjAbList.Add (thisp.assetBundleName);
		}
		//Debug.LogError(" get asset "+thisp.assetName+" assetBundleName= "+thisp.assetBundleName);
		if (thisp.isCS == false) {
			List<LoadAssetCb_> cblist = null;
			if (LoadObjCBList.TryGetValue (thisp.assetName, out cblist) == true) {
				for (int i=0; i<cblist.Count; i++) {
					if (cblist [i].cb != null) {
						if (cblist [i].info == null) {
							if (cblist [i].cb != null) {
								cblist [i].cb.call (prefabobj);
							}
						} else {
							if (cblist [i].cb != null) {
								cblist [i].cb.call (cblist [i].info, prefabobj);
							}
						}
					}
				}
				LoadObjCBList.Remove (thisp.assetName);
			}
		} else {
			tModleFactory.Ins.GetAbObj(thisp.assetName,prefabobj);
			CSLoadingObj.Remove(thisp.assetName);
		}
		nowLoadingAssetNum --;
		//if(b_clearafter==true)
		//{
		//	AssetBundleManager.UnloadAssetBundle (AssetName);
		//}
	}
	public Dictionary<string,string> CSLoadingObj = new Dictionary<string, string>();

	//CS用加载资源
	public void CSLoadAssetAsset(string prefabName,bool isui)
	{
		
		if (prefabName == "" || prefabName == "0")
		{
			Debug.LogError("LoadAssetByObject prefabName==''  " + prefabName);
			return;
		}
		if ( prefabName == null)
		{
			Debug.LogError("LoadAssetByObject prefabName==null " );
			return;
		}
		//查找如果已经有资源了 直接回调-
		


		GameObject result = null;
		if(isui==false)
		{
			GmHasLoadObjList.TryGetValue (prefabName, out result);
		}
		if(result!=null)
		{
			tModleFactory.Ins.GetAbObj(prefabName,result);
		}
		else
		{

			#if bundletest

				if (CSLoadingObj.ContainsValue (prefabName) == false) {
					string needassetBundleName = prefabNameToAssetName2 (isui, prefabName);
					if (needassetBundleName == "")
					{
						return;
					}
					LoadAssetP_ thisp = new LoadAssetP_();
					thisp.assetBundleName = needassetBundleName;
					thisp.assetName = prefabName;
					thisp.isui= isui;
					thisp.isCS=true;
					CSLoadingObj.Add(prefabName,prefabName);
					StartCoroutine ("LoadThisObj",  thisp);
					
					nowLoadingAssetNum ++;
				}
			#else
			string localPrefabPath = "Assets/ArtResources/" + (isui == false ? "Gm" : "Ui") + "/Prefab/" + prefabName + ".prefab";//"ArtResources/" + (isui == false ? "Gm" : "Ui") + "/Prefab/" + prefabName;//
			GameObject prefab = UnityEditor.AssetDatabase.LoadAssetAtPath(localPrefabPath, typeof(GameObject)) as GameObject;//Resources.Load(localPrefabPath) as GameObject;//
				tModleFactory.Ins.GetAbObj(prefabName,prefab);
			#endif


		}		
		//}
	}
	
	
	
	
	public void PrintAssetNeedLoad()
	{
		foreach (var item in LoadObjCBList.Keys)  
		{  
			Debug.LogError("Asset wait load item = "+item);
		} 
		
	}
	//清理当前场景
	public void DoClear()
	{
		//StopLoadAsset ();
		ClearLoadAsset ();
		Resources.UnloadUnusedAssets ();
	}
	//清理临时资源 释放内存
	public void ClearLoadAsset()
	{
		/*
		if(retemp==true)
		{
			List<string> keylist = new List<string>(LoadTempObjaAsset.Keys);
			for(int i =0;i<keylist.Count;i++)
			{
				AssetBundleManager.UnloadAssetBundle (keylist[i]);
			}
		}
	*/
		//if(LoadObjCBList.Count>0)
		//{
		//	Debug.LogError("eeeeeeeeeeeeeLoadObjCBList.Count="+LoadObjCBList.Count);
		//}
		//LoadObjCBList.Clear ();
		//只释放战斗资源  UI资源都不释放
		//List<string> keylist = new List<string>(GmHasLoadObjList.Keys);
		GmHasLoadObjList.Clear ();

		//List<string> keylist = new List<string>(HasLoadObjList.Keys);
		for(int i =GmLoadObjAbList.Count-1;i>=0;i--)
		{
			//Debug.LogError("UnloadAssetBundle key= "+keylist[i]);
			AssetBundleManager.UnloadAssetBundle (GmLoadObjAbList[i]);
			//AssetBundleManager.ClearAllAssetBundle (keylist[i]);
		}
		GmLoadObjAbList.Clear ();
		//Resources.UnloadUnusedAssets ();
	}
	//停止当前加载资源的进程 改成了 协程不停止 将要加载的清空
	public void StopLoadAsset()
	{
		StopCoroutine ("LoadThisObj" );
		//ClearLoadAssetTask ();
	}

	public void LoadCreate(string assetBundleName, string assetName)
	{
		StartCoroutine (LoadCreateBase(assetBundleName, assetName));
	}
	public int GetLoadObjCBListNum()
	{
		return LoadObjCBList.Count;
	}

	/// <summary>
	/// Inits the asset bundle manager.
	/// </summary>
	public void InitAssetBundle()
	{
		#if UNITY_EDITOR 
			#if bundletest
				EnterLoadAssetBoundle();
				StartCoroutine (DoInitAssetBundle());
			#else
				LoadMainLua();
			#endif
		#else
			EnterLoadAssetBoundle();
			StartCoroutine (DoInitAssetBundle());
		#endif
	}
	/*
	public GameObject GetChildObj(GameObject go)
	{
		if(go.GetComponent<lgObjList>()!=null)
		{
			return go;
		}
		return go.transform.GetChild (0).gameObject;
	}
	
	public Animation GetAnimation(GameObject go)
	{
		if(go.GetComponent<Animation>()!=null)
		{
			return go.GetComponent<Animation>();
		}
		else
		{
		    return go.GetComponent<lgRoleBody>().ModelObj.GetComponent<Animation>();
		}
		return null;
	}
	
	//获得对象的所有父类比例
	public Vector3 GetAllParentScale(GameObject go)
	{
		Vector3 relScale = Vector3.one;
		Transform tmpParent = go.transform.parent;
		while(tmpParent != null)
		{
			relScale = new Vector3(relScale.x * tmpParent.localScale.x, relScale.y * tmpParent.localScale.y, relScale.z * tmpParent.localScale.z);
			tmpParent = tmpParent.parent;
		}
		return relScale;
	}
	*/
    /*
    //需要加载载的所有prefab names/Bundle Names
    public List<string> gmPefabNames = new List<string>();
    public List<string> uiPefabNames = new List<string>();
    public List<string> gmBundleNames = new List<string>();
    public List<string> uiBundleNames = new List<string>();
    private void LoadListFromTxt(string fileName, ref List<string> gmList, ref List<string> uiList)
    {
        //加载依赖
        string str = "";
        string relFilePath = GetGameLocalPath() + "Usedata/" + fileName + ".txt";
        if (!File.Exists(relFilePath))
        {
            Debug.LogError(relFilePath + " 不存在！");
        }
        else
        {
            using (FileStream fs = new FileStream(relFilePath, FileMode.Open))
            {
                using (StreamReader sr = new StreamReader(fs))
                {
                    str = sr.ReadToEnd();
                }
            }

            string[] arr = str.Split(new char[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < arr.Length; i++)
            {
                string[] tempArr = arr[i].Split(',');
                if (i == 0)
                {
                    for (int a = 0; a < tempArr.Length; a++)
                    {
                        gmList.Add(tempArr[a]);
                    }
                }
                else
                {
                    for (int a = 0; a < tempArr.Length; a++)
                    {
                        uiList.Add(tempArr[a]);
                    }
                }
            }
        }
    }
    */
    IEnumerator DoInitAssetBundle()
	{
        //LoadListFromTxt("PrefabNames",ref gmPefabNames,ref uiPefabNames);
        //LoadListFromTxt("BundleNames", ref gmBundleNames, ref uiBundleNames);       
        yield return StartCoroutine (Initialize ());
	}
	


	//read bunld from gm dir or ui dir
	public string curBunldType = "gm";
	string prefabNameToAssetName(string prefabName)
	{
        try
        {
            return curBunldType + "/prefab/" + prefabName.ToLower() + ".unity3d";
        }
        catch(Exception ex)
        {
            return curBunldType + "/prefab/monster4_1.unity3d";
        }
	}

	string prefabNameToAssetName2(bool isui,string prefabName)
	{
		if(isui==true)
		{
			return  GetAssetBundleName("ui/prefab/" + prefabName.ToLower() + ".unity3d");
		}
		else
		{
			return  GetAssetBundleName("gm/prefab/" + prefabName.ToLower() + ".unity3d");
		}
	}

	Dictionary<string, string> assetBundleNamesDic = new Dictionary<string, string>();
	/// <summary>
	/// 根据prefabName，取得它对应的assetBundleName
	/// </summary>
	/// <returns>The asset bundle name.</returns>
	/// <param name="prefabName">Prefab name.</param>
	string GetAssetBundleName(string bundleName)
	{
		if (assetBundleNamesDic.Count == 0) {
			//加载依赖
			string str = "";
			string relFilePath = GetGameLocalPath() + "Usedata/AssetBundleNames.txt";
			if (!File.Exists(relFilePath)) {
				Debug.LogError(relFilePath + " 不存在！");
				return "";
			}
			using(FileStream fs = new FileStream(relFilePath, FileMode.Open))
			{
				using(StreamReader sr = new StreamReader(fs))
				{
					str = sr.ReadToEnd();
				}
			}

			string[] arr = str.Split(new char[]{'|'}, StringSplitOptions.RemoveEmptyEntries);
			for (int i = 0; i < arr.Length; i++) {
				string[] tempArr = arr[i].Split(',');
				//Debug.LogError("GetAssetBundleName tempArr[0].."+tempArr[0]);
				assetBundleNamesDic.Add(tempArr[0], tempArr[1]);
			}
		}

		if (assetBundleNamesDic.ContainsKey(bundleName)) {
			return assetBundleNamesDic[bundleName];
		}
		else {
			Debug.LogError("找不到" + bundleName + "对应的bundleName from AssetBundleNames.txt");
			return "";
		}
	}

	string PlayerPrefsGetString(string key)
	{
		return PlayerPrefs.GetString(key);
    }
    void PlayerPrefsSetString(string key,string v)
    {
         PlayerPrefs.SetString(key,v);
    }
	public int GetListInt(List<int> thislist,int id)
	{
		return thislist [id];
	}
	public float GetV3Angle(Vector3 v1,Vector3 v2)
	{
		return Vector3.Angle (v1, v2);
	}
	public Quaternion GetQuaternionSlerp(Quaternion rote1,Quaternion rote2,float f)
	{
		return Quaternion.Slerp(rote1, rote2, f);
	}
	
	public void EnterLoadAssetBoundle()
	{
		BundleState = AssetBundleState.OnLoadAssetBundle;
	}
	
	public void ExitAssetBoundle()
	{
		BundleState = AssetBundleState.LoadAssetBundleOK;
		LoadMainLua();
	}
	
	public int GetAssetBoundleState()
	{
		#if UNITY_EDITOR 
		#if bundletest
		return (int)BundleState;
		#else
		return 2;
		#endif
		#else
		return (int)BundleState;
		#endif
	}
	
	public string GetSceneName()
	{
		return Application.loadedLevelName;
	}

	public int GetAssetLoadNum()
	{
		//return AssetBundleManager.GetNowInProgressOperationsCount();
		return nowLoadingAssetNum;
	}
	/*
	public UIAtlas GetAtlas(object _Gob)
	{
		UIAtlas _uiatlas = _Gob as UIAtlas;
		return _uiatlas;
	}
	
	public UIAtlas transGrayAtlasSoftClip(UIAtlas oldAtlas)
	{
		if(oldAtlas ==null)
		{
			return null;
		}	
		Shader grayShdr =(Shader)Resources.Load("shader/TransparentGray(SoftClip)",typeof(Shader) );
		UIAtlas	newAtlas =(UIAtlas)GameObject.Instantiate(oldAtlas);
		Material grayMtl =(Material)GameObject.Instantiate(oldAtlas.spriteMaterial);
		grayMtl.shader =grayShdr;
		newAtlas.spriteMaterial =grayMtl;
		newAtlas.name = "softclip" + "_" + oldAtlas.name +"Gray";
		return newAtlas;
	}
	
	public UIAtlas transGrayAtlasNormal(UIAtlas oldAtlas)
	{
		if(oldAtlas ==null)
		{
			return null;
		}	
		Shader grayShdr =(Shader)Resources.Load("shader/TransparentGray",typeof(Shader) );
		UIAtlas	newAtlas =(UIAtlas)GameObject.Instantiate(oldAtlas);
		Material grayMtl =(Material)GameObject.Instantiate(oldAtlas.spriteMaterial);
		grayMtl.shader =grayShdr;
		newAtlas.spriteMaterial =grayMtl;
		newAtlas.name ="normal"+ "_" + oldAtlas.name +"Gray";
				
		return newAtlas;
	}
	
	public UIAtlas SetAtlasMask(UIAtlas oldAtlas)
	{
		
		if(oldAtlas ==null)
		{
			return null;
		}	
		Shader grayShdr =(Shader)Resources.Load("shader/Unlit - Transparent Colored",typeof(Shader) );
		UIAtlas	newAtlas =(UIAtlas)GameObject.Instantiate(oldAtlas);
		Material grayMtl =(Material)GameObject.Instantiate(oldAtlas.spriteMaterial);
		grayMtl.shader =grayShdr;
		newAtlas.spriteMaterial =grayMtl;
		Texture2D Circle = (Texture2D)Resources.Load("UI_Cut_IconCircle");
		newAtlas.spriteMaterial.SetTexture("_MainTex2",Circle);	
		newAtlas.name = oldAtlas.name;
		return newAtlas;
	}
	
	public UIAtlas SetAtlasGrayMask(UIAtlas oldAtlas)
	{
		if(oldAtlas ==null)
		{
			return null;
		}	
		Shader grayShdr =(Shader)Resources.Load("shader/TransparentGray",typeof(Shader) );
		UIAtlas	newAtlas =(UIAtlas)GameObject.Instantiate(oldAtlas);
		Material grayMtl =(Material)GameObject.Instantiate(oldAtlas.spriteMaterial);
		grayMtl.shader =grayShdr;
		newAtlas.spriteMaterial =grayMtl;
		Texture2D Circle = (Texture2D)Resources.Load("UI_Cut_IconCircle");
		newAtlas.spriteMaterial.SetTexture("_MainTex2",Circle);	
		newAtlas.name = oldAtlas.name;
		return newAtlas;	
	}
	
	*/
	public UIAtlas transGrayAtlasNormal(UIAtlas oldAtlas)
	{
		if(oldAtlas ==null)
		{
			return null;
		}	
		Shader grayShdr =(Shader)Resources.Load("shader/TransparentGray",typeof(Shader) );
		UIAtlas	newAtlas =(UIAtlas)GameObject.Instantiate(oldAtlas);
		Material grayMtl =(Material)GameObject.Instantiate(oldAtlas.spriteMaterial);
		grayMtl.shader =grayShdr;
		newAtlas.spriteMaterial =grayMtl;
		newAtlas.name ="normal"+ "_" + oldAtlas.name +"Gray";
				
		return newAtlas;
	}
	
	public UIAtlas transGrayAtlasSoftClip(UIAtlas oldAtlas)
	{
		if(oldAtlas ==null)
		{
			return null;
		}	
		Shader grayShdr =(Shader)Resources.Load("shader/TransparentGray(SoftClip)",typeof(Shader) );
		UIAtlas	newAtlas =(UIAtlas)GameObject.Instantiate(oldAtlas);
		Material grayMtl =(Material)GameObject.Instantiate(oldAtlas.spriteMaterial);
		grayMtl.shader =grayShdr;
		newAtlas.spriteMaterial =grayMtl;
		newAtlas.name = "softclip" + "_" + oldAtlas.name +"Gray";
		return newAtlas;
	}
	public void SetGobLayer(Transform _Transfrom , int _Layer)
	{
		if(_Transfrom!=null)
		{
			_Transfrom.gameObject.layer = _Layer;
		}
		
		
		Transform[] Components = _Transfrom.GetComponentsInChildren<Transform>(true);
		for(int i = 0 ; i < Components.Length ; i++)
		{		
			if(Components[i]!=null)
			{
								
				if(Components[i].GetComponent<ParticleSystem>()!=null&&Components[i].GetComponent<ParticleScaler>()==null)
				{
				   //Components[i].gameObject.SetActive(false);
				   Components[i].gameObject.AddComponent<ParticleScaler>().Set(_Layer);
					Components[i].gameObject.AddComponent<PracticeNgui>().SetQueue(3500);
				  // Components[i].gameObject.SetActive(true);
				  // Components[i].gameObject.SetActive(true);
					
				}
				else if(Components[i].GetComponent<ParticleSystem>()==null)
				{
					Components[i].gameObject.layer = _Layer;
				}
				
			}
		}
		
		
	}
	public System.DateTime GetTimeYear(int _Time)
	{
		string dataT = _Time.ToString();
		System.DateTime dtStart = System.TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970,1,1));
		long Itime = long.Parse(dataT+"0000000");
		System.TimeSpan tonow = new System.TimeSpan(Itime);
		System.DateTime dtResult = dtStart.Add(tonow);
		return dtResult;
	}
	

	public bool CheckObjIsNull(GameObject obj)
	{
		return obj == null;
	}
	/*
	public BoxCollider GetHoveredObject()
	{
		if (UICamera.hoveredObject == null)
			return null;
		return UICamera.hoveredObject.GetComponent<BoxCollider>();
	}
	*/
	public Vector3 GetCameraScreenToWorldPoint(Camera tempCamera , Vector3 _pos)
	{	
		if(tempCamera!=null)
		{
		   return tempCamera.ScreenToWorldPoint(_pos);	
		}
		return Vector3.zero;
	}
	public Vector3 GetCameraWorldToScreenPoint(Camera tempCamera , Vector3 _pos)
	{	
		if(tempCamera!=null)
		{
		   return tempCamera.WorldToScreenPoint(_pos);	
		}
		return Vector3.zero;
	}
	
	
	public string GamePlatform()
	{
		return Enviroment;
	}
	
	private Dictionary<string , string> BanWords = new Dictionary<string, string>();
	public bool CheckBanWord(string sName , string _BanWords)
	{
		
		if(BanWords.Count == 0)
		{
		   string[] Split = _BanWords.Split(new char[]{','});
		   for(int i = 0 ; i < Split.Length ; i++)
	       {
			  if(BanWords.ContainsKey(Split[i])==false)
			  {
			     BanWords.Add(Split[i] , Split[i]);
			  }
		   }
		
		}
			
		string 				temp1;
		string				rtName =sName;
		int					nStartPos = 0;
		
		while(nStartPos < sName.Length)
		{
			
			for(int nCount = nStartPos; nCount < sName.Length; ++nCount)
			{
				temp1 = sName.Substring(nStartPos,nCount - nStartPos + 1);
				if(BanWords.ContainsKey(temp1) == true)
				{
					return false;
					/*string	koukou ="";
					for(int i =0;i <temp1.Length;i++)
					{
						koukou +="口";
					}
					
					rtName =sName.Replace(temp1,koukou);
					sName = rtName;
					nStartPos=-1;
					break;*/
				}
			
			}
			++nStartPos;
		}
		return true;
	}
	
	public int GetByte(string _text)														//获得字符串字节长度
	{
		int textlength = _text.Length;
		int Length = System.Text.Encoding.UTF8.GetBytes(_text.ToCharArray()).Length;
		return (textlength + Length)/2;
	}
	/// <summary>
	/// 设置ScrollView左下对齐
	/// </summary>
	/// <param name="scrollView">Scroll view obj.</param>
	/// <param name="uiGrid">User interface grid obj.</param>
	/// 
	/*
	public void SetScrollViewBottomLeft(GameObject scrollView, GameObject uiGrid)
	{
		scrollView.GetComponent<UIScrollView> ().contentPivot = UIWidget.Pivot.TopLeft;
//		scrollView.GetComponent<UIScrollView> ().contentPivot = UIWidget.Pivot.BottomLeft;
//		uiGrid.GetComponent<UIGrid>().Reposition();
		scrollView.GetComponent<UIScrollView> ().ResetPosition();
	}
	*/
	//竞技场匹配倒计时
	private int curCount = 0;
	private List<GameObject> showHidenObjArr = new List<GameObject>();
	public void SetShowHidenObj(GameObject obj1, GameObject obj2, GameObject obj3)
	{
		if (showHidenObjArr.Count > 0) 
		{
			showHidenObjArr = new List<GameObject>();
		}

		showHidenObjArr.Add(obj1);
		showHidenObjArr.Add(obj2);
		showHidenObjArr.Add(obj3);
	}

	public void StartShowHiddenDo(bool isDo)
	{
		CancelInvoke ("StartShowHiddenDoDo");
		if (isDo) 
		{
			curCount = 0;	
			InvokeRepeating ("StartShowHiddenDoDo", 0, 0.5f);
		}
	}

	void StartShowHiddenDoDo()
	{
		curCount++;
		for (int i = 1; i < 4; i++) 
		{
			if(curCount % 4 == i)
			{
				if(showHidenObjArr[i - 1]!=null)
				{
					showHidenObjArr[i - 1].SetActive(true);
				}
			}
			else if(curCount % 4 == 0)
			{
				if(showHidenObjArr[i - 1]!=null)
				{
					showHidenObjArr[i - 1].SetActive(false);
				}
			}
		}
	}
	/*
	public void SetLabelColor(UILabel _Text , float _r , float _g , float _b, float _a)
	{
		_Text.color = new Color((float)_r/255 , (float)_g/255 , (float)_b/255 , (float)_a/255);
	}
	
	public void SetLabelOutLine(UILabel _Text , bool _Open)
	{
		if(_Open==true)
		{
		   _Text.effectStyle = UILabel.Effect.Outline;
		}
		else
		{
		   _Text.effectStyle = UILabel.Effect.None;
		}	
	}
	*/
	public bool b_clearafter=false;
	public void SetClearLoadAssetB(bool clearafter)
	{
		b_clearafter = clearafter;
	}

    public string GetNowLevelName()
    {
        return Application.loadedLevelName;
    }

    public AsyncOperation LoadLevelAsync(string lvlName)
    {
        return Application.LoadLevelAsync(lvlName);
    }
	
	public bool JudgeName(string _Name)
	{
		if(Regex.IsMatch(_Name , "^[0-9a-zA-Z\u4e00-\u9fa5_-]+$"))
		{
			return true;	
		}
		return false;
	}
	
	public bool JudgeCode(string _Code)
	{
		if(Regex.IsMatch(_Code , "^[0-9A-Za-z_~!@#$%^&*]{6,16}$"))
		{
			return true;	
		}
		return false;
	}
	
	public bool JudgeAccount(string _Account)
	{
		if(Regex.IsMatch(_Account , "^[0-9A-Za-z_]{5,12}$"))
		{
			return true;	
		}
		return false;
	}
	
	public int GetZhengShu(int _Number)
	{
		int t = _Number/10;
		return t;
	}
	
	public int GetYuShu(int _Number)
	{
		int t = _Number%10;
		return t;
	}
			
 	public void SetNameMeshColor(TextMesh _Name , float r , float g , float b)
	{
	   _Name.color = new Color(r , g , b);
	}
	
	public void SetSpriteColor(SpriteRenderer _Sprite , float r , float g , float b)
	{
	   	_Sprite.color = new Color(r , g , b);
	}
	
	private Renderer MapRender;
	private GameObject Cube;
	private Texture2D Tex;

	public Texture2D CreateTexture()
	{
		if(Tex!=null)
		{
			return Tex;
		}

		
		if(Tex==null)
		{
		   Texture2D maint = new Texture2D(800 , 640 , TextureFormat.RGBA32 , false);
		   Tex = maint;
		}
		for(int i = 1 ; i <= Tex.width ; i++)
		{
			for(int j = 1 ; j <= Tex.height ; j++)
			{
			    Tex.SetPixel(i , j , new Color(0f , 0f ,0f , 0f));
			}
		}	
		Tex.filterMode = FilterMode.Point;
		Tex.Apply();
		return Tex;
		//MapRender.material.mainTexture = Tex;
		//MapRender.material.shader = Shader.Find("Unlit/Transparent");
		//Cube.transform.localPosition = new Vector3(1707f , -434f , 889);
		//Cube.transform.localScale = new Vector3(800f , 1f , 640f);
	}
	
	void OnDestroy()
	{
		Tex = null;
	}
	
	public void SetTexture(int _Xpixel , int _Ypixel , int _CityType)
	{
		if(Tex==null)
		{
			return;
		}
		for(int i = 1 ; i <= 21 ; i++)
		{			
			for(int j = 1 ; j <= 21 ; j++)
			{
				if(_CityType==1)
				{
					Tex.SetPixel(_Xpixel + i - 10 , _Ypixel + j - 10, new Color(1f , (float)128/(float)255 ,0f , 1f));
				}
				else if(_CityType==2)
				{
					Tex.SetPixel(_Xpixel + i - 10 , _Ypixel + j - 10, new Color(0f , (float)245/(float)255 ,1f , 1f));
				}
				else if(_CityType==3)
				{
					Tex.SetPixel(_Xpixel + i - 10 , _Ypixel + j - 10, new Color((float)30/(float)255 , 1f ,0f , 1f));
				}
				else if(_CityType==4)
				{
					Tex.SetPixel(_Xpixel + i - 10 , _Ypixel + j - 10, new Color(1f , 0f ,(float)227/(float)255 , 1f));
				}
				
			    
			}
		}
	}
	
	public void SetTexApply()
	{
		Tex.Apply();
	}

	public bool IsInBattle =false;
	//public void EnterBattle(int maptype,int mapdbid )
	//{
	//	EnterBattle (maptype, mapdbid, false);
	//}
	public void EnterBattle(int maptype,int mapdbid,bool isfirstblood)
	{
		Tex = null;
		if(Fingerroot!=null)
		{
			Fingerroot.SetActive(true);
		}
		IsInBattle =true;
		btdatap_ mapdata=new btdatap_();
		mapdata.maptype= (bttype_)(maptype);        //当前战斗类型
		mapdata.mapDbid=mapdbid;			//地图信息
		mapdata.firstblood = isfirstblood;
		lgbtmag.Ins.IniSome(mapdata);

	}
	public void QuitBattle()
	{
		if(Fingerroot!=null)
		{
			Fingerroot.SetActive(false);
		}
		IsInBattle =false;
		tModleFactory.Ins.ClearObj ();	
		System.Object[] args = new System.Object[0];      
        Call(mainlua, "GameMain.OutZQBattle", args);
	}

	public Color hexToColor(string hex)
	{
		hex = hex.Replace ("0x", "");//in case the string is formatted 0xFFFFFF
		hex = hex.Replace ("#", "");//in case the string is formatted #FFFFFF
		byte a = 255;//assume fully visible unless specified in hex
		byte r = byte.Parse(hex.Substring(0,2), System.Globalization.NumberStyles.HexNumber);
		byte g = byte.Parse(hex.Substring(2,2), System.Globalization.NumberStyles.HexNumber);
		byte b = byte.Parse(hex.Substring(4,2), System.Globalization.NumberStyles.HexNumber);
		//Only use alpha if the string has enough characters
		if(hex.Length == 8){
			a = byte.Parse(hex.Substring(4,2), System.Globalization.NumberStyles.HexNumber);
		}
		return new Color32(r,g,b,a);
	}
	
	public void PlayAnimation(GameObject _Model , string _PrefabName , string _AnimationName)		
	{
		Animation myani = _Model.GetComponent<Animation>();
		/*if(_PrefabName == "Mount1_1")
		{
			myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.walkList[0],"walk");
			myani.Stop();
		    myani.Play(_AnimationName);	
			return;
		}
	    
		int animaid = lgCfgMag.Ins.GetRoleAnimaId(_PrefabName);
		animaid = 1;
	    if(animaid>0)
		{
			myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.waitList[animaid],"wait");
			myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.walkList[animaid],"walk");
			myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.dieList[animaid],"die");
			myani.AddClip(lgCfgMag.Ins.MyRoleAnimaKu.attackList[animaid],"attack");
		}*/
		myani.Stop();
        myani.CrossFade(_AnimationName);
    }

    public void PlayOnceAnimation(GameObject _Model, string _PrefabName, string _AnimationName , string _EndAnimaitionName)
    {
        Animation myani = _Model.GetComponent<Animation>();
        var clip = myani.GetClip(_AnimationName);
        myani.Stop();
        myani.CrossFade(_AnimationName);
        //myani.Play(_AnimationName);
        StartCoroutine(WaitTimeToPlayAni(clip.length ,  _Model,  _PrefabName, _EndAnimaitionName));
    }
    private IEnumerator WaitTimeToPlayAni(float time , GameObject _Model, string _PrefabName, string _AnimationName)
    {
        yield return new WaitForSeconds(time);
        //PlayAnimation(_Model, _PrefabName, _AnimationName);
    }
    //得到角色符文信息
    public LuaTable GetRole1FuWenInfo()
	{
		//System.Object[] args = new System.Object[1];	
		//args[0] = "1";
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetBattleInfo1"); 	//snbug
		return t;
	}
	public LuaTable GetRole2FuWenInfo()
	{
		//System.Object[] args = new System.Object[1];	
		//args[0] = "2";
		LuaTable t= (LuaTable)Call(mainlua, "GameMain.GetBattleInfo2"); 	//snbug
		return t;
	}

	public void Setpvprolelist(LuaTable RoleList1,LuaTable RoleList2)
	{
		List<Pvp_RoleList_> temppvp_RoleList1 =new List<Pvp_RoleList_>();
		List<Pvp_RoleList_> temppvp_RoleList2 =new List<Pvp_RoleList_>();

		IEnumerator<LuaTable.TablePair> temp = RoleList1.GetEnumerator ();
		LuaTable.TablePair tempTablePair;
		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			Pvp_RoleList_ Fightroleinfo = new Pvp_RoleList_();
			Fightroleinfo.name = System.Convert.ToString(roleinfo["name"]);
			Fightroleinfo.countryid = System.Convert.ToInt32(roleinfo["countryid"]);

			temppvp_RoleList1.Add(Fightroleinfo);
		}

		temp = RoleList2.GetEnumerator ();

		for(;temp.MoveNext()==true;)
		{
			tempTablePair = (LuaTable.TablePair)(temp.Current);
			LuaTable roleinfo =  (LuaTable)(tempTablePair.value);
			Pvp_RoleList_ Fightroleinfo = new Pvp_RoleList_();
			Fightroleinfo.name = System.Convert.ToString(roleinfo["name"]);
			Fightroleinfo.countryid = System.Convert.ToInt32(roleinfo["countryid"]);
			temppvp_RoleList2.Add(Fightroleinfo);
		}

		lgbtmag.Ins.Setpvprolelist( temppvp_RoleList1,temppvp_RoleList2);
	}
	
	public void CancelPar(Transform _Transfrom)
	{
		Transform[] Components = _Transfrom.GetComponentsInChildren<Transform>(true);
		for(int i = 0 ; i < Components.Length ; i++)
		{		
			if(Components[i]!=null)
			{								
				if(Components[i].GetComponent<ParticleScaler>()!=null)
				{
				   Components[i].gameObject.AddComponent<ParticleScaler>().CancelPar();			
				}								
			}
		}
		
	}
	public void ShowPar(Transform _Transfrom)
	{
		Transform[] Components = _Transfrom.GetComponentsInChildren<Transform>(true);
		for(int i = 0 ; i < Components.Length ; i++)
		{		
			if(Components[i]!=null)
			{								
				if(Components[i].GetComponent<ParticleScaler>()!=null)
				{
				   Components[i].gameObject.AddComponent<ParticleScaler>().OpenPar();			
				}								
			}
		}
		
	}
    /// <summary>
    /// 得到网络状态
    /// </summary>
    /// <returns>0 没有网络；1 流量上网 ； 2 wifi 上网</returns>
    public int GetNetState()
    {
        int netState = 0;
        switch (Application.internetReachability)
        {
            case NetworkReachability.NotReachable://没有网络
                netState = 0;
                break;
            case NetworkReachability.ReachableViaCarrierDataNetwork://通过流量上网
                netState = 1;
                break;
            case NetworkReachability.ReachableViaLocalAreaNetwork://通过wifi网络可达
                netState = 2;
                break;
        }
        return netState;
    }
    /// <summary>
    /// 得到电量
    /// </summary>
    /// <returns></returns>
    public int GetBattery()
    {
#if UNITY_ANDROID
        try
        {
            string CapacityString = System.IO.File.ReadAllText("/sys/class/power_supply/battery/capacity");
            return int.Parse(CapacityString);
        }
        catch (Exception e)
        {
            //Debug.Log("Failed to read battery power; " + e.Message);
        }
        return -1;
#elif UNITY_IPHONE
        return -1;//需要获取iOS的电量
#else
        return -1;
#endif
    }


    public string GetSysTime()
    {
        var time = System.DateTime.Now;
        
        var str = time.ToString("mm:ss");
		var endTime = time.Hour.ToString()+":"+str;
        return endTime;
    }
	public bool Maikefeng = false;
    public void SendInitChat(string name , string uuid , int country , int countryChatId , int worldChatId , int lvl , int quality , string countryAtlasName , string countrySpriteName , int commandId)
    {
		//Debug.LogError ("SendInitChat countryChatId="+countryChatId.ToString()+" worldChatId="+worldChatId.ToString());
        IniChatData_ inidata = new IniChatData_();
        inidata.name = name;
        //inidata.chatid =-1;	//GotyeChatTarget.ID

        inidata.uuid = uuid;       //账号ID  防止查找用
        inidata.Country = country;//所属国家 -1 还没有加入国家
        inidata.country_atlas = countryAtlasName;
        inidata.country_sp = countrySpriteName;
        inidata.headspid = commandId;
		/*
        var ceshiCountryId = 0;
        //测试用
        switch (inidata.Country)//1 ， 2 ，3 ，4 蜀 魏 吴 中立
        {
            case 1:
                ceshiCountryId = 524213;
                break;
            case 2:
                ceshiCountryId = 524209;
                break;
            case 3:
                ceshiCountryId = 524211;
                break;
        }
        */
		inidata.countrychatid = countryChatId;//ceshiCountryId;//国家聊天房间id
		inidata.worldchatid = worldChatId;//476672;//worldChatId;   //世界聊天室id
        inidata.lvl = lvl;       //等级
        inidata.qulity = quality; //品质
        inidata.countrychatfb = false;  //国家频道禁言
        inidata.chatfblvl = 10;     //禁言权限等级  高的禁言低级的

        lgChatMag.Ins.IniChat(inidata);

    }
    /// <summary>
    /// 改变信息
    /// </summary>
    public void SetChatInfo(int lvl , int countroy , int commandId , string name)
    {
        lgChatMag.Ins.SetChatfblvl(lvl, countroy , commandId , name);
    }

	//sdk相关
	public lgSdkMag MySdkMag=null;
	public void IniSdk(int sdk_type,int sdk_p)
	{
#if UNITY_IPHONE
        if(MySdkMag==null)
		{
			MySdkMag = gameObject.AddComponent<lgSdkMag>() as lgSdkMag;
		}
		Debug.LogError("lgnodelcsfun------   IniSdk  sdk_type="+sdk_type.ToString()+" sdk_p="+sdk_p.ToString());
		MySdkMag.IniSdk (sdk_type,sdk_p);
#endif
    }




    //gou
    public void AskBuy(string objid ,string dindan)
	{
        #if UNITY_IPHONE
		bool canbuy= MySdkMag.AskBuy (objid,dindan);
		if(canbuy==true)
		{
            //start loading
            Call(mainlua, "GameMain.StartSendBuyInfo");
        }
#endif
	}
	public void GetBuyResult(int re)//0 成功，else 错误
	{
#if UNITY_IPHONE
        //end loading
        Call(mainlua, "GameMain.EndBuyWeb", re);
#endif
    }
    public void ClearBuyRecord()
	{
#if UNITY_IPHONE
        MySdkMag.ClearBuyRecord ();
#endif
    }


    public void PopTip(string str)
    {
        Call(mainlua, "GameMain.PopChatTips", str);
    }

    public int GetStrByteCount(string str)
    {
        byte[] sarr = System.Text.Encoding.Default.GetBytes(str);
        int len = sarr.Length;
		Debug.LogError(len);
        return len;
    }

    public void SetParticleScale(float scale , GameObject obj)
    {
        /*var lists = obj.GetComponentsInChildren<ParticleScaler>();
        if(lists.Length>0)
        {
            foreach(var item in lists)
            {
                item.SetAllScale(scale);
            }
        }*/
    }

    public void AddFriend(string _UUID)
    {
        Call(mainlua, "GameMain.AddFriend", _UUID);
    }

}
