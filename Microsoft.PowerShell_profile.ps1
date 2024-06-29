#oh-my-posh.exe init pwsh | Invoke-Expression

# PSFzfの読み込みとAlias有効化
#Import-Module PSFzf
#Enable-PsFzfAliases
# ZLocationの読み込み
#Import-Module ZLocation

function Uniqueing {
    # Define a hash set in the begin block
    begin {
        $hashSet = @{}
    }
    
    # Process each input line
    process {
        if (-not $hashSet.ContainsKey($_)) {
            $hashSet[$_] = $true
            $_
        }
    }
}

Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
    $command = Get-Content (Get-PSReadlineOption).HistorySavePath | Uniqueing | fzf
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
}

# alias PSFzf (Enable-PsFzfAliases is very weight)
Set-Alias -Name fz -Value Invoke-FuzzyZLocation
Set-Alias -Name fh -Value Invoke-FuzzyHistory
Set-Alias -Name fd -Value Invoke-FuzzySetLocation
Set-Alias -Name fr -Value Invoke-PsFzfRipgrep

# alias
Set-Alias -Name e -Value explorer 

# bash key bind
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteChar
Set-PSReadLineKeyHandler -Key "Ctrl+w" -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key "Ctrl+u" -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Key "Ctrl+k" -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Key "Ctrl+a" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+e" -Function EndOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function ForwardChar
Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardChar
Set-PSReadLineKeyHandler -Key "Alt+f" -Function NextWord
Set-PSReadLineKeyHandler -Key "Alt+b" -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function PreviousHistory
Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function NextHistory