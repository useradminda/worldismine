//using SimpleJson;
using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.ComponentModel;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SLua;
using System.IO;
using ProtoBuf;
using ProtoBuf.Meta;
using proto.msg;
using com.u9;

namespace DotNetClient {
	
	public enum NetWorkState {
		[Description("initial state")]
		CLOSED,
		
		[Description("connecting server")]
		CONNECTING,
		
		[Description("server connected")]
		CONNECTED,
		
		[Description("disconnected with server")]
		DISCONNECTED,
		
		[Description("connect timeout")]
		TIMEOUT,
		
		[Description("netwrok error")]
		ERROR
	}
	[CustomLuaClass]
	public class hzClient : IDisposable
    {
		private static hzClient _ins = null;

        public static hzClient GetPtr()
        {
            return _ins;
        }

        public static void Create(string host, int port)
        {
            Destroy();

            _ins = new hzClient();
			_ins.initClient(host, port);
            //CheapShadow.InitLight(new Vector3(1, 1, 0), 0.1f);
			//Screen.SetResolution(800, 450, false);
        }

        public static void Destroy()
        {
            if (_ins != null)
            {
                _ins.disconnect();
                _ins = null;
            }
        }
		
		private NetWorkState netWorkState = NetWorkState.CLOSED; // current network state

		public EventManager eventManager;
		private Socket socket;
        private Transporter transporter;
		private bool disposed = false;

        private ManualResetEvent timeoutEvent = new ManualResetEvent(false);
        private int timeoutMSec = 8000;    //connect timeout count in millisecond

		private void initClient(string host, int port) {
            this.eventManager = new EventManager(this);
			HeartBeatService.Create(2, this);
			NetWorkChanged(NetWorkState.CONNECTING);

			this.socket = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
	        IPEndPoint ie = new IPEndPoint(IPAddress.Parse(host), port);

            /*
            socket.BeginConnect(ie, new AsyncCallback((result) =>
            {
                try
                {
                    this.socket.EndConnect(result);
                    NetWorkChanged(NetWorkState.CONNECTED);
                }(int)NetMsg.CLIENT_LOGIN
                catch (SocketException e)
                {
                    Debug.Log(e.ToString());
                    if (netWorkState != NetWorkState.TIMEOUT)
                    {
                        NetWorkChanged(NetWorkState.ERROR);
                    }
                    Dispose();
                }
                finally
                {
                    timeoutEvent.Set();
                }
            }), this.socket);

            if (timeoutEvent.WaitOne(timeoutMSec, false))
            {
                if (netWorkState != NetWorkState.CONNECTED && netWorkState != NetWorkState.ERROR)
                {
                    NetWorkChanged(NetWorkState.TIMEOUT);
                    Dispose();
                }
            }
            */

            try
            {
                this.socket.Connect(ie);
                NetWorkChanged(NetWorkState.CONNECTED);
            }
            catch (SocketException e)
            {
                Debug.LogError(String.Format("unable to connect to server: {0}", e.ToString()));
                NetWorkChanged(NetWorkState.ERROR);
				lgNoDelCsFun.Ins.WebEvent(net_msg_id_define.CPPServerError);
                return;
            }

            connect();
		}

		private void NetWorkChanged(NetWorkState state) {
			netWorkState = state;

            string color = "green";
            switch(netWorkState)
            {
                case NetWorkState.CLOSED:
                case NetWorkState.DISCONNECTED:
                    color = "yellow";
                    break;
                case NetWorkState.ERROR:
                case NetWorkState.TIMEOUT:
                    color = "red";
                    break;
            }
			Debug.Log ("<color="+color+">NetWork State Changed : [ " + state.ToString() + " ]</color>");
		}

        public bool connect()
        {
            try {
                this.transporter = new Transporter(this, this.socket);
                this.transporter.start();
				HeartBeatService.getInstance().start();
				this.disposed = false;
                return true;
            } catch (Exception e) {
                Debug.Log(e);
                //if (e != null)
                    //Debug.LogError(e.ToString());
                return false;
            }
		}

