(*
AOM(Adobe Output Module)インストーラー
20151219　初回作成
20151221 一部修正
20151224 ログ表示部修正
20151225　sudoの一部誤り訂正
20160510　Adobeのサーバー側のリダイレクトに対応
20160517　キャッシュの削除を含めて初期化する処理に変更
20160529 Reset_Adobe_Output_Module_BridgeCC.scptに名称変更
20160831	ダウンロードファイルの変更に対応
【ポイント】
一部の環境（Bridge CS6版とBridge CC版を併用する方）で発生する
出力パネルの『I/oエラー』が発生する場合
このスクリプトを実行すると解決する事があります。（必ずではないですが…）

【留意事項】
一部初期設定等をリセットします。
設定等をリセットしないインストールだけの場合は
こちら
http://force4u.cocolog-nifty.com/skywalker/2016/05/bridgeccaomadob.html
を利用してください

AOM(Adobe Output Module)のMac版は
解凍時のアクセス権の影響で
複数の人が同じ機器を利用する場合
インストールした人以外が出力パネルを利用出来ない（エラーになる）
インストールからアクセス権設定までを自動化して
トラブル防止用に作成した
業務用に作成した物を可読性を配慮して作り直した
アクセス権でstaffにフルアクセス権を付けている（ここは好みの問題）
Bridge Help / Install Adobe Output Module 
Install the Adobe Output Module for Bridge CC 6.2
https://helpx.adobe.com/bridge/kb/install-output-module-bridge-cc.html
詳しくはこちら
http://force4u.cocolog-nifty.com/skywalker/2015/12/aomadobe-output.html

AdobeOutputModule.jsx
DateTime: 2008/04/10
Adobe Output Module 4.0
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

---日付けと時間からテンポラリー用のフォルダ名を作成
set theNowTime to (my doDateAndTIme(current date)) as text
---テンポラリー用フォルダのパスを定義
set theTrashDir to ("/tmp/" & theNowTime) as text


-----テンポラリーフォルダを作成
try
	set theCommand to ("mkdir -pv " & theTrashDir) as text
	do shell script theCommand
	set theTmpPath to theTrashDir as text
	delay 1
on error
	return "テンポラリフォルダ作成でエラーが発生しました"
end try

-----ファイルをダウンロード
try
	---旧URL
	---set theCommand to ("curl -L -o '" & theTmpPath & "/AOM_Mac_New.zip' 'https://helpx.adobe.com/content/help/en/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_1/file.res/AOM_Mac_New.zip'") as text
	---20160831新URL
	set theCommand to ("curl -L -o '" & theTmpPath & "/AOM_Mac_New.zip' 'https://helpx.adobe.com/content/help/en/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_section_393125832/download-3/file.res/AOM_Mac_New.zip'") as text
	do shell script theCommand
	delay 1
on error
	return "ダウンロードでエラーが発生しました"
end try
-----ファイルを解凍
try
	set theCommand to ("unzip  '" & theTmpPath & "/AOM_Mac_New.zip' -d '" & theTmpPath & "'") as text
	do shell script theCommand
	delay 1
on error
	return "ファイルの解凍でエラーが発生しました"
end try
-----インストール先のフォルダを確保
try
	set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
	do shell script theCommand with administrator privileges
	set theCommand to ("sudo mkdir -p '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces'") as text
	do shell script theCommand with administrator privileges
on error
	----ここはエラー制御無しで
end try
-----ワークススペースファイルを移動（おきかえ）
try
	set theCommand to ("sudo mv -f '" & theTmpPath & "/AOM_Mac/AdobeOutputModule.workspace' '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces'") as text
	do shell script theCommand with administrator privileges
on error
	---ここはエラー制御無しでOKかな
end try
-----モジュールを移動（エラーしたら削除してから新しいファイルを移動）
try
	set theCommand to ("sudo mv -f '" & theTmpPath & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
	do shell script theCommand with administrator privileges
on error
	set theCommand to ("sudo mv -f  '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module' '" & theTmpPath & "'") as text
	do shell script theCommand with administrator privileges
	set theCommand to ("sudo mv -f '" & theTmpPath & "/AOM_Mac/Adobe Output Module' '/Library/Application Support/Adobe/Bridge CC Extensions'") as text
	do shell script theCommand with administrator privileges
end try
-----アクセス権を修正775(アクセス権は好みで）
try
	set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module'") as text
	do shell script theCommand with administrator privileges
	set theCommand to ("sudo chgrp  -Rf staff '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module'") as text
	do shell script theCommand with administrator privileges
	set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC Extensions/Adobe Output Module'") as text
	do shell script theCommand with administrator privileges
on error
	return "アクセス権修正でエラーが発生しました"
end try
-----アクセス権を修正775(アクセス権は好みで）
try
	set theCommand to ("sudo chown -Rf root  '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces/AdobeOutputModule.workspace'") as text
	do shell script theCommand with administrator privileges
	set theCommand to ("sudo chgrp  -Rf staff '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces/AdobeOutputModule.workspace'") as text
	do shell script theCommand with administrator privileges
	set theCommand to ("sudo chmod  -Rf 775 '/Library/Application Support/Adobe/Bridge CC Extensions/Workspaces/AdobeOutputModule.workspace'") as text
	do shell script theCommand with administrator privileges
on error
	return "アクセス権修正でエラーが発生しました"
end try

-----Workspacesキャッシュクリア
try
	set theUserBridgeDir to path to application support folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPath & "/Support'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Bridge CC' '" & theTmpPath & "/Support'") as text
	do shell script theCommand
on error
	log "Workspacesキャッシュがありませんでした"
end try

-----Commonクリア
try
	set theUserBridgeDir to path to application support folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPath & "/Common'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Common' '" & theTmpPath & "/Common'") as text
	do shell script theCommand
on error
	log "Commonキャッシュがありませんでした"
end try

-----Preferencesクリア
try
	set theUserBridgeDir to path to preferences folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPath & "/Preferences'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Bridge' '" & theTmpPath & "/Preferences'") as text
	do shell script theCommand
on error
	log "Preferencesディレクトリがありませんでした"
end try

-----plistクリア
try
	set theUserBridgeDir to path to preferences folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPath & "/Preferences'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "com.adobe.bridge6.plist' '" & theTmpPath & "/Preferences'") as text
	do shell script theCommand
on error
	log "plistがありませんでした"
end try



-----Cachesクリア
try
	set theUserBridgeDir to path to library folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPath & "/Caches'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Caches/Adobe' '" & theTmpPath & "/Caches'") as text
	do shell script theCommand
on error
	log "Cachesがありませんでした"
end try

-----temporary itemsクリア
try
	set theUserBridgeDir to path to temporary items
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPath & "/TemporaryItems'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe' '" & theTmpPath & "/TemporaryItems'") as text
	do shell script theCommand
on error
	log "temporary Adobeがありませんでした"
end try


-----temporary itemsクリア
try
	set theUserBridgeDir to path to temporary items
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mkdir -p   '" & theTmpPath & "/TemporaryItems'") as text
	do shell script theCommand
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe Output Module' '" & theTmpPath & "/TemporaryItems'") as text
	do shell script theCommand
on error
	log "temporary　Adobe Output Moduleがありませんでした"
end try




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

