tkchVrcVaNiiUtils.bat
autoChangeTail.ps1
lineFilter.ps1
oscLineSender.ps1
====

VRChat のログファイルを監視し任意のイベントを検出すると
VaNiiMenu に OSCメッセージを送る一連の PowerShell スクリプトと起動バッチ 

## Description

tkchVrcVaNiiUtils.bat を実行すると
autoChangeTail.ps1、lineFilter.ps1、oscLineSender.ps1 が起動され
VRChat のログファイルを監視し任意のイベントを検出すると VaNiiMenu に通知します。

監視するイベントは
- アバター変更（Avatar change）
- インスタンスからの退出（OnPlayerLeft）
- リスポーン（Spawning）
です。

VRChat のログファイルに出力される内容を詳細に把握されている方であれば
lineFilter.ps1 を修正することで色々と通知内容を増やすことができると思います。

動作確認環境
- Windows 10
- VRChat w_2019.1.4p2
- VaNiiMenu v0.10h beta（https://sabowl.sakura.ne.jp/gpsnmeajp/unity/vaniimenu/）

## Requirement

Rug.Osc ライブラリを使用します。（Copyright (C) 2013 Phill Tew (peatew@gmail.com)

https://bitbucket.org/rugcode/rug.osc）

## Install

- tkchVrcVaNiiUtils.bat, autoChangeTail.ps1, lineFilter.ps1, oscLineSender.ps1 をどこか適当なディレクトリにSJISで保存する
- Rug.Osc.dll を入手し上記と同じディレクトリに置く
- VaNiiMenu で受信機能を有効にする（ファイアウォールのブロックダイアログが出たら許可する）

## Usage

コマンドラインまたはエクスプローラーからのダブルクリックで tkchVrcVaNiiUtils.bat を実行してください。
VRChat の起動前でも起動後でも構いません。最新のログファイルを検出します。

それぞれのファイルについての説明は、
- README_autoChangeTail.md （準備中）
- README_lineFilter.md （準備中）
- README_oscLineSender.md
を参照してください。

PowerShell なのに、わざわざ cmd.exe 経由で起動させてパイプで繋いでいる理由は、
1. PowerShell のパイプラインだとバッファされてしまい通知としてのリアルタイム性が失われるため
2. Rug.Osc.dll を相対パスでロードできるため
の2つです。

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
