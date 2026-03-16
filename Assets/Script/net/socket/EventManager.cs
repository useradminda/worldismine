using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using System.Threading;
using SLua;
using ProtoBuf;
using ProtoBuf.Meta;
using proto.msg;
using System.IO;
using com.u9;
namespace DotNetClient
{

	public class EventManager : IDisposable {
        private hzClient _client = null;

        private Dictionary<int, Action<PacketMessage>> callBackMap = new Dictionary<int, Action<PacketMessage>>();

		public EventManager(hzClient client) {
            _client = client;
		}

		//Adds callback to callBackMap by id.
        public void AddCallBack(NetMsg msgID, Action<PacketMessage> callback) {
            int id = (int)msgID;
            if (id > 0 && callback != null) {
                this.callBackMap.Add(id, callback);
			}
        }
		public static string ToHexString(byte[] bytes) // 0xae00cf => "AE00CF "
		{
			string hexString = string.Empty;
			
			if (bytes != null)
			{
				
				StringBuilder strB = new StringBuilder();
				
				for (int i = 0; i < bytes.Length; i++)
				{
					
					strB.Append(bytes[i].ToString("X2"));
					
				}
				
				hexString = strB.ToString();
				
			} return hexString;
			
		}
        public void InvokeCallBack(PacketMessage msg)
        {
            int buLen = msg.msgLen - PacketMessage.PACK_HEAD_SIZE;
            byte[] tmp = new byte[buLen];
            int i = 0;
            for (i = 0; i < buLen; i++)
            {
                tmp[i] = msg.buff[i + PacketMessage.PACK_HEAD_SIZE];
            }
			/*
            if ((NetMsg)msg.msgID != NetMsg.BATTLE_OBJ_EVENT_NTF)
            {
                Debug.LogWarning("Unknown message id : " + msg.msgID);
                return;
            }
            */
            /*
			if ((NetMsg)msg.msgID == NetMsg.NM_PING_REP)
			{
				HeartBeatService.getInstance().onReceiveBackPackage(1);
				return;
			}
            */
			if ((NetMsg)msg.msgID != NetMsg.BATTLE_OBJ_EVENT_NTF&&(NetMsg)msg.msgID != NetMsg.LoginBattleServer_NTF&&(NetMsg)msg.msgID != NetMsg.CLIENT_LOGIN_REP)
			{
				Debug.LogWarning("Unknown message id : " + msg.msgID);

				return;
			}

			if ((NetMsg)msg.msgID == NetMsg.BATTLE_OBJ_EVENT_NTF) 
			{
				//Debug.LogError("disconnecting socket!! Have a test");
				//_client.disconnect();
			}
			//Debug.LogError ("===========================/////======" + msg);

            /*RuntimeTypeModel serializer = ProtoModelSerializer.Create();
            PT_Event_List ins = new PT_Event_List();
            MemoryStream memStream = new MemoryStream(tmp);
            serializer.Deserialize(memStream, ins, ins.GetType());
            */
			ProtobufSerializer serializer = new ProtobufSerializer ( );
			PT_Event_List ins = null;
			//Deserialize
			using ( MemoryStream m = new MemoryStream ( tmp ) )
			{
                try
                {
                    ins = serializer.Deserialize(m, null, typeof(PT_Event_List)) as PT_Event_List;
					//Debug.LogWarning("pack body size="+tmp.Length);

					//Debug.LogWarning("byte to string2:"+ToHexString(tmp));
                }
                catch (Exception e)
                {
                    Debug.LogError(e.ToString());
                    Debug.LogError("byte length :" + tmp.Length);
                    int kk = 0;
                    string tmps = "";
                    for (; kk < tmp.Length; kk++)
                    {
                        tmps += tmp[kk].ToString();
                    }
                    //Debug.LogWarning("byte to string:" + tmps);
					//Debug.LogWarning("byte to string2:"+ToHexString(tmp));

                    if (_client != null)
                    {
                        Debug.LogError("disconnecting socket!!");
                        _client.disconnect();
                    }

                    System.Object[] args = new System.Object[2];
                    args[0] = "GameMain.NetDieCB";
                    args[1] = "bytes of Protobuf error";
                    lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "GameMain.CallBack", args);

                    return;
                }
			}
			//Debug.Log ( "newData.mmm=" + ins.ToString() );

            for (i = 0; i < ins.events.Count; i++)
            {
                PT_Event pbins = ins.events[i];
                Event e = new Event();
                e.id = pbins.id;

				//Debug.LogWarning("event id=:"+e.id);
                e.check = pbins.check;
                e.delete = pbins.b_delete;

                Event.M s_dosome = new Event.M();

                for (int j = 0; j < pbins.@do.@int.Count; j++)
                {
                    e.dosome.intList.Add(pbins.@do.@int[j]);
                }
                for (int j = 0; j < pbins.@do.@float.Count; j++)
                {
                    e.dosome.floatList.Add(pbins.@do.@float[j]);
                }
                for (int j = 0; j < pbins.@do.@string.Count; j++)
                {
                    e.dosome.stringList.Add(pbins.@do.@string[j]);
                }
                for (int j = 0; j < pbins.@do.pos.Count; j++)
                {
                    PT_Pos4 p = pbins.@do.pos[j];
                    e.dosome.vectorList.Add(new Vector4(p.x, p.y, p.z, p.w));
                }

                System.Object[] args = new System.Object[1];
                args[0] = e;
                lgNoDelCsFun.Ins.Call(lgNoDelCsFun.Ins.mainlua, "SocketClient.ReceiveNetEvent", args);
            }

            //int Tid = Thread.CurrentThread.ManagedThreadId;
            //Debug.LogError ("current thread id is: " + Tid);

        }

   

		// Dispose() calls Dispose(true)
		public void Dispose() {
			Dispose(true);
			GC.SuppressFinalize(this);
		}

		// The bulk of the clean-up code is implemented in Dispose(bool)
		protected void Dispose(bool disposing) {
			this.callBackMap.Clear();
		}
	}
}

