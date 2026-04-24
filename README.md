# Mac Terminal Workflow

一套适合 macOS 开发者的现代化终端工作流配置，基于 **Ghostty + Oh My Zsh + Zoxide + Yazi** 组合，兼顾颜值、效率和日常可用性。

这篇文档不是简单复制配置，而是基于我自己的实际落地过程，整理出一套可直接复现的安装与配置说明。

## 效果概览

这套配置主要解决四类问题：

- 让终端界面更现代，支持更舒服的字体、窗口布局和快捷键
- 让目录跳转更高效，用 `zoxide` 替代低效的手动 `cd`
- 让文件浏览更顺手，用 `yazi` 做终端里的文件管理
- 让 shell 使用体验更完整，结合 `oh-my-zsh`、自动建议与高亮插件

---

## 工具选型

### 1. Ghostty
现代化 GPU 加速终端，启动快、渲染顺滑，适合日常开发使用。

### 2. Oh My Zsh
Zsh 配置框架，用来快速管理主题、插件和 shell 行为。

### 3. Zoxide
智能目录跳转工具，替代传统 `cd`。

### 4. Yazi
高性能终端文件管理器，适合快速浏览、预览和打开文件。

---

## 安装方式

建议使用 Homebrew 安装。

```bash
brew install ghostty
brew install zoxide
brew install yazi
brew install ffmpegthumbnailer
brew install poppler
```

其中：

- `ffmpegthumbnailer` 用于 Yazi 的视频预览
- `poppler` 用于 Yazi 的 PDF 预览

安装 Oh My Zsh：

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

安装 Zsh 插件：

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

---

## 目录结构

最终会涉及这些配置文件：

```text
~/.config/ghostty/config
~/.config/yazi/yazi.toml
~/.config/yazi/keymap.toml
~/.config/yazi/theme.toml
~/.zshrc
```

如果 `~/.config/ghostty` 或 `~/.config/yazi` 不存在，先创建：

```bash
mkdir -p ~/.config/ghostty
mkdir -p ~/.config/yazi
```

---

## Ghostty 配置

配置文件位置：

```text
~/.config/ghostty/config
```

推荐配置：

```toml
# --- Typography ---
font-family = "Maple Mono NF CN"
font-size = 15
font-thicken = true
adjust-cell-height = 6

# --- Theme and Colors ---
theme = Kanagawa Wave

# --- Window and Appearance ---
background-opacity = 1
macos-titlebar-style = transparent
window-padding-x = 14
window-padding-y = 10
window-save-state = never
window-width = 80
window-height = 24
window-theme = auto

# --- Cursor ---
cursor-style = bar
cursor-style-blink = true

# --- Mouse ---
mouse-hide-while-typing = true
copy-on-select = clipboard

# --- Quick Terminal ---
quick-terminal-position = top
quick-terminal-screen = mouse
quick-terminal-autohide = true
quick-terminal-animation-duration = 0.15

# --- Close behavior ---
confirm-close-surface = false

# --- Security ---
clipboard-paste-protection = true
clipboard-paste-bracketed-safe = true

# --- Shell Integration ---
shell-integration = detect
shell-integration-features = cursor,sudo,no-title,ssh-env,ssh-terminfo,path

# --- Keybindings ---
keybind = cmd+t=new_tab
keybind = cmd+shift+left=previous_tab
keybind = cmd+shift+right=next_tab
keybind = cmd+w=close_surface

keybind = cmd+d=new_split:right
keybind = cmd+shift+d=new_split:down
keybind = cmd+alt+left=goto_split:left
keybind = cmd+alt+right=goto_split:right
keybind = cmd+alt+up=goto_split:top
keybind = cmd+alt+down=goto_split:bottom

keybind = cmd+plus=increase_font_size:1
keybind = cmd+minus=decrease_font_size:1
keybind = cmd+zero=reset_font_size

keybind = global:ctrl+grave_accent=toggle_quick_terminal
keybind = cmd+shift+e=equalize_splits
keybind = cmd+shift+f=toggle_split_zoom
keybind = cmd+shift+comma=reload_config

# --- Performance ---
scrollback-limit = 25000000
```

