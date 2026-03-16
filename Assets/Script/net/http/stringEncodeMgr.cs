using UnityEngine;
using System.Collections;
using System.Text;
using System.Security.Cryptography;
using System.IO;
using System;
public class stringEncodeMgr
{
	private static stringEncodeMgr _ins = null;
	public string key = "2ttRx4$d$cF*#j3o";
	public string s_iv = "1234567812345678";
    public int is_down_jm = 1;
	public static stringEncodeMgr Ins
	{
		get
		{
			if(_ins == null)
			{
				_ins = new stringEncodeMgr();
			}
			return _ins;
		}
	}
	public string Encrypt(string toEncrypt)
	{
		return Encrypt(toEncrypt,key,s_iv);
	}
	public  string Encrypt(string toEncrypt, string key, string iv)
    {
			
        byte[] keyArray = UTF8Encoding.UTF8.GetBytes(key);
        byte[] ivArray = UTF8Encoding.UTF8.GetBytes(iv);
        byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(toEncrypt);

        RijndaelManaged rDel = new RijndaelManaged();
        rDel.Key = keyArray;
        rDel.IV = ivArray;
        rDel.Mode = CipherMode.CBC;
        rDel.Padding = PaddingMode.Zeros;
		//Debug.LogError(iv);
        ICryptoTransform cTransform = rDel.CreateEncryptor();
        byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
		
		byte[] b_iv = UTF8Encoding.UTF8.GetBytes(iv);
		//Debug.LogError("b_iv: " + Convert.ToBase64String(b_iv,0,b_iv.Length));
		//Debug.LogError("resultArray: " + Convert.ToBase64String(resultArray,0,resultArray.Length));
		byte[] tmp = new byte[b_iv.Length+resultArray.Length];
	
	   	b_iv.CopyTo(tmp,0);
		resultArray.CopyTo(tmp,b_iv.Length);
		//Array.Copy(resultArray,0,tmp,b_iv.Length,resultArray.Length);
		
		
		//Debug.LogError(Convert.ToBase64String(tmp, 0, tmp.Length));
        return Convert.ToBase64String(tmp, 0, tmp.Length);
		//return Convert.ToString(resultArray);
    }
    public string Decrypt(string toDecrypt)
    {
        if(toDecrypt == "")
        {
            return "";
        }
        return Decrypt(toDecrypt, key, s_iv);
    }
	public  string Decrypt(string toDecrypt, string key, string iv)
    {
        byte[] keyArray = UTF8Encoding.UTF8.GetBytes(key);
        byte[] ivArray = new byte[16];//UTF8Encoding.UTF8.GetBytes(iv);
       // byte[] toDecryptArray = UTF8Encoding.UTF8.GetBytes(toDecrypt);
        byte[] toDecryptArray1 = Convert.FromBase64String(toDecrypt);
        byte[] toDecryptArray = new byte[toDecryptArray1.Length - 16];

        //toDecryptArray1.CopyTo(toDecryptArray,15);
        Array.Copy(toDecryptArray1, 16, toDecryptArray, 0, toDecryptArray.Length);
        Array.Copy(toDecryptArray1, 0, ivArray, 0, 16);
        RijndaelManaged rDel = new RijndaelManaged();
        rDel.Key = keyArray;
        rDel.IV = ivArray;
        rDel.Mode = CipherMode.CBC;
        rDel.Padding = PaddingMode.Zeros;
        //string plaintext = "";
        //ICryptoTransform decryptor = rDel.CreateDecryptor(rDel.Key, rDel.IV);
        //using (MemoryStream msDecrypt = new MemoryStream(toDecryptArray))
        //{
        //    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
        //    {
        //        using (StreamReader srDecrypt = new StreamReader(csDecrypt))
        //        {

        //            // Read the decrypted bytes from the decrypting stream   
        //            // and place them in a string.  
        //            plaintext = srDecrypt.ReadToEnd();
        //        }
        //    }
        //}
        //return plaintext;

        ICryptoTransform cTransform = rDel.CreateDecryptor(rDel.Key, rDel.IV);
        byte[] resultArray = cTransform.TransformFinalBlock(toDecryptArray, 0, toDecryptArray.Length);

        return UTF8Encoding.UTF8.GetString(resultArray);
        //string s = Convert.ToString(utf8);
       // return s;
       
    }
	
}

