using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Text;

public class SetAssetBundleName : Editor
{
    static Dictionary<string, string> midPath = new Dictionary<string, string>(); //资源再项目中的路径和打包后的名字前缀
    static bool isAuto = false;
    // 设置assetbundle的名字(修改meta文件)
    //[MenuItem("AssetBundles/AssetBundleName/Set")]
    static void OnSetAssetBundleName()
    {
        isAuto = false;
        Object[] gos = Selection.objects;
        for (int i = 0; i < gos.Length; i++)
        {
            string path = AssetDatabase.GetAssetPath(gos[i]);
            string[] extList = new string[] { ".prefab", ".png", ".jpg", ".tga", ".mat", ".unity" };
           // EditorUtil.Walk(true, path, extList, DoSetAssetBundleName);
        }

        //刷新编辑器
        AssetDatabase.Refresh();
        Debug.Log("AssetBundleName设置完毕,共修改个" + gos.Length + "文件");
    }

    //[MenuItem("AssetBundles/AssetBundleName/Cancel")]
    static void OnCancelAssetBundleName()
    {
        Object[] gos = Selection.objects;
        Debug.Log(gos.Length);
        for (int i = 0; i < gos.Length; i++)
        {
            Debug.Log(AssetDatabase.GetAssetPath(gos[i]));

            string path = AssetDatabase.GetAssetPath(gos[i]);
            string[] extList = new string[] { ".prefab", ".png", ".jpg", ".tga", ".unity" };
           // EditorUtil.Walk(false, path, extList, DoSetAssetBundleName);
        }

        //刷新编辑器
        AssetDatabase.Refresh();
        Debug.Log("AssetBundleName去除完毕,共修改个" + gos.Length + "文件");
    }

    static string GetTempPath()
    {
        string result = "";
#if UNITY_EDITOR
        result = Application.dataPath + "/ziyuan/";
#elif UNITY_STANDALONE_WIN
		result =  Application.temporaryCachePath + "/ZQ/";
#elif UNITY_IPHONE
		result = Application.temporaryCachePath + "/ZQ/";
		
#elif UNITY_ANDROID
		result = Application.temporaryCachePath + "/ZQ/";
#endif
        return result;
    }

