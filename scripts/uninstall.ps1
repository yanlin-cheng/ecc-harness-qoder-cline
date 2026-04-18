# ECC-Harness-Qoder-Cline - 卸载脚本
# 功能：卸载安装的配置，可选择恢复到原始状态

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('cline', 'qoder', 'all')]
    [string]$Editor = 'all',
    
    [Parameter(Mandatory=$false)]
    [ValidateSet('global', 'project')]
    [string]$Type = 'global',
    
    [Parameter(Mandatory=$false)]
    [string[]]$Components = @('rules', 'skills'),
    
    [switch]$Restore,  # 是否从备份恢复原有配置
    [switch]$Clean,     # 完全清除（包括备份）
    [switch]$List      # 仅列出已安装的配置
)

# ==================== 配置 ====================
$ErrorActionPreference = "Continue"

# Cline 配置路径
$ClinePaths = @{
    global = @{
        rules    = "$env:USERPROFILE\Documents\Cline\Rules"
        skills   = "$env:USERPROFILE\.cline\skills"
        agents   = "$env:USERPROFILE\.cline\agents"
    }
    project = @{
        rules    = ".clinerules"
        skills   = ".cline\skills"
    }
}

# Qoder 配置路径
$QoderPaths = @{
    global = @{
        skills   = "$env:USERPROFILE\.qoder\skills"
    }
    project = @{
        rules    = ".qoder\rules"
        skills   = ".qoder\skills"
    }
}

# ==================== 颜色函数 ====================
function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "  $Message" -ForegroundColor Gray
}

function Write-Failed {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

# ==================== 列出已安装配置 ====================
function List-Installed {
    param([string]$Editor, [string]$Type, [string[]]$Components)
    
    Write-Header "已安装的配置"
    
    if ($Editor -eq 'cline' -or $Editor -eq 'all') {
        Write-Host "Cline 配置：" -ForegroundColor Yellow
        $paths = $ClinePaths[$Type]
        foreach ($component in $Components) {
            if ($paths.ContainsKey($component)) {
                $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
                if (Test-Path $targetPath) {
                    $files = Get-ChildItem -Path $targetPath -Recurse -File
                    Write-Success "  $component - $($files.Count) 个文件"
                    Write-Info "    位置: $targetPath"
                } else {
                    Write-Info "  $component - 未安装"
                }
            }
        }
    }
    
    if ($Editor -eq 'qoder' -or $Editor -eq 'all') {
        Write-Host ""
        Write-Host "Qoder 配置：" -ForegroundColor Yellow
        $paths = $QoderPaths[$Type]
        foreach ($component in $Components) {
            if ($paths.ContainsKey($component)) {
                $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
                if (Test-Path $targetPath) {
                    $files = Get-ChildItem -Path $targetPath -Recurse -File
                    Write-Success "  $component - $($files.Count) 个文件"
                    Write-Info "    位置: $targetPath"
                } else {
                    Write-Info "  $component - 未安装"
                }
            }
        }
    }
}

# ==================== 卸载配置 ====================
function Uninstall-Config {
    param(
        [string]$TargetPath,
        [string]$ComponentName
    )
    
    if (Test-Path $TargetPath) {
        try {
            Remove-Item -Path $TargetPath -Recurse -Force
            Write-Success "已卸载: $ComponentName"
            return $true
        } catch {
            Write-Failed "卸载失败: $ComponentName - $_"
            return $false
        }
    } else {
        Write-Info "未安装: $ComponentName"
        return $true
    }
}

# ==================== 恢复备份 ====================
function Restore-Backup {
    param([string]$BackupPath, [string]$TargetPath, [string]$ComponentName)
    
    if (Test-Path $BackupPath) {
        try {
            # 确保目标目录存在
            if (-not (Test-Path (Split-Path $TargetPath -Parent))) {
                New-Item -ItemType Directory -Path (Split-Path $TargetPath -Parent) -Force | Out-Null
            }
            
            # 恢复备份
            Copy-Item -Path $BackupPath -Destination $TargetPath -Recurse -Force
            $files = Get-ChildItem -Path $BackupPath -Recurse -File
            Write-Success "已恢复: $ComponentName ($($files.Count) 个文件)"
            return $true
        } catch {
            Write-Failed "恢复失败: $ComponentName - $_"
            return $false
        }
    } else {
        Write-Warning "未找到备份: $BackupPath"
        return $false
    }
}

# ==================== 主流程 ====================
Write-Header "ECC-Harness-Qoder-Cline 卸载程序"

# 查找最新的备份目录
$backupDirs = Get-ChildItem -Path $env:TEMP -Filter "ecc-harness-backup-*" -Directory -ErrorAction SilentlyContinue |
              Sort-Object LastWriteTime -Descending

if ($backupDirs) {
    $latestBackup = $backupDirs[0].FullName
    Write-Host "找到最新备份: $latestBackup" -ForegroundColor Cyan
}

# 仅列出模式
if ($List) {
    List-Installed -Editor $Editor -Type $Type -Components $Components
    exit 0
}

# 恢复模式
if ($Restore) {
    Write-Header "从备份恢复"
    
    if (-not $latestBackup) {
        Write-Failed "未找到备份目录，无法恢复"
        exit 1
    }
    
    $restored = $false
    if ($Editor -eq 'cline' -or $Editor -eq 'all') {
        $paths = $ClinePaths[$Type]
        foreach ($component in $Components) {
            if ($paths.ContainsKey($component)) {
                $backupPath = Join-Path $latestBackup "cline\$Type\$component"
                $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
                Restore-Backup -BackupPath $backupPath -TargetPath $targetPath -ComponentName "Cline $component"
                $restored = $true
            }
        }
    }
    
    if ($Editor -eq 'qoder' -or $Editor -eq 'all') {
        $paths = $QoderPaths[$Type]
        foreach ($component in $Components) {
            if ($paths.ContainsKey($component)) {
                $backupPath = Join-Path $latestBackup "qoder\$Type\$component"
                $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
                Restore-Backup -BackupPath $backupPath -TargetPath $targetPath -ComponentName "Qoder $component"
                $restored = $true
            }
        }
    }
    
    if ($restored) {
        Write-Host ""
        Write-Success "恢复完成！请重启编辑器。"
    }
    exit 0
}

# 卸载模式
Write-Host "操作模式: 卸载配置" -ForegroundColor Yellow
Write-Host "  编辑器: $($Editor.ToUpper())"
Write-Host "  安装类型: $($Type.ToUpper())"
Write-Host "  组件: $($Components -join ', ')"
Write-Host ""

if (-not $Clean) {
    $confirm = Read-Host "确认卸载？原有配置将无法恢复 (Y/N)"
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Host "卸载已取消" -ForegroundColor Yellow
        exit 0
    }
}

