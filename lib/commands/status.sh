#!/bin/bash

# ============================================================================
# Status Command Handler
# ============================================================================

status_command() {
  local arg="${1:-}"
  
  case "$arg" in
    -h|--help)
      status_help
      return 0
      ;;
    "")
      show_status
      return 0
      ;;
    *)
      error "Unknown option: $arg"
      status_help
      return 1
      ;;
  esac
}

status_help() {
  cat <<EOF
Usage: envforge status [options]

Options:
  -h, --help          Show this help message

Shows the current envforge context (workspace, project, or standalone).
EOF
}

show_status() {
  local context_type=$(get_context_type)
  local context_path=$(get_context_path)
  
  log "Context: $context_type"
  log "Location: $context_path"
  
  if is_nested_project; then
    local workspace_path=$(get_workspace_path)
    log "Workspace: $workspace_path"
  fi
  
  case "$context_type" in
    $CONTEXT_WORKSPACE)
      log "Type: Workspace (top-level container)"
      ;;
    $CONTEXT_PROJECT)
      if is_nested_project; then
        log "Type: Project (nested in workspace)"
      else
        log "Type: Project (standalone)"
      fi
      ;;
    $CONTEXT_STANDALONE)
      log "Type: Standalone (no project/workspace detected)"
      ;;
  esac
  
  return 0
}
