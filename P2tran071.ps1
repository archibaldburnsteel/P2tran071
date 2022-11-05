<#
    .SYNOPSIS
        Creates MSP TRAN071 from passport csv
    .DESCRIPTION

    .PARAMETER NA

    .PARAMETER NA

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

    .NOTES
        Author:  A. S.
        Last Edit:  2022-11-04
        Version 1.0 - initial release
#>
$ErrorActionPreference = "stop"
Set-StrictMode -Version Latest

$p2List = @{}
$sb = [System.Text.StringBuilder]::new()
$content = Import-Csv -path "C:\blah\P2 BALANCE.csv" -Delimiter ","
$list = Import-csv -path "C:\Users\asolomon.WESTGATE\Downloads\SD INFO Testing Table Test V.3.csv" -Delimiter ","

foreach ($item in $list) {
    switch ($item.'LOAN NUMBER') {
        '0000104666' {break;}
        '0000106198' {break;}
        '0000108058' {break;}
        '0000109031' {break;}
        '0000110093' {break;}
        '0000112631' {break;}
        '0000114298' {break;}
        '0000104287' {break;}
        default {    $p2List.Add([int]$item.'loan number',0); break}
    }
    
}
$lnCOunt = [string]$p2list.Count
$sum = 0
$sb2 = [System.Text.StringBuilder]::new()
foreach ($rec in $content) {
    $ln = [int]$rec.'loan number'
    $total = ([decimal]$rec.'TOTAL MONTHLY PAYMENT') - ([decimal]$rec."SUSPENSE BALANCE")
    if ($total -lt 0) {$total = 0 }
    $total = ([int]($total * 100))
    $sum += $total
    if ($p2List.ContainsKey($ln)) {
        $sb.AppendLine('071830*' + " ".PadRight(7,' ') + $total.tostring("#000000000") + " ".PadRight(19,' ') + (Get-Date).ToString('MMddyy') + " ".PadRight(25,' ') + $total.tostring("#0000000") + " ".PadRight(9,' ') + $ln.ToString('#0000000000000'))
    }
}
$sb2.AppendLine('071830##751' + $lnCOunt.PadLeft(5,'0') + $sum.ToString('#000000000') +" ".PadRight(31,' ') + '2')
$sb2.Append($sb.tostring())
[IO.File]::WriteAllLines('C:\blah\tran071.txt', $sb2.ToString())