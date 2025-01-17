function psFzf {
    $origin = [System.Console]::OutputEncoding
    $utf8 = [System.Text.Encoding]::GetEncoding("utf-8")
    $OutputEncoding = $utf8
    [System.Console]::OutputEncoding = $utf8
    $out = ($input | fzf.exe)
    [System.Console]::OutputEncoding = $origin
    return $out
}

$selection = .\list_bookmark.ps1 | psFzf

$index = $selection -replace '(\d+) \| .+', '$1'
.\execute_bookmark.ps1 -index $index