    public static string luaBundleName = "lua";//生成的lua脚本bundle名，可根据需要更改
    static List<string> luaDirPathList = new List<string>();
    static void ImportLuaScriptFile()
    {
        luaDirPathList = new List<string>();
        string toDirPath = "";
#if UNITY_EDITOR_WIN
        string pathPre = Application.dataPath.Replace("/", @"\") + @"\ziyuan\";
        luaDirPathList.Add(pathPre + @"Usedata\Common");
        luaDirPathList.Add(pathPre + @"Usedata\gm\UiLua");
        luaDirPathList.Add(pathPre + @"Usedata\ui\UiLua");
        toDirPath = Application.dataPath + @"\ArtResources\Gm\Prefab\" + luaBundleName + @"\";
#else
		string pathPre = Application.dataPath + @"/ziyuan/";
		luaDirPathList.Add(pathPre + @"Usedata/Common");
		luaDirPathList.Add(pathPre + @"Usedata/gm/UiLua");
		luaDirPathList.Add(pathPre + @"Usedata/ui/UiLua");
		toDirPath = Application.dataPath + @"/ArtResources/Gm/Prefab/" + luaBundleName + "/";
#endif
        //添加lua子文件夹
        for (int i = 0; i < luaDirPathList.Count; i++)
        {
            string[] dirs = Directory.GetDirectories(luaDirPathList[i]);
            for (int d = 0; d < dirs.Length; d++)
            {
                Debug.Log("add sub dir:" + dirs[d]);
                luaDirPathList.Add(dirs[d]);
            }
        }
        Debug.Log("all dir count:" + luaDirPathList.Count);
        //判断文件夹是否存在
        if (Directory.Exists(toDirPath))
        {
            string[] files = Directory.GetFiles(toDirPath);
            for (int i = 0; i < files.Length; i++)
            {
                File.Delete(files[i]);
            }
        }
        else {
            Directory.CreateDirectory(toDirPath);
        }

        Dictionary<string, string> luaDic = new Dictionary<string, string>();
        for (int i = 0; i < luaDirPathList.Count; i++)
        {
            string[] files = Directory.GetFiles(luaDirPathList[i]);
            for (int f = 0; f < files.Length; f++)
            {
                if (Path.GetExtension(files[f]) == ".lua")
                {
                    using (StreamReader sr = new StreamReader(files[f], Encoding.UTF8)) //编码格式-可更改
                    {
                        if (!luaDic.ContainsKey(Path.GetFileNameWithoutExtension(files[f])))
                        {
                            string luaContent = sr.ReadToEnd();
                            luaContent = EncryptLua(luaContent);
                            luaDic.Add(Path.GetFileNameWithoutExtension(files[f]), luaContent);
                        }
                    }
                }
            }
        }

        //not test yet 20151216
        foreach (var key in luaDic.Keys)
        {
            //File.WriteAllText(toDirPath + key + ".txt", luaDic[key]);
            using (FileStream fsSource = new FileStream(toDirPath + key + ".txt",
                                                        FileMode.Create, FileAccess.Write))
            {
                byte[] data = UTF8Encoding.UTF8.GetBytes(luaDic[key]);
                fsSource.Write(data, 0, data.Length);
            }

        }

        Debug.Log("导入lua脚本完毕，开始设置assetbundlename...");
    }

    //加密lua脚本字符串
    static string EncryptLua(string luaContent)
    {
        return luaContent;
    }

    // 设置文件夹下所有assetbundle的名字(修改meta文件)
    [MenuItem("AssetBundles/一键更新bundle(12分钟)")] //AssetBundles/SetBundleNameAuto
    public static void OnSetBundleNameAuto()
    {
        midPath = new Dictionary<string, string>();
        isClearFlag = false;
        //        ImportLuaScriptFile();
        string path = Application.dataPath;
//#if UNITY_STANDALONE_WIN
//		path = path.Replace(@"\Assets", @"\AssetBundles\") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + @"\";
//#else
        path = path.Replace("/Assets", "/AssetBundles/") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + "/";
//#endif

        if (Directory.Exists(path))
        {
            Directory.Delete(path, true);
        }

        Caching.ClearCache();
        isAuto = true;
        if (midPath.Count == 0)
        {
#if UNITY_EDITOR_WIN
            //midPath.Add (@"ArtResources\Gm\Material\", @"Gm\Material\");
            //midPath.Add (@"ArtResources\Gm\Texture\", @"Gm\Texture\");
            //midPath.Add (@"ArtResources\Scene\", @"Gm\Prefab\");
            midPath.Add(@"ArtResources\Gm\Prefab\", @"Gm\Prefab\");
            midPath.Add(@"ArtResources\Ui\Prefab\", @"Ui\Prefab\");
            //midPath.Add (@"ArtResources\Ui\Material\", @"Ui\Material\");
            //midPath.Add (@"ArtResources\Ui\Texture\", @"Ui\Texture\");
#else
			//midPath.Add (@"ArtResources/Gm/Material/", @"Gm/Material/");
			//midPath.Add (@"ArtResources/Gm/Texture/", @"Gm/Texture/");
			//midPath.Add (@"ArtResources/Scene/", @"Gm/Prefab/");
			midPath.Add (@"ArtResources/Gm/Prefab/", @"Gm/Prefab/");
			midPath.Add (@"ArtResources/Ui/Prefab/", @"Ui/Prefab/");
			//midPath.Add (@"ArtResources/Ui/Material/", @"Ui/Material/");
			//midPath.Add (@"ArtResources/Ui/Texture/", @"Ui/Texture/");
#endif
        }

        foreach (string relaPath in midPath.Keys)
        {
            string dirPath = Path.Combine(Application.dataPath, relaPath);
            string[] files = Directory.GetFiles(dirPath);
            for (int i = 0; i < files.Length; i++)
            {
                if (Path.GetExtension(files[i]) == ".meta")
                {
                    DoSetAssetBundleName(true, files[i], relaPath);
                }
            }
        }
#if loadbundlecycletest
#if UNITY_EDITOR_WIN
		StreamWriter writer = new StreamWriter(Application.dataPath + @"\Resources\PrefabRecord.txt");
#else
		StreamWriter writer = new StreamWriter(Application.dataPath + @"/Resources/PrefabRecord.txt");
#endif
		writer.Write (PrefabRecord);
		writer.Close();
		Debug.Log ("all prefab count:" + prefabCount);
#endif
        //刷新编辑器
        AssetDatabase.Refresh();
        Debug.Log("AssetBundleName自动设置完毕(1/4)!");
        Debug.Log("正在制作bundle(2/4): ...");
        BuildScript.BuildAssetBundles();
    }

    static bool isClearFlag = false;

    [MenuItem("AssetBundles/重置All BundleName=None")] //AssetBundles/SetBundleNameAuto
    public static void OnSetBundleNameAutoCancel()
    {
        relDic = new Dictionary<string, string>();
        midPath = new Dictionary<string, string>();
        //        ImportLuaScriptFile();
        isClearFlag = true;
        string path = Application.dataPath;

//#if UNITY_STANDALONE_WIN
//		path = path.Replace(@"\Assets", @"\AssetBundles\") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + @"\";
//#else
        path = path.Replace("/Assets", "/AssetBundles/") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + "/";
//#endif
        if (Directory.Exists(path))
        {
            Directory.Delete(path, true);
        }

        Caching.ClearCache();
        isAuto = true;
        if (midPath.Count == 0)
        {
#if UNITY_EDITOR_WIN
            midPath.Add(@"ArtResources\Gm\Material\", @"Gm\Material\");
            midPath.Add(@"ArtResources\Gm\Texture\", @"Gm\Texture\");
            midPath.Add(@"ArtResources\Scene\", @"Gm\Prefab\");
            midPath.Add(@"ArtResources\Gm\Prefab\", @"Gm\Prefab\");
            midPath.Add(@"ArtResources\Ui\Prefab\", @"Ui\Prefab\");
            midPath.Add(@"ArtResources\Ui\Material\", @"Ui\Material\");
            midPath.Add(@"ArtResources\Ui\Texture\", @"Ui\Texture\");
#else
			midPath.Add (@"ArtResources/Gm/Material/", @"Gm/Material/");
			midPath.Add (@"ArtResources/Gm/Texture/", @"Gm/Texture/");
			midPath.Add (@"ArtResources/Scene/", @"Gm/Prefab/");
			midPath.Add (@"ArtResources/Gm/Prefab/", @"Gm/Prefab/");
			midPath.Add (@"ArtResources/Ui/Prefab/", @"Ui/Prefab/");
			midPath.Add (@"ArtResources/Ui/Material/", @"Ui/Material/");
			midPath.Add (@"ArtResources/Ui/Texture/", @"Ui/Texture/");
#endif
        }

        foreach (string relaPath in midPath.Keys)
        {
            string dirPath = Path.Combine(Application.dataPath, relaPath);
            string[] files = Directory.GetFiles(dirPath);
            for (int i = 0; i < files.Length; i++)
            {
                if (Path.GetExtension(files[i]) == ".meta")
                {
                    DoSetAssetBundleName(true, files[i], relaPath);
                }
            }
        }
#if loadbundlecycletest
#if UNITY_EDITOR_WIN
		StreamWriter writer = new StreamWriter(Application.dataPath + @"\Resources\PrefabRecord.txt");
#else
		StreamWriter writer = new StreamWriter(Application.dataPath + @"/Resources/PrefabRecord.txt");
#endif
		writer.Write (PrefabRecord);
		writer.Close();
		Debug.Log ("all prefab count:" + prefabCount);
#endif
        //刷新编辑器
        AssetDatabase.Refresh();
        Debug.Log("AssetBundleName清除完毕!");
    }

    static int prefabCount = 0;
    static string PrefabRecord = "";
    static void DoSetAssetBundleName(bool isSetAssetBundleName, string path, string relaPath = "")
    {
        string prefabName = (isSetAssetBundleName ? (isAuto ? midPath[relaPath] : "") + Path.GetFileName(path).Split('.')[0] + ".unity3d" : "");
        StreamReader fs = new StreamReader(path);
        List<string> ret = new List<string>();
        string line;
        bool isExistsAssetBundleNameYet = false;
        string prefabNameLower = prefabName.ToLower();
        if (relDic.Count > 0)
        {
            if (relDic.ContainsKey(prefabNameLower))
            {
                prefabNameLower = relDic[prefabNameLower];
            }
            else
            {
                Debug.LogError(prefabNameLower + ":key not extist");
            }

        }

        if (isClearFlag)
        {
            //Debug.Log("do--" + prefabNameLower);
            prefabNameLower = "";
        }
        //else
        //{
        //    Debug.Log("ffffffffffff");
        //}

        //if (path.Contains (@"ArtResources\Gm\Prefab") || path.Contains ("ArtResources/Gm/Prefab")
        //	|| path.Contains (@"ArtResources\Ui\Prefab") || path.Contains ("ArtResources/Ui/Prefab")) {            

        //} else {
        //	prefabNameLower = "";	
        //}

#if loadbundlecycletest
		if (path.Contains ("Prefab")) {
			PrefabRecord += prefabNameLower + "|";
			prefabCount++;
		}
#endif

        while ((line = fs.ReadLine()) != null)
        {
            line = line.Replace("\n", "");
            if (line.IndexOf("assetBundleName:") != -1)
            {
                line = "  assetBundleName: " + prefabNameLower;
                isExistsAssetBundleNameYet = true;
            }
            ret.Add(line);
        }

        if (!isExistsAssetBundleNameYet)
        {
            ret.Add("  assetBundleName: " + prefabNameLower);
        }

        fs.Close();

        File.Delete(path);

        StreamWriter writer = new StreamWriter(path + ".tmp");
        foreach (var each in ret)
        {
            writer.WriteLine(each);
        }
        writer.Close();

        File.Copy(path + ".tmp", path);
        File.Delete(path + ".tmp");

    }

    public static Dictionary<string, string> relDic = new Dictionary<string, string>();
    /// <summary>
    /// Analyzes the bundle merge.
    /// (3/4):读取生成的bundle文件大小，将小文件的bundleName设置一样的，生成1M的bundle文件
    /// 1MB = 1048576Byte
    /// </summary>
    //[MenuItem("AssetBundles/AnalyzeBundleMerge")]
    public static void AnalyzeBundleMerge()
    {
        relDic = new Dictionary<string, string>();
        string path = Application.dataPath;// "E:/HZ_slua_android/Assets";//Application.dataPath;
        string gmPrefabPath = "";
        string uiPrefabPath = "";
//#if UNITY_STANDALONE_WIN
//		path = path.Replace(@"\Assets", @"\AssetBundles\") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + @"\";
//        gmPrefabPath = path + @"gm\prefab";
//        uiPrefabPath = path + @"ui\prefab";
//#else
        path = path.Replace("/Assets", "/AssetBundles/") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + "/";
        gmPrefabPath = path + "gm/prefab";
        uiPrefabPath = path + "ui/prefab";
//#endif
        string relStr = "";
        relStr = LoadPreVersionRelation();
        //Debug.Log("gmAnalyzedPrefabNames.Count:" + gmAnalyzedPrefabNames.Count);
        //Debug.Log("uiAnalyzedPrefabNames.Count:" + uiAnalyzedPrefabNames.Count);
        //Debug.Log("relDic.Count:" + relDic.Count + "------" + gmDataStartIndex + "--------" + uiDataStartIndex);
       
        
        //Debug.Log(relStr);
//        prefabNames = "";
        relStr += DoAnalyze(gmPrefabPath, true);
//        prefabNames += "|";
        relStr += DoAnalyze(uiPrefabPath, false);
        //Debug.Log(relStr);
        //return;
        Debug.Log("(3.5/4):分析完毕，重设prefab的bundleName...");
        Debug.Log(relDic.Count + ":" + relStr);

        //Directory.Delete(path, true);
        OnSetBundleNameAuto();

        using (FileStream fs = File.Create(path + "AssetBundleNames.txt"))
        {
            using (StreamWriter sw = new StreamWriter(fs))
            {
                sw.Write(relStr);
            }
        }
//不需要了
/*   
        //存储所有的prefabNames
        using (FileStream fs = File.Create(path + "PrefabNames.txt"))
        {
            using (StreamWriter sw = new StreamWriter(fs))
            {
                sw.Write(prefabNames);
            }
        }
        //存储所有的bundleNames
        string bundleNameStr = "";
        for (int i = 1; i < gmBundleNameIndex + 1; i++)
        {
            bundleNameStr += "gm/prefab/data" + i + ".unity3d" + (i == gmBundleNameIndex ? "|" : ",");
        }
        for (int i = 1; i < uiBundleNameIndex + 1; i++)
        {
            bundleNameStr += "ui/prefab/data" + i + ".unity3d" + (i == uiBundleNameIndex ? "" : ",");
        }
        using (FileStream fs = File.Create(path + "BundleNames.txt"))
        {
            using (StreamWriter sw = new StreamWriter(fs))
            {
                sw.Write(bundleNameStr);
            }
        }
*/
        relDic = new Dictionary<string, string>();

        UpdateZiyuanDirBundle();
        Debug.Log("已将bundle拷贝到ziyuan/Usedata内,更新完成!(4/4)" + System.DateTime.Now.ToLongTimeString());
    }

    static List<string> gmAnalyzedPrefabNames = new List<string>();
    static List<string> uiAnalyzedPrefabNames = new List<string>();
    static int gmDataStartIndex = 0;
    static int uiDataStartIndex = 0;
    /// <summary>
    /// 预加载上个版本的prefabName和bundleName对应关系，只有新的pefab才进行Analyze分析，旧prefab对应关系不变
    /// </summary>
    /// <returns></returns>
    private static string LoadPreVersionRelation()
    {
        gmAnalyzedPrefabNames = new List<string>();
        uiAnalyzedPrefabNames = new List<string>();
        gmDataStartIndex = 0;
        uiDataStartIndex = 0;
        string relFilePath = Application.dataPath + "/ziyuan/Usedata/AssetBundleNames.txt";
        if (File.Exists(relFilePath))
        {
            //加载依赖
            string str = "";
            using (FileStream fs = new FileStream(relFilePath, FileMode.Open))
            {
                using (StreamReader sr = new StreamReader(fs))
                {
                    str = sr.ReadToEnd();
                }
            }
            string[] arr = str.Split(new char[] { '|' }, System.StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < arr.Length; i++)
            {
                string[] tempArr = arr[i].Split(',');
#if UNITY_IPHONE 
				relDic.Add(tempArr[0], tempArr[1]);
#else
				relDic.Add(tempArr[0].Replace("/", @"\"), tempArr[1]);
#endif
               
                int curIndex = int.Parse(tempArr[1].Replace("gm/prefab/data", "").Replace(".unity3d", "").Replace("ui/prefab/data", ""));
                if (tempArr[0].Contains("gm/"))
                {
                    gmAnalyzedPrefabNames.Add(tempArr[0]);
                    if (curIndex > gmDataStartIndex)
                    {
                        gmDataStartIndex = curIndex;
                    }
                }
                else
                {
                    uiAnalyzedPrefabNames.Add(tempArr[0]);
                    if (curIndex > uiDataStartIndex)
                    {
                        uiDataStartIndex = curIndex;
                    }
                }
            }

            return str;
        }
        else
        {
            Debug.LogWarning(relFilePath + " 不存在！所有的prefab月bundle对应将重设...");
            return "";
        }
    }

    private static string prefabNames = "";//记录prefab names
    private static int uiBundleNameIndex = 0;
    private static int gmBundleNameIndex = 0;

    private static string DoAnalyze(string bundleDirPath, bool isGm)//, int dataStart
    {
        DirectoryInfo dirInfo = new DirectoryInfo(bundleDirPath);
        FileInfo[] tmpfiles = dirInfo.GetFiles("*.unity3d");
        //Debug.Log(tmpfiles.Length);
        //Debug.Log(isGm ? gmAnalyzedPrefabNames.Count : uiAnalyzedPrefabNames.Count);
        //int tmpCount = tmpfiles.Length - (isGm ? gmAnalyzedPrefabNames.Count : uiAnalyzedPrefabNames.Count);
        //if (tmpCount <= 0)
        //{
        //    return "";
        //}
        //Debug.Log("新增prefab--" + (isGm ? "gm" : "ui") + ":" + tmpCount);
        
        List<string> tmpList = uiAnalyzedPrefabNames;
        if (isGm)
        {
            tmpList = gmAnalyzedPrefabNames;
        }

        List<FileInfo> tmpFileInfoList = new List<FileInfo>();
        for (int i = 0; i < tmpfiles.Length; i++)
        {
            if (!tmpList.Contains((isGm ? "gm":"ui") + "/prefab/" + tmpfiles[i].Name))
            {
                //Debug.Log("tmpfiles[i].Name:" + tmpfiles[i].Name);
                tmpFileInfoList.Add(tmpfiles[i]);
            }
        }
        if (tmpFileInfoList.Count == 0)
        {
            return "";
        }

        FileInfo[] files = tmpFileInfoList.ToArray();
        //Debug.Log(isGm + ":" + files.Length + "_" + files.Length + "_" + newfileIndex + "_" + files[files.Length - 1].Name);

        //文件和大小数组 从大到小排序
        string[] fileNames = new string[files.Length];
        float[] fileSizes = new float[files.Length];
        string preStr = "";
        if (isGm)
        {
#if UNITY_EDITOR_WIN
            preStr = @"gm\prefab\";
#else
			preStr = @"gm/prefab/";
#endif
        }
        else {
#if UNITY_EDITOR_WIN
            preStr = @"ui\prefab\";
#else
			preStr = @"ui/prefab/";
#endif
        }
        for (int i = 0; i < files.Length; i++)
        {
            fileNames[i] = preStr + files[i].Name;
            fileSizes[i] = files[i].Length;
        }

        for (int i = 0; i < fileSizes.Length; i++)
        {
            for (int j = i + 1; j < fileSizes.Length; j++)
            {
                if (fileSizes[j] > fileSizes[i])
                {
                    float temp = fileSizes[j];
                    fileSizes[j] = fileSizes[i];
                    fileSizes[i] = temp;

                    string temp2 = fileNames[j];
                    fileNames[j] = fileNames[i];
                    fileNames[i] = temp2;
                }
            }
        }

        //合并bundle计算，不超过1048576Byte
        int oneMbSize = 1048576;
        int dataIndex = (isGm ? gmDataStartIndex : uiDataStartIndex) + 1;//1;

        for (int i = 0; i < fileSizes.Length; i++)
        {
            if (fileSizes[i] == 0)
            {
                break;
            }

            string sameName = "data" + dataIndex + ".unity3d";
            fileNames[i] += "," + fileNames[i].Replace(Path.GetFileName(fileNames[i]), sameName);

            if (fileSizes[i] < oneMbSize)
            {
                for (int j = files.Length - 1; j > i; j--)
                {
                    if (fileSizes[j] == 0)
                    {
                        continue;
                    }

                    if (fileSizes[i] + fileSizes[j] > oneMbSize)
                    {
                        break;
                    }
                    else {
                        fileNames[j] += "," + fileNames[j].Replace(Path.GetFileName(fileNames[j]), sameName);
                        fileSizes[i] += fileSizes[j];
                        fileSizes[j] = 0;
                    }
                }
            }

            if (isGm)
            {
                gmBundleNameIndex = dataIndex;
            }
            else
            {
                uiBundleNameIndex = dataIndex;
            }

            dataIndex++;
        }
        //gm/prefab/terrain14.unity3d,gm/prefab/data49.unity3d
        string result = "";
        for (int i = 0; i < fileNames.Length; i++)
        {
            result += fileNames[i].Replace(@"\", "/") + "|";
            string[] arr = fileNames[i].Split(',');
            relDic.Add(arr[0], arr[1]);
            prefabNames += Path.GetFileNameWithoutExtension(arr[0].Replace(@"\", "/")) + (i == (fileNames.Length - 1) ? "" : ",");
        }
        return result;
    }

    /// <summary>
    /// Updates the ziyuan dir bundle.
    /// 把生成的bundle拷贝到项目ziyuan/Usedata下的目录中
    /// </summary>
    public static void UpdateZiyuanDirBundle()
    {
        //删除ziyuan\Usedata\gm\prefab ziyuan\Usedata\ui\prefab
        string gmPath = Application.dataPath + "/ziyuan/Usedata/gm/prefab";
        string uiPath = Application.dataPath + "/ziyuan/Usedata/ui/prefab";
        if (Directory.Exists(gmPath))
        {
            //Debug.Log ("del dir=" + gmPath);
            Directory.Delete(gmPath, true);
        }
        if (Directory.Exists(uiPath))
        {
            //Debug.Log ("del dir=" + uiPath);
            Directory.Delete(uiPath, true);
        }

        string path = Application.dataPath;// "E:/HZ_slua_android/Assets";//Application.dataPath;
//#if UNITY_STANDALONE_WIN
//		path = path.Replace(@"\Assets", @"\AssetBundles\") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + @"\";
//#else
        path = path.Replace("/Assets", "/AssetBundles/") + BaseLoader.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget) + "/";
//#endif

        CopyDirctory(path, Application.dataPath + "/ziyuan/Usedata/");

    }

    static void CopyDirctory(string sPath, string tPath)
    {
        CopyFiles(sPath, tPath);

        DirectoryInfo dirInfo = new DirectoryInfo(sPath);
        DirectoryInfo[] subDirs = dirInfo.GetDirectories("*", SearchOption.AllDirectories);
        for (int i = 0; i < subDirs.Length; i++)
        {
            CopyFiles(subDirs[i].FullName.Replace(@"\", "/"), tPath + subDirs[i].FullName.Replace(@"\", "/").Replace(sPath, ""));
        }
    }

    static void CopyFiles(string fromDirPath, string toDirPath)
    {
        //Debug.Log ("CopySubDirFiles---" + fromDirPath + " to " + toDirPath);
        if (!Directory.Exists(toDirPath))
        {
            Directory.CreateDirectory(toDirPath);
        }
        DirectoryInfo dirInfo = new DirectoryInfo(fromDirPath);
        FileInfo[] files = dirInfo.GetFiles();
        //Debug.Log (fromDirPath + " files:" + files.Length);
        for (int i = 0; i < files.Length; i++)
        {
            files[i].CopyTo(toDirPath + "/" + files[i].Name, true);
        }
    }
}