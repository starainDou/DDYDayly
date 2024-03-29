> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [www.blinkedu.cn](https://www.blinkedu.cn/index.php/2020/12/10/unity%E4%B8%AD%E4%BD%BF%E7%94%A8aes%E5%8A%A0%E5%AF%86%E6%96%B9%E5%BC%8F%E8%BF%9B%E8%A1%8Cassetbundle%E5%8A%A0%E5%AF%86/)

> 为什么要对 AssetBundle 进行加密 防止资源被破解 加密算法 因为对 AB 包进行加密后还需要再加载 AB 包时进行解密，所以选择 AES 加密方式。

为什么要对 AssetBundle 进行加密
----------------------

防止资源被破解

加密算法
----

因为对 AB 包进行加密后还需要再加载 AB 包时进行解密，所以选择 AES 加密方式。AES 是对称加密算法，在加密时会设定一个密钥，通过该密钥进行加密。在游戏运行过程中加载 AB 包时，先使用同样的密钥对其进行解密，然后再加载 AB 包。

*   为了识别文件是否已经被加密过（防止多次加密）。需要定一个文件的识别头（这里设置的”AESEncrypt”），在加密时会将这个头写入到文件的头部，当加密时读取最前面的和识别头相等长度的字节与识别头进行比较，如果相等则表示加密过，否则就进行加密。
*   进行解密时，需要将识别字节头给移除再进行解密

下面是进行 AES 加密的脚本代码，具体原理网上有很多讲解（我也是搬运过来的 2333333…）

```
using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;
public class AES
{
    
    private const string AES_HEAD = "AESEncrypt";

    
    
    
    
    
    public static void AESFileEncrypt(string path, string EncrptyKey)
    {
        if (!File.Exists(path))
            return;
        try
        {
            using (FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite))
            {
                if (fs != null)
                {
                    
                    byte[] headBuff = new byte[10];
                    fs.Read(headBuff, 0, headBuff.Length);
                    string headTag = Encoding.UTF8.GetString(headBuff);
                    if (headTag == AES_HEAD)
                    {
#if UNITY_EDITOR
                        Debug.Log(path + "已经加密过了！");
#endif
                        return;
                    }
                    
                    fs.Seek(0, SeekOrigin.Begin);
                    byte[] buffer = new byte[fs.Length];
                    fs.Read(buffer, 0, Convert.ToInt32(fs.Length));
                    fs.Seek(0, SeekOrigin.Begin);
                    fs.SetLength(0);
                    byte[] headBuffer = Encoding.UTF8.GetBytes(AES_HEAD);
                    fs.Write(headBuffer, 0, headBuffer.Length);
                    byte[] EncBuffer = AESEncrypt(buffer, EncrptyKey);
                    fs.Write(EncBuffer, 0, EncBuffer.Length);
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogError(e);
        }
    }

    
    
    
    
    
    public static void AESFileDecrypt(string path, string EncrptyKey)
    {
        if (!File.Exists(path))
        {
            return;
        }
        try
        {
            using (FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite))
            {
                if (fs != null)
                {
                    byte[] headBuff = new byte[10];
                    fs.Read(headBuff, 0, headBuff.Length);
                    string headTag = Encoding.UTF8.GetString(headBuff);
                    if (headTag == AES_HEAD)
                    {
                        byte[] buffer = new byte[fs.Length - headBuff.Length];
                        fs.Read(buffer, 0, Convert.ToInt32(fs.Length - headBuff.Length));
                        fs.Seek(0, SeekOrigin.Begin);
                        fs.SetLength(0);
                        byte[] DecBuffer = AESDecrypt(buffer, EncrptyKey);
                        fs.Write(DecBuffer, 0, DecBuffer.Length);
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogError(e);
        }
    }

    
    
    
    
    public static byte[] AESFileByteDecrypt(string path, string EncrptyKey)
    {
        if (!File.Exists(path))
        {
            return null;
        }
        byte[] DecBuffer = null;
        try
        {
            using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                if (fs != null)
                {
                    byte[] headBuff = new byte[10];
                    fs.Read(headBuff, 0, headBuff.Length);
                    string headTag = Encoding.UTF8.GetString(headBuff);
                    if (headTag == AES_HEAD)
                    {
                        byte[] buffer = new byte[fs.Length - headBuff.Length];
                        fs.Read(buffer, 0, Convert.ToInt32(fs.Length - headBuff.Length));
                        DecBuffer = AESDecrypt(buffer, EncrptyKey);
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogError(e);
        }

        return DecBuffer;
    }

    
    
    
    
    
    public static string AESEncrypt(string EncryptString, string EncryptKey)
    {
        return Convert.ToBase64String(AESEncrypt(Encoding.Default.GetBytes(EncryptString), EncryptKey));
    }

    
    
    
    
    
    public static byte[] AESEncrypt(byte[] EncryptByte, string EncryptKey)
    {
        if (EncryptByte.Length == 0) { throw (new Exception("明文不得为空")); }
        if (string.IsNullOrEmpty(EncryptKey)) { throw (new Exception("密钥不得为空")); }
        byte[] m_strEncrypt;
        byte[] m_btIV = Convert.FromBase64String("Rkb4jvUy/ye7Cd7k89QQgQ==");
        byte[] m_salt = Convert.FromBase64String("gsf4jvkyhye5/d7k8OrLgM==");
        Rijndael m_AESProvider = Rijndael.Create();
        try
        {
            MemoryStream m_stream = new MemoryStream();
            PasswordDeriveBytes pdb = new PasswordDeriveBytes(EncryptKey, m_salt);
            ICryptoTransform transform = m_AESProvider.CreateEncryptor(pdb.GetBytes(32), m_btIV);
            CryptoStream m_csstream = new CryptoStream(m_stream, transform, CryptoStreamMode.Write);
            m_csstream.Write(EncryptByte, 0, EncryptByte.Length);
            m_csstream.FlushFinalBlock();
            m_strEncrypt = m_stream.ToArray();
            m_stream.Close(); m_stream.Dispose();
            m_csstream.Close(); m_csstream.Dispose();
        }
        catch (IOException ex) { throw ex; }
        catch (CryptographicException ex) { throw ex; }
        catch (ArgumentException ex) { throw ex; }
        catch (Exception ex) { throw ex; }
        finally { m_AESProvider.Clear(); }
        return m_strEncrypt;
    }


    
    
    
    
    
    public static string AESDecrypt(string DecryptString, string DecryptKey)
    {
        return Convert.ToBase64String(AESDecrypt(Encoding.Default.GetBytes(DecryptString), DecryptKey));
    }

    
    
    
    
    
    public static byte[] AESDecrypt(byte[] DecryptByte, string DecryptKey)
    {
        if (DecryptByte.Length == 0) { throw (new Exception("密文不得为空")); }
        if (string.IsNullOrEmpty(DecryptKey)) { throw (new Exception("密钥不得为空")); }
        byte[] m_strDecrypt;
        byte[] m_btIV = Convert.FromBase64String("Rkb4jvUy/ye7Cd7k89QQgQ==");
        byte[] m_salt = Convert.FromBase64String("gsf4jvkyhye5/d7k8OrLgM==");
        Rijndael m_AESProvider = Rijndael.Create();
        try
        {
            MemoryStream m_stream = new MemoryStream();
            PasswordDeriveBytes pdb = new PasswordDeriveBytes(DecryptKey, m_salt);
            ICryptoTransform transform = m_AESProvider.CreateDecryptor(pdb.GetBytes(32), m_btIV);
            CryptoStream m_csstream = new CryptoStream(m_stream, transform, CryptoStreamMode.Write);
            m_csstream.Write(DecryptByte, 0, DecryptByte.Length);
            m_csstream.FlushFinalBlock();
            m_strDecrypt = m_stream.ToArray();
            m_stream.Close(); m_stream.Dispose();
            m_csstream.Close(); m_csstream.Dispose();
        }
        catch (IOException ex) { throw ex; }
        catch (CryptographicException ex) { throw ex; }
        catch (ArgumentException ex) { throw ex; }
        catch (Exception ex) { throw ex; }
        finally { m_AESProvider.Clear(); }
        return m_strDecrypt;
    }
}



```

打包 AssetBundle
--------------

首先搭建一个简单的界面，将其制作成预制体[![][img-0]  
接下来需要设置预制体的 AssetBundle 名称  
[![][img-1]

编写打包的脚本代码（该脚本需要放置在 Editor 目录下），脚本名称随意，这里就只贴出打包的方法

```
  [MenuItem("Tools/Build")]
    static void Build()
    {
        string path = Application.streamingAssetsPath + "/" + EditorUserBuildSettings.activeBuildTarget;
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }
        BuildPipeline.BuildAssetBundles(path, BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        AssetDatabase.Refresh();
    }


```

等 Unity 编译完后再顶部菜单中会出现 Tools 选项，点击下方的 Build 进行打包

[![][img-2]

打包完的 AssetBundle

[![][img-3]

尝试用使用 AssetStudio 查看一下 ab 包，将 panel 拖入 AssetStudio 中，成功看到打包到 ab 包中的图片

[![][img-4]

加密 AssetBundle
--------------

同打包一样，在打包的脚本中添加一个加密方法进行测试，点击菜单中的加密

```
[MenuItem("Tools/加密")]
    static void EncryptAssetBundle()
    {
        string path = Application.streamingAssetsPath + "/" + EditorUserBuildSettings.activeBuildTarget + "/panel";
        AES.AESFileEncrypt(path, SECRET_KEY);
        AssetDatabase.Refresh();
    }


```

用记事本打开 panel，发现前面出现了标识头 AESEncrypt

[![][img-5]

再用 AssteStudio 看一下能不能查看到里面的资源，结果是空空如也，没有任何内容

[![][img-6]

解密和加载 AB 包
----------

同上一样，写一个方法测试一下对 AB 包进行解密，并将界面实力化出来

```
[MenuItem("Tools/解密")]
    static void DecryptAssetBunld()
    {
        string path = Application.streamingAssetsPath + "/" + EditorUserBuildSettings.activeBuildTarget + "/panel";
        
        byte[] bytes = AES.AESFileByteDecrypt(path, SECRET_KEY);
        
        AssetBundle ab = AssetBundle.LoadFromMemory(bytes);
        
        GameObject prefab = ab.LoadAsset<GameObject>("Panel");
        
        GameObject.Instantiate(prefab,GameObject.Find("Canvas").transform);
    }


```

点击 Tools 菜单下的解密，成功实例化界面  
[![][img-7]

[img-0]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=

[img-1]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=

[img-2]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=

[img-3]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=

[img-4]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=

[img-5]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=

[img-6]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=

[img-7]:data:text/html;base64,PGh0bWw+DQo8aGVhZD48dGl0bGU+NDA0IE5vdCBGb3VuZDwvdGl0bGU+PC9oZWFkPg0KPGJvZHk+DQo8Y2VudGVyPjxoMT40MDQgTm90IEZvdW5kPC9oMT48L2NlbnRlcj4NCjxocj48Y2VudGVyPm5naW54PC9jZW50ZXI+DQo8L2JvZHk+DQo8L2h0bWw+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo8IS0tIGEgcGFkZGluZyB0byBkaXNhYmxlIE1TSUUgYW5kIENocm9tZSBmcmllbmRseSBlcnJvciBwYWdlIC0tPg0KPCEtLSBhIHBhZGRpbmcgdG8gZGlzYWJsZSBNU0lFIGFuZCBDaHJvbWUgZnJpZW5kbHkgZXJyb3IgcGFnZSAtLT4NCjwhLS0gYSBwYWRkaW5nIHRvIGRpc2FibGUgTVNJRSBhbmQgQ2hyb21lIGZyaWVuZGx5IGVycm9yIHBhZ2UgLS0+DQo=