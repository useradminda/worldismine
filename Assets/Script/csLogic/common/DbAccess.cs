using UnityEngine;
using System;
using System.Collections;
using Mono.Data.Sqlite;
using System.IO;
using SLua;

[CustomLuaClass]
public class configDB
{
    private static configDB _ins = null;
    public DbAccess theDB = null;

    public static configDB GetInstance()
    {
        return Ins;
    }
    public static configDB Ins
    {
        get
        {
            if (_ins == null)
            {
                _ins = new configDB();
				// || UNITY_STANDALONE_WIN
#if UNITY_EDITOR
                string fileName = "zqtx_config.db";
                string dirPath = Application.dataPath + "/ziyuan/";
                if (File.Exists(dirPath + "currentDbName.txt"))
                {
                    string dbname = File.ReadAllText(dirPath + "currentDbName.txt");
                    if (File.Exists(dirPath + dbname))
                    {
                        fileName = dbname;
                    }
                }
				string configFilePath = dirPath + fileName;
#else
				string configFilePath = Application.persistentDataPath + "/ZQ/zqtx_config.db";
#endif

                //string configFilePath = Application.temporaryCachePath + "/DHZ/dhz_config.db";
				Debug.LogError ("DB path ="+configFilePath);
                _ins.theDB = new DbAccess("URI=file:" + configFilePath);
            }
            return _ins;
        }
    }

    public string GetMixedConfig(int id)
    {
        string jsonStr = "";
        if (_ins != null)
        {
            SqliteDataReader sqReader = _ins.theDB.ExecuteQuery("SELECT * FROM `mixed_config` WHERE `id`=" + id);
            if (sqReader.Read())
            {
                jsonStr = sqReader.GetString(2);
            }
            else
            {
                Debug.LogError("mixed_config not found. id="+id);
            }
        }

        return jsonStr;
    }

    public void load_preload_configs()
    {

        SqliteDataReader sqReader = theDB.ReadFullTable("buff");
        while (sqReader.Read())
        {
            Debug.LogError(sqReader.GetInt32(0));
        }
    }
}

[CustomLuaClass]
public class DbAccess
{
    private SqliteConnection dbConnection;
    private SqliteCommand dbCommand;
    private SqliteDataReader reader;
    public DbAccess(string connectionString)
    {
        OpenDB(connectionString);
    }
    public DbAccess()
    {
    }

    public void OpenDB(string connectionString)
    {
        try
        {
            dbConnection = new SqliteConnection(connectionString);
            dbConnection.Open();
            Debug.Log("Connected to db");
        }
        catch (Exception e)
        {
            string temp1 = e.ToString();
            Debug.Log(temp1 + connectionString);
        }
    }
    public void CloseSqlConnection()
    {
        if (dbCommand != null)
        {
            //dbCommand.Dispose ();
        }
        dbCommand = null;
        if (reader != null)
        {
            //reader.Dispose ();
        }
        reader = null;
        if (dbConnection != null)
        {
            dbConnection.Close();
        }

        dbConnection = null;
        Debug.Log("Disconnected from db.");
    }
    public SqliteDataReader ExecuteQuery(string sqlQuery)
    {
        SqliteCommand dbCommand1 = dbConnection.CreateCommand();
        dbCommand1.CommandText = sqlQuery;
        if (reader != null)
        {
            //reader.Dispose();
            reader.Close();
            reader = null;
        }
        SqliteDataReader reader1 = dbCommand1.ExecuteReader();
        object ttt = reader1[1];
        //dbCommand1.Dispose();
        dbCommand1 = null;
        return reader1;
    }
    public SqliteDataReader ReadFullTable(string tableName)
    {
        string query = "SELECT * FROM " + tableName;
        return ExecuteQuery(query);
    }

    public System.Object[] GetText(SqliteDataReader _Reader)
    {
        System.Object[] args = new System.Object[_Reader.FieldCount];
        //while(_Reader.Read())
        {
            for (int i = 0; i < _Reader.FieldCount; i++)
            {
                args[i] = _Reader[i];
            }
            return args;
        }
    }

    public SqliteDataReader SelectWhere(string tableName, string[] items, string[] col, string[] operation, string[] values)
    {
        if (col.Length != operation.Length || operation.Length != values.Length)
        {
            //throw new SqliteException ("col.Length != operation.Length != values.Length");
        }

        string query = "SELECT " + items[0];
        for (int i = 1; i < items.Length; ++i)
        {
            query += ", " + items[i];
        }
        query += " FROM " + tableName + " WHERE " + col[0] + operation[0] + "'" + values[0] + "' ";
        for (int i = 1; i < col.Length; ++i)
        {
            query += " AND " + col[i] + operation[i] + "'" + values[0] + "' ";
        }
        return ExecuteQuery(query);
    }
}