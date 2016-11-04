(*
AOM(Adobe Output Module)インストーラー
20151219	初回作成
20151221	一部修正
20151224	ログ表示部修正
20151225	udoの一部誤り訂正
20160510	Adobeのサーバー側のリダイレクトに対応
20160517	キャッシュの削除を含めて初期化する処理に変更
20160713	CC2015に対応　少し直しました
20160720	CC2015用のAOM_Package_Mac.zipのインストールに対応
20160720	名称変更Install_Adobe_Output_Module_CC2015.scpt
20160831	ダウンロードファイルのURL変更に対応
20161104	CC2017に対応（JPサイトでエラーになったらENサイトからダウンロード）

AOM(Adobe Output Module)のMac版は
解凍時のアクセス権の影響で
複数の人が同じ機器を利用する場合
インストールした人以外が出力パネルを利用出来ない（エラーになる）
インストールからアクセス権設定までを自動化して
トラブル防止用に作成した
業務用に作成した物を可読性を配慮して作り直した
アクセス権でstaffにフルアクセス権を付けている（ここは好みの問題）
Bridge Help / Install Adobe Output Module 
https://helpx.adobe.com/bridge/kb/install-output-module-bridge-cc.html

*)

----ログを表示
tell application "AppleScript Editor"
	activate
	try
		tell application "System Events" to keystroke "3" using {command down}
	end try
	try
		tell application "System Events" to keystroke "l" using {option down, command down}
	end try
end tell

set numVerChk2013 to 0 as number
set numVerChk2015 to 0 as number
set numVerChk2017 to 0 as number



-----Bridge CC 2017 のインストール判定
try
	set theLocalSuppDir to (path to application support folder from local domain) as text
	set theLocalSuppBrCCdir to (theLocalSuppDir & "Adobe:Bridge CC Extensions:") as text
	set aliasLocalSuppBrCCdir to theLocalSuppBrCCdir as alias
on error
	set numVerChk2013 to 1 as number
end try
-----Bridge CC 2017 のインストール判定
try
	set theLocalSuppDir to (path to application support folder from local domain) as text
	set theLocalSuppBrCCdir to (theLocalSuppDir & "Adobe:Bridge CC 2015 Extensions:") as text
	set aliasLocalSuppBrCCdir to theLocalSuppBrCCdir as alias
on error
	set numVerChk2015 to 1 as number
end try
-----Bridge CC 2017 のインストール判定
try
	set theLocalSuppDir to (path to application support folder from local domain) as text
	set theLocalSuppBrCCdir to (theLocalSuppDir & "Adobe:Bridge CC 2017 Extensions:") as text
	set aliasLocalSuppBrCCdir to theLocalSuppBrCCdir as alias
on error
	set numVerChk2017 to 1 as number
end try




---日付けと時間からテンポラリー用のフォルダ名を作成
set theNowTime to (my doDateAndTIme(current date)) as text

---テンポラリー用フォルダのパスを定義
set theTrashDirCC to ("/tmp/" & theNowTime & "CC") as text

---テンポラリー用フォルダのパスを定義
set theTrashDir2015 to ("/tmp/" & theNowTime & "CC2015") as text

---テンポラリー用フォルダのパスを定義
set theTrashDir2017 to ("/tmp/" & theNowTime & "CC2017") as text


-----テンポラリーフォルダを作成Bridge CC 6.2
try
	set theCommand to ("mkdir -pv " & theTrashDirCC) as text
	do shell script theCommand
	set theTmpPathCC to theTrashDirCC as text
	delay 1
on error
	return "テンポラリフォルダ作成でエラーが発生しました"
end try
-----テンポラリーフォルダを作成Bridge CC 6.3 
try
	set theCommand to ("mkdir -pv " & theTrashDir2015) as text
	do shell script theCommand
	set theTmpPath2015 to theTrashDir2015 as text
	delay 1
on error
	return "テンポラリフォルダ作成でエラーが発生しました"
end try
-----テンポラリーフォルダを作成Bridge CC 7
try
	set theCommand to ("mkdir -pv " & theTrashDir2017) as text
	do shell script theCommand
	set theTmpPath2017 to theTrashDir2017 as text
	delay 1
on error
	return "テンポラリフォルダ作成でエラーが発生しました"
end try

