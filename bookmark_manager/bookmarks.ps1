$global:FilePath = "c:\temp\bookmarks.json"

function New-Bookmark {
    param (
        [string]$Url,
        [string]$Title
    )
    
    $newBookmark = [PSCustomObject]@{
        Url       = $Url
        Title     = $Title
        Reference = 0
    }
    
    return $newBookmark
}

# Export bookmarks to a JSON file
function Export-ToJson {
    param (
        [array]$bookmarks
    )
    $bookmarksJson = $bookmarks | ConvertTo-Json -Depth 2
    $bookmarksJson | Out-File -FilePath $global:FilePath -Encoding UTF8
}

# Function to import bookmarks from a JSON file
function Import-FromJson {
    $bookmarks = @()

    if (Test-Path $global:FilePath) {
        $jsonData =
        Get-Content -Path $global:FilePath -Raw | ConvertFrom-Json
        foreach ($row in $jsonData) {
            $bookmark = [PSCustomObject]@{
                Url       = $row.Url
                Title     = $row.Title
                Reference = $row.Reference
            }
            $bookmarks += $bookmark
        }
    }

    return $bookmarks
}

function Get-UrlTitle {
    param (
        [string]$Url
    )

    try {
        $response = Invoke-WebRequest -Uri $Url
        $html = $response.ParsedHtml
        $title = $html.getElementsByTagName("title")[0].innerHtml
    }
    catch {
        $title = "No title"
    }
    return $title
}