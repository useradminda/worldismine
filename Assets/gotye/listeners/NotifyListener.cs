using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

namespace gotye{

    public interface NotifyListener : GotyeListener
    {
        /**
         * 收到或发送消息回调通知
         * @param message  消息对象
         */
        //void onReceivePushMessage(GotyeMessage message);

        /**
         * 收到通知
         * @param notify 通知对象
         */
        //void onReceiveNotify(GotyeNotify notify);
        /**
     * 好友添加或删除通知
     * 
     * @param addOrRemove
     *            true表示添加好友，false表示删除好友
     * @param user
     *            被添加或删除的好友
     */
        //	void onFriendChanged(bool addOrRemove, GotyeUser user);

        /**
         * 通知变态变化通知，多用户更新界面
         */
        //void onNotifyStateChanged();

        /**
         * 接收到通知的时候触发
         */
        // void onReceiveNotify();

        /**
         * 发送通知
         */
        //  void onSendNotify();
        //}


        void onGetUnreadNotifyCount(int count);

        void onGetNotifyList(List<GotyeNotify> notifylist);




    }
}