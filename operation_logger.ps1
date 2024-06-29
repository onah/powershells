Add-Type @"
using System;
using System.Runtime.InteropServices;
public class User32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);
}
"@

function Get-ForegroundWindowTitle {
    $hwnd = [User32]::GetForegroundWindow()
    if ($hwnd -eq [IntPtr]::Zero) {
        return "No window is currently focused."
    }
    $title = New-Object -TypeName System.Text.StringBuilder -ArgumentList 256
    [User32]::GetWindowText($hwnd, $title, $title.Capacity) | Out-Null
    return $title.ToString()
}

# ログファイルの格納場所を指定
$logDirectory = "C:\Logs"

# 待ち時間を変数に設定（秒単位）
$intervalSeconds = 30

# 古いログファイルを削除
$thresholdDate = (Get-Date).AddMonths(-1)
Get-ChildItem -Path $logDirectory -Filter "ope_*.log" | Where-Object { $_.LastWriteTime -lt $thresholdDate } | Remove-Item

# ディレクトリが存在しない場合は作成
if (-not (Test-Path -Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory
}

# 変数を初期化
$previousWindowTitle = ""

# Windows Formsの使用
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# コンテキストメニューの作成
$contextMenu = New-Object System.Windows.Forms.ContextMenu
$exitMenuItem = New-Object System.Windows.Forms.MenuItem("Exit")
$exitMenuItem.Add_Click({ $notifyIcon.Dispose(); [System.Windows.Forms.Application]::Exit() })
$contextMenu.MenuItems.Add($exitMenuItem)

# アイコンの設定
$notifyIcon = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Icon = [System.Drawing.SystemIcons]::Application
$notifyIcon.ContextMenu = $contextMenu
$notifyIcon.Visible = $true

# タスクトレイアイコンのバルーンヒント
$notifyIcon.ShowBalloonTip(1000, "Window Focus Logger", "The script is running and monitoring the focused window.", [System.Windows.Forms.ToolTipIcon]::Info)

# タスクの実行
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $intervalSeconds * 1000
$timer.Add_Tick({
        $currentDate = Get-Date -Format "yyyyMMdd"
        $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $windowTitle = Get-ForegroundWindowTitle

        if ($windowTitle -ne $previousWindowTitle) {
            $logEntry = "$currentDateTime - The title of the currently focused window is: $windowTitle"
        
            $logFileName = Join-Path -Path $logDirectory -ChildPath "ope_$currentDate.log"
            Add-Content -Path $logFileName -Value $logEntry

            $previousWindowTitle = $windowTitle
        }
    })
$timer.Start()

# フォームの作成と表示
$form = New-Object System.Windows.Forms.Form
$form.WindowState = 'Minimized'
$form.ShowInTaskbar = $false
$form.Add_Shown({ $form.Hide() })
[System.Windows.Forms.Application]::Run($form)
