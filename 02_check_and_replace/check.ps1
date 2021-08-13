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
    $parentDirectoryName = Split-Path (Split-Path $convertedPath -Parent) -Leaf
    $savePath = Join-Path $PSScriptRoot "result_from_$($parentDirectoryName).csv"

    $result = . $convertedPath

    $result | 
        Select-Object `
            @{label="Pat"; expression={([int]$_.Pat).ToString().PadLeft(3)}},
            Var,
            Net,
            Nvl,
            Prf,
            Pdt,
            Arg,
            @{
                label='Res'; 
                expression={
                    if($_.Succeeded) {
                        if ($_.TypeAfter -eq 'PSReference`1' -and $_.ValueAfter -match '^.+00:00$') {
                            'ne1ne2'
                        } elseif ($_.TypeAfter -eq 'PSReference`1'){
                            'ne1'
                        } elseif ($_.ValueAfter -match '^.+00:00$') {
                            'ne2'
                        } elseif ($_.TypeAfter -eq 'DateTime') {
                            'ooo'
                        } else {
                            'ne?'
                        }
                    } else {
                        'xxx'
                    }
                }
            } | Export-Csv -LiteralPath $savePath -Encoding utf8 -Append -NoTypeInformation

    Write-Verbose "$($result.Pat)"
    Write-Verbose "$($result.ValueAfter)"
    Write-Verbose ("$($result.ValueAfter)" -in @('0001年1月1日 0:00:00', '0001年1月1日 0:00:00', '0001/01/01 0:00:00', '01/01/0001 00:00:00'))
    Write-Verbose ("$($result.ValueAfter)" -match '^.+00:00$')
}