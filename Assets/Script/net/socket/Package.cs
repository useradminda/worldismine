using System;
using System.Text;

namespace DotNetClient
{
    public class Package
    {
        public int msgID;
        public int length;
        public byte[] body;

        public Package(int msgID, byte[] body)
        {
            this.msgID = msgID;
            this.length = body.Length;
            this.body = body;
        }
    }


    public class PackageProtocol
    {
        public static int PACK_HEAD_OFFSET = 0;
        public static int PACK_VERSION_OFFSET = 2;
        public static int PACK_LENGTH_OFFSET = 3;
        public static int PACK_MESSSAGEID_OFFSET = 7;
        public static int PACK_USERDATA_OFFSET = 11;
        public static int PACK_SERVERID_OFFSET = 19;
        public static int PACK_MESSAGE_OFFSET = 23;
        public static int PACK_HEAD_SIZE = 23;

        public static byte[] encode(int msgID, long userUD, int srvID, byte[] body)
        {

			
            int length = PACK_HEAD_SIZE;

            if (body != null)
                length += body.Length;

            byte[] buf = new byte[length];

            buf[PACK_HEAD_OFFSET] = 8;
            buf[PACK_HEAD_OFFSET + 1] = 8;
            buf[PACK_VERSION_OFFSET] = 1;
            buf[PACK_MESSSAGEID_OFFSET] = 10;

            buf[PACK_LENGTH_OFFSET] = (byte)(length & 0xff);
            buf[PACK_LENGTH_OFFSET + 1] = (byte)(length >> 8 & 0xff);
            buf[PACK_LENGTH_OFFSET + 2] = (byte)(length >> 16 & 0xff);
            buf[PACK_LENGTH_OFFSET + 3] = (byte)(length >> 24 & 0xff);

            buf[PACK_MESSSAGEID_OFFSET] = (byte)(msgID & 0xff);
            buf[PACK_MESSSAGEID_OFFSET + 1] = (byte)(msgID >> 8 & 0xff);
            buf[PACK_MESSSAGEID_OFFSET + 2] = (byte)(msgID >> 16 & 0xff);
            buf[PACK_MESSSAGEID_OFFSET + 3] = (byte)(msgID >> 24 & 0xff);

            buf[PACK_USERDATA_OFFSET] = (byte)(userUD & 0xff);
            buf[PACK_USERDATA_OFFSET + 1] = (byte)(userUD >> 8 & 0xff);
            buf[PACK_USERDATA_OFFSET + 2] = (byte)(userUD >> 16 & 0xff);
            buf[PACK_USERDATA_OFFSET + 3] = (byte)(userUD >> 24 & 0xff);
			buf[PACK_USERDATA_OFFSET + 4] = (byte)(userUD >> 32& 0xff);
            buf[PACK_USERDATA_OFFSET + 5] = (byte)(userUD >> 40 & 0xff);
            buf[PACK_USERDATA_OFFSET + 6] = (byte)(userUD >> 48 & 0xff);
            buf[PACK_USERDATA_OFFSET + 7] = (byte)(userUD >> 56 & 0xff);
            buf[PACK_SERVERID_OFFSET] = (byte)(srvID & 0xff);
            buf[PACK_SERVERID_OFFSET + 1] = (byte)(srvID >> 8 & 0xff);
            buf[PACK_SERVERID_OFFSET + 2] = (byte)(srvID >> 16 & 0xff);
            buf[PACK_SERVERID_OFFSET + 3] = (byte)(srvID >> 24 & 0xff);

            for (int i = 0; i < body.Length; i++)
            {
                buf[PACK_HEAD_SIZE + i] = body[i];
            }

            return buf;
        }

        public static Package decode(byte[] buf)
        {
            int msgID = buf[PACK_MESSSAGEID_OFFSET] + (buf[PACK_MESSSAGEID_OFFSET + 1] << 8) + (buf[PACK_MESSSAGEID_OFFSET + 2] << 16) + (buf[PACK_MESSSAGEID_OFFSET + 3] << 24);
            //int uuid = buf[PACK_USERDATA_OFFSET] + (buf[PACK_USERDATA_OFFSET + 1] << 8) + (buf[PACK_USERDATA_OFFSET + 2] << 16) + (buf[PACK_USERDATA_OFFSET + 3] << 24);
            //int srvID = buf[PACK_SERVERID_OFFSET] + (buf[PACK_SERVERID_OFFSET + 1] << 8) + (buf[PACK_SERVERID_OFFSET + 2] << 16) + (buf[PACK_SERVERID_OFFSET + 3] << 24);
            //int msgLen = buf[PACK_LENGTH_OFFSET] + (buf[PACK_LENGTH_OFFSET + 1] << 8) + (buf[PACK_LENGTH_OFFSET + 2] << 16) + (buf[PACK_LENGTH_OFFSET + 3] << 24);

            byte[] body = new byte[buf.Length - PACK_HEAD_SIZE];

            for (int i = 0; i < body.Length; i++)
            {
                body[i] = buf[i + PACK_HEAD_SIZE];
            }

            //return new Package(msgID, uuid, srvID, body);
            return new Package(msgID, body);
        }
    }
}