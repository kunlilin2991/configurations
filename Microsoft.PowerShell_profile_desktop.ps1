# ========== 权限设置 ==========
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# ========== Oh My Posh 纯文本主题（永不报错） ==========
oh-my-posh init pwsh --config "$env:USERPROFILE\.oh-my-posh\themes\pure.omp.json" | Invoke-Expression


# ========== Git 支持 ==========
Import-Module posh-git

# ========== 关闭文件图标（按你要求） ==========
Remove-Module Terminal-Icons -ErrorAction SilentlyContinue

# ========== 命令补全 ==========
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# ========== 🔥 完整 Linux 命令兼容 ==========
function ls { Get-ChildItem @args }
function ll { Get-ChildItem -l @args }
function la { Get-ChildItem -Force @args }
function pwd { $PWD.Path }
function cat { Get-Content @args }
function touch { New-Item -ItemType File @args }
function mkdir { New-Item -ItemType Directory @args }
function rm { Remove-Item @args }
function cp { Copy-Item @args }
function mv { Move-Item @args }
function grep { Select-String @args }
function clear { Clear-Host }
function ps { Get-Process @args }
function kill { Stop-Process @args }
function head { Get-Content -Head 10 @args }
function tail { Get-Content -Tail 10 @args }
function wget { Invoke-WebRequest @args }
function which { Get-Command @args }