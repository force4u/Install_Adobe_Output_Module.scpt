(*
AOM(Adobe Output Module)インストーラー
20151219　初回作成
20151221 一部修正
AOM(Adobe Output Module)のMac版は
解凍時のアクセス権の影響で
複数の人が同じ機器を利用する場合
インストールした人以外が出力パネルを利用出来ない（エラーになる）
インストールからアクセス権設定までを自動化して
トラブル防止用に作成した
業務用に作成した物を可読性を配慮して作り直した
アクセス権でstaffにフルアクセス権を付けている（ここは好みの問題）
*)

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
	set theCommand to ("curl -o '" & theTmpPath & "/AOM_Mac_New.zip' 'https://helpx.adobe.com/content/help/en/bridge/kb/install-output-module-bridge-cc/_jcr_content/main-pars/download_1/file.res/AOM_Mac_New.zip'") as text
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
	do shell script theCommand
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

-----キャッシュクリア
try
	set theUserBridgeDir to path to application support folder from user domain
	set theUserBridgeDir to (POSIX path of theUserBridgeDir) as text
	set theCommand to ("mv -f  '" & theUserBridgeDir & "Adobe/Bridge CC/Workspaces/!!-$$$AdobeOutputModule.workspace' '" & theTmpPath & "'") as text
	do shell script theCommand
on error
	-----ここはエラー制御なし
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

