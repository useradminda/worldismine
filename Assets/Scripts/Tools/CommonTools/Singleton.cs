// 数据结构对象单例工具
namespace ZTools
{
    public abstract class Singleton<T> where T : class, new()
    {
        protected static T _inst;

        public static T Instance
        {
            get
            {
                if (null == _inst)
                {
                    _inst = new T();
                }

                return _inst;
            }
        }
    }
}