$uninstalled = $false

if ($Editor -eq 'cline' -or $Editor -eq 'all') {
    Write-Host ""
    Write-Host "Cline 配置：" -ForegroundColor Yellow
    $paths = $ClinePaths[$Type]
    foreach ($component in $Components) {
        if ($paths.ContainsKey($component)) {
            $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
            if (Uninstall-Config -TargetPath $targetPath -ComponentName "Cline $component") {
                $uninstalled = $true
            }
        }
    }
}

if ($Editor -eq 'qoder' -or $Editor -eq 'all') {
    Write-Host ""
    Write-Host "Qoder 配置：" -ForegroundColor Yellow
    $paths = $QoderPaths[$Type]
    foreach ($component in $Components) {
        if ($paths.ContainsKey($component)) {
            $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
            if (Uninstall-Config -TargetPath $targetPath -ComponentName "Qoder $component") {
                $uninstalled = $true
            }
        }
    }
}

# 清理备份
if ($Clean -and $latestBackup) {
    Write-Host ""
    Write-Host "清理备份目录..." -ForegroundColor Yellow
    Remove-Item -Path $latestBackup -Recurse -Force -ErrorAction SilentlyContinue
    Write-Success "备份已清理: $latestBackup"
}

Write-Host ""
if ($uninstalled) {
    Write-Success "卸载完成！请重启编辑器。"
} else {
    Write-Info "没有找到需要卸载的配置。"
}

Write-Host ""
Write-Host "提示：" -ForegroundColor Cyan
Write-Host "  - 如需恢复到原始状态，请使用: .\uninstall.ps1 -Restore"
Write-Host "  - 如需查看已安装配置，请使用: .\uninstall.ps1 -List"
