
. .\bookmarks.ps1

$bookmarks = @()
$bookmarks += Import-FromJson -FilePath "bookmarks.json"

$index = 0

$bookmarksString = @()

foreach ($bookmark in $bookmarks) {
    $url = $bookmark.Url
    $title = $bookmark.Title
    $reference = $bookmark.Reference

    #Write-Host "$index | $title | $url | $reference"
    $bookmarksString += "$index | $title | $url | $reference"
    $index++
}

$bookmarksString

