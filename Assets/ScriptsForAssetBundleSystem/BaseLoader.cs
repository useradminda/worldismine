using UnityEngine;
using System.Collections;
using System;
using SLua;
using System.Collections.Generic;

#pragma warning disable 0219


#if UNITY_EDITOR	
using UnityEditor;
#endif

public class BaseLoader : MonoBehaviour {

	const string kAssetBundlesPath = "/AssetBundles/";

	// Use this for initialization.

#if UNITY_EDITOR && loadbundlecycletest
	protected void OnGUI()
	{
		if(loadingAsset.Count > 0)
			GUI.Label (new Rect (10, 10, 500, 100), "loading asset === " + loadingAsset [0].assetBundleName);
	}
#endif
	
	// Update is called once per frame
	protected void Update () {
        if (loadingAsset.Count < 1 && loadAssetQueue.Count > 0)
		{
            loadingAsset.Add(loadAssetQueue[0]);
            loadAssetQueue.RemoveAt(0);
            StartCoroutine("LoadThisObj", loadingAsset[0]);
		}
	}


	// Initialize the downloading url and AssetBundleManifest object.
	protected IEnumerator Initialize()
	{
		// Don't destroy the game object as we base on it to run the loading script.
		DontDestroyOnLoad(gameObject);
		
#if UNITY_EDITOR
		Debug.Log ("We are " + (AssetBundleManager.SimulateAssetBundleInEditor ? "in Editor simulation mode" : "in normal mode") );
#endif

		string platformFolderForAssetBundles = 
#if UNITY_EDITOR
			GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget);
#else
			GetPlatformFolderForAssetBundles(Application.platform);
#endif

		// Set base downloading url.
		string relativePath = GetRelativePath();
		//"file://C:/Users/jayce/AppData/Local/Temp/u9/hz/DHZ/Usedata/"
//		AssetBundleManager.BaseDownloadingURL = "file://" + lgNoDelCsFun.Ins.GetGameLocalPath() + "Usedata/";
		Caching.ClearCache ();
		//Debug.LogError (AssetBundleManager.BaseDownloadingURL);
		// Initialize AssetBundleManifest which loads the AssetBundleManifest object.
		var request = AssetBundleManager.Initialize(platformFolderForAssetBundles);
		if (request != null)
			yield return StartCoroutine(request);
	}

	public string GetRelativePath()
	{
		if (Application.isEditor)
			return "file://" +  System.Environment.CurrentDirectory.Replace("\\", "/"); // Use the build output folder directly.
		else if (Application.platform == RuntimePlatform.WebGLPlayer)
			return System.IO.Path.GetDirectoryName(Application.absoluteURL).Replace("\\", "/")+ "/StreamingAssets";
		else if (Application.isMobilePlatform || Application.isConsolePlatform)
			return Application.streamingAssetsPath;
		else // For standalone player.
			return "file://" +  Application.streamingAssetsPath;
	}

#if UNITY_EDITOR
	public static string GetPlatformFolderForAssetBundles(BuildTarget target)
	{
		switch(target)
		{
		case BuildTarget.Android:
			return "Android";
		case BuildTarget.iOS:
			return "iOS";
		//case BuildTarget.WebPlayer:
			//return "WebPlayer";
		case BuildTarget.StandaloneWindows:
		case BuildTarget.StandaloneWindows64:
			return "Windows";
		case BuildTarget.StandaloneOSXIntel:
		case BuildTarget.StandaloneOSXIntel64:
		case BuildTarget.StandaloneOSX:
			return "OSX";
			// Add more build targets for your own.
			// If you add more targets, don't forget to add the same platforms to GetPlatformFolderForAssetBundles(RuntimePlatform) function.
		default:
			return null;
		}
	}
