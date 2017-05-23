# CandleTrailing
ローソク足の中で現在の価格が割安なのか、割高なのかを判定するためのロジック   


## Description
このロジックはまずはじめに、ローソク足の形成をX%待ちます。   
例えば日足チャートで50%待つ設定であれば、半日待つことになります。   
1時間足で50%であれば30分です。   
   
待ち時間が終了すると、その時点でのローソク足の高値と安値を記録します。   
この時の高値より高い価格で売りシグナル、安値より安い価格で買いシグナルを発生させることを目指したロジックです。   
   
しかしこの高値・安値はまだ更新していく可能性があるため、高値超え・安値割りだけでシグナルを発生させると、より良い価格でのエントリーを逃してしまいます。   
そこでトレーリングストップの方法を使用し、高値・安値を更新する毎に、シグナル発生の価格を更新していきます。   
高値・安値の更新から、Ypipsだけ逆行するとシグナルを発生させる仕組みとなっています。   
（逆光時の価格は待ち時間終了時の高値・安値よりも有利な価格であるのが条件）


## Install
- CandleTrailing.mqhをダウンロード
- /MQL4/Includesの中に保存


## Usage
ヘッダーファイルを読み込む   
`#include <CandleTrailing.mqh>`

インスタンスを作成する。   
コンストラクタの第一引数はトレーリング幅（pips）、第二引数は待機時間の割合（％）。    

    CandleTrailing *CT;
    
    int OnInit()
    {
       CT = new CandleTrailing(1, 50);
    
       return(INIT_SUCCEEDED);
    }


判定を受け取り、結果に応じて処理を実行する。   
0: シグナル無し, 1: 買い, -1: 売り    
`int signal = CT.Signal();`