        public void SendNetEvent(string _account_uuid, int server_id, LuaTable evt)
        {
			long account_uuid= System.Convert.ToInt64(_account_uuid);
            PT_M pt_m = new PT_M();
            pt_m.place_holder = 0;

            LuaTable dosome = evt["dosome"] as LuaTable;
            LuaTable m = dosome[1] as LuaTable;
            if (m["intList"] != null)
            {
                int i = 1;
                LuaTable list = m["intList"] as LuaTable;
                while (list[i] != null)
                {
					int d = Convert.ToInt32(list[i]);
					if(i==1)
					{

						if(d == 1)
						{
							Debug.LogWarning("--------------Send EventManager Inited NetPack----------------");
						}
						else if(d==10)
						{
							Debug.LogWarning("--------------Send Roles Inited NetPack----------------");
						}
					}

					pt_m.@int.Add(d);
                    i++;
                }
            }
            if (m["floatList"] != null)
            {
                int i = 1;
                LuaTable list = m["floatList"] as LuaTable;
                while (list[i] != null)
                {
                    pt_m.@float.Add((float)Convert.ToDouble(list[i]));
                    i++;
                }
            }
            if (m["stringList"] != null)
            {
                int i = 1;
                LuaTable list = m["stringList"] as LuaTable;
                while (list[i] != null)
                {
                    pt_m.@string.Add(list[i].ToString());
                    i++;
                }
            }
            if (m["vectorList"] != null)
            {
                int i = 1;
                LuaTable list = m["vectorList"] as LuaTable;
                while (list[i] != null)
                {
                    Vector4 vec = (Vector4)list[i];
                    PT_Pos4 pb = new PT_Pos4();
                    pb.x = vec.x;
                    pb.y = vec.y;
                    pb.z = vec.z;
                    pb.w = vec.w;
                    pt_m.pos.Add(pb);
                    i++;
                }
            }

            PT_Event pt_event = new PT_Event();
            pt_event.id = Convert.ToInt32(evt["id"]);
            pt_event.check = evt["check"].ToString();
            pt_event.@do = pt_m;
            pt_event.b_delete = Convert.ToInt32(evt["delete"]);

			ProtobufSerializer serializer = new ProtobufSerializer ( );
			//Serialize
			byte[] bytes = null;
			using ( System.IO.MemoryStream m111 = new MemoryStream ( ) )
			{
				serializer.Serialize ( m111 , pt_event );
				m111.Position = 0;
				int length = (int)m111.Length;
				bytes = new byte[length];
				m111.Read(bytes, 0 ,length);
			}

			/*
            RuntimeTypeModel serializer = ProtoModelSerializer.Create();

            MemoryStream memStream = new MemoryStream();
            serializer.Serialize(memStream, pt_event);
            byte[] bytes = new byte[memStream.Length];
            memStream.Seek(0, SeekOrigin.Begin);
            memStream.Read(bytes, 0, bytes.Length);
			*/
			/*
            if (pt_event.id == 100001) {
                this.Request(NetMsg.CLIENT_LOGIN, account_uuid, server_id, bytes);
            } else {
                this.Request(NetMsg.BATTLE_OBJ_EVENT_ASK, account_uuid, server_id, bytes);
            }
            */

           // Debug.Log("eventID:" + pt_event.id);
			if (pt_event.id == 100022) 
			{
				//this.Request((int)NetMsg.LoginBattleServer, account_uuid, server_id,bytes);
				return;
			}
			if (pt_event.id == 100023) 
			{
				//this.Request((int)NetMsg.DisConnectBattleServer, account_uuid, server_id, bytes);
				return;
			}
			
			//Debug.LogError(pt_event.Build());
			
			if (pt_event.id == 100001) {
				
				//this.Request((int)NetMsg.CLIENT_LOGIN, account_uuid, server_id, bytes);
			} else {
                //Debug.LogError("DDDDDDDDDDDD" + pt_event.id + " " + server_id);
				this.Request(pt_event.id, account_uuid, server_id, bytes);
			}

			
		}
		
		public int Request(int type, long userid, int srvid, byte[] data) {

            //Debug.LogError(Enum.GetName(typeof(NetMsg), type));
            int msgID = type;
            byte[] pkg = PackageProtocol.encode(msgID, userid, srvid, data);
            if (this.transporter == null)
            {
               // Debug.LogError("transporter is uninitialized");
                return 0;
            }

            //Debug.LogError(Enum.GetName(typeof(NetMsg), type));
            /*
            if (type == NetMsg.CLIENT_LOGIN) {
                Debug.Log("....CLIENT LOGIN REQUEST....");
                Debug.Log("....PKG LENGTH="+pkg.Length+"....");
            }
            */

            transporter.send(pkg);
            return 0;
        }

        public void update() {
            if (transporter == null)
            {
                return;
            }
            int a = 0;
            while(true)
            {
                PacketMessage msg = transporter.get_pack();
                if (msg != null)
                {
                    /*
                    if (msg.msgID == (int)NetMsg.CLIENT_LOGIN_REP)
                    {
                        Debug.Log("....CLINET LOGIN RESPONSE INVOKE CALLBACK....");
                    }
                    */
                    //                Debug.Log("....DEQUEUE MSG....");
                    eventManager.InvokeCallBack(msg);
                    a++;
                    if(a >= 10)
                    {
                        break;
                    }
                }
                else
                {
                    break;
                }

            }
			
            test_packet_count();
        }
        public float last_debug_time = Time.realtimeSinceStartup;
        public void test_packet_count()
        {
            float this_time = Time.realtimeSinceStartup;
            if(this_time- last_debug_time>30)
            {
                last_debug_time = this_time;
                float space_time = this_time - transporter.start_time;
                int packet_count = transporter.count_pack;
                int packet_miao = (int)(packet_count / space_time);
                Debug.LogError("total packet: " + packet_count + " per second packet: " + packet_miao);
            }
           
        }

        internal void processMessage(PacketMessage pkg) {
            if (pkg.msgID > 0) {
                eventManager.InvokeCallBack(pkg);
            }
        }

		public void disconnect() {
			HeartBeatService.getInstance ().stop ();
			Dispose ();
		}

		public void Dispose() {
			Dispose(true);
			GC.SuppressFinalize(this);
		}

		// The bulk of the clean-up code 
		protected virtual void Dispose(bool disposing) {
			if (this.disposed)
				return;

			if (disposing) {
                if (this.transporter != null) {
                    this.transporter.close();
                }

                if (this.eventManager != null) {
					this.eventManager.Dispose();
                }

				try {
					this.socket.Shutdown(SocketShutdown.Both);
					this.socket.Close();
			        NetWorkChanged(NetWorkState.DISCONNECTED);
					this.disposed = true;
				} catch (Exception e) {
					Debug.LogError(e.ToString());
				}

				this.disposed = true;
			}
		}
	}
	[CustomLuaClass]
    class Event
    {
        public int id;
        public string check;
        public M dosome = new M();
        public int delete;
		[CustomLuaClass]
        public class M
        {
            public List<int> intList = new List<int>();
            public List<float> floatList = new List<float>();
            public List<string> stringList = new List<string>();
            public List<Vector4> vectorList = new List<Vector4>();
        }
    }
}