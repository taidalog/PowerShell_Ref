Set-StrictMode -Version Latest

$parameterPatterns = Import-Csv -Path (Join-Path $PSScriptRoot 'patterns8.csv') -Encoding UTF8

foreach ($pp in $parameterPatterns) {
    
    $scriptName = "TestByRef_method_$($pp.Pat)"

    # 変数
    if ($pp.Var -eq '1') {
        $str1 = '[ref]'
    } else {
        $str1 = ''
    }

    # .NET
    if ($pp.Net -eq '1') {
        $str2 = '[ref]'
    } else {
        $str2 = ''
    }
    
    # .NET .Value
    if ($pp.Nvl -eq '1') {
        $str3 = '.Value'
    } else {
        $str3 = ''
    }
    

$fnc = '# ' + $pp.Pat + '

' + $str1 + '$parsedDateTime = [DateTime]::MinValue

$resultList = [PSCustomObject]@{
    Pat = "' + $pp.Pat + '"
    Var = ' + "$(if ($pp.Var -eq '1') {'"ref"'} else {'"---"'})" + '
    Net = ' + "$(if ($pp.Net -eq '1') {'"ref"'} else {'"---"'})" + '
    Nvl = ' + "$(if ($pp.Nvl -eq '1') {'"val"'} else {'"---"'})" + '
    TypeBefore = $parsedDateTime.GetType().Name
    ValueBefore = $null
    Error = $null
    TypeAfter = $null
    ValueAfter = $null
    Succeeded = $null
}

if ($resultList.TypeBefore -eq "DateTime") {
    $resultList.ValueBefore = $parsedDateTime.DateTime
} elseif ($resultList.TypeBefore -eq ''PSReference`1'') {
    $resultList.ValueBefore = $parsedDateTime.Value
}

try {
    $resultList.Succeeded = [DateTime]::TryParseExact(
        "2021-08-11 12-34-56",
        "yyyy-MM-dd HH-mm-ss",
        [System.Globalization.DateTimeFormatInfo]::InvariantInfo,
        [System.Globalization.DateTimeStyles]::None,
        ' + $str2 + '$parsedDateTime' + $str3 + '
    )
} catch {
    $resultList.Error = $Error[0].CategoryInfo.Reason
}

$resultList.TypeAfter = $parsedDateTime.GetType().Name

if ($resultList.TypeAfter -eq "DateTime") {
    $resultList.ValueAfter = $parsedDateTime.DateTime
} elseif ($resultList.TypeAfter -eq ''PSReference`1'') {
    $resultList.ValueAfter = $parsedDateTime.Value
}

$resultList

"|$($resultList.Pat)|$($resultList.Var)|$($resultList.Net)|$($resultList.Nvl)|$($resultList.Succeeded)|" | 
    Out-File -FilePath (Join-Path (Split-Path $PSScriptRoot -Parent) "result\result_from_method.md") -Encoding UTF8 -Append

$null = $parsedDateTime
Remove-Variable -Name parsedDateTime -Force

$null = $resultList
Remove-Variable -Name resultList -Force'

    $fnc | Out-File -FilePath (Join-Path (Split-Path $PSScriptRoot -Parent) "method\$($scriptName).ps1") -Encoding UTF8
}