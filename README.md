# powershell-it-support-toolkit

## Overview
This toolkit provides a set of PowerShell scripts used in enterprise environments for recurring IT support tasks. Designed for hybrid environments with Azure AD, Intune, and JAMF.

## Features
- Mass password reset for AD users
- Report inactive devices from Intune
- Clear cache for Zoom/Teams/Outlook
- Auto-mount network drives
- Install apps via Chocolatey

## Requirements
- PowerShell 5.x or later
- AzureAD module / Intune Graph API access

## Usage
```powershell
.\reset-user-passwords.ps1
