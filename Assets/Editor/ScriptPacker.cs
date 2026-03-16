using UnityEngine;
using UnityEditor;
using System;  
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Security.Cryptography;


public class ScriptPacker : EditorWindow
{
    [MenuItem("Tools/打包")]
    static void Pack()
    {
        //Debug.Log("BuildAssetBundles");
        //AssetbundlesMenuItems.BuildAssetBundles();
        //Debug.Log("SetBundleNameAuto");
        //SetAssetBundleName.OnSetBundleNameAuto();
        Init();
    }
	static string DBname = "zqtx_config.db";
    private static void Init()
    {
        savePathBase = EUtil.CombinePath(Application.dataPath, "..", "VersionBackup");
        fileDir = EUtil.CombinePath(Application.dataPath, "ziyuan");
        configPath = EUtil.CombinePath(Application.dataPath, "streamingAssets", "GameConfig.lua");

        if (LoadGameConfig() == false)
        {
            Debug.LogError("Can not find \"GameConfig.lua\".");
            return;
        }

        ScriptPacker window = (ScriptPacker)ScriptPacker.GetWindow(typeof (ScriptPacker));
        window.Show();
        window.position = new Rect(20, 80, 800, 600);
        CheckLatestVersion();
    }

    void OnGUI()
    {
        GUI.Label(new Rect(20, 20, 70, 20), "Server :");
        GUI.Label(new Rect(20, 50, 70, 20), "Language :");
        GUI.Label(new Rect(20, 80, 70, 20), "Channel :");
        GUI.Label(new Rect(20, 110, 70, 20), "Version :");

        server = GUI.TextField(new Rect(100, 20, 200, 20), server, 50);
        language = GUI.TextField(new Rect(100, 50, 200, 20), language, 15);
        channel = GUI.TextField(new Rect(100, 80, 200, 20), channel, 15);
        version = GUI.TextField(new Rect(100, 110, 200, 20), version, 15);

        if (GUI.Button(new Rect(100, 140, 70, 20), "Generate"))
        {
            if (version == latestVersion)
            {
                Debug.LogError("Current version is same as latest version!");
                return;
            }

            savePath = EUtil.CombinePath(savePathBase, channel, language, version);
            CopyDiffFiles(fileDir);
            CopyDB();
            SaveGameConfig();
            SaveVersionRecord();
            EUtil.DeleteEmptyDir(EUtil.CombinePath(savePath, "patch"));
            ZipDir();
            Debug.Log("Packing is finished. files are stored in " + savePath);
            System.Diagnostics.Process.Start("explorer.exe", savePath);

            ScriptPacker window = (ScriptPacker)ScriptPacker.GetWindow(typeof (ScriptPacker));
            window.Close();
        }
    }

    private static void CheckLatestVersion()
    {
        latestVersion = "0.0.0.0";
        string versionPath = EUtil.CombinePath(savePathBase, channel, language);
        if (Directory.Exists(versionPath))
        {
            if (Directory.GetDirectories(versionPath).Length > 0)
            {
                int vi = 0;
                foreach (string path in Directory.GetDirectories(versionPath))
                {
                    string v = System.IO.Path.GetFileName(path);
                    string[] tmp = v.Split('.');
                    if (tmp.Length != 4)
                    {
                        continue;
                    }

                    int ci = 0;
                    foreach (string s in tmp)
                    {
                        ci = System.Convert.ToInt32(s) + ci * 100;
                    }
                    if (ci > vi)
                    {
                        vi = ci;
                        latestVersion = v;
                    }
                }
            }
        }
        else
        {
            Directory.CreateDirectory(versionPath);
        }

        Debug.Log("latest version is " + latestVersion);
    }

    private static void ZipDir()
    {
        string folderToZip = EUtil.CombinePath(savePath, "full");
        string zipedFile = EUtil.CombinePath(savePath, "InstallZiyuan.zip");
        ZipHelper.ZipDirectory(folderToZip, zipedFile);

        string destinationPath = EUtil.CombinePath(Application.dataPath, "streamingAssets", "InstallZiyuan.zip");
        if (File.Exists(destinationPath))
        {
            File.Delete(destinationPath);
            Debug.Log("Remove \"" + Path.GetFileName(destinationPath) + "\"");
        }
        File.Move(zipedFile, destinationPath);
        Debug.Log("\"" + Path.GetFileName(destinationPath) + "\" has been Copied to streamingAssets folder.");

        folderToZip = EUtil.CombinePath(savePath, "patch");
        zipedFile = EUtil.CombinePath(savePath, version + ".zip");
        ZipHelper.ZipDirectory(folderToZip, zipedFile);
        Directory.Delete(folderToZip, true);
    }

    private static string GetFullZipFileName()
    {
        return channel + "_" + language + "_v" + version + "_full.zip";
    }

