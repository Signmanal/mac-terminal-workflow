#!/bin/bash

# ============================================
# Mac Terminal Workflow 自动安装脚本
# ============================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 备份文件
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$file" "$backup"
        print_success "已备份: $file -> $backup"
    fi
}

# 备份目录
backup_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        local backup="${dir}.backup.$(date +%Y%m%d_%H%M%S)"
        cp -r "$dir" "$backup"
        print_success "已备份: $dir -> $backup"
    fi
}

echo ""
echo "============================================"
echo "  Mac Terminal Workflow 安装脚本"
echo "============================================"
echo ""

# ============================================
# 1. 检查 Homebrew
# ============================================
print_info "检查 Homebrew..."
if ! command_exists brew; then
    print_warning "未检测到 Homebrew，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Apple Silicon Mac 需要添加到 PATH
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew 安装完成"
else
    print_success "Homebrew 已安装"
fi

# ============================================
# 2. 安装核心工具
# ============================================
print_info "检查并安装核心工具..."

# Ghostty
if ! command_exists ghostty; then
    print_info "正在安装 Ghostty..."
    brew install ghostty
    print_success "Ghostty 安装完成"
else
    print_success "Ghostty 已安装"
fi

# Zoxide
if ! command_exists zoxide; then
    print_info "正在安装 Zoxide..."
    brew install zoxide
    print_success "Zoxide 安装完成"
else
    print_success "Zoxide 已安装"
fi

# Yazi
if ! command_exists yazi; then
    print_info "正在安装 Yazi..."
    brew install yazi
    print_success "Yazi 安装完成"
else
    print_success "Yazi 已安装"
fi

# Yazi 预览依赖
print_info "安装 Yazi 预览依赖..."
brew install ffmpegthumbnailer poppler 2>/dev/null || true
print_success "Yazi 预览依赖安装完成"

# ============================================
# 3. 安装 Oh My Zsh
# ============================================
print_info "检查 Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "正在安装 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh 安装完成"
else
    print_success "Oh My Zsh 已安装"
fi

# ============================================
# 4. 安装 Zsh 插件
# ============================================
print_info "安装 Zsh 插件..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_info "正在安装 zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_success "zsh-syntax-highlighting 安装完成"
else
    print_success "zsh-syntax-highlighting 已安装"
fi

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_info "正在安装 zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_success "zsh-autosuggestions 安装完成"
else
    print_success "zsh-autosuggestions 已安装"
fi

# ============================================
# 5. 配置文件部署
# ============================================
print_info "部署配置文件..."

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

# Ghostty 配置
print_info "配置 Ghostty..."
mkdir -p "$HOME/.config/ghostty"
backup_file "$HOME/.config/ghostty/config"
cp "$CONFIG_DIR/ghostty/config" "$HOME/.config/ghostty/config"
print_success "Ghostty 配置完成"

# Yazi 配置
print_info "配置 Yazi..."
mkdir -p "$HOME/.config/yazi"
backup_file "$HOME/.config/yazi/yazi.toml"
backup_file "$HOME/.config/yazi/keymap.toml"
backup_file "$HOME/.config/yazi/theme.toml"
cp "$CONFIG_DIR/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
cp "$CONFIG_DIR/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
cp "$CONFIG_DIR/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
print_success "Yazi 配置完成"

# Zsh 配置
print_info "配置 Zsh..."
backup_file "$HOME/.zshrc"

# 检查是否已经添加过配置
if ! grep -q "# Mac Terminal Workflow Config" "$HOME/.zshrc" 2>/dev/null; then
    echo "" >> "$HOME/.zshrc"
    echo "# ============================================" >> "$HOME/.zshrc"
    echo "# Mac Terminal Workflow Config" >> "$HOME/.zshrc"
    echo "# ============================================" >> "$HOME/.zshrc"
    cat "$CONFIG_DIR/zsh/.zshrc.example" >> "$HOME/.zshrc"
    print_success "Zsh 配置已添加到 ~/.zshrc"
else
    print_warning "Zsh 配置已存在，跳过添加"
fi

# ============================================
# 6. 完成
# ============================================
echo ""
echo "============================================"
print_success "安装完成！"
echo "============================================"
echo ""
print_info "下一步操作："
echo "  1. 重启终端或执行: source ~/.zshrc"
echo "  2. 启动 Ghostty 终端"
echo "  3. 按 Cmd+Shift+Space 测试快速终端"
echo "  4. 输入 'yy' 或 'f' 测试 Yazi 文件管理器"
echo "  5. 使用 'z 目录名' 测试智能跳转"
echo ""
print_info "快捷键参考："
echo "  - Ghostty 快速终端: Cmd+Shift+Space"
echo "  - 新建标签页: Cmd+T"
echo "  - 垂直分屏: Cmd+D"
echo "  - Yazi 文件管理: yy 或 f"
echo "  - 智能跳转: z 目录名"
echo ""
print_info "配置文件位置："
echo "  - Ghostty: ~/.config/ghostty/config"
echo "  - Yazi: ~/.config/yazi/"
echo "  - Zsh: ~/.zshrc"
echo ""
print_warning "备份文件已保存，如需恢复请查看 *.backup.* 文件"
echo ""
