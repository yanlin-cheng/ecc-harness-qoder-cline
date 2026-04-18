# Deep Stack Cline Config - 同步脚本
# 使用方法：.\scripts\sync.ps1
# 功能：从 ECC 仓库拉取最新配置并同步到 Cline

$ErrorActionPreference = "Stop"

# 配置路径
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR
$ECC_ROOT = "$PROJECT_ROOT\..\everything-claude-code"
$CLINE_RULES = "$env:USERPROFILE\Documents\Cline\Rules"
$CLINE_SKILLS = "$env:USERPROFILE\.cline\skills"
$CLINE_HOOKS = "$env:USERPROFILE\Documents\Cline\Hooks"

# 颜色输出函数
function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

# 开始同步
Write-Header "同步 ECC 配置"

# 检查 ECC 目录是否存在
if (-not (Test-Path $ECC_ROOT)) {
    Write-Host "错误：ECC 仓库不存在 - $ECC_ROOT" -ForegroundColor Red
    Write-Host "请先运行安装脚本：.\scripts\install.ps1" -ForegroundColor Yellow
    exit 1
}

# 更新 ECC 仓库
Write-Host "更新 ECC 仓库..." -ForegroundColor Yellow
Set-Location $ECC_ROOT
git fetch origin
$currentBranch = git branch --show-current
git checkout $currentBranch
git pull origin $currentBranch
Write-Success "ECC 仓库已更新"

# 同步 Rules
Write-Host "同步 Rules..." -ForegroundColor Yellow
xcopy "$ECC_ROOT\rules\common" $CLINE_RULES /E /I /Y | Out-Null
$rulesCount = (Get-ChildItem $CLINE_RULES -File).Count
Write-Success "已同步 $rulesCount 个规则文件"

# 同步 Skills
Write-Host "同步 Skills..." -ForegroundColor Yellow
$skills = @("search-first", "tdd-workflow", "git-workflow")
foreach ($skill in $skills) {
    if (Test-Path "$ECC_ROOT\skills\$skill") {
        xcopy "$ECC_ROOT\skills\$skill" "$CLINE_SKILLS\$skill" /E /I /Y | Out-Null
        Write-Host "  已同步：$skill" -ForegroundColor Gray
    }
}
Write-Success "已同步 3 个技能"

# 同步 Hooks
Write-Host "同步 Hooks..." -ForegroundColor Yellow
xcopy "$ECC_ROOT\hooks" $CLINE_HOOKS /E /I /Y | Out-Null
$hooksCount = (Get-ChildItem $CLINE_HOOKS -File).Count
Write-Success "已同步 $hooksCount 个钩子文件"

# 同步完成
Write-Header "同步完成"

Write-Host "下一步操作：" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 重启 VS Code（如果需要）" -ForegroundColor White
Write-Host "2. 检查 Cline 插件中的配置更新" -ForegroundColor White
Write-Host ""
Write-Host "提示：建议每周同步一次以获取最新配置" -ForegroundColor Yellow
Write-Host ""