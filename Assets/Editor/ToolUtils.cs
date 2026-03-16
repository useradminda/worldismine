using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using ICSharpCode.SharpZipLib;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Checksums;
using UnityEngine;
using UnityEditor;


public class EUtil
{
    public static void DeleteEmptyDir(string path)
    {
        string[] dirs = Directory.GetDirectories(path);
        for (int i = 0; i < dirs.Length; i++)
        {
            DeleteEmptyDir(dirs[i]);
        }
        try
        {
            Directory.Delete(path);
        }
        catch (Exception e)
        {
            Debug.LogError(e.ToString());
        }
    }

    public static string CombinePath(params string[] values)
    {
        string path = "";
        for (int i=0; i < values.Length; i++)
        {
            path += values[i].TrimEnd(new char[] { '/', '\\' }) + Path.DirectorySeparatorChar;
        }

        return Path.GetFullPath(path).TrimEnd(new char[] {Path.DirectorySeparatorChar});
    }

    public static bool CompareFile(string p1, string p2)
    {
        if (File.Exists(p1) == false || File.Exists(p2) == false)
        {
            return false;
        }
        else if (GetMD5HashFromFile(p1) != GetMD5HashFromFile(p2))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public static string GetMD5HashFromFile(string fileName)
    {
        try
        {
            FileStream file = new FileStream(fileName, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(file);
            file.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("GetMD5HashFromFile() fail,error:" + ex.Message);
        }
    }
}
    
    /// <summary> 
    /// 适用与ZIP压缩 
    /// </summary> 
    public class ZipHelper
    {

        private static string _dirSepChar = "/";
        private static string _folderToZipRoot = "";

        /// <summary> 
        /// 递归压缩文件夹的内部方法 
        /// </summary> 
        /// <param name="folderToZip">要压缩的文件夹路径</param> 
        /// <param name="zipStream">压缩输出流</param> 
        /// <param name="parentFolderName">此文件夹的上级文件夹</param> 
        /// <returns></returns> 
        private static bool ZipDirectory(string folderToZip, ZipOutputStream zipStream, string parentFolderName)
        {
            string currentFolder;
            if (parentFolderName == "")
            {
                currentFolder = "." + _dirSepChar;
            }
            else
            {
                currentFolder = "." + _dirSepChar + folderToZip.Replace(_folderToZipRoot, "").Replace("\\", _dirSepChar).TrimEnd(new char[] { '/', '\\' }) + _dirSepChar;
            }

            bool result = true;
            string[] folders, files;
            ZipEntry ent = null;
            FileStream fs = null;
            Crc32 crc = new Crc32();

            try
            {
                ent = new ZipEntry(currentFolder);
                zipStream.PutNextEntry(ent);
                zipStream.Flush();

                files = Directory.GetFiles(folderToZip);
                foreach (string file in files)
                {
                    fs = File.OpenRead(file);

                    byte[] buffer = new byte[fs.Length];
                    fs.Read(buffer, 0, buffer.Length);
                    ent = new ZipEntry(currentFolder + Path.GetFileName(file));
                    ent.DateTime = DateTime.Now;
                    ent.Size = fs.Length;

                    fs.Close();

                    crc.Reset();
                    crc.Update(buffer);

                    ent.Crc = crc.Value;
                    zipStream.PutNextEntry(ent);
                    zipStream.Write(buffer, 0, buffer.Length);
                }

            }
            catch
            {
                result = false;
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                    fs.Dispose();
                }
                if (ent != null)
                {
                    ent = null;
                }
                GC.Collect();
                GC.Collect(1);
            }

            folders = Directory.GetDirectories(folderToZip);
            foreach (string folder in folders)
                if (!ZipDirectory(folder, zipStream, folderToZip))
                    return false;

            return result;
        }

        /// <summary> 
        /// 压缩文件夹  
        /// </summary> 
        /// <param name="folderToZip">要压缩的文件夹路径</param> 
        /// <param name="zipedFile">压缩文件完整路径</param> 
        /// <param name="password">密码</param> 
        /// <returns>是否压缩成功</returns> 
        public static bool ZipDirectory(string folderToZip, string zipedFile, string password)
        {
            bool result = false;
            if (!Directory.Exists(folderToZip))
                return result;

            ZipOutputStream zipStream = new ZipOutputStream(File.Create(zipedFile));
            zipStream.SetLevel(6);
            if (!string.IsNullOrEmpty(password)) zipStream.Password = password;

            result = ZipDirectory(folderToZip, zipStream, "");

            zipStream.Finish();
            zipStream.Close();

            return result;
        }

        /// <summary> 
        /// 压缩文件夹 
        /// </summary> 
        /// <param name="folderToZip">要压缩的文件夹路径</param> 
        /// <param name="zipedFile">压缩文件完整路径</param> 
        /// <returns>是否压缩成功</returns> 
        public static bool ZipDirectory(string folderToZip, string zipedFile)
        {
            //_folderToZipRoot = folderToZip.TrimEnd(new char[]{'\\', '/'}) + Path.DirectorySeparatorChar;
            _folderToZipRoot = folderToZip.TrimEnd(new char[]{'\\', '/'}) + Path.DirectorySeparatorChar;
            bool result = ZipDirectory(folderToZip, zipedFile, null);
            return result;
        }

        /// <summary> 
        /// 压缩文件 
        /// </summary> 
        /// <param name="fileToZip">要压缩的文件全名</param> 
        /// <param name="zipedFile">压缩后的文件名</param> 
        /// <param name="password">密码</param> 
        /// <returns>压缩结果</returns> 
        public static bool ZipFile(string fileToZip, string zipedFile, string password)
        {
            bool result = true;
            ZipOutputStream zipStream = null;
            FileStream fs = null;
            ZipEntry ent = null;

            if (!File.Exists(fileToZip))
                return false;

            try
            {
                fs = File.OpenRead(fileToZip);
                byte[] buffer = new byte[fs.Length];
                fs.Read(buffer, 0, buffer.Length);
                fs.Close();

                fs = File.Create(zipedFile);
                zipStream = new ZipOutputStream(fs);
                if (!string.IsNullOrEmpty(password)) zipStream.Password = password;
                ent = new ZipEntry(Path.GetFileName(fileToZip));
                zipStream.PutNextEntry(ent);
                zipStream.SetLevel(6);

                zipStream.Write(buffer, 0, buffer.Length);

            }
            catch
            {
                result = false;
            }
            finally
            {
                if (zipStream != null)
                {
                    zipStream.Finish();
                    zipStream.Close();
                }
                if (ent != null)
                {
                    ent = null;
                }
                if (fs != null)
                {
                    fs.Close();
                    fs.Dispose();
                }
            }
            GC.Collect();
            GC.Collect(1);

            return result;
        }

        /// <summary> 
        /// 压缩文件 
        /// </summary> 
        /// <param name="fileToZip">要压缩的文件全名</param> 
        /// <param name="zipedFile">压缩后的文件名</param> 
        /// <returns>压缩结果</returns> 
        public static bool ZipFile(string fileToZip, string zipedFile)
        {
            bool result = ZipFile(fileToZip, zipedFile, null);
            return result;
        }

        /// <summary> 
        /// 压缩文件或文件夹 
        /// </summary> 
        /// <param name="fileToZip">要压缩的路径</param> 
        /// <param name="zipedFile">压缩后的文件名</param> 
        /// <param name="password">密码</param> 
        /// <returns>压缩结果</returns> 
        public static bool Zip(string fileToZip, string zipedFile, string password)
        {
            bool result = false;
            if (Directory.Exists(fileToZip))
                result = ZipDirectory(fileToZip, zipedFile, password);
            else if (File.Exists(fileToZip))
                result = ZipFile(fileToZip, zipedFile, password);

            return result;
        }

        /// <summary> 
        /// 压缩文件或文件夹 
        /// </summary> 
        /// <param name="fileToZip">要压缩的路径</param> 
        /// <param name="zipedFile">压缩后的文件名</param> 
        /// <returns>压缩结果</returns> 
        public static bool Zip(string fileToZip, string zipedFile)
        {
            bool result = Zip(fileToZip, zipedFile, null);
            return result;

        }
    }