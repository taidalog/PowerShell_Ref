[CmdletBinding()]
param (
    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$true,
               Position=0,
               ParameterSetName="Path",
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to one or more locations.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Path
)


foreach ($p in $Path) {
    $convertedPath = Convert-Path -Path $p

    $source = Get-Content -Path $convertedPath -Encoding utf8

    $replacedString = $source.Replace('","', '|').Replace('"', '|')

    $replaceStrings = @()
    $replaceStrings += [PSCustomObject]@{s = 'ref'; r = '[ref]'}
    $replaceStrings += [PSCustomObject]@{s = 'dat'; r = '[DateTime]'}
    $replaceStrings += [PSCustomObject]@{s = 'val'; r = '.Value'}
    $replaceStrings += [PSCustomObject]@{s = '---'; r = '-'}
    $replaceStrings += [PSCustomObject]@{s = 'ooo'; r = '<span style="color: #ff0000">成功</span>'}
    $replaceStrings += [PSCustomObject]@{s = 'xxx'; r = '失敗'}
    $replaceStrings += [PSCustomObject]@{s = 'xme'; r = '失敗'}
    $replaceStrings += [PSCustomObject]@{s = 'xie'; r = '失敗'}
    $replaceStrings += [PSCustomObject]@{s = 'xpe'; r = '失敗'}
    $replaceStrings += [PSCustomObject]@{s = 'ne1'; r = '※1'}
    $replaceStrings += [PSCustomObject]@{s = 'ne2'; r = '※2'}

    foreach ($rep in $replaceStrings) {
        $replacedString = $replacedString.Replace($rep.s, $rep.r)
    }

    $originalExtension = [IO.Path]::GetExtension($convertedPath)
    $savePath = $convertedPath.Replace($originalExtension, '.md')

    $replacedString | Out-File -FilePath $savePath -Encoding utf8
}