#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$SCRIPT_DIR/configs"
DRY_RUN=false
VERBOSE=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    cat <<EOF
dotfile - Dotfiles management script

USAGE:
    $0 [OPTIONS] COMMAND

COMMANDS:
    config          Update configuration files

OPTIONS:
    -d, --dry-run   Show what would be done without making changes
    -v, --verbose   Enable verbose output
    -h, --help      Show this help message

EOF
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}[VERBOSE]${NC} $1"
    fi
}

log_dryrun() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${MAGENTA}[DRYRUN]${NC} $1"
    fi
}

validate_source_file() {
    local source_file="$1"
    if [ ! -f "$source_file" ]; then
        log_error "Source file does not exist: $source_file"
        return 1
    fi
    return 0
}

ensure_target_dir() {
    local target_path="$1"
    local target_dir
    target_dir=$(dirname "$target_path")

    if [ ! -d "$target_dir" ]; then
        log_verbose "Creating target directory: $target_dir"
        [ "$DRY_RUN" = false ] && mkdir -p "$target_dir"
    fi
}

create_symlink() {
    local source_file="$1"
    local target_path="$2"
    local description="$3"

    log_info "Updating $description"
    log_verbose "Source: $source_file"
    log_verbose "Target: $target_path"

    if ! validate_source_file "$source_file"; then
        return 1
    fi

    ensure_target_dir "$target_path"

    if [ "$DRY_RUN" = true ]; then
        log_dryrun "Create symlink: $source_file -> $target_path"
        return 0
    fi

    if ln -sf "$source_file" "$target_path"; then
        log_success "$description updated successfully"
        return 0
    fi

    log_error "Failed to update $description"
    return 1
}

install_config() {
    local source_file="$1"
    local target_path="$2"
    local description="$3"

    log_info "Installing $description"
    log_verbose "Source: $source_file"
    log_verbose "Target: $target_path"

    if ! validate_source_file "$source_file"; then
        return 1
    fi

    ensure_target_dir "$target_path"

    if [ "$DRY_RUN" = true ]; then
        log_dryrun "Install to $USER: $source_file -> $target_path"
        return 0
    else
        if install -o "$USER" "$source_file" "$target_path"; then
            log_success "$description installed successfully"
        return 0
        elif [ $? -eq 64 ]; then
            log_info "No update required for $description"
            return 0
        else
            log_error "Failed to install $description"
            return 1
        fi
    fi
}

get_system_info() {
    KERNEL=$(uname -s)
    ARCH=$(uname -m)
    log_verbose "System: $KERNEL $ARCH"

    if [ "$KERNEL" = "Linux" ] && [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID="$ID"
        DISTRO_VERSION="$VERSION_ID"
        log_verbose "Distribution: $DISTRO_ID $DISTRO_VERSION"
    fi
}

config() {
    log_info "Starting dotfiles configuration update"

    get_system_info

    create_symlink "$CONFIGS_DIR/.vimrc" "$HOME/.vimrc" ".vimrc"
    create_symlink "$CONFIGS_DIR/.tmux.conf" "$HOME/.tmux.conf" ".tmux.conf"
    install_config "$CONFIGS_DIR/.ssh_config" "$HOME/.ssh/config" "ssh config"
    create_symlink "$CONFIGS_DIR/init.lua" "$HOME/.config/nvim/init.lua" "neovim config"

    if [ "$KERNEL" = "Darwin" ]; then
        configure_macos
    elif [ "$KERNEL" = "Linux" ]; then
        configure_linux
    else
        log_warning "Unsupported operating system: $KERNEL"
    fi

    log_success "Configuration update completed"
}

configure_macos() {
    log_info "Configuring macOS-specific settings"

    if [ -d ~/.config/ghostty/ ]; then
        create_symlink "$CONFIGS_DIR/ghostty/.ghostty" "$HOME/.config/ghostty/config" "Ghostty config"
        create_symlink "$CONFIGS_DIR/ghostty/.ghostty_macos" "$HOME/.config/ghostty/optional_config" "Ghostty macOS config"
    else
        log_warning "Ghostty config directory not found, skipping Ghostty configuration"
    fi
}

configure_linux() {
    log_info "Configuring Linux-specific settings"

    if [ "$ARCH" = "x86_64" ] && [ -f /etc/os-release ]; then
        case "$DISTRO_ID" in
            ubuntu)
                configure_ubuntu
                ;;
            debian)
                configure_debian
                ;;
            *)
                log_warning "Unsupported Linux distribution: $DISTRO_ID"
                ;;
        esac
    else
        log_info "Unsupported architecture or missing OS release info: $ARCH"
    fi
}

configure_ubuntu() {
    log_info "Configuring Ubuntu-specific settings"

    create_symlink "$CONFIGS_DIR/ubuntu-x86/.bashrc" "$HOME/.bashrc" "Bash configuration"

    if [ -d ~/.config/ibus/rime/ ]; then
        create_symlink "$CONFIGS_DIR/rime/default.custom.yaml" "$HOME/.config/ibus/rime/default.custom.yaml" "IBus Rime config"
    else
        log_warning "IBus Rime config directory not found, skipping Rime configuration"
    fi

    if [ -d ~/.config/ghostty/ ]; then
        create_symlink "$CONFIGS_DIR/ghostty/.ghostty" "$HOME/.config/ghostty/config" "Ghostty config"
        create_symlink "$CONFIGS_DIR/ghostty/.ghostty_ubuntu" "$HOME/.config/ghostty/optional_config" "Ghostty Ubuntu config"
    else
        log_warning "Ghostty config directory not found, skipping Ghostty configuration"
    fi
}

configure_debian() {
    log_info "Configuring Debian-specific settings"

    create_symlink "$CONFIGS_DIR/debian/.bashrc" "$HOME/.bashrc" "Bash configuration"
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -dv|-vd)
                DRY_RUN=true
                VERBOSE=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            config)
                COMMAND="$1"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

main() {
    parse_arguments "$@"

    if [ -z "$COMMAND" ]; then
        log_error "No command specified"
        usage
        exit 1
    fi

    case "$COMMAND" in
        config)
            config
            ;;
        *)
            log_error "Unknown command: $COMMAND"
            usage
            exit 1
            ;;
    esac
}

main "$@"
