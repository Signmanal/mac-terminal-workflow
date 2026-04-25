# Mac Terminal Workflow

一套适合 macOS 开发者的现代化终端工作流配置，基于 **Ghostty + Oh My Zsh + Zoxide + Yazi** 组合，兼顾颜值、效率和日常可用性。

这套配置不是简单复制粘贴，而是基于实际落地过程，整理出一套可直接复现的安装与配置说明。

## 📸 效果概览

这套配置主要解决四类问题：

- **现代化界面** - 让终端界面更舒适，支持更好的字体、窗口布局和快捷键
- **高效目录跳转** - 用 `zoxide` 替代低效的手动 `cd`，智能记忆常用目录
- **便捷文件浏览** - 用 `yazi` 做终端里的文件管理器，支持预览和快速操作
- **完整 Shell 体验** - 结合 `oh-my-zsh`、自动建议与高亮插件，提升命令行效率

---

## 🛠️ 工具选型

### 1. Ghostty
现代化 GPU 加速终端模拟器，启动快、渲染顺滑，支持 Quake 风格下拉终端。

**特点**：
- GPU 加速渲染，性能优秀
- 原生支持分屏和标签页
- 丰富的快捷键配置
- 支持 Quake 风格快速终端（`Cmd+Shift+Space` 唤起）

### 2. Oh My Zsh
Zsh 配置框架，用来快速管理主题、插件和 shell 行为。

**特点**：
- 丰富的主题和插件生态
- 开箱即用的 Git 集成
- 强大的自动补全功能

### 3. Zoxide
智能目录跳转工具，替代传统 `cd`，基于访问频率和最近性智能跳转。

**特点**：
- 自动记录访问过的目录
- 模糊匹配目录名
- 比 `cd` 快 10 倍以上

### 4. Yazi
高性能终端文件管理器，适合快速浏览、预览和打开文件。

**特点**：
- 异步 I/O，速度极快
- 支持图片、视频、PDF 预览
- Vim 风格快捷键
- 退出后自动跳转到最后访问的目录

---

## 📦 安装方式

### 1. 安装 Homebrew（如果还没有）

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. 安装核心工具

```bash
# 安装终端和工具
brew install ghostty
brew install zoxide
brew install yazi

# 安装 Yazi 预览依赖
brew install ffmpegthumbnailer  # 视频预览
brew install poppler            # PDF 预览
```

### 3. 安装 Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 4. 安装 Zsh 插件

```bash
# 语法高亮
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 自动建议
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

---

## ⚙️ 配置文件

### 目录结构

最终会涉及这些配置文件：

```text
~/.config/ghostty/config        # Ghostty 配置
~/.config/yazi/yazi.toml        # Yazi 主配置
~/.config/yazi/keymap.toml      # Yazi 快捷键
~/.config/yazi/theme.toml       # Yazi 主题
~/.zshrc                        # Zsh 配置
```

### 快速配置

#### 方法一：使用安装脚本（推荐）

```bash
# 克隆本仓库
git clone https://github.com/你的用户名/你的仓库名.git
cd 你的仓库名/terminal-config

# 运行安装脚本（会自动备份现有配置）
./install.sh
```

#### 方法二：手动配置

1. **创建配置目录**

```bash
mkdir -p ~/.config/ghostty
mkdir -p ~/.config/yazi
```

2. **复制配置文件**

```bash
# Ghostty 配置
cp configs/ghostty/config ~/.config/ghostty/config