-----ファイルをダウンロード Bridge CC 2013 version 6.2
if numVerChk2013 is 0 then
	try
		set theCommand to ("curl -L -o '" & theTmpPathCC & "/AOM_Mac_New.zip' 'https://helpx.adobe.com/jp/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_section_393125832/download-3/file.res/AOM_Mac_New.zip'") as text
		do shell script theCommand
		delay 1
	on error
		try
			set theCommand to ("curl -L -o '" & theTmpPathCC & "/AOM_Mac_New.zip' 'https://helpx.adobe.com/content/help/en/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_section_393125832/download-3/file.res/AOM_Mac_New.zip'") as text
			do shell script theCommand
			delay 1
		on error
			
			return "ダウンロードでエラーが発生しました"
		end try
	end try
end if
-----ファイルをダウンロードBridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theCommand to ("curl -L -o '" & theTmpPath2015 & "/AOM_Package_Mac.zip' 'https://helpx.adobe.com/jp/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_section/download-3/file.res/AOM_Package_Mac.zip'") as text
		do shell script theCommand
		delay 1
	on error
		try
			set theCommand to ("curl -L -o '" & theTmpPath2015 & "/AOM_Package_Mac.zip' 'https://helpx.adobe.com/content/help/en/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_section/download-3/file.res/AOM_Package_Mac.zip'") as text
			do shell script theCommand
			delay 1
		on error
			return "ダウンロードでエラーが発生しました"
		end try
	end try
end if
-----ファイルをダウンロードBridge CC 2017 version 7
if numVerChk2017 is 0 then
	try
		set theCommand to ("curl -L -o '" & theTmpPath2017 & "/AOM_Mac.zip' 'https://helpx.adobe.com/jp/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_section_1276784658/download-3/file.res/AOM_Mac.zip'") as text
		do shell script theCommand
		delay 1
	on error
		try
			set theCommand to ("curl -L -o '" & theTmpPath2017 & "/AOM_Mac.zip' 'https://helpx.adobe.com/content/help/en/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_section_1276784658/download-3/file.res/AOM_Mac.zip'") as text
			do shell script theCommand
			delay 1
		on error
			return "ダウンロードでエラーが発生しました"
		end try
	end try
end if


-----ファイルを解凍 Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theCommand to ("unzip  '" & theTmpPathCC & "/AOM_Mac_New.zip' -d '" & theTmpPathCC & "'") as text
		do shell script theCommand
		delay 1
	on error
		return "ファイルの解凍でエラーが発生しました"
	end try
end if
-----ファイルを解凍 Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theCommand to ("unzip  '" & theTmpPath2015 & "/AOM_Package_Mac.zip' -d '" & theTmpPath2015 & "'") as text
		do shell script theCommand
		delay 1
	on error
		return "ファイルの解凍でエラーが発生しました"
	end try
end if
-----ファイルを解凍 Bridge CC 2017 version 7
if numVerChk2017 is 0 then
	try
		set theCommand to ("unzip  '" & theTmpPath2017 & "/AOM_Mac.zip' -d '" & theTmpPath2017 & "'") as text
		do shell script theCommand
		delay 1
	on error
		return "ファイルの解凍でエラーが発生しました"
	end try
end if

-----インストール先のフォルダを確保 Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		----ここはエラー制御無しで
	end try
end if
-----インストール先のフォルダを確保 Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC 2015 Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		----ここはエラー制御無しで
	end try
end if
-----インストール先のフォルダを確保 Bridge CC 2017 version 7
if numVerChk2017 is 0 then
	try
		set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC 2017 Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		----ここはエラー制御無しで
	end try
end if


