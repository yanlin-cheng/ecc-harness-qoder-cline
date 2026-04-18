# ECC-Harness-Qoder-Cline - 安装脚本
# 功能：智能安装配置，备份已有配置，不会覆盖用户的现有配置

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('cline', 'qoder', 'all')]
    [string]$Editor = 'all',
    
    [Parameter(Mandatory=$false)]
    [ValidateSet('global', 'project')]
    [string]$Type = 'global',
    
    [Parameter(Mandatory=$false)]
    [string[]]$Components = @('rules', 'skills'),
    
    [switch]$Force,  # 是否强制覆盖（跳过备份，直接覆盖）
    [switch]$SkipBackup  # 是否跳过备份步骤
)

# ==================== 配置 ====================
$ErrorActionPreference = "Continue"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR
$BACKUP_DIR = "$env:TEMP\ecc-harness-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

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

# ==================== 备份函数 ====================
function Backup-ExistingFiles {
    param([string]$SourcePath, [string]$BackupPath)
    
    if (Test-Path $SourcePath) {
        Write-Info "发现已有配置，正在备份..."
        New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
        Copy-Item -Path $SourcePath -Destination $BackupPath -Recurse -Force
        $count = (Get-ChildItem $BackupPath -Recurse -File).Count
        Write-Success "已备份 $count 个文件到: $BackupPath"
        return $true
    }
    return $false
}

# ==================== 智能复制函数 ====================
function Install-Config {
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$ComponentName
    )
    
    Write-Host ""
    Write-Host "  处理 $ComponentName..." -ForegroundColor Yellow
    
    # 检查源目录是否存在
    if (-not (Test-Path $SourcePath)) {
        Write-Info "  源目录不存在: $SourcePath"
        return @{ New = 0; Skipped = 0; Errors = 0 }
    }
    
    # 获取源文件列表
    $sourceFiles = Get-ChildItem -Path $SourcePath -Recurse -File
    $newCount = 0
    $skippedCount = 0
    $errorCount = 0
    
    # 如果目标目录不存在，创建它
    if (-not (Test-Path $TargetPath)) {
        New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
        Write-Info "  已创建目录: $TargetPath"
    }
    
    # 遍历源文件
    foreach ($file in $sourceFiles) {
        $relativePath = $file.FullName.Substring($SourcePath.Length).TrimStart('\', '/')
        $targetFile = Join-Path $TargetPath $relativePath
        
        # 检查目标文件是否存在
        if ((-not $Force) -and (Test-Path $targetFile)) {
            Write-Info "  跳过（已存在）: $relativePath"
            $skippedCount++
        } else {
            try {
                # 确保目标目录存在
                $targetDir = Split-Path $targetFile -Parent
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                
                # 复制文件
                Copy-Item -Path $file.FullName -Destination $targetFile -Force
                Write-Info "  新增: $relativePath"
                $newCount++
            } catch {
                Write-Failed "  复制失败: $relativePath - $_"
                $errorCount++
            }
        }
    }
    
    # 输出统计
    Write-Host ""
    if ($newCount -gt 0) {
        Write-Success "  新增 $newCount 个 $ComponentName"
    }
    if ($skippedCount -gt 0) {
        Write-Info "  跳过 $skippedCount 个已有 $ComponentName"
    }
    if ($errorCount -gt 0) {
        Write-Failed "  $errorCount 个 $ComponentName 复制失败"
    }
    
    return @{ New = $newCount; Skipped = $skippedCount; Errors = $errorCount }
}

# ==================== 主安装流程 ====================
Write-Header "ECC-Harness-Qoder-Cline 安装程序"

# 显示配置信息
Write-Host "配置信息：" -ForegroundColor Cyan
Write-Host "  编辑器: $($Editor.ToUpper())"
Write-Host "  安装类型: $($Type.ToUpper())"
Write-Host "  组件: $($Components -join ', ')"
if ($Force) { Write-Host "  模式: 强制覆盖" -ForegroundColor Yellow }
else { Write-Host "  模式: 智能合并（保留已有配置）" -ForegroundColor Cyan }

