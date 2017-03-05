; #FUNCTION# ====================================================================================================================
; Name ..........: donateCCWBL
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016-09)
; Modified ......: MR.ViPER (27-12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;collect donation request users images
Func donateCCWBLUserImageCollect($x, $y)

	Local $imagematch = False

	;capture donate request image
	;_CaptureRegion2(0, $y - 90, $x - 30, $y)
	_CaptureRegion2()
	;If $g_iDebugImageSave = 1 Then DebugImageSave("donateCCWBLUserImageCollect_", False, "png", True)

	;if OnlyWhiteList enable check and donate TO COMPLETE
	If $g_iDebugSetlog = 1 Then Setlog("Search into whitelist...", $color_purple)
	Local $xyz = _FileListToArrayRec($g_sProfileDonateCaptureWhitelistPath, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	If UBound($xyz) > 1 Then
		;_CaptureRegion2()
		For $i = 1 To UBound($xyz) - 1
			Local $result = FindImageInPlace("DCCWBL", $g_sProfileDonateCaptureWhitelistPath & $xyz[$i], "0," & $y - 90 & "," & $x - 30 & "," & $y, False)
			If StringInStr($result, ",") > 0 Then
				;Local $splitedPosition = StringSplit($result, ",", 2)
				;Local $xfound = Int($splitedPosition[0])
				;Local $yfound = Int($splitedPosition[1])
				If $g_iCmbDonateFilter = 2 Then Setlog("WHITE LIST: image match! " & $xyz[$i], $COLOR_SUCCESS)
				$imagematch = True
				If $g_iCmbDonateFilter = 2 Then Return True ; <=== return DONATE if name found in white list
				ExitLoop
			EndIf
		Next
	EndIf


	;if OnlyBlackList enable check and donate
	If $g_iDebugSetlog = 1 Then Setlog("Search into blacklist...", $color_purple)
	Local $xyz1 = _FileListToArrayRec($g_sProfileDonateCaptureBlacklistPath, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	If UBound($xyz1) > 1 Then
		;_CaptureRegion2()
		For $i = 1 To UBound($xyz1) - 1
			Local $result1 = FindImageInPlace("DCCWBL", $g_sProfileDonateCaptureBlacklistPath & $xyz1[$i], "0," & $y - 90 & "," & $x - 30 & "," & $y, False)
			If StringInStr($result1, ",") > 0 Then
				;Local $xfound = Int(StringSplit($result1, ",", 2)[0])
				;Local $yfound = Int(StringSplit($result1, ",", 2)[1])
				If $g_iCmbDonateFilter = 3 Then Setlog("BLACK LIST: image match! " & $xyz1[$i], $COLOR_SUCCESS)
				$imagematch = True
				If $g_iCmbDonateFilter = 3 Then Return False ; <=== return NO DONATE if name found in black list
				ExitLoop
			Else
				If $g_iDebugSetlog = 1 Then SetLog("Image not found", $COLOR_ERROR)
			EndIf
		Next
	EndIf


	If $imagematch = False And $g_iCmbDonateFilter > 0 Then
		If $g_iDebugSetlog = 1 Then Setlog("Search into images to assign...", $color_purple)
		;try to search into images to Assign
		Local $xyzw = _FileListToArrayRec($g_sProfileDonateCapturePath, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($xyzw) > 1 Then
			;_CaptureRegion2()
			For $i = 1 To UBound($xyzw) - 1
				Local $resultxyzw = FindImageInPlace("DCCWBL", $g_sProfileDonateCapturePath & $xyzw[$i], "0," & $y - 90 & "," & $x - 30 & "," & $y, False)
				If StringInStr($resultxyzw, ",") > 0 Then
					;Local $xfound = Int(StringSplit($resultxyzw, ",", 2)[0])
					;Local $yfound = Int(StringSplit($resultxyzw, ",", 2)[1])
					If $g_iCmbDonateFilter = 1 Or $g_iDebugSetlog = 1 Then Setlog("IMAGES TO ASSIGN: image match! " & $xyzw[$i], $COLOR_SUCCESS)
					$imagematch = True
					ExitLoop
				EndIf
			Next
		EndIf

		;save image (search divider chat line to know position of village name)
		If $imagematch = False Then
			If $g_iDebugSetlog = 1 Then Setlog("save image in images to assign...", $color_purple)

			;search chat divider line
			Local $founddivider
			Local $chat_divider = @ScriptDir & "\imgxml\donateccwbl\chatdivider_0_98.xml"
			Local $chat_divider_hidden = @ScriptDir & "\imgxml\donateccwbl\chatdividerhidden_0_98.xml"
			;_CaptureRegion2()
			Local $iAllFilesCount = 0
			Local $res = FindImageInPlace("DCCWBL", $chat_divider, "0," & $y - 90 & "," & $x - 30 & "," & $y, False)
			If $res = "" Then
				;SetLog("No Chat divider found, try to found hidden chat divider", $COLOR_ERROR)
				;search chat divider hidden
				Local $reshidden = FindImageInPlace("DCCWBL", $chat_divider_hidden, "0," & $y - 90 & "," & $x - 30 & "," & $y, False)
				If $reshidden = "" Then
					If $g_iDebugSetlog = 1 Then SetLog("No Chat divider hidden found", $COLOR_ERROR)
				Else
					If $g_iDebugSetlog = 1 Then
					   Local $xfound = Int(StringSplit($reshidden, ",", 2)[0])
					   Local $yfound = Int(StringSplit($reshidden, ",", 2)[1])
					   SetLog("ChatDivider hidden found (" & $xfound & "," & $yfound & ")", $COLOR_SUCCESS)
					EndIf

					; now crop image to have only request village name and put in $hClone
					Local $oBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2)
					Local $hClone = _GDIPlus_BitmapCloneArea($oBitmap, 31, $yfound + 14, 100, 11, $GDIP_PXF24RGB)
					;save image
					Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
					Local $Time = @HOUR & "." & @MIN & "." & @SEC
					$iAllFilesCount = _FileListToArrayRec($g_sProfileDonateCapturePath, "*", 1, 0, 0, 0)
					If IsArray($iAllFilesCount) Then
						$iAllFilesCount = $iAllFilesCount[0]
					Else
						$iAllFilesCount = 0
					EndIf
					Local $filename = String("ClanMate-" & $Date & "_" & Number($iAllFilesCount) + 1 & "_98.png")
					_GDIPlus_ImageSaveToFile($hClone, $g_sProfileDonateCapturePath & $filename)
					If $g_iCmbDonateFilter = 1 Then Setlog("Clan Mate image Stored: " & $filename, $COLOR_SUCCESS)
					_GDIPlus_BitmapDispose($hClone)
					_GDIPlus_BitmapDispose($oBitmap)
				EndIf
			Else
				If $g_iDebugSetlog = 1 Then
				   Local $xfound = Int(StringSplit($res, ",", 2)[0])
				   Local $yfound = Int(StringSplit($res, ",", 2)[1])
				   SetLog("ChatDivider found (" & $xfound & "," & $yfound & ")", $COLOR_SUCCESS)
			    EndIf

				; now crop image to have only request village name and put in $hClone
				Local $oBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2)
				Local $hClone = _GDIPlus_BitmapCloneArea($oBitmap, 31, $yfound + 14, 100, 11, $GDIP_PXF24RGB)
				;save image
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN & "." & @SEC
				$iAllFilesCount = _FileListToArrayRec($g_sProfileDonateCapturePath, "*", 1, 0, 0, 0)
				If IsArray($iAllFilesCount) Then
					$iAllFilesCount = $iAllFilesCount[0]
				Else
					$iAllFilesCount = 0
				EndIf
				Local $filename = String("ClanMate--" & $Date & "_" & Number($iAllFilesCount) + 1 & "_98.png")
				_GDIPlus_ImageSaveToFile($hClone, $g_sProfileDonateCapturePath & $filename)
				_GDIPlus_BitmapDispose($hClone)
				_GDIPlus_BitmapDispose($oBitmap)
				If $g_iCmbDonateFilter = 1 Then Setlog("IMAGES TO ASSIGN: stored!", $COLOR_SUCCESS)
				;remove old files into folder images to assign if are older than 2 days
				Deletefiles($g_sProfileDonateCapturePath, "*.png", 2, 0)
			EndIf
		EndIf
	EndIf
	If $g_iCmbDonateFilter <= 1 Then
		Return True ; <=== return DONATE if no white or black list set
	ElseIf $g_iCmbDonateFilter = 3 Then
		Return True ; <=== return DONATE if name not found in black list
	Else
		Return False ; <=== return NO DONATE
	EndIf
EndFunc   ;==>donateCCWBLUserImageCollect
