# PowerShell IT Support Toolkit - Sample Scripts

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

# Run examples
# Reset-ADPasswords -OU "OU=Users,DC=yourdomain,DC=com"
# Clear-AppCache -App Teams
# Map-NetworkDrives
# Install-EssentialApps