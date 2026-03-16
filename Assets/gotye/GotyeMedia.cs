
using System;
using System.Collections;
using System.Runtime.InteropServices;
using gotyejson;
namespace gotye
{
	/// <summary>
	/// 多媒体类型.
	/// </summary>
    public enum GotyeMediaType
    {
        /// <summary>
        /// 文本类型
        /// </summary>
        Text=0,
        /// <summary>
    /// 图片
    /// </summary>
        Image = 1, 
		/// <summary>
		/// 语音消息
		/// </summary>
        Audio,
		/// <summary>
		///用户自定义数据
		/// </summary>
		UserData,
    };    
	/// <summary>
	/// 多媒体（图片和语音）数据载体
	/// </summary>
    public class GotyeMedia
    {
		/// <summary>
		/// 多媒体（图片和语音）
		/// </summary>
		/// <value>The type.</value>
		public GotyeMediaType Type { get; set; }

		/// <summary>
		/// 语音消息时长(ms)
		/// </summary>
		/// <value>The duration.</value>
		public int Duration { get; set; }
       /// <summary>
       /// 图片URL
       /// </summary>
       /// <value>The URL.</value>
		public string Url { get; set; }
		/// <summary>
		/// 本地文件路径
		/// </summary>
		/// <value>The path.</value>
		public string Path { get; set; }
		/// <summary>
		/// 本地文件路径
		/// </summary>
		/// <value>The path.</value>
		public string PathEx { get; set; }

		public GotyeMediaStatus Status{ get; set;}
		/// <summary>
		/// 根据类型创建多媒体
		/// </summary>
		/// <param name="type">Type.</param>
        public GotyeMedia(GotyeMediaType type)
        {
			this.Type = type;
        }

		public GotyeMedia()
		{
			this.Type = GotyeMediaType.Image;
		}

		/// <summary>
		/// 根据类型和数据内容创建多媒体消息载体
		/// </summary>
		/// <param name="type">媒体类型</param>
		/// <param name="path">图片缩略图路径或者语音文件路径</param>
		/// <param name="pathEx">图片完整尺寸文件路径</param>
        public GotyeMedia(GotyeMediaType type, string path, string pathEx)
        {
			this.Type = type;
			Path = path;
            PathEx = pathEx;
        }

       
        public static GotyeMedia jsonToMedia(GotyeJsonData obj)
        {
             int type = (int)obj["type"];
             string pathEx = null; ;

             if (obj.ContainsKey("path_ex"))
                 pathEx = (string)obj["path_ex"];
           
             string path=(string)obj["path"];
             GotyeMedia media=new GotyeMedia((GotyeMediaType)type,path,pathEx);
            
             if (obj.ContainsKey("url"))
                media.Url = (string)obj["url"];

             if (obj.ContainsKey("duration"))
                 media.Duration = (int)obj["duration"];

             if (obj.ContainsKey("status"))
				media.Status = (GotyeMediaStatus)(int)obj["status"]; 

            return media;
        }
        public static GotyeMedia jsonToIcon(GotyeJsonData obj)
        {
            
            string pathEx = (string)obj["path_ex"];
            string path = (string)obj["path"];
            string url = (string)obj["url"];
            GotyeMedia media = new GotyeMedia(GotyeMediaType.Image, path, pathEx);
            media.Url = url;
            return media;
        }
	
	
    }
}