    private static void CopyDB()
    {
		string fileName = DBname;
        string txtPath = EUtil.CombinePath(fileDir, "currentDbName.txt");
        if (File.Exists(txtPath))
        {
            string dbname = File.ReadAllText(txtPath);
            if (File.Exists(EUtil.CombinePath(fileDir, dbname)))
            {
                fileName = dbname;
            }
        }
        string configFilePath = EUtil.CombinePath(fileDir, fileName);

		string patchDbPath = EUtil.CombinePath(savePath, "patch", DBname);
		string fullDbPath = EUtil.CombinePath(savePath, "full", DBname);

        string latestDbPath = GetLatestFilePath(configFilePath);
        if (EUtil.CompareFile(configFilePath, latestDbPath) == false)
        {
            File.Copy(configFilePath, patchDbPath);
        }

        File.Copy(configFilePath, fullDbPath);
    }


    private static void CopyDiffFiles(string dirPath)
    {
        string patchDirPrefix = EUtil.CombinePath(savePath, "patch");
        string patchdir = dirPath.Replace(fileDir, patchDirPrefix);
        if (Directory.Exists(patchdir))
        {
            Directory.Delete(patchdir, true);
        }
        Directory.CreateDirectory(patchdir);

        string fullDirPrefix = EUtil.CombinePath(savePath, "full");
        string fulldir = dirPath.Replace(fileDir, fullDirPrefix);
        if (Directory.Exists(fulldir))
        {
            Directory.Delete(fulldir, true);
        }
        Directory.CreateDirectory(fulldir);

        foreach (string path in Directory.GetFiles(dirPath))
        {
            if (System.IO.Path.GetExtension(path) == ".meta")
            {
                continue;
            }
            else if (System.IO.Path.GetExtension(path) == ".docx")
            {
                continue;
            }
            else if (System.IO.Path.GetExtension(path) == ".db")
            {
                continue;
            }

            string latestFilePath = GetLatestFilePath(path);
            if (EUtil.CompareFile(latestFilePath, path) == false)
            {
                File.Copy(path, path.Replace(fileDir, patchDirPrefix));
            }

            File.Copy(path, path.Replace(fileDir, fullDirPrefix));
        }

        if (Directory.GetDirectories(dirPath).Length > 0)
        {
            foreach (string path in Directory.GetDirectories(dirPath))
            {
                CopyDiffFiles(path);
            }
        }
    }

    private static string GetLatestFilePath(string currentPath)
    {
        string latestFullPath = EUtil.CombinePath(savePathBase, channel, language, latestVersion, "full");
        return currentPath.Replace(fileDir, latestFullPath);
    }

    private static bool LoadGameConfig()
    {
        if (File.Exists(configPath) == false)
        {
            return false;
        }

        string txt = File.ReadAllText(configPath);
        string[] tmp = txt.Split(new char[2]{'\r','\n'});
        for (int i = 0; i < tmp.Length; i++ )
        {
            string line = Regex.Replace(tmp[i].Trim(), "[\" ;]", "");
            string[] ctt = line.Split('=');
            switch (ctt[0])
            {
                case "GameName":
                    gameName = ctt[1];
                    break;
                case "ChannelName":
                    channel= ctt[1];
                    break;
                case "Language":
                    language= ctt[1];
                    break;
                case "MyVer":
                    version = ctt[1];
                    break;
                case "UpDataSer":
                    server = ctt[1];
                    break;
                default:
                    break;
            }
        }

        version = latestVersion;

#if UNITY_ANDROID
        channel = "Android";
#endif

#if UNITY_IPHONE
	        channel = "App";
#endif

#if UNITY_STANDALONE_WIN
	        channel = "Pc";
#endif


        return true;
    }

    private static void SaveGameConfig()
    {
        string str = "GameConfig = {\r\n"
            + " GameName = \"" + gameName + "\";\r\n"
            + " ChannelName = \"" + channel + "\";\r\n"
            + " Language = \"" + language + "\";\r\n"
            + " UpDataSer = \"" + server + "\";\r\n"
            + " MyVer = \"" + version + "\";\r\n"
            + "}\r\n"
            + "return GameConfig;\r\n";

        File.WriteAllText(configPath, str);
        File.Copy(configPath, EUtil.CombinePath(savePath, "full", "GameConfig.lua"), true);
        File.Copy(configPath, EUtil.CombinePath(savePath, "patch", "GameConfig.lua"), true);
        //if (channel != "Android")
            File.Copy(configPath, EUtil.CombinePath(fileDir, "GameConfig.lua"), true);

        Debug.Log("GameConfig.lua has been Saved.");
    }

    private static void SaveVersionRecord()
    {
        string sourcePath = EUtil.CombinePath(savePath, "full", "VersionRecord.txt");
        string str = "{\"NowVer\":\"" + version + "\",\"TarVer\":\"" + version + "\",\"UpState\":\"-1\",\"UpProgress\":\"-1\"}";
        File.WriteAllText(sourcePath, str);

        File.Copy(sourcePath, EUtil.CombinePath(Application.dataPath, "streamingAssets", "VersionRecord.txt"), true);
        File.Copy(sourcePath, EUtil.CombinePath(savePath, "patch", "VersionRecord.txt"), true);
        //if (channel != "Android")
            File.Copy(sourcePath, EUtil.CombinePath(fileDir, "VersionRecord.txt"), true);
    }

    private static string gameName = "";
    private static string channel = "";
    private static string version = "";
    private static string language = "";
    private static string server = "";
    private static string latestVersion = "0.0.0.0";

    private static string savePath = "";
    private static string savePathBase = "";
    private static string fileDir = "";
    private static string configPath = "";
}