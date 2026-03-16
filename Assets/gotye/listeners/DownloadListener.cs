using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

namespace gotye{
public interface DownloadListener  : GotyeListener{
	/**
	 * 下载图片回调
	 * @param code 状态码 参见 {@link GotyeStatusCode}
	 * @param media 下载的媒体
	 */
	  void onDownloadMedia(GotyeStatusCode code,GotyeMedia media);
}
}