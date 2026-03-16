using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class AssetbundlesMenuItems
{
	const string kSimulateAssetBundlesMenu = "AssetBundles/Simulate AssetBundles";

	//[MenuItem(kSimulateAssetBundlesMenu)]
	public static void ToggleSimulateAssetBundle ()
	{
		AssetBundleManager.SimulateAssetBundleInEditor = !AssetBundleManager.SimulateAssetBundleInEditor;
	}

	//[MenuItem(kSimulateAssetBundlesMenu, true)]
	public static bool ToggleSimulateAssetBundleValidate ()
	{
		Menu.SetChecked(kSimulateAssetBundlesMenu, AssetBundleManager.SimulateAssetBundleInEditor);
		return true;
	}
	
	//[MenuItem ("AssetBundles/Build AssetBundles")]
	static public void BuildAssetBundles ()
	{
		BuildScript.BuildAssetBundles();
	}

	//[MenuItem ("AssetBundles/Build Player")]
	static void BuildPlayer ()
	{
		BuildScript.BuildPlayer();
	}

	/// <summary>
	/// Updates the use prefab dir by art prefab.
	/// </summary>
	//[MenuItem ("AssetBundles/UpdateUsePrefabDirByArtPrefab")]
	static void UpdateUsePrefabDirByArtPrefab ()
	{
		string[] filePaths = Directory.GetFiles (Application.dataPath + "/Resources/UsePrefab/");
		for (int i = 0; i < filePaths.Length; i++) {
			if (filePaths[i].EndsWith(".meta"))
				continue;

			Debug.Log (filePaths[i]);
			string sourcePath = filePaths[i].Replace("Resources/UsePrefab", "ArtResources/Gm/Prefab");
			if(File.Exists(sourcePath))
			{
				Debug.Log ("true");
				File.Copy(sourcePath, filePaths[i], true);
			}
		}

		Debug.Log ("刷新UsePrefab下的资源已为最新");
	}
}
