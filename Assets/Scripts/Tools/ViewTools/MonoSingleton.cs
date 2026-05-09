using UnityEngine;
// mono单例工具
namespace ZTools
{
    public class MonoSingleton<T> : MonoBehaviour where T : Component
    {
        private static T _instance = null;
        private static object status = new object();

        public static T Instance
        {
            get
            {
                lock (status)
                {
                    if (_instance == null) { _instance = FindObjectOfType<T>(); }
                    if (_instance == null) { _instance = new GameObject(typeof(T).Name).AddComponent<T>(); DontDestroyOnLoad(_instance.gameObject); }
                    return _instance;
                }
            }
        }
    }
}