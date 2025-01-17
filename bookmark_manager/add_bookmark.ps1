
param (
    [Parameter(Mandatory = $true)]
    [string]$url
)

. .\bookmarks.ps1

$bookmarks = @()
$bookmarks += Import-FromJson

$duplication = Where-Object { $_.Url -eq $url } -InputObject $bookmarks
if ($duplication) {
    Write-Host "Bookmark already exists"
    exit
}

$title = Get-UrlTitle -Url $url
$bookmarks += New-Bookmark -Url $url -Title $title

Export-ToJson $bookmarks
