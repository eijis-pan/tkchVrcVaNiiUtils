oscLineSender.ps1
====

標準入力から VaNiiMenu に OSCメッセージを送ることができる PowerShell スクリプト

## Description

VaNiiMenu の OSC受信機能を試すために PowerShell スクリプトで作成した Rug.Osc ライブラリの Wrapper です。

UDPで39972ポートに文字列を送信します。

動作確認環境
- Windows 10
- VaNiiMenu v0.10h beta（https://sabowl.sakura.ne.jp/gpsnmeajp/unity/vaniimenu/）

## Requirement

Rug.Osc ライブラリを使用します。（Copyright (C) 2013 Phill Tew (peatew@gmail.com)

https://bitbucket.org/rugcode/rug.osc）

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
- `powershell -command "Set-Executionpolicy remotesigned -s process -f;.¥oscLineSender.ps1"`

3. PowerShell コンソールから実行する
- PowerShell コンソールを起動します。
- cd コマンドでインストールディレクトリに移動します。
- 必要に応じて `Set-Executionpolicy remotesigned -s process -f` を実行してください。
- `[Reflection.Assembly]::LoadFrom("[配置したディレクトリのフルパス]¥Rug.Osc.dll")`
- `.¥oscLineSender.ps1`

## VS

go言語で実装された oscerコマンド を使った方が簡単かも

https://github.com/aike/oscer

## Author

github:[eijis](https://github.com/eijis-pan)  または twitter: @ eijis_pan

## Licence

[MIT Licence](https://github.com/eijis-pan/tkchVrcVaNiiUtils/LICENCE.txt) 

## Disclaimer

利用は自己責任でお願いします。
本プログラムは、なんの欠陥もないという無制限の保証を行うものではありません。
本プログラムに関する不具合修正や質問についてのお問い合わせもお受けできない場合があります。
本プログラムの利用によって生じたあらゆる損害に対して、一切の責任を負いません。
本プログラムの利用によって生じるいかなる問題についても、その責を負いません。
