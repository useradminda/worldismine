using System;
namespace DotNetClient
{
   
    public class PacketMessage
    {
        [System.Runtime.InteropServices.DllImport("ws2_32.dll")]
        static extern int ntohl(int netLong);

       
        public static int PACK_HEAD_OFFSET = 0;
        public static int PACK_VERSION_OFFSET = 2;
        public static int PACK_LENGTH_OFFSET = 3;
        public static int PACK_MESSSAGEID_OFFSET = 7;
        public static int PACK_USERDATA_OFFSET = 11;
        public static int PACK_SERVERID_OFFSET = 19;
        public static int PACK_MESSAGE_OFFSET = 23;
        public const  int PACK_HEAD_SIZE = 23;

        public byte[] buff;
        public int msgID;
		public long roleID;
        public int svrID;
        public int msgLen; // include head

        PacketMessage()
        {
        }
        public PacketMessage(byte[] src, int len)
        {
            msgID = (src[PACK_MESSSAGEID_OFFSET] + (src[PACK_MESSSAGEID_OFFSET + 1] << 8) + (src[PACK_MESSSAGEID_OFFSET + 2] << 16) + (src[PACK_MESSSAGEID_OFFSET + 3] << 24));
            roleID = System.BitConverter.ToInt64(src, PACK_USERDATA_OFFSET);
            //roleID = src[PACK_USERDATA_OFFSET] + (src[PACK_USERDATA_OFFSET + 1] << 8) + (src[PACK_USERDATA_OFFSET + 2] << 16) + (src[PACK_USERDATA_OFFSET + 3] << 24);
            svrID = (src[PACK_SERVERID_OFFSET] + (src[PACK_SERVERID_OFFSET + 1] << 8) + (src[PACK_SERVERID_OFFSET + 2] << 16) + (src[PACK_SERVERID_OFFSET + 3] << 24));
            msgLen = (src[PACK_LENGTH_OFFSET] + (src[PACK_LENGTH_OFFSET + 1] << 8) + (src[PACK_LENGTH_OFFSET + 2] << 16) + (src[PACK_LENGTH_OFFSET + 3] << 24));



            //msgID = (src[PACK_MESSSAGEID_OFFSET+3] + (src[PACK_MESSSAGEID_OFFSET + 2] << 8) + (src[PACK_MESSSAGEID_OFFSET + 1] << 16) + (src[PACK_MESSSAGEID_OFFSET ] << 24));
            //roleID = System.BitConverter.ToInt64(src, PACK_USERDATA_OFFSET);
            ////roleID = src[PACK_USERDATA_OFFSET] + (src[PACK_USERDATA_OFFSET + 1] << 8) + (src[PACK_USERDATA_OFFSET + 2] << 16) + (src[PACK_USERDATA_OFFSET + 3] << 24);
            //svrID = (src[PACK_SERVERID_OFFSET] + (src[PACK_SERVERID_OFFSET + 1] << 8) + (src[PACK_SERVERID_OFFSET + 2] << 16) + (src[PACK_SERVERID_OFFSET + 3] << 24));
            //msgLen = (src[PACK_LENGTH_OFFSET+3] + (src[PACK_LENGTH_OFFSET + 2] << 8) + (src[PACK_LENGTH_OFFSET + 1] << 16) + (src[PACK_LENGTH_OFFSET ] << 24));
            buff = new byte[msgLen];
            for (int i = 0; i < msgLen; i++)
            {
                buff[i] = src[i];
            }
        }

        public void appendData(byte[] d, int len)
        {
            if (msgLen - PACK_HEAD_SIZE != len)
            {
                return;
            }
            for (int i = 0; i < len; i++)
            {
                buff[PACK_HEAD_SIZE + i] = d[i];
            }
        }
    }
    
}
