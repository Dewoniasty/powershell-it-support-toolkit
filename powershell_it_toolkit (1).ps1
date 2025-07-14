# PowerShell IT Support Toolkit - Extended Version with Self-Service Portal

# 1. Reset password for all users in a specific OU
function Reset-ADPasswords {
    param(
        [string]$OU,
        [string]$NewPassword = "NewP@ssw0rd123"
    )
    Get-ADUser -SearchBase $OU -Filter * | ForEach-Object {
        Set-ADAccountPassword -Identity $_ -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $NewPassword -Force)
        Write-Output "Password reset for: $($_.SamAccountName)"
    }
}

# 2. List inactive devices from Intune (example placeholder, real one uses Graph API)
function Get-InactiveIntuneDevices {
    Write-Output "[!] This is a placeholder. Connect via MS Graph API to retrieve inactive devices."
    # Would use Microsoft.Graph.Intune module or MS Graph SDK here
}

# 3. Clear Teams/Zoom/Outlook cache
function Clear-AppCache {
    param([ValidateSet("Teams", "Zoom", "Outlook")][string]$App)

    switch ($App) {
        "Teams" {
            Remove-Item "$env:APPDATA\Microsoft\Teams\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Output "Teams cache cleared."
        }
        "Zoom" {
            Remove-Item "$env:APPDATA\Zoom\data\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Output "Zoom cache cleared."
        }
        "Outlook" {
            Remove-Item "$env:LOCALAPPDATA\Microsoft\Outlook\RoamCache\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Output "Outlook cache cleared."
        }
    }
}

# 4. Map network drives based on user group
function Map-NetworkDrives {
    $userGroups = (Get-ADUser $env:USERNAME -Properties MemberOf).MemberOf
    if ($userGroups -match "Finance") {
        New-PSDrive -Name F -PSProvider FileSystem -Root "\\server\finance" -Persist
    }
    if ($userGroups -match "HR") {
        New-PSDrive -Name H -PSProvider FileSystem -Root "\\server\hr" -Persist
    }
    Write-Output "Drives mapped based on AD group."
}

# 5. Install essential apps via Chocolatey
function Install-EssentialApps {
    $apps = @("googlechrome", "7zip", "notepadplusplus", "zoom")
    foreach ($app in $apps) {
        choco install $app -y
        Write-Output "$app installed."
    }
}

# 6. Self-Service App Installation Menu (20 most popular apps)
function Show-SelfServicePortal {
    $apps = @(
        @{Name="Google Chrome"; ID="googlechrome"},
        @{Name="Mozilla Firefox"; ID="firefox"},
        @{Name="7-Zip"; ID="7zip"},
        @{Name="Notepad++"; ID="notepadplusplus"},
        @{Name="Zoom"; ID="zoom"},
        @{Name="Slack"; ID="slack"},
        @{Name="VLC Player"; ID="vlc"},
        @{Name="Spotify"; ID="spotify"},
        @{Name="Microsoft Edge"; ID="microsoft-edge"},
        @{Name="Visual Studio Code"; ID="vscode"},
        @{Name="TeamViewer"; ID="teamviewer"},
        @{Name="Adobe Reader"; ID="adobereader"},
        @{Name="WinRAR"; ID="winrar"},
        @{Name="Git"; ID="git"},
        @{Name="FileZilla"; ID="filezilla"},
        @{Name="Steam"; ID="steam"},
        @{Name="Discord"; ID="discord"},
        @{Name="Python"; ID="python"},
        @{Name="Java JDK"; ID="jdk8"},
        @{Name="OBS Studio"; ID="obs-studio"}
    )

    Write-Host "Select an application to install:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $apps.Count; $i++) {
        Write-Host "$($i+1). $($apps[$i].Name)"
    }

    $choice = Read-Host "Enter number (1-$($apps.Count)) or 'q' to quit"
    if ($choice -eq 'q') { return }

    $index = [int]$choice - 1
    if ($index -ge 0 -and $index -lt $apps.Count) {
        $id = $apps[$index].ID
        choco install $id -y
        Write-Host "$($apps[$index].Name) installed."
    } else {
        Write-Host "Invalid selection."
    }
}

# 7. Clear NVRAM on macOS (requires admin rights and macOS environment)
function Clear-NVRAM {
    Write-Host "[!] This script is intended for macOS only."
    Write-Host "To reset NVRAM manually on macOS, restart and hold Option+Command+P+R."
    Write-Host "Automated NVRAM reset via script is not supported due to security restrictions."
}

# Example Usage
# Reset-ADPasswords -OU "OU=Users,DC=yourdomain,DC=com"
# Clear-AppCache -App Teams
# Map-NetworkDrives
# Install-EssentialApps
# Show-SelfServicePortal
# Clear-NVRAM