# 询问确认（如果未使用 -Force）
if (-not $Force) {
    Write-Host ""
    $confirm = Read-Host "继续安装？ (Y/N)"
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Host "安装已取消" -ForegroundColor Yellow
        exit 0
    }
}

$totalInstalled = 0
$totalSkipped = 0
$backupInfo = @()

# ==================== 安装 Cline 配置 ====================
if ($Editor -eq 'cline' -or $Editor -eq 'all') {
    Write-Header "安装 Cline 配置"
    
    $paths = $ClinePaths[$Type]
    
    # 备份已有配置
    if (-not $SkipBackup -and -not $Force) {
        foreach ($component in $Components) {
            if ($paths.ContainsKey($component)) {
                $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
                if (Test-Path $targetPath) {
                    $backupPath = Join-Path $BACKUP_DIR "cline\$Type\$component"
                    Backup-ExistingFiles -SourcePath $targetPath -BackupPath $backupPath
                    $backupInfo += "Cline $Type $component -> $BACKUP_DIR"
                }
            }
        }
    }
    
    # 安装配置
    foreach ($component in $Components) {
        if ($paths.ContainsKey($component)) {
            $sourcePath = Join-Path $PROJECT_ROOT "configs\$component"
            $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
            
            if (Test-Path $sourcePath) {
                $result = Install-Config -SourcePath $sourcePath -TargetPath $targetPath -ComponentName "Cline $component"
                $totalInstalled += $result.New
                $totalSkipped += $result.Skipped
            }
        }
    }
}

# ==================== 安装 Qoder 配置 ====================
if ($Editor -eq 'qoder' -or $Editor -eq 'all') {
    Write-Header "安装 Qoder 配置"
    
    $paths = $QoderPaths[$Type]
    
    # 备份已有配置
    if (-not $SkipBackup -and -not $Force) {
        foreach ($component in $Components) {
            if ($paths.ContainsKey($component)) {
                $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
                if (Test-Path $targetPath) {
                    $backupPath = Join-Path $BACKUP_DIR "qoder\$Type\$component"
                    Backup-ExistingFiles -SourcePath $targetPath -BackupPath $backupPath
                    $backupInfo += "Qoder $Type $component -> $BACKUP_DIR"
                }
            }
        }
    }
    
    # 安装配置
    foreach ($component in $Components) {
        if ($paths.ContainsKey($component)) {
            $sourcePath = Join-Path $PROJECT_ROOT "configs\$component"
            $targetPath = $ExecutionContext.InvokeCommand.ExpandString($paths[$component])
            
            if (Test-Path $sourcePath) {
                $result = Install-Config -SourcePath $sourcePath -TargetPath $targetPath -ComponentName "Qoder $component"
                $totalInstalled += $result.New
                $totalSkipped += $result.Skipped
            }
        }
    }
}

# ==================== 安装完成 ====================
Write-Header "安装完成"

Write-Host "安装统计：" -ForegroundColor Cyan
Write-Host "  新增文件: $totalInstalled"
Write-Host "  跳过文件: $totalSkipped"

if ($backupInfo.Count -gt 0) {
    Write-Host ""
    Write-Host "备份信息：" -ForegroundColor Cyan
    Write-Host "  您的原有配置已备份到: $BACKUP_DIR"
    Write-Host "  如需恢复，请使用卸载脚本或手动复制备份文件"
}

Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Green
Write-Host "  1. 重启 VS Code (Cline) 或 Qoder"
Write-Host "  2. 检查配置是否生效"
Write-Host "  3. 如需卸载，运行: .\scripts\uninstall.ps1"

Write-Host ""
Write-Host "配置文件位置：" -ForegroundColor Cyan
if ($Editor -eq 'cline' -or $Editor -eq 'all') {
    Write-Host "  Cline Rules:   $env:USERPROFILE\Documents\Cline\Rules"
    Write-Host "  Cline Skills:  $env:USERPROFILE\.cline\skills"
}
if ($Editor -eq 'qoder' -or $Editor -eq 'all') {
    Write-Host "  Qoder Rules:   .qoder\rules"
    Write-Host "  Qoder Skills:  .qoder\skills"
}

Write-Host ""
