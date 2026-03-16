using System;
using System.Net.Sockets;
using System.Collections.Generic;
using UnityEngine;
using System.Threading;

namespace DotNetClient
{
	class StateObject
	{
		public const int BufferSize = 1024*4*64;
		internal byte[] buffer = new byte[BufferSize];
	}

	public class Transporter
	{
		private static object lockObj = new object ();
		private Socket socket;
		private Action<byte[]> messageProcesser;
		
		//Used for get message
		private StateObject stateObject = new StateObject();
		private TransportState transportState;
		private IAsyncResult asyncReceive;
		private IAsyncResult asyncSend;
		private bool onSending = false;
		private byte[] buffer;
        private hzClient client;

		private int m_bodyLength=0;
		private int m_LeftbodyLength=0;
		private int m_LeftHeadLength=PacketMessage.PACK_HEAD_SIZE;

        private byte[] netPackHead = new byte[PacketMessage.PACK_HEAD_SIZE];
        public Queue<PacketMessage> list_pack = new Queue<PacketMessage>();
        PacketMessage tmpPack;
        public int count_pack = 0;
        public float start_time = Time.realtimeSinceStartup;
        public Transporter (hzClient client, Socket socket/*, Action<byte[]> processer*/){
            this.client = client;
			this.socket = socket;
			this.socket.SendTimeout = 1000;
			//this.messageProcesser = processer;
			transportState = TransportState.readHead;
            start_time = Time.realtimeSinceStartup;

        }

		public void receive_head(int len=PacketMessage.PACK_HEAD_SIZE,int beginIndex=0)
		{
			this.asyncReceive = socket.BeginReceive(stateObject.buffer, beginIndex, len, SocketFlags.None, new AsyncCallback(endReceive_head), stateObject);
        }
        private void endReceive_head(IAsyncResult asyncReceive)
        {
            if (this.transportState == TransportState.closed) return;
            StateObject state = (StateObject)asyncReceive.AsyncState;
            Socket socket = this.socket;
            int length = socket.EndReceive(asyncReceive);
			if (length != PacketMessage.PACK_HEAD_SIZE)
			{
				//Debug.LogError("Invalid head length!!");

				Debug.LogError("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Received HeadLength ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  length="+length+" m_headLength="+PacketMessage.PACK_HEAD_SIZE);
				m_LeftHeadLength=m_LeftHeadLength-length;

				if(m_LeftHeadLength>0)
				{
					receive_head(m_LeftHeadLength,PacketMessage.PACK_HEAD_SIZE-m_LeftHeadLength);
					return;
				}


			}else if(length>m_LeftHeadLength)
			{
				throw(new Exception("What?!"));
			}
			tmpPack = new PacketMessage(state.buffer, PacketMessage.PACK_HEAD_SIZE);

            int len = tmpPack.msgLen - PacketMessage.PACK_HEAD_SIZE;

			m_LeftbodyLength = m_bodyLength = len;
            receive_body(len,0);
        }

        public void receive_body(int len,int beginIndex)
        {
			this.asyncReceive = socket.BeginReceive(stateObject.buffer, beginIndex, len, SocketFlags.None, new AsyncCallback(endReceive_body), stateObject);
        }
		public PacketMessage get_pack()
		{
			lock(lockObj)
			{
				if(list_pack.Count>0)
				{
					return list_pack.Dequeue();
				}
				return null;

			}
		}
        
        private void endReceive_body(IAsyncResult asyncReceive)
        {
            if (this.transportState == TransportState.closed)
                return;
			//int Tid = Thread.CurrentThread.ManagedThreadId;
			//Debug.LogError ("===================current thread id is: " + Tid);
            StateObject state = (StateObject)asyncReceive.AsyncState;
            Socket socket = this.socket;

            try
            {
                int length = socket.EndReceive(asyncReceive);
				if(length!=m_bodyLength)
				{
					m_LeftbodyLength=m_LeftbodyLength-length;
					Debug.LogError("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Received BodyLength ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  length="+length+" m_bodyLength="+m_bodyLength);
					if(m_LeftbodyLength>0)
					{
						receive_body(m_LeftbodyLength,m_bodyLength-m_LeftbodyLength);
						return;
					}

				}else if(length>m_LeftbodyLength)
				{
					throw(new Exception("What?!"));
				}

                if (length > 0)
                {
                    tmpPack.appendData(state.buffer, m_bodyLength);

                    /*
                    if (tmpPack.msgID == (int)NetMsg.CLIENT_LOGIN_REP)
                    {
                        Debug.Log("....CLIENT LOGIN RESPONSE....");
                    }
                    */
					lock(lockObj)
					{
                        //Debug.Log("....END RECEIVE PACK....");
						list_pack.Enqueue(tmpPack);
                        count_pack++;
                        //Debug.LogError(count_pack);

                    }
                    
                    //this.messageProcesser.Invoke(tmpPack.buff);

                    // receive next message
                    if (this.transportState != TransportState.closed)
					{
						m_LeftHeadLength = PacketMessage.PACK_HEAD_SIZE;
                        receive_head();
					}
					else{
						Debug.LogError("!!!!!!!!!Dont Receive Buffer Any More!!!");
					}
                }
                else
                {
                    this.onDisconnect();
                }
            }
            catch (System.Net.Sockets.SocketException)
            {
                this.onDisconnect();
            }
        }

		public void start(){
            receive_head();
		}

        public void send(byte[] buffer)
        {
            if (this.transportState != TransportState.closed)
            {
				if(this.socket.Connected)
				{
					try
					{
						int slen = socket.Send(buffer);
						if(slen != buffer.Length)
						{
							Debug.LogError("!!!!Socket Send Buffer Error: Send Length Error slen="+slen.ToString()+" bufferLength="+buffer.Length.ToString());
						}
					}
					catch(Exception e)
					{
						Debug.LogError("!!!!Socket Send Buffer Error:"+e.ToString());
					}
				}
			

                //this.asyncSend = socket.BeginSend(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(sendCallback), socket);
                //this.onSending = true;
            }
            else
            {
                Debug.LogError("transport state is closed");
            }
        }

        private void onDisconnect()
        {
            this.client.disconnect();
        }
		
		private void sendCallback(IAsyncResult asyncSend){
			if(this.transportState == TransportState.closed) return;
			socket.EndSend (asyncSend);
			this.onSending = false;
		}

		internal void close(){
			this.transportState = TransportState.closed;
		}
	}
}