# Yazi 配置
cp configs/yazi/*.toml ~/.config/yazi/

# Zsh 配置（追加到现有 .zshrc）
cat configs/zsh/.zshrc.example >> ~/.zshrc
```

3. **重新加载配置**

```bash
source ~/.zshrc
```

---

## 🎨 主题说明

本配置使用 **Kanagawa Wave** 主题，这是一套深色主题，灵感来自日本浮世绘《神奈川冲浪里》。

**主要颜色**：
- 背景：`#1F1F28`（深灰黑）
- 前景：`#DCD7BA`（米白）
- 强调色：`#7E9CD8`（蓝紫）、`#E6C384`（金黄）、`#98BB6C`（青绿）

如果想更换主题，可以修改：
- Ghostty: `~/.config/ghostty/config` 中的 `theme` 字段
- Yazi: `~/.config/yazi/theme.toml` 中的颜色值

---

## ⌨️ 快捷键参考

### Ghostty 快捷键

| 功能 | 快捷键 |
|------|--------|
| 新建标签页 | `Cmd+T` |
| 关闭标签页 | `Cmd+W` |
| 切换标签页 | `Cmd+Shift+Left/Right` |
| 垂直分屏 | `Cmd+D` |
| 水平分屏 | `Cmd+Shift+D` |
| 切换分屏 | `Cmd+方向键` |
| 快速终端 | `Cmd+Shift+Space` |
| 清屏 | `Cmd+K` |
| 放大字体 | `Cmd++` |
| 缩小字体 | `Cmd+-` |
| 重置字体 | `Cmd+0` |

### Yazi 快捷键

| 功能 | 快捷键 |
|------|--------|
| 上下移动 | `j/k` |
| 进入目录 | `l` 或 `Enter` |
| 返回上级 | `h` |
| 跳到顶部 | `gg` |
| 跳到底部 | `G` |
| 选择文件 | `Space` |
| 复制 | `y` |
| 剪切 | `x` |
| 粘贴 | `p` |
| 删除 | `d` |
| 重命名 | `r` |
| 搜索 | `/` |
| 过滤 | `f` |
| 退出 | `q` |

### Zsh 常用命令

| 功能 | 命令 |
|------|------|
| 智能跳转 | `z 目录名` |
| 打开文件管理器 | `yy` 或 `f` |
| 查看历史 | `history` |
| Git 状态 | `gs` |
| 清屏 | `c` 或 `clear` |

---

## 🚀 使用技巧

### 1. Zoxide 智能跳转

```bash
# 传统方式
cd ~/Documents/Projects/my-project

# Zoxide 方式（只需输入部分目录名）
z proj

# 查看访问记录
zoxide query -l
```

### 2. Yazi 文件管理

```bash
# 启动 yazi（退出后自动跳转到最后访问的目录）
yy

# 或使用别名
f
```

### 3. Ghostty 快速终端

按 `Cmd+Shift+Space` 可以从任何应用快速唤起一个下拉终端，再按一次隐藏。非常适合快速执行命令。

### 4. Oh My Zsh 插件

配置中已启用的插件：
- `git` - Git 命令别名和状态显示
- `zsh-autosuggestions` - 命令自动建议（灰色提示，按 `→` 接受）
- `zsh-syntax-highlighting` - 命令语法高亮
- `z` - 目录跳转（已被 zoxide 替代）
- `sudo` - 按两次 `Esc` 在命令前添加 sudo
- `extract` - 统一的解压命令 `extract 文件名`
- `colored-man-pages` - 彩色 man 手册

---

## 🔧 自定义配置

### 更换字体

编辑 `~/.config/ghostty/config`：

```toml
font-family = "你的字体名称"
font-size = 15
```

推荐字体：
- Maple Mono NF CN（本配置默认）
- JetBrains Mono Nerd Font
- Fira Code Nerd Font
- Cascadia Code

### 调整窗口透明度

编辑 `~/.config/ghostty/config`：

```toml
background-opacity = 0.95  # 0.0-1.0，1.0 为完全不透明
```

### 更换 Oh My Zsh 主题

编辑 `~/.zshrc`：

```bash
ZSH_THEME="agnoster"  # 或其他主题名
```

推荐主题：
- `robbyrussell`（默认，简洁）
- `agnoster`（显示 Git 状态）
- `powerlevel10k`（功能强大，需单独安装）

---

## 📝 常见问题

### Q: Ghostty 无法启动？
A: 确保已安装最新版本：`brew upgrade ghostty`

### Q: Yazi 预览不显示图片？
A: 检查是否安装了预览依赖：
```bash
brew install ffmpegthumbnailer poppler
```

### Q: Zsh 插件不生效？
A: 确保在 `~/.zshrc` 中正确配置了插件列表，并执行 `source ~/.zshrc`

### Q: Zoxide 跳转不准确？
A: Zoxide 需要一段时间学习你的使用习惯，多使用几次后会更准确

### Q: 如何卸载？
A: 删除配置文件并恢复备份：
```bash
rm -rf ~/.config/ghostty
rm -rf ~/.config/yazi
# 恢复 .zshrc 备份
mv ~/.zshrc.backup ~/.zshrc
```

---

## 📚 参考资料

- [Ghostty 官方文档](https://ghostty.org/)
- [Oh My Zsh 官方文档](https://ohmyz.sh/)
- [Zoxide GitHub](https://github.com/ajeetdsouza/zoxide)
- [Yazi GitHub](https://github.com/sxyazi/yazi)
- [Kanagawa 主题](https://github.com/rebelot/kanagawa.nvim)

---

## 📄 许可证

MIT License

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

如果这套配置对你有帮助，欢迎 Star ⭐
