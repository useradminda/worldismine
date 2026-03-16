using System;
using System.Timers;

namespace DotNetClient
{
    class HeartBeatService
    {
        int interval;
        public int timeout;
        Timer timer;
        DateTime lastTime;
		hzClient m_client;
		DateTime m_sendTime;
		bool m_bSended;
        //Protocol protocol;
		private static HeartBeatService _hbService = null;

		public static HeartBeatService Create(int interval, hzClient client){
			if (_hbService == null) {
				_hbService = new HeartBeatService (interval, client);
			}
			return _hbService;
		}

		public static HeartBeatService getInstance(){
			if (_hbService != null) {
				return _hbService;
			} else {
				throw(new Exception("Please Create HeartBeatService First!! "));
			}
		}

		private HeartBeatService(int interval, hzClient client)
        {
            this.interval = interval * 1000;
            //this.protocol = protocol;
			this.m_client = client;
			//eventMgr.AddCallBack (NetMsg.NM_PING_REP, new Action<PacketMessage>(onReceiveBackPackage));
        }

        internal void resetTimeout()
        {
            this.timeout = 0;
            lastTime = DateTime.Now;
        }

        public void sendHeartBeat(object source, ElapsedEventArgs e)
        {
			/*
            TimeSpan span = DateTime.Now - lastTime;
            timeout = (int)span.TotalMilliseconds;

            //check timeout
            if (timeout > interval * 2)
            {
                //protocol.getHzClient().disconnect();
                return;
            }*/
			if (m_bSended)
				return;
			m_bSended = true;
            //Send heart beat
            //protocol.send(NetMsg.NM_PING_REP);
			this.m_sendTime = DateTime.Now;
			byte[] body = new byte[1]{0x08};
			byte[] buf = PackageProtocol.encode((int)NetMsg.NM_PING, 0, 0, body);
			//PacketMessage pingMsg = new PacketMessage (buf,0);
			//m_client.Request ((int)NetMsg.NM_PING, 0, 0, buf);
        }

		public void onReceiveBackPackage(int unixStamp)
		{
			m_bSended = false;
			TimeSpan span = DateTime.Now - m_sendTime;
			float totalTime = (float)span.TotalMilliseconds;
			float halfTime = totalTime / 2.0f;
			int a = (int)(halfTime * 100);
			halfTime = (float)a / 100.0f;
			lgNoDelCsFun.Ins.ShowTip("ping", halfTime.ToString()+"ms");
		}

        public void start()
        {
            if (interval < 1000) return;

			//start hearbeat
			if (this.timer == null) {
				this.timer = new Timer();
				timer.Interval = interval;
				timer.Elapsed += new ElapsedEventHandler(sendHeartBeat);
				timer.Enabled = true;
			}

            //Set timeout
            timeout = 0;
            lastTime = DateTime.Now;
        }

        public void stop()
        {
            if (this.timer != null)
            {
                this.timer.Enabled = false;
                this.timer.Dispose();
            }
        }
    }
}
