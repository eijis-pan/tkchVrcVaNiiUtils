autoChangeTail.ps1
====

ディレクトリパスとファイル名パターンを指定し、最も新しい作成日付のファイルを監視して標準出力する PowerShell スクリプト

## Description

unix系のosでは tail -f でログファイルへ追加出力される内容を表示し続けることができます。<br>
PowerShellでも Get-Content -Wait -Tail 0 で同等のことが可能です。<br>
どちらも１つのファイルを指定する必要がありますが、これに加え<br>
本スクリプトはディレクトリのパスとファイル名のパターンを指定することで<br>
最新の該当ファイルが作成されると切り替わります。<br>
また、該当ファイルがない状態からでも起動しておくことができます。

動作確認環境
- Windows 10

## Install

- autoChangeTail.bat, autoChangeTail.ps1 をどこか適当なディレクトリにSJISで保存する

## Usage

```
autoChangeTail.ps1 -path $pwd -filter *.*
```
（パラメタは省略可能です。例としてパラメタに指定している値が省略時のデフォルト値です。）

```
autoChangeTail.ps1 -quiet
```
write-host への出力を抑止<br>
-quiet を指定するとメッセージが出力されなくなり、ファイルへ追加出力される内容のみになります。

実行するためには
- PowerShellスクリプト（.ps1 拡張子）のローカル実行を許可する設定がされていること

が必要です。

以下の３通りの方法があります。

1. バッチファイルを実行する（一番簡単な方法）
- autoChangeTail.bat を実行する

2. コマンドプロンプト（cmd.exe）から実行する
- コマンドプロンプトを起動します。
- cd コマンドでインストールディレクトリに移動します。
- `powershell -command "Set-Executionpolicy remotesigned -s process -f;.¥autoChangeTail.ps1"`

3. PowerShell コンソールから実行する
- PowerShell コンソールを起動します。
- cd コマンドでインストールディレクトリに移動します。
- 必要に応じて `Set-Executionpolicy remotesigned -s process -f` を実行してください。
- `.¥autoChangeTail.ps1`

## Author

github:[eijis](https://github.com/eijis-pan)  または twitter: @ eijis_pan

## Licence

[MIT Licence](https://github.com/eijis-pan/tkchVrcVaNiiUtils/LICENCE.txt) 

## Disclaimer

利用は自己責任でお願いします。<br>
本プログラムは、なんの欠陥もないという無制限の保証を行うものではありません。<br>
本プログラムに関する不具合修正や質問についてのお問い合わせもお受けできない場合があります。<br>
本プログラムの利用によって生じたあらゆる損害に対して、一切の責任を負いません。<br>
本プログラムの利用によって生じるいかなる問題についても、その責を負いません。
