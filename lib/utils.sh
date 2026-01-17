#!/bin/bash

# ============================================================================
# General Utilities Module
# ============================================================================

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log() {
  echo -e "${BLUE}[envforge]${NC} $*" >&2
}

success() {
  echo -e "${GREEN}✓${NC} $*" >&2
}

warn() {
  echo -e "${YELLOW}⚠${NC} $*" >&2
}

error() {
  echo -e "${RED}✗${NC} $*" >&2
}

debug() {
  if [[ "${ENVFORGE_DEBUG:-false}" == "true" ]]; then
    echo -e "${BLUE}[DEBUG]${NC} $*" >&2
  fi
}

# Confirm user action
confirm() {
  local prompt="$1"
  local response
  
  read -p "$(echo -e ${YELLOW}$prompt${NC}) [y/N] " -n 1 -r response
  echo
  [[ "$response" =~ ^[Yy]$ ]]
}

# Create directory with error handling
mkdir_safe() {
  local dir="$1"
  if mkdir -p "$dir" 2>/dev/null; then
    debug "Created directory: $dir"
    return 0
  else
    error "Failed to create directory: $dir"
    return 1
  fi
}

# Check if file/directory exists
file_exists() {
  [[ -e "$1" ]]
}

# Check if directory exists
dir_exists() {
  [[ -d "$1" ]]
}

# Join array elements with delimiter
join_by() {
  local delimiter="$1"
  shift
  local first=true
  for item in "$@"; do
    if [[ "$first" == true ]]; then
      printf '%s' "$item"
      first=false
    else
      printf '%s%s' "$delimiter" "$item"
    fi
  done
}

# Write to audit log
audit_log() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] $message" >> "$ENVFORGE_AUDIT_LOG"
  debug "Audit: $message"
}

# Make file executable
make_executable() {
  local file="$1"
  if chmod +x "$file" 2>/dev/null; then
    debug "Made executable: $file"
    return 0
  else
    error "Failed to make executable: $file"
    return 1
  fi
}
