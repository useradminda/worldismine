--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
TransferCountrySys = {}

--选择阵营
function TransferCountrySys.ChooseCamp(Num)
	local info = Num
	WebEvent.ChooseCamp(info , "TransferCountrySys.ChooseCampCallBack",TransferCountrySys.ChooseCampCallBack)
end

function TransferCountrySys.ChooseCampCallBack(data , returnId)
    if returnId==0 then
	    local camp = ClinetInfomation.GetCamp()
	    if camp == 1 then
		    DataUIInstance.PopTip("恭喜你加入蜀国")----蜀魏吴
	    end
	    if camp == 2 then
		    DataUIInstance.PopTip("恭喜你加入魏国")
	    end
	    if camp == 3 then
		    DataUIInstance.PopTip("恭喜你加入吴国")
	    end
	    local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
	    if UIControlTar ~=nil then
		    UIControlTar:ShowChooseCampBtn()
	    end
          
    end
    local _UIGuideTar = MainGameUI.FindPanelTarget("UIGuide")
	if _UIGuideTar ~=nil then	   
       --_UIGuideTar:OpenWorldMap(60 , 33004 , _UIGuideTar.OpenChangeScene , 1)
       _UIGuideTar:GoToNextGuide()
    end 
end

return TransferCountrySys
--endregion
