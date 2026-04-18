# ECC-Harness-Qoder-Cline

> 专为 **Qoder** 和 **Cline** 打造的 AI 编程配置包

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Qoder](https://img.shields.io/badge/Qoder-Supported-blue.svg)](https://qoder.com/)
[![Cline](https://img.shields.io/badge/Cline-Supported-green.svg)](https://docs.cline.bot/)

---

## 快速安装（3 步搞定）

### 第一步：下载项目

打开 **PowerShell**（Windows 搜索 "PowerShell"），运行：

```powershell
git clone https://github.com/yanlin-cheng/ecc-harness-qoder-cline.git
cd ecc-harness-qoder-cline
```

### 第二步：选择安装方式

**选项 A：安装到 Cline**

```powershell
# 全局安装（所有项目都能用）
.\scripts\install.ps1 -Editor cline -Type global

# 项目安装（只在当前项目生效）
.\scripts\install.ps1 -Editor cline -Type project
```

**选项 B：安装到 Qoder**

```powershell
# 项目安装（推荐）
.\scripts\install.ps1 -Editor qoder -Type project
```

### 第三步：重启编辑器

- **Cline 用户**：关闭 VS Code，重新打开
- **Qoder 用户**：关闭 Qoder，重新打开

**搞定！** 🎉

---

## 全局安装 vs 项目安装

### 全局安装（推荐个人使用）

**适用场景：** 你在多个项目中使用同一个编辑器

**效果：** 安装一次，所有项目都能用

**安装命令：**
```powershell
.\scripts\install.ps1 -Editor cline -Type global
```

### 项目安装（推荐团队使用）

**适用场景：** 你希望配置跟随项目代码一起共享

**效果：** 配置保存在项目文件夹中，团队成员拉取代码后自动获得配置

**安装命令：**
```powershell
# 先进入你的项目目录
cd 你的项目路径

# 然后运行安装
..\ecc-harness-qoder-cline\scripts\install.ps1 -Editor cline -Type project
```

---

## 常见问题

### 问：PowerShell 提示"无法加载脚本"怎么办？

答：首次运行需要允许执行脚本，运行一次即可：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 问：Cline 和 Qoder 有什么区别？

答：
- **Cline**：VS Code 的 AI 编程插件
- **Qoder**：独立的 AI 编程编辑器

你用哪个就安装哪个，也可以两个都装！

### 问：如何卸载？

答：运行卸载脚本：

```powershell
.\scripts\uninstall.ps1 -Editor cline -Type global
```

---

## 包含什么？

安装后你会获得：

- ✅ **10 个编程规则** - 编码风格、Git 工作流、安全规范等
- ✅ **14 个 AI 技能** - TDD 测试、代码审查、API 设计等
- ✅ **10 个 AI 智能体** - 代码规划、系统设计、性能优化等（仅 Cline）

---

## 中文文档

查看 [README.zh-CN.md](README.zh-CN.md) 了解更详细的使用说明。
