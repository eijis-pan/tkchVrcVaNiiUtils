oscLineSender.ps1
====

Overview

標準入力から VaNiiMenu に OSCメッセージを送ることができる PowerShell スクリプト

## Description

VaNiiMenu の OSC受信機能を試すために PowerShell スクリプトで作成した Rug.Osc ライブラリ の Wrapper です。
UDPで39972ポートに文字列を送信します。

動作確認環境
- Windows 10
- VaNiiMenu v0.10h beta（https://sabowl.sakura.ne.jp/gpsnmeajp/unity/vaniimenu/）

## Requirement

Rug.Osc ライブラリを使用します。（Copyright (C) 2013 Phill Tew (peatew@gmail.com)　https://bitbucket.org/rugcode/rug.osc）

## Install

- oscLineSender.ps1 と oscLineSender.bat をどこか適当なディレクトリにSJISで保存する
- Rug.Osc.dll を入手し上記と同じディレクトリに置く
- VaNiiMenu で受信機能を有効にする（ファイアウォールのブロックダイアログが出たら許可する）

## Usage

```
oscLineSender.ps1 -targetIpAddr=127.0.0.1 -targetUdpPort=39972 -oscAddr=/VaNiiMenu/Alert
```
（パラメタは省略可能です。例としてパラメタに指定している値が省略時のデフォルト値です。）

実行するためには
- Rug.Osc.dll がアセンブリを参照できる状態であること（簡単な方法としては実行するカレントディレクトリに配置すること）
- PowerShellスクリプト（.ps1 拡張子）のローカル実行を許可する設定がされていること
が必要です。

以下の３通りの方法があります。

1. バッチファイルを実行する（一番簡単な方法）
- oscLineSender.bat を実行する

2. コマンドプロンプト（cmd.exe）から実行する
- コマンドプロンプトを起動します。
- cd コマンドでインストールディレクトリに移動します。
- powershell -command "Set-Executionpolicy remotesigned -s process -f;.¥oscLineSender.ps1"

3. PowerShell コンソールから実行する
- PowerShell コンソールを起動します。
- cd コマンドでインストールディレクトリに移動します。
- 必要に応じて Set-Executionpolicy remotesigned -s process -f を実行してください。
- \[Reflection.Assembly]::LoadFrom("[配置したディレクトリのフルパス]¥Rug.Osc.dll")
- .¥oscLineSender.ps1

## Licence

[MIT](https://github.com/eijis-pan/tkchVrcVaNiiUtils/LICENCE.txt) Licence

## Author

github:[eijis](https://github.com/eijis-pan) 
twitter:[eijis_pan](https://twitter.com/eijis_pan)

## VS

go言語で実装された oscer を使った方が簡単かも
https://github.com/aike/oscer
