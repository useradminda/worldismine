using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections;
using System.Collections.Generic;

public class down_db  : EditorWindow
{

    private static string configDirPath = "";

	WWW w = null;
    bool finishDownload = false;

	[MenuItem("Tools/下载数据库")]  
	static void down_DB()  
	{  
        configDirPath = Application.dataPath + "/ziyuan/";
        configDirPath = configDirPath.Replace("\\", "/");

		down_db window = (down_db) down_db.GetWindow( typeof( down_db ) );
		window.Show();
		window.position = new Rect( 20, 80, 100, 50 );
	}  

	// Use this for initialization
	void Start ()
	{
		Debug.LogError("start....");
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (w == null)
		{
			w = new WWW("http://114.215.92.238:10500/phpLiteAdmin/configs/zqtx_config.db?" + System.DateTime.Now.ToString("MMddHHmmss"));
			Debug.LogError("start....");
		}
		if(!finishDownload && (w != null) && (w.isDone))
		{
            finishDownload = true;
            down_db window = (down_db) down_db.GetWindow( typeof( down_db ) );
            window.Close();

            foreach (string path in Directory.GetFiles(configDirPath))
            {
                if (System.IO.Path.GetExtension(path) == ".db")
                {
                    if (System.IO.Path.GetFileName(path) != "zqtx_config.db")
                    {
                        try
                        {
                            File.Delete(path);
                        }
                        catch(System.IO.IOException e)
                        {
                            Debug.LogError(e.ToString());
                        }
                    }
                }
            }

			byte[]model = w.bytes;
			int length = model.Length;
			Debug.LogError("文件长度： "+ length);

			//写入模型到本地
			//CreateModelFile(Application.persistentDataPath,"Model.assetbundle",model,length);
            string filename = "zqtx_config" + System.DateTime.Now.ToString("MMddHHmmss") + ".db";
            Debug.LogError("文件名为：" + filename);
            try
            {

			    File.WriteAllBytes(configDirPath + filename, model);
                File.WriteAllText(configDirPath + "currentDbName.txt", filename);
            }
            catch(System.IO.IOException e)
            {
                Debug.LogError(e);
            }
			Debug.LogError("数据库下载完毕");
		}
	}
}