-----アクセス権を修正775(アクセス権は好みで）Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theCommand to ("sudo chown root  '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  admin '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  775 '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if
-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theCommand to ("sudo chown root  '/Library/Application Support/Adobe/Bridge CC 2015 Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  admin '/Library/Application Support/Adobe/Bridge CC 2015 Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  775 '/Library/Application Support/Adobe/Bridge CC 2015 Extensions'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if
-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2017 version 7
if numVerChk2017 is 0 then
	try
		set theCommand to ("sudo chown root  '/Library/Application Support/Adobe/Bridge CC 2017 Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  admin '/Library/Application Support/Adobe/Bridge CC 2017 Extensions'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  775 '/Library/Application Support/Adobe/Bridge CC 2017 Extensions'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if




-----アクセス権を修正775(アクセス権は好みで）Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theCommand to ("sudo chown root  '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  admin '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  777 '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if
-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theCommand to ("sudo chown root  '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  admin '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  777 '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if

-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2017 version 7 
if numVerChk2017 is 0 then
	try
		set theCommand to ("sudo chown root  '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  admin '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  777 '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if




-----ワークススペースファイルを移動（おきかえ）Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theCommand to ("sudo mv -f '" & theTmpPathCC & "/AOM_Mac/AdobeOutputModule.workspace' '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		---ここはエラー制御無しでOKかな
	end try
end if
-----ワークススペースファイルを移動（おきかえ）Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theCommand to ("sudo mv -f '" & theTmpPath2015 & "/AOM_Mac/AdobeOutputModule.workspace' '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		---ここはエラー制御無しでOKかな
	end try
end if
-----ワークススペースファイルを移動（おきかえ）Bridge CC 2017 version 7 
if numVerChk2017 is 0 then
	try
		set theCommand to ("sudo mv -f '" & theTmpPath2017 & "/AOM_Mac/AdobeOutputModule.workspace' '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces'") as text
		do shell script theCommand with administrator privileges
	on error
		---ここはエラー制御無しでOKかな
	end try
end if




-----モジュールを移動（エラーしたら削除してから新しいファイルを移動）Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theCommand to ("sudo mv -f '" & theTmpPathCC & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
		do shell script theCommand with administrator privileges
	on error
		set theCommand to ("sudo mv -f  '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module' '" & theTmpPathCC & "'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo mv -f '" & theTmpPathCC & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
		do shell script theCommand with administrator privileges
	end try
	-----アクセス権を修正775(アクセス権は好みで）Bridge CC version 6.2
	try
		set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  -Rf admin '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
	-----アクセス権を修正775(アクセス権は好みで） Bridge CC version 6.2
	try
		set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  -Rf admin '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if

-----モジュールを移動（エラーしたら削除してから新しいファイルを移動）Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theCommand to ("sudo mv -f '" & theTmpPath2015 & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC 2015 Extensions'") as text
		do shell script theCommand with administrator privileges
	on error
		set theCommand to ("sudo mv -f  '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Adobe Output Module' '" & theTmpPath2015 & "'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo mv -f '" & theTmpPath2015 & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC 2015 Extensions'") as text
		do shell script theCommand with administrator privileges
	end try
	-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2015 version 6.3 
	try
		set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  -Rf admin '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
	-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2015 version 6.3 
	try
		set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  -Rf admin '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC 2015 Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if


-----モジュールを移動（エラーしたら削除してから新しいファイルを移動）Bridge CC 2017 version 7
if numVerChk2017 is 0 then
	try
		set theCommand to ("sudo mv -f '" & theTmpPath2017 & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC 2017 Extensions'") as text
		do shell script theCommand with administrator privileges
	on error
		set theCommand to ("sudo mv -f  '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Adobe Output Module' '" & theTmpPath2017 & "'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo mv -f '" & theTmpPath2017 & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC 2017 Extensions'") as text
		do shell script theCommand with administrator privileges
	end try
	-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2017 version 7
	try
		set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  -Rf admin '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Adobe Output Module'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
	-----アクセス権を修正775(アクセス権は好みで）Bridge CC 2017 version 7 
	try
		set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chgrp  -Rf admin '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
		set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC 2017 Extensions/Workspaces/AdobeOutputModule.workspace'") as text
		do shell script theCommand with administrator privileges
	on error
		return "アクセス権修正でエラーが発生しました"
	end try
end if

-----Workspacesキャッシュクリア　Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theUserBridgeDir to path to application support folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPathCC & "/Support'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Bridge CC' '" & theTmpPathCC & "/Support'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if

-----Workspacesキャッシュクリア　Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theUserBridgeDir to path to application support folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2015 & "/Support'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Bridge CC 2015' '" & theTmpPath2015 & "/Support'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if

-----Workspacesキャッシュクリア　Bridge CC 2017 version 7 
if numVerChk2017 is 0 then
	try
		set theUserBridgeDir to path to application support folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2017 & "/Support'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Bridge CC 2017' '" & theTmpPath2017 & "/Support'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if

-----Commonクリア
try
	set theUserBridgeDir to path to application support folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPathCC & "/Common'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Common' '" & theTmpPathCC & "/Common'") as text
	do shell script theCommand
on error
	-----ここはエラー制御なし
end try

-----Preferencesクリア
try
	set theUserBridgeDir to path to preferences folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPathCC & "/Preferences'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Bridge' '" & theTmpPathCC & "/Preferences'") as text
	do shell script theCommand
on error
	-----ここはエラー制御なし
end try


-----plistクリア Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theUserBridgeDir to path to preferences folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPathCC & "/Preferences'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "com.adobe.bridge6.plist' '" & theTmpPathCC & "/Preferences'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if
-----plistクリア Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theUserBridgeDir to path to preferences folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2015 & "/Preferences'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "com.adobe.bridge6.3.plist' '" & theTmpPath2015 & "/Preferences'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if
-----plistクリア Bridge CC 2017 version 7 
if numVerChk2017 is 0 then
	try
		set theUserBridgeDir to path to preferences folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2017 & "/Preferences'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "com.adobe.bridge7.plist' '" & theTmpPath2017 & "/Preferences'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if

-----Cachesクリア Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theUserBridgeDir to path to library folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPathCC & "/Caches'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Caches/Adobe/Bridge CC' '" & theTmpPathCC & "/Caches'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if
-----Cachesクリア Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theUserBridgeDir to path to library folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2015 & "/Caches'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Caches/Adobe/Bridge CC 2015' '" & theTmpPath2015 & "/Caches'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if
-----Cachesクリア Bridge CC 2017 version 7
if numVerChk2017 is 0 then
	try
		set theUserBridgeDir to path to library folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2017 & "/Caches'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Caches/Adobe/Bridge CC 2017' '" & theTmpPath2017 & "/Caches'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if





-----Cachesクリア Bridge CC version 6.2
if numVerChk2013 is 0 then
	try
		set theUserBridgeDir to path to library folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPathCC & "/Caches'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Caches/com.adobe.bridge6' '" & theTmpPathCC & "/Caches'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if
-----Cachesクリア Bridge CC 2015 version 6.3 
if numVerChk2015 is 0 then
	try
		set theUserBridgeDir to path to library folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2015 & "/Caches'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Caches/com.adobe.bridge6.3' '" & theTmpPath2015 & "/Caches'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if
-----Cachesクリア Bridge CC 2017 version 7
if numVerChk2017 is 0 then
	try
		set theUserBridgeDir to path to library folder from user domain
		set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
		set theCommand to ("mkdir -p   '" & theTmpPath2017 & "/Caches'") as text
		do shell script theCommand
		set theCommand to ("mv -f  '" & theUserBridgeDir & "Caches/com.adobe.bridge7' '" & theTmpPath2017 & "/Caches'") as text
		do shell script theCommand
	on error
		-----ここはエラー制御なし
	end try
end if

-----temporary itemsクリア
try
	set theUserBridgeDir to path to temporary items
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPathCC & "/TemporaryItems'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe' '" & theTmpPathCC & "/TemporaryItems'") as text
	do shell script theCommand
on error
	-----ここはエラー制御なし
end try


-----temporary itemsクリア
try
	set theUserBridgeDir to path to temporary items
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPathCC & "/TemporaryItems'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe Output Module' '" & theTmpPathCC & "/TemporaryItems'") as text
	do shell script theCommand
on error
	-----ここはエラー制御なし
end try


---do shell script "defaults write com.apple.spaces spans-displays -bool true"





return "AOM(Adobe Output Module)のインストールが終了しました\rブリッジを起動させて出力パネルを確認してください\rテンポラリフォルダの中身は次回起動時に消去されます"


--------------------------------------------------#ここからサブルーチン
to doDateAndTIme(theDate)
	set y to (year of theDate)
	set m to my monthNumStr(month of theDate)
	set d to day of theDate
	set hms to time of theDate
	set hh to h of sec2hms(hms)
	set mm to m of sec2hms(hms)
	set ss to s of sec2hms(hms)
	return (y as text) & my zero1(m) & my zero1(d) & "_" & zero1(hh) & zero1(mm) & zero1(ss)
	return (y as text) & my zero1(m) & my zero1(d)
end doDateAndTIme

------------------------------
to monthNumStr(theMonth)
	set monList to {January, February, March, April, May, June, July, August, September, October, November, December}
	repeat with i from 1 to 12
		if item i of monList is theMonth then exit repeat
	end repeat
	return i
end monthNumStr
------------------------------
to sec2hms(sec)
	set ret to {h:0, m:0, s:0}
	set h of ret to sec div hours
	set m of ret to (sec - (h of ret) * hours) div minutes
	set s of ret to sec mod minutes
	return ret
end sec2hms
------------------------------
to zero1(n)
	if n < 10 then
		return "0" & n
	else
		return n as text
	end if
end zero1