#endif

	static string GetPlatformFolderForAssetBundles(RuntimePlatform platform)
	{
		switch(platform)
		{
		case RuntimePlatform.Android:
			return "Android";
		case RuntimePlatform.IPhonePlayer:
			return "iOS";
		//case RuntimePlatform.WindowsWebPlayer:
		//case RuntimePlatform.OSXWebPlayer:
			//return "WebPlayer";
		case RuntimePlatform.WindowsPlayer:
			return "Windows";
		case RuntimePlatform.OSXPlayer:
			return "OSX";
			// Add more build platform for your own.
			// If you add more platforms, don't forget to add the same targets to GetPlatformFolderForAssetBundles(BuildTarget) function.
		default:
			return null;
		}
	}

    static List<LoadAssetP_> loadAssetQueue = new List<LoadAssetP_>();
    static List<LoadAssetP_> loadingAsset = new List<LoadAssetP_>();
    protected void AddLoadAssetTask(LoadAssetP_ thisp)
    {
        loadAssetQueue.Add(thisp);
    }

	protected IEnumerator LoadThisObj (LoadAssetP_ thisp)
	{
		//Debug.Log ("LoadThisObj thisp.assetName=" + thisp.assetName+" time="+Time.time);
		// Load asset from assetBundle.
		yield return 1;
		AssetBundleLoadAssetOperation request = AssetBundleManager.LoadAssetAsync(thisp.assetBundleName, thisp.assetName, typeof(GameObject) );
		if (request == null)
			yield break;
		yield return StartCoroutine(request);
		
		// Get the asset.
		GameObject prefab = request.GetAsset<GameObject> ();
		//Debug.Log(assetName + (prefab == null ? " isn't" : " is")+ " loaded successfully at frame2 " + Time.time );
		lgNoDelCsFun.Ins.LoadAssetCB (thisp, prefab);
        loadingAsset.Remove(thisp);
	}

	protected IEnumerator Load (LuaTable info, string assetBundleName, string assetName, LuaFunction cb)
	{
		Debug.Log ("Load assetBundleName=" + assetBundleName+" time="+Time.time);
		// Load asset from assetBundle.
		AssetBundleLoadAssetOperation request = AssetBundleManager.LoadAssetAsync(assetBundleName, assetName, typeof(GameObject) );
		if (request == null)
			yield break;
		yield return StartCoroutine(request);
		
		// Get the asset.
		GameObject prefab = request.GetAsset<GameObject> ();
		//Debug.Log(assetName + (prefab == null ? " isn't" : " is")+ " loaded successfully at frame2 " + Time.time );
		
		//if (prefab != null)
		//GameObject.Instantiate(prefab);
		if (cb != null) {
			//Debug.Log(assetName + (prefab == null ? " isn't" : " is")+ " loaded successfully at frame2 " + Time.time );
			cb.call (info, prefab);
		}
	}
	
	protected IEnumerator Load (string assetBundleName, string assetName, LuaFunction cb)
	{
		Debug.LogWarning("Start to load " + assetBundleName + "|" + assetName + " at frame " + Time.frameCount);

		// Load asset from assetBundle.
		AssetBundleLoadAssetOperation request = AssetBundleManager.LoadAssetAsync(assetBundleName, assetName, typeof(GameObject) );
		if (request == null)
			yield break;
		yield return StartCoroutine(request);

		// Get the asset.
		GameObject prefab = request.GetAsset<GameObject> ();
		//Debug.Log(assetName + (prefab == null ? " isn't" : " is")+ " loaded successfully at frame3 " + Time.frameCount );

		//if (prefab != null && cb == null)
		//	GameObject.Instantiate(prefab);

		if (cb != null) {
			cb.call (prefab);
		}
	}

	protected IEnumerator LoadCreateBase (string assetBundleName, string assetName)
	{
		Debug.Log ("Load assetBundleName=" + assetBundleName+" time="+Time.time);
		// Load asset from assetBundle.
		AssetBundleLoadAssetOperation request = AssetBundleManager.LoadAssetAsync(assetBundleName, assetName, typeof(GameObject) );
		if (request == null)
			yield break;
		yield return StartCoroutine(request);
		
		// Get the asset.
		GameObject prefab = request.GetAsset<GameObject> ();
		//Debug.Log(assetName + (prefab == null ? " isn't" : " is")+ " loaded successfully at frame2 " + Time.time );
		
		if (prefab != null)
		GameObject.Instantiate(prefab);
	}

    protected IEnumerator LoadLevel (string assetBundleName, string levelName, bool isAdditive)
	{
		Debug.Log("Start to load scene " + levelName + " at frame " + Time.frameCount);

		// Load level from assetBundle.
		AssetBundleLoadOperation request = AssetBundleManager.LoadLevelAsync(assetBundleName, levelName, isAdditive);
		if (request == null)
			yield break;
		yield return StartCoroutine(request);

		// This log will only be output when loading level additively.
		Debug.Log("Finish loading scene " + levelName + " at frame " + Time.frameCount);
	}

}
