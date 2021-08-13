# 036

function TestByRef_function_036 {
    param (
        [DateTime]
        $Result
    )

    [DateTime]::TryParseExact(
        '2021-08-11 12-34-56',
        'yyyy-MM-dd HH-mm-ss',
        [System.Globalization.DateTimeFormatInfo]::InvariantInfo,
        [System.Globalization.DateTimeStyles]::None,
        [ref]$Result.Value
    )
}


$parsedDateTime = [DateTime]::MinValue

$resultList = [PSCustomObject]@{
    Pat = "036"
    Var = "---"
    Net = "ref"
    Nvl = "val"
    Prf = "---"
    Pdt = "dat"
    Arg = "ref"
    TypeBefore = $parsedDateTime.GetType().Name
    ValueBefore = $null
    Error = $null
    TypeAfter = $null
    ValueAfter = $null
    Succeeded = $null
}

if ($resultList.TypeBefore -eq "DateTime") {
    $resultList.ValueBefore = $parsedDateTime.DateTime
} elseif ($resultList.TypeBefore -eq 'PSReference`1') {
    $resultList.ValueBefore = $parsedDateTime.Value
}

try {
    $resultList.Succeeded = TestByRef_function_036 ([ref]$parsedDateTime)
} catch {
    $resultList.Error = $Error[0].CategoryInfo.Reason
}

$resultList.TypeAfter = $parsedDateTime.GetType().Name

if ($resultList.TypeAfter -eq "DateTime") {
    $resultList.ValueAfter = $parsedDateTime.DateTime
} elseif ($resultList.TypeAfter -eq 'PSReference`1') {
    $resultList.ValueAfter = $parsedDateTime.Value
}

$resultList

"|$($resultList.Pat)|$($resultList.Var)|$($resultList.Net)|$($resultList.Nvl)|$($resultList.Prf)|$($resultList.Pdt)|$($resultList.Arg)|$($resultList.Succeeded)|" | 
    Out-File -FilePath (Join-Path (Split-Path $PSScriptRoot -Parent) "result\result_from_function.md") -Encoding UTF8 -Append

$null = $parsedDateTime
Remove-Variable -Name parsedDateTime -Force

$null = $resultList
Remove-Variable -Name resultList -Force
