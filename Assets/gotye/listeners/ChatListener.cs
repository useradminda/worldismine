using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

namespace gotye
{
    public interface ChatListener : GotyeListener
    {
        /**
         * 发送消息后回调
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param message 被发送的消息对象
         */
        void onSendMessage(GotyeStatusCode code, GotyeMessage message);

        /**
         * 接收信息
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param message
         */
        void onReceiveMessage(GotyeMessage message);

        /**
         * 下载消息
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param message 下载的消息对象
         */
		void onDownloadMediaInMessage(GotyeStatusCode code, GotyeMessage message);
 
        /**
         * 举报回调
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param message 被举报的消息
         */
        void onReport(GotyeStatusCode code, GotyeMessage message);

        /**
         * 开始录制语音消息回调
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param isRealTime 是否实时语音
         * @param targetType 发送对象类型
         * @param target  发送对象
         */
        void onStartTalk(GotyeStatusCode code, 
                GotyeChatTarget target,  bool isRealTime);

        /**
         * 停止录制语音消息回调
         * @param code  状态码 参见 {@link GotyeStatusCode}
         * @param message
         * @param isVoiceReal
         */
        void onStopTalk(GotyeStatusCode code, bool realtime, GotyeMessage message/*, bool *cancelSending*/);
        /**
         * 解码语音消息
         * @param code 状态码 参见 {@link GotyeStatusCode}
         * @param message 被解码的消息对象
         */
        void onDecodeMessage(GotyeStatusCode code, GotyeMessage message);

		/**
	        * 获取历史消息回调
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	        * @param list 历史消息列表
	    */
	    void onGetMessageList(GotyeStatusCode code, List<GotyeMessage> list/*, bool downloadMediaIfNeed*/);

       // void onRequestCS(GotyeStatusCode code, GotyeUser user);

        /**
	        * 设置群组消息回调
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	        * @param group 当前群组
            * @param msgConfig 群组的消息配置参数    
	    */
        void onSetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig);
        /**
	        * 获取群组消息设置回调
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	        * @param group 当前的群组
	    */
        void onGetGroupMsgConfig(GotyeStatusCode code, GotyeGroup group, GotyeGroupMsgConfig msgConfig);
        /**
	        * 获取离线消息回调
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	        * @param msgList 历史消息列表
            * @param downloadMediaIfNeed 是否需要下载多媒体     
	    */

        void onGetOfflineMessageList(GotyeStatusCode code, List<GotyeMessage> msgList/*, bool downloadMediaIfNeed*/);
        /**
	        * 获取历史消息回调
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	        * @param list 历史消息列表
	    */
        void onGetHistoryMessageList(GotyeStatusCode code, List<GotyeMessage> msgList/*, bool downloadMediaIfNeed*/);
        /**
	        * 
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	    */
        void onStartAPNS(GotyeStatusCode code);

        /**
	        * 
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	    */
        void onStopAPNS(GotyeStatusCode code);

        /**
	        * 更新未读消息回调
	        * @deprecated
	        * @param code 状态码 参见 {@link GotyeStatusCode}
	    */
        void onUpdateUnreadMessageCount(GotyeStatusCode code);

        void onGetLastMessage(GotyeChatTarget target, GotyeMessage message);

        void onGetSessionList(List<GotyeChatTarget> list);

        void onGetUnreadMessageCount(GotyeChatTarget target, int count);

        void onGetTotalUnreadMessageCount(int count);

        void onGetTotalUnreadMessageCountOfTypes(List<GotyeChatTargetType> types, int count);

    }
}
