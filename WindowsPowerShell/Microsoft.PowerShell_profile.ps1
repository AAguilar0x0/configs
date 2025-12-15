#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

#Import-Module posh-git
#Import-Module oh-my-posh
#Set-PoshPrompt -Theme clean-detailed
#oh-my-posh --init --shell pwsh --config ~\AppData\Local\Programs\oh-my-posh\themes\clean-detailed.omp.json | Invoke-Expression
oh-my-posh --init --shell pwsh --config "D:\Library\Desktop\repo\Other\configs\clean-detailed.omp.json" | Invoke-Expression

#Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
# Chocolatey profile
#$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#  Import-Module "$ChocolateyProfile"
#}