### 我实际使用时的几个建议

- 字体建议使用 Nerd Font，避免图标显示异常
- `Maple Mono NF CN` 很适合中英文混排
- `Ctrl + \`` 作为全局下拉终端快捷键非常高频，值得保留

---

## Yazi 配置

### 主配置

文件位置：

```text
~/.config/yazi/yazi.toml
```

```toml
[mgr]
ratio = [1, 2, 5]
sort_by = "natural"
sort_sensitive = false
sort_reverse = false
sort_dir_first = true
linemode = "size"
show_hidden = false
show_symlink = true
scrolloff = 5
mouse_events = ["click", "scroll"]
title_format = "Yazi: {cwd}"

[preview]
max_width = 600
max_height = 900
image_filter = "lanczos3"
image_quality = 75

[opener]
edit = [
  { run = 'code %s', desc = "VSCode", for = "unix" },
]
open = [
  { run = 'open %s', desc = "Open", for = "macos" },
]
reveal = [
  { run = 'open -R %1', desc = "Reveal in Finder", for = "macos" },
]

[open]
prepend_rules = [
  { mime = "text/*", use = ["edit", "open", "reveal"] },
  { mime = "application/json", use = ["edit", "open", "reveal"] },
  { mime = "*/javascript", use = ["edit", "open", "reveal"] },
  { mime = "*/typescript", use = ["edit", "open", "reveal"] },
  { mime = "*/x-yaml", use = ["edit", "open", "reveal"] },
]

[tasks]
micro_workers = 10
macro_workers = 25
bizarre_retry = 5

[plugin]
prepend_fetchers = [
  { id = "git", name = "*", run = "git", prio = "normal" },
]
```

### 快捷键配置

文件位置：

```text
~/.config/yazi/keymap.toml
```

```toml
[[manager.prepend_keymap]]
on = ["g", "h"]
run = "cd ~"
desc = "Go to home directory"

[[manager.prepend_keymap]]
on = ["g", "c"]
run = "cd ~/.config"
desc = "Go to config directory"

[[manager.prepend_keymap]]
on = ["g", "d"]
run = "cd ~/Downloads"
desc = "Go to downloads"

[[manager.prepend_keymap]]
on = ["g", "w"]
run = "cd ~/work"
desc = "Go to work directory"

[[manager.prepend_keymap]]
on = ["g", "D"]
run = "cd ~/Desktop"
desc = "Go to desktop"

[[manager.prepend_keymap]]
on = ["g", "t"]
run = "cd /tmp"
desc = "Go to tmp"
```

> 如果你的 `~/work` 不存在，记得改成自己的常用工作目录。

### 主题配置

文件位置：

```text
~/.config/yazi/theme.toml
```

```toml
[mode]
normal_main = { fg = "black", bg = "blue", bold = true }
normal_alt = { fg = "blue", bg = "reset", bold = true }
select_main = { fg = "black", bg = "green", bold = true }
select_alt = { fg = "green", bg = "reset", bold = true }
unset_main = { fg = "black", bg = "red", bold = true }
unset_alt = { fg = "red", bg = "reset", bold = true }

[status]
sep_left = { open = "", close = "" }
sep_right = { open = "", close = "" }
overall = { fg = "reset", bg = "reset" }

[filetype]
rules = [
  { mime = "image/*", fg = "magenta" },
  { mime = "video/*", fg = "yellow" },
  { mime = "audio/*", fg = "yellow" },
  { mime = "application/zip", fg = "red" },
  { mime = "application/gzip", fg = "red" },
  { mime = "application/x-tar", fg = "red" },
  { mime = "application/x-bzip2", fg = "red" },
  { mime = "application/x-7z-compressed", fg = "red" },
  { mime = "application/x-rar", fg = "red" },
  { mime = "application/x-xz", fg = "red" },
  { mime = "application/pdf", fg = "cyan" },
  { mime = "application/*doc*", fg = "green" },
  { mime = "application/*sheet*", fg = "green" },
  { mime = "application/*presentation*", fg = "green" },
  { name = "*", fg = "reset" },
  { name = "*/", fg = "blue", bold = true },
]
```

