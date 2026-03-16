using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
 

namespace gotye
{
    public class FileUtil
    {
        public static byte[] getBytes(string path) {
           
            if(StringUtil.isEmpty(path)){
                return null;
            }
            if(!File.Exists(path)){
                return null;
            }
            FileStream stream = new FileInfo(path).OpenRead();
            Byte[] buffer = new Byte[stream.Length];
            //从流中读取字节块并将该数据写入给定缓冲区buffer中
            stream.Read(buffer, 0, Convert.ToInt32(stream.Length));
            stream.Close();
            return buffer;
        }

    }
}
