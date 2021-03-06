# ObjectTrackingTest_blink
実験のご協力ありがとうございます．

下記の注意点をよく読んだうえでテストを受けてください．

## はじめに
本研究に協力していただける方は[同意書(Googleフォーム)](https://forms.gle/sBLxTezTzahiGHwu6 "https://forms.gle/sBLxTezTzahiGHwu6")の提出をお願いします．

## 必要なもの
- PCとマウス
- PCにProcessingが入ってない人は[ダウンロード](https://processing.org/download "https://processing.org/download")
- Minimライブラリを追加インストール
    
    Processing/librariesディレクトリで次のようにコマンド
    ```
    git clone https://github.com/ddf/Minim.git
    ```
    その他の方法:
        
    「スケッチ」→「ライブラリをインポート」→「ライブラリを追加」→ 
    検索窓で"minim"と検索してMinim (An audio library that provides easy to use classes for playback, recording, analysis, and synthesis of sound.) をinstall

## 実験手順
### <練習>

まずは実験内容を理解していただくためにテストの練習をしてもらいます．

__<<重要>>__
主なタスクは次の2つです．
- 画面内を動き回るオブジェクトをマウスカーソルで追跡してください(約1分間)
- テスト中はプログラムが指示するタイミングでまばたきしてください
    
    練習では音声と，画面左上にまばたきをする人のピクトグラムが提示されます．
    [![Image from Gyazo](https://i.gyazo.com/e7200720a82e22e39f1b79dae6e85ca1.jpg)](https://gyazo.com/e7200720a82e22e39f1b79dae6e85ca1)
    4回に1回違う音が鳴った時に，(提示されたまばたき動作と同じタイミングで)まばたきしてください．
    本番では音声のみが提示されます．

Practiceフォルダ内のPractice.pdeを(processing.exeで)開いて，再生ボタンをクリックしてください．

画面の指示にしたがってテストの練習をしてください．

オブジェクトの中心にマウスカーソルを3秒間合わせるとテストの練習が開始します．

5回行うと終了画面になりますが，慣れるまでさらに繰り返しても，早めに切り上げてもかまいません．

ただし，テストで行うタスクをしっかりと理解してください．
- - -
### <本番>
Testフォルダ内のTest.pdeを開いて，再生ボタンをクリックしてください．

本番は，1分間×5回のテストを受けた時点で終了となります．

__<<重要>>__
- 音声の提示のみを頼りに(4回に1回違う音が鳴ったタイミングで)まばたきをしてください
    
    **練習で画面左上に提示されたまばたき動作は，本番では提示されません**．
- できるだけ頑張ってオブジェクトを追跡してください
- 実験をはじめからやり直す場合は，生成されたsubject_XXフォルダをフォルダごと消去してください
- - -
### <データのアップロード>
Testフォルダ内に生成された「subject_XX」フォルダの「XX」の部分を自分の名前に変更してください．

例: 「subject_perry」

名前変更したフォルダの中にcsvファイルが5つ入っていることを確認して，フォルダごとサーバにアップしてください．

アップロード先: exchangeフォルダ下の utsumi/実験データ_ObjectTracking/

- - -
説明は以上です．

ここまで読んでいただきありがとうございます．
