#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-https://github.com/junevm/dotfiles.git}"
LOCAL_BIN_DIR="${HOME}/.local/bin"
STATE_DIR="${HOME}/.local/state/chezmoi-bootstrap"
CHECKPOINT_FILE="${STATE_DIR}/checkpoints"
LOG_FILE="${STATE_DIR}/bootstrap.log"

mkdir -p "${STATE_DIR}" "${LOCAL_BIN_DIR}"
touch "${CHECKPOINT_FILE}" "${LOG_FILE}"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "${LOG_FILE}"
}

die() {
    log "ERROR: $*"
    exit 1
}

is_supported_distro() {
    local os_id="$1"
    local os_like="$2"
    local pretty="$3"

    if [[ "${os_id}" == "cachyos" ]]; then
        return 0
    fi

    if [[ " ${os_like} " == *" arch "* && "${pretty}" =~ [Cc]achy[Oo][Ss] ]]; then
        return 0
    fi

    return 1
}

on_error() {
    local code=$?
    log "FAILED at line ${BASH_LINENO[0]} with exit code ${code}. Re-run bootstrap.sh to resume."
    exit "${code}"
}
trap on_error ERR

has_checkpoint() {
    grep -qxF "$1" "${CHECKPOINT_FILE}"
}

add_checkpoint() {
    if ! has_checkpoint "$1"; then
        printf '%s\n' "$1" >> "${CHECKPOINT_FILE}"
    fi
}

run_step() {
    local key="$1"
    shift
    if has_checkpoint "${key}"; then
        log "SKIP ${key} (already completed)"
        return 0
    fi

    log "RUN  ${key}"
    "$@"
    add_checkpoint "${key}"
    log "DONE ${key}"
}

require_supported_distro() {
    if [[ ! -r /etc/os-release ]]; then
        die "Cannot detect distribution: /etc/os-release not found"
    fi

    # shellcheck disable=SC1091
    source /etc/os-release
    local os_id="${ID:-}"
    local os_like="${ID_LIKE:-}"
    local pretty="${PRETTY_NAME:-${NAME:-${os_id}}}"

    if ! is_supported_distro "${os_id}" "${os_like}" "${pretty}"; then
        if [[ "${DOTFILES_ALLOW_UNSUPPORTED:-0}" == "1" ]]; then
            log "WARN: unsupported OS detected (${pretty}). Continuing because override flag is set"
        else
            die "This bootstrap targets CachyOS (GNOME). Set DOTFILES_ALLOW_UNSUPPORTED=1 to force run."
        fi
    fi
}

ensure_sudo() {
    command -v sudo >/dev/null 2>&1 || die "sudo is required"
    sudo -v
}

detect_package_manager() {
    if command -v pacman >/dev/null 2>&1; then
        PKG_MANAGER="pacman"
        return 0
    fi

    die "pacman is required for CachyOS"
}

ensure_base_packages() {
    if [[ "${PKG_MANAGER}" == "pacman" ]]; then
        sudo pacman -Sy --needed --noconfirm curl ca-certificates
        return 0
    fi

    die "Unsupported package manager: ${PKG_MANAGER}"
}

install_chezmoi() {
    if ! command -v chezmoi >/dev/null 2>&1; then
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${LOCAL_BIN_DIR}"
    fi
}

init_chezmoi_repo() {
    local chezmoi_bin
    chezmoi_bin="$(command -v chezmoi || true)"
    [[ -n "${chezmoi_bin}" ]] || chezmoi_bin="${LOCAL_BIN_DIR}/chezmoi"
    [[ -x "${chezmoi_bin}" ]] || die "chezmoi binary not found"
    "${chezmoi_bin}" init --depth=1 "${DOTFILES_REPO_URL}"
}

install_mise() {
    if ! command -v mise >/dev/null 2>&1; then
        curl -fsSL https://mise.run | MISE_INSTALL_PATH="${LOCAL_BIN_DIR}/mise" sh
    fi
}

run_restore() {
    local mise_bin
    mise_bin="$(command -v mise || true)"
    [[ -n "${mise_bin}" ]] || mise_bin="${LOCAL_BIN_DIR}/mise"
    [[ -x "${mise_bin}" ]] || die "mise binary not found"

    export PATH="${LOCAL_BIN_DIR}:${PATH}"

    cd "${HOME}/.local/share/chezmoi"
    "${mise_bin}" trust
    "${mise_bin}" run restore
}

main() {
    log "Starting bootstrap"
    run_step "preflight-distro" require_supported_distro
    run_step "preflight-sudo" ensure_sudo
    run_step "preflight-package-manager" detect_package_manager
    run_step "base-packages" ensure_base_packages
    run_step "install-chezmoi" install_chezmoi
    run_step "init-chezmoi" init_chezmoi_repo
    run_step "install-mise" install_mise
    run_step "run-restore" run_restore
    log "Bootstrap complete. Reboot to apply all changes."
}

main "$@"
