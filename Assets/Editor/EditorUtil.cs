using UnityEngine;
using System.Collections;
using System.IO;

public class EditorUtil 
{
	public delegate void Callback (bool isSetAssetBundleName, string path);
	public static void Walk(bool isSetAssetBundleName, string path, string[] extList,Callback DoSetAssetBundleName)//Assets/Resources/role/Boss4_t0.prefab
	{
		bool isTypeRight = false;
		//检查是否是指定类型的文件
		for (int i = 0; i < extList.Length; i++) {
			if (path.Contains(extList[i])) {
				isTypeRight = true;
				break;
			}
		}

		if (!isTypeRight)
			return;
		string metaPath = path + ".meta";
		if (!File.Exists (metaPath)) 
			return;

		DoSetAssetBundleName (isSetAssetBundleName, metaPath);
	}
}
