
param (
    [Parameter(Mandatory = $true)]
    [int]$index
)

. .\bookmarks.ps1

$bookmarks = @()
$bookmarks += Import-FromJson

$bookmarks[$index].Reference++

$sortedBookmarks = $bookmarks | Sort-Object -Property Reference -Descending
Export-ToJson $sortedBookmarks

Start-Process $bookmarks[$index].Url
