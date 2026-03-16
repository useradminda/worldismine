using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

namespace gotye
{

    public interface PlayListener : GotyeListener
    {
        /**
         * 开始播放语音消息
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param message 被播放的消息
         */
        void onPlayStart(GotyeStatusCode code, GotyeMessage message);

        /**
         * 播放进度
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param position 当前播放位置
         */
        void onPlaying(GotyeStatusCode code, int position);

        /**
         * 停止播放
         * @param code 状态码 参见 {@link GotyeStatusCode}
         */
		void onPlayStop();

        /**
         * 播放实时语音
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param roomId 当前聊天室id
         * @param who 谁正在发起实时语音
         */
        void onPlayStartReal(GotyeStatusCode code, GotyeRoom room,
              GotyeUser who);
    }
}