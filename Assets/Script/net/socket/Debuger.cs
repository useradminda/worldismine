using UnityEngine;
using System.Collections;
using SLua;
namespace DotNetClient
{
    [CustomLuaClass]
    public class Debuger
    {

        static public bool enableLog = false;
        static public void EnableLog()
        {
            enableLog = true;
        }
        static public void DisableLog()
        {
            enableLog = false;
        }

        static public void Log(object message)
        {
            Log(message, null);
        }
        static public void Log(object message, Object context)
        {
            if (enableLog)
            {
                Debug.Log(message, context);
            }
        }
        static public void LogError(object message)
        {
            LogError(message, null);
        }
        static public void LogError(object message, Object context)
        {
            if (enableLog)
            {
                Debug.LogError(message, context);
            }
        }
        static public void LogWarning(object message)
        {
            LogWarning(message, null);
        }
        static public void LogWarning(object message, Object context)
        {
            if (enableLog)
            {
                Debug.LogWarning(message, context);
            }
        }
    }
}
