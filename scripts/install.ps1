# Deep Stack Cline Config - 安装脚本
# 使用方法：.\scripts\install.ps1

$ErrorActionPreference = "Stop"

# 配置路径
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR
$ECC_ROOT = "$PROJECT_ROOT\..\everything-claude-code"
$CLINE_RULES = "$env:USERPROFILE\Documents\Cline\Rules"
$CLINE_SKILLS = "$env:USERPROFILE\.cline\skills"
$CLINE_WORKFLOWS = "$env:USERPROFILE\Documents\Cline\Workflows"
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

function Write-Error-Exit {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
    exit 1
}

# 开始安装
Write-Header "Deep Stack Cline Config 安装程序"

# 检查 ECC 目录是否存在
Write-Host "检查依赖..." -ForegroundColor Yellow
if (-not (Test-Path $ECC_ROOT)) {
    Write-Host "ECC 仓库不存在 - $ECC_ROOT" -ForegroundColor Yellow
    Write-Host "正在克隆 ECC 仓库..." -ForegroundColor Cyan
    git clone https://github.com/affaan-m/everything-claude-code.git $ECC_ROOT
    Write-Success "ECC 仓库已克隆"
} else {
    Write-Success "ECC 仓库已存在"
}

# 创建目标目录
Write-Host "创建配置目录..." -ForegroundColor Yellow
$directories = @($CLINE_RULES, $CLINE_SKILLS, $CLINE_WORKFLOWS, $CLINE_HOOKS)
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  已创建：$dir" -ForegroundColor Gray
    }
}
Write-Success "配置目录已创建"

# 复制 Rules
Write-Host "复制 Rules..." -ForegroundColor Yellow
xcopy "$ECC_ROOT\rules\common" $CLINE_RULES /E /I /Y | Out-Null
$rulesCount = (Get-ChildItem $CLINE_RULES -File).Count
Write-Success "已复制 $rulesCount 个规则文件到 $CLINE_RULES"

# 复制 Skills
Write-Host "复制 Skills..." -ForegroundColor Yellow
$skills = @("search-first", "tdd-workflow", "git-workflow")
foreach ($skill in $skills) {
    if (Test-Path "$ECC_ROOT\skills\$skill") {
        xcopy "$ECC_ROOT\skills\$skill" "$CLINE_SKILLS\$skill" /E /I /Y | Out-Null
        Write-Host "  已复制：$skill" -ForegroundColor Gray
    }
}
Write-Success "已复制 3 个技能到 $CLINE_SKILLS"

# 复制 Hooks
Write-Host "复制 Hooks..." -ForegroundColor Yellow
xcopy "$ECC_ROOT\hooks" $CLINE_HOOKS /E /I /Y | Out-Null
$hooksCount = (Get-ChildItem $CLINE_HOOKS -File).Count
Write-Success "已复制 $hooksCount 个钩子文件到 $CLINE_HOOKS"

# 安装完成
Write-Header "安装完成"

Write-Host "下一步操作：" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 重启 VS Code" -ForegroundColor White
Write-Host "2. 打开 Cline 插件查看配置" -ForegroundColor White
Write-Host "3. 查看 README.md 了解更多配置选项" -ForegroundColor White
Write-Host ""
Write-Host "配置位置：" -ForegroundColor Cyan
Write-Host "  Rules:     $CLINE_RULES" -ForegroundColor Gray
Write-Host "  Skills:    $CLINE_SKILLS" -ForegroundColor Gray
Write-Host "  Workflows: $CLINE_WORKFLOWS" -ForegroundColor Gray
Write-Host "  Hooks:     $CLINE_HOOKS" -ForegroundColor Gray
Write-Host ""