---

## Zsh 配置

文件位置：

```text
~/.zshrc
```

核心思路：

- 主题改为 `agnoster`
- 关闭 Oh My Zsh 自动更新
- 启用 `git`、`zsh-syntax-highlighting`、`zsh-autosuggestions`
- 增加 `y()` 函数，让 Yazi 退出后自动切换到当前目录
- 启用 `zoxide`
- 在 Ghostty 中自动把窗口标题设置成当前目录

参考配置：

```bash
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
DISABLE_AUTO_UPDATE="true"

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=30
DEFAULT_USER="your_username"

if [[ -n "${GHOSTTY_RESOURCES_DIR:-}" ]]; then
    ghostty_set_title() {
        local dir="${PWD/#$HOME/~}"
        printf '\033]2;%s\033\\' "$dir"
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd ghostty_set_title
    add-zsh-hook precmd ghostty_set_title
    add-zsh-hook preexec ghostty_set_title
    ghostty_set_title
fi

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

eval "$(zoxide init zsh)"
```

> `DEFAULT_USER` 记得改成你自己的用户名。

---

## 我这次实际落地的过程

这次实际配置时，我做了这些事：

1. 检查本机是否已经存在 Ghostty / Yazi 配置文件
2. 确认 `~/.config/ghostty` 和 `~/.config/yazi` 目录为空，可以直接创建配置
3. 检查现有 `~/.zshrc`，确认还是默认的 Oh My Zsh 模板
4. 按需修改 `~/.zshrc`，保留原有主体结构，只替换主题、插件并补充函数和集成配置
5. 新建 Ghostty 和 Yazi 配置文件
6. 检查目录映射是否合理，发现 `~/work` 在当前机器上不存在，因此建议后续手动改成自己的实际工作目录

这种方式比整份覆盖更稳，因为不会把已有的自定义 shell 配置一并抹掉。

---

## 常用命令

### 重新加载 Zsh 配置

```bash
source ~/.zshrc
```

### 启动 Yazi

```bash
y
```

### 使用 Zoxide 跳转目录

```bash
z work
z foo bar
zi project
```

### 查看 Ghostty 可用主题

```bash
ghostty +list-themes
```

---

## 常见问题

### 1. 图标显示异常
大概率是没有安装 Nerd Font，或者终端字体没有切到支持图标的字体。

### 2. Yazi 无法预览 PDF / 视频
检查是否安装了：

```bash
brew install ffmpegthumbnailer poppler
```

### 3. `gw` 快捷键不能用
说明 `~/work` 目录不存在，把它改成你自己的工作目录即可。

### 4. Ghostty 标题没有按目录变化
确认你使用的是 Ghostty，并且通过 `~/.zshrc` 正常加载了相关 hook。

---

## 适合谁用

如果你符合下面几种情况，这套配置会很顺手：

- 日常使用 macOS 做开发
- 长时间待在终端里
- 希望目录切换和文件浏览更高效
- 想要比系统默认终端更现代的体验

---

## 后续可继续优化的方向

- 为 Ghostty 增加更适合自己的主题与透明度方案
- 给 Yazi 增加更多 opener 和预览规则
- 给 `.zshrc` 增加更细的 alias、git 辅助命令和开发环境变量
- 把 `~/work` 等路径映射成自己的真实目录

---

## 参考来源

本文为个人实操整理版，配置思路参考了以下 gist，并结合自己的实际环境做了改写与落地：

- https://gist.github.com/lltx/a61f98fdb761c9af7c5fd6cbfe963842
