# =====================================================================
# Windows PowerShell Script: setup-wsl.ps1
# Purpose: Unattended install and configuration of WSL2 with Ubuntu
# =====================================================================

# --- CONFIGURATION SECTION ---
$WSLUser = "devuser"  # Change this if desired


$DistroName = "Ubuntu-24.04"
$Packages = @(
    "build-essential",
    "curl",
    "git",
    "wget",
    "vim",
    "docker.io",
    "docker-compose-v2"
)

# --- STEP 1: Enable WSL and Virtual Machine Platform ---
Write-Host "Enabling WSL and Virtual Machine Platform..." -ForegroundColor Cyan
wsl --status 2>$null
if ($LASTEXITCODE -ne 0) {
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-Host "WSL features enabled. Restart your computer if prompted." -ForegroundColor Yellow
}

# --- STEP 2: Set WSL2 as Default ---
Write-Host "Setting WSL2 as the default version..." -ForegroundColor Cyan
wsl --set-default-version 2

# --- STEP 3: Install Ubuntu if missing ---
$InstalledDistros = (wsl --list --online) -join "`n"
if ($InstalledDistros -match $DistroName) {
    Write-Host "$DistroName is available in WSL." -ForegroundColor Green
} else {
    Write-Host "Installing $DistroName..." -ForegroundColor Cyan
    wsl --install -d $DistroName --no-launch
    Write-Host "$DistroName installation triggered. This may take a few minutes..."
}

# --- STEP 4: Wait for installation completion ---
Write-Host "Waiting for WSL to be ready..."
Start-Sleep -Seconds 10
wsl --set-default-version 2
wsl --set-default $DistroName

# --- STEP 5: Create default user if needed ---
Write-Host "Configuring Ubuntu user..."
wsl -d $DistroName -- bash -c "if ! id -u $WSLUser >/dev/null 2>&1; then adduser --disabled-password --gecos '' $WSLUser && usermod -aG sudo $WSLUser; fi"
wsl -d $DistroName -- bash -c "echo '$WSLUser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
# wsl -d $DistroName -- bash -c "chsh -s /usr/bin/zsh $WSLUser"

# --- STEP 6: Update and install packages ---
Write-Host "Updating system and installing packages..." -ForegroundColor Cyan
$PkgList = $Packages -join " "
wsl -d $DistroName -- bash -c "sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install -y $PkgList"

# --- STEP 7: Configure environment ---
Write-Host "Setting up environment for $WSLUser..." -ForegroundColor Cyan
$EnvScript = @'
# Added by setup_wsl_env.ps1
export PATH=\$PATH:\$HOME/.local/bin
# alias ll='ls -alF'
# alias gs='git status'
'@
wsl -d $DistroName -- bash -c "echo '$EnvScript' >> /home/$WSLUser/.bashrc"

# --- STEP 8: Install GitHub CLI ---

# Prepare Bash script as a here-string (single-quoted)
$GithubCliScript = @'
sudo mkdir -p -m 755 /etc/apt/keyrings
out=$(mktemp)
wget -nv -O "$out" "https://cli.github.com/packages/githubcli-archive-keyring.gpg"
sudo cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
sudo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y
'@

# Remove Windows carriage returns
$GithubCliScript = $GithubCliScript -replace "`r",""

# Write the Bash script to a Windows temp file
$TempFile = "$env:TEMP\install_gh.sh"
Set-Content -Path $TempFile -Value $GithubCliScript -NoNewline

# Convert Windows path to WSL path
$DriveLetter = $TempFile.Substring(0,1).ToLower()
$WslPath = $TempFile.Substring(2) -replace '\\','/'
$WslTempPath = "/mnt/$DriveLetter$WslPath"

# Execute the script inside WSL
wsl -d $DistroName -- bash "$WslTempPath"

# --- STEP 9: Add user to docker group ---
wsl -d $DistroName -- bash -c "sudo groupadd docker"
wsl -d $DistroName -- bash -c "sudo usermod -aG docker $WSLUser"

# --- STEP 10: Done ---
Write-Host "`n✅ WSL2 Ubuntu environment is ready!"
Write-Host "User: $WSLUser"
Write-Host "Installed packages: $PkgList"

wsl -d $DistroName