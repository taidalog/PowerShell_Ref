'"Pat","Var","Net","Nvl"' | Out-File -FilePath (Join-Path $PSScriptRoot '.\patterns8.csv') -Encoding utf8

foreach ($n in (1..8)) {
    $bin = [System.Convert]::ToString($n - 1, 2)
    $bin = ([int]$bin).ToString('000')
    $bin = '"' + $($bin.ToCharArray() -join '","') + '"'
    $bin = '"' + $n.ToString('000') + '",' + $bin
    $bin | Out-File -FilePath (Join-Path $PSScriptRoot '.\patterns8.csv') -Encoding utf8 -Append
}


'"Pat","Var","Net","Nvl","Prf","Pdt","Arg"' | Out-File -FilePath (Join-Path $PSScriptRoot '.\patterns64.csv') -Encoding utf8

foreach ($n in (1..64)) {
    $bin = [System.Convert]::ToString($n - 1, 2)
    $bin = ([int]$bin).ToString('000000')
    $bin = '"' + $($bin.ToCharArray() -join '","') + '"'
    $bin = '"' + ($n + 8).ToString('000') + '",' + $bin
    $bin | Out-File -FilePath (Join-Path $PSScriptRoot '.\patterns64.csv') -Encoding utf8 -Append
}
