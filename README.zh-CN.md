# ECC-Harness-Qoder-Cline

> 基于 Everything-Claude-Code (ECC) 的精华配置，专为 **Qoder** 和 **Cline** 两大 AI 编辑器打造！

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Qoder](https://img.shields.io/badge/Qoder-Supported-blue.svg)](https://qoder.com/)
[![Cline](https://img.shields.io/badge/Cline-Supported-green.svg)](https://docs.cline.bot/)
[![ECC](https://img.shields.io/badge/Powered%20by-ECC-orange.svg)](https://github.com/affaan-m/everything-claude-code)

---

## 这是什么？

从 [Everything-Claude-Code (ECC)](https://github.com/affaan-m/everything-claude-code) 项目中提取的**精华配置**，专门适配 **Qoder** 和 **Cline** 两个 AI 编程助手。

### 核心特性

- **精选配置** - 从 ECC 的 183 个技能、48 个智能体中精选最实用的配置
- **双编辑器支持** - 同时支持 Qoder 和 Cline
- **一键安装** - PowerShell 脚本自动化安装
- **灵活选择** - 支持全局/项目安装，可选组件
- **智能合并** - 不会覆盖您已有的配置
- **自动备份** - 安装前自动备份原有配置
- **持续同步** - 定期从 ECC 同步最新配置

### 效果对比

| 配置前 | 配置后 |
|--------|--------|
| 代码风格不一致 | 遵循统一编码规范 |
| 直接开始写代码 | 先调研现有方案 |
| 测试覆盖率低 | TDD 工作流，80%+ 覆盖率 |
| Git 提交随意 | Conventional Commits |
| 安全问题易忽略 | 自动检测敏感信息 |

---

## 快速开始

### 前置要求

- Windows 10/11
- 已安装 Qoder 或 Cline
- Git 已安装
- PowerShell 5.0+

### 一键安装

```powershell
# 1. 克隆本仓库
git clone https://github.com/yanlin-cheng/ecc-harness-qoder-cline.git
cd ecc-harness-qoder-cline

# 2. 安装到 Cline（全局）
.\scripts\install.ps1 -Editor cline -Type global

# 3. 安装到 Qoder（项目）
.\scripts\install.ps1 -Editor qoder -Type project

# 4. 重启编辑器
```

### 智能安装特性

- ✅ **备份已有配置** - 安装前自动备份您的原有配置
- ✅ **智能合并** - 只安装新文件，不覆盖您已有的配置
- ✅ **详细报告** - 告诉您哪些是新装的，哪些被跳过了
- ✅ **随时卸载** - 使用卸载脚本可恢复或清除配置

### 验证安装

**Cline 用户：**
1. 重启 VS Code
2. 点击 **Rules** 标签 - 应看到 10 个规则
3. 点击 **Skills** 标签 - 应看到 14 个技能

**Qoder 用户：**
1. 重启 Qoder IDE
2. 在对话框输入 `/` 查看加载的技能列表
3. 检查 `.qoder/rules/` 目录

---

## 配置内容

### Rules (规则) - 10 个核心规则

| 文件 | 说明 | 适用编辑器 |
|------|------|-----------|
| `agents.md` | 智能体使用指南 | Cline + Qoder |
| `code-review.md` | 代码审查规范 | Cline + Qoder |
| `coding-style.md` | 编码风格 | Cline + Qoder |
| `development-workflow.md` | 开发流程 | Cline + Qoder |
| `git-workflow.md` | Git 工作流 | Cline + Qoder |
| `hooks.md` | 钩子说明 | Cline |
| `patterns.md` | 设计模式 | Cline + Qoder |
| `performance.md` | 性能优化 | Cline + Qoder |
| `security.md` | 安全规范 | Cline + Qoder |
| `testing.md` | 测试要求 | Cline + Qoder |

### Skills (技能) - 14 个精选技能

**核心工作流：**
- `tdd-workflow` - TDD 工作流（测试驱动开发）
- `search-first` - 先调研再编码
- `git-workflow` - Git 最佳实践
- `coding-standards` - 编码标准
- `security-review` - 安全审查

**代码质量：**
- `documentation-lookup` - 文档查找
- `verification-loop` - 验证循环
- `strategic-compact` - 上下文压缩
- `agent-introspection-debugging` - Agent 调试

**开发模式：**
- `backend-patterns` - 后端模式
- `frontend-patterns` - 前端模式
- `api-design` - API 设计
- `e2e-testing` - E2E 测试
- `mcp-server-patterns` - MCP 开发模式

### Agents (智能体) - 10 个核心智能体（仅 Cline）

- `planner` - 实现规划
- `architect` - 系统设计
- `code-reviewer` - 代码审查
- `security-reviewer` - 安全审查
- `tdd-guide` - TDD 指导
- `build-error-resolver` - 构建错误修复
- `performance-optimizer` - 性能优化
- `refactor-cleaner` - 重构清理
- `doc-updater` - 文档更新
- `code-simplifier` - 代码简化

---

## 使用指南

### 全局 vs 项目安装

| 类型 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| **全局安装** | 个人偏好、跨项目通用配置 | 一次安装，所有项目生效 | 不随项目共享 |
| **项目安装** | 团队规范、项目特定配置 | 随代码库共享，协作者自动获取 | 每个项目需单独安装 |

### 安装命令速查

```powershell
# Cline 全局安装所有组件
.\scripts\install.ps1 -Editor cline -Type global

# Cline 项目安装所有组件
.\scripts\install.ps1 -Editor cline -Type project

# Qoder 全局安装技能
.\scripts\install.ps1 -Editor qoder -Type global

# Qoder 项目安装规则和技能
.\scripts\install.ps1 -Editor qoder -Type project

# 同时安装两个编辑器
.\scripts\install.ps1 -Editor all -Type project

# 选择性安装（只安装规则和技能）
.\scripts\install.ps1 -Editor cline -Type global -Components rules,skills
```

### 卸载配置

```powershell
# 查看已安装的配置
.\scripts\uninstall.ps1 -List

# 卸载配置（保留备份）
.\scripts\uninstall.ps1 -Editor cline -Type global

# 从备份恢复原有配置
.\scripts\uninstall.ps1 -Restore -Editor cline -Type global

# 完全清除（包括备份）
.\scripts\uninstall.ps1 -Clean -Editor all -Type global
```

### 安装/卸载参数说明

| 参数 | 说明 | 可选值 |
|------|------|--------|
| `-Editor` | 选择编辑器 | `cline`, `qoder`, `all` |
| `-Type` | 安装类型 | `global`, `project` |
| `-Components` | 安装的组件 | `rules`, `skills` (可组合) |
| `-Force` | 强制覆盖已有文件 | 跳过备份，直接覆盖 |
| `-SkipBackup` | 跳过备份步骤 | 加快安装速度 |
| `-Restore` | 从备份恢复 | 恢复原有配置 |
| `-Clean` | 完全清除 | 删除配置和备份 |
| `-List` | 列出已安装配置 | 仅查看，不操作 |

---

## 项目结构

```
ecc-harness-qoder-cline/
├── README.md                        # 本文件
├── README.zh-CN.md                  # 中文说明
├── LICENSE                          # MIT 许可证
├── CHANGELOG.md                     # 版本变更日志
├── configs/                         # 配置源文件（来自 ECC）
│   ├── rules/                       # 10 个通用规则
│   ├── skills/                      # 14 个精选技能
│   └── agents/                      # 10 个核心智能体
├── scripts/                         # 安装和卸载脚本
│   ├── install.ps1                  # 安装脚本（智能合并，不会覆盖已有配置）
│   └── uninstall.ps1                # 卸载脚本（支持恢复原有配置）
└── docs/                            # 详细文档（待补充）
```

---

## 编辑器支持对比

| 组件 | Cline 全局 | Cline 项目 | Qoder 全局 | Qoder 项目 |
|------|-----------|-----------|-----------|-----------|
| Rules | ✅ | ✅ | ❌ | ✅ |
| Skills | ✅ | ✅ | ✅ | ✅ |
| Agents | ✅ | ❌ | ❌ | ❌ |

> **注意：** Qoder 仅支持项目级 Rules 和 Skills，其他组件暂不支持。

---

## 常见问题

### 配置后在编辑器中看不到？

**解决：** 重启编辑器，Cline/Qoder 需要重新加载配置。

### Skills 目录结构是怎样的？

每个 Skill 是一个文件夹，包含 `SKILL.md` 文件：

```
~/.cline/skills/
└── skill-name/
    └── SKILL.md
```

### 如何禁用某个配置？

在编辑器界面中关闭对应的开关即可，或直接删除对应的配置文件。

### 可以只配置部分 Rules 吗？

可以，使用 `-Components` 参数选择性安装：

```powershell
.\scripts\install.ps1 -Editor cline -Type global -Components rules,skills
```

### 安装会覆盖我原有的配置吗？

**不会！** 安装脚本会：
1. 自动备份您原有的配置
2. 只安装新文件，跳过您已有的文件
3. 提供详细报告告诉您安装了多少新文件，跳过了多少已有文件

---

## 更新配置

ECC 仓库会持续更新，定期同步以获取最新配置：

```powershell
# 进入项目目录
cd ecc-harness-qoder-cline

# 更新本仓库
git pull origin main

# 重新安装配置
.\scripts\install.ps1 -Editor all -Type project
```

---

## 贡献

欢迎贡献：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 许可证

本项目基于 [ECC](https://github.com/affaan-m/everything-claude-code) 配置，遵循 MIT 许可证。

---

## 致谢

- [Everything Claude Code (ECC)](https://github.com/affaan-m/everything-claude-code) - 提供高质量的配置模板
- [Qoder](https://qoder.com/) - 强大的 AI 编程助手
- [Cline](https://docs.cline.bot/) - 开源 AI 编程助手

---

## 联系方式

- GitHub：[ecc-harness-qoder-cline](https://github.com/yanlin-cheng/ecc-harness-qoder-cline)
- 问题反馈：[Issues](https://github.com/yanlin-cheng/ecc-harness-qoder-cline/issues)

---

**祝你使用愉快！**
