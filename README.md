# PowerShell_Ref
PowerShell scripts to study how to use [ref] to call .NET method

1. .\01_create_all_patterns\make_patterns.ps1 で組み合わせの CSV ファイルを作る  
    - patterns64.csv は function, scriptblock 用  
    - patterns8.csv  は method 用
1. CSV ファイルを元に .\01_create_all_patterns\copyTestByRef_function.ps1 で検証用のスクリプトを作る
1. .\02_check_and_replace\check.ps1 で検証用のスクリプトを全て実行し、結果を .\02_check_and_replace\result_from_function.csv に出力する
1. .\02_check_and_replace\replace.ps1 で 結果の CSV を Markdown に変換する
1. Markdown に |:-:| を追加する
1. scriptblock と method でも2以降を行う  
    method は .\02_check_and_replace\check_method.ps1 を使う

result フォルダは途中から使うのをやめた。