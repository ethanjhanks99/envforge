#!/bin/bash

# ============================================================================
# Context Detection Module
# ============================================================================

# Detect context by walking up directory tree
# Returns: JSON object with context info
# Example: {"type":"project","path":"/path/to/project","workspace_path":"/path/to/workspace"}
detect_context() {
  local current_dir="$PWD"
  local found_envrc=false
  local context_type=""
  local context_path=""
  local workspace_path=""
  
  # Walk up directory tree looking for .envrc
  while [[ "$current_dir" != "/" ]]; do
    if [[ -f "$current_dir/.envrc" ]]; then
      found_envrc=true
      context_path="$current_dir"
      
      # Read ENVFORGE_TYPE from .envrc
      context_type=$(grep "^export ENVFORGE_TYPE=" "$current_dir/.envrc" 2>/dev/null | \
                     cut -d'=' -f2 | tr -d '"' || echo "unknown")
      
      # If it's a project, keep looking up for workspace
      if [[ "$context_type" == "$CONTEXT_PROJECT" ]]; then
        # Look for parent workspace
        workspace_path=$(find_parent_workspace "$current_dir")
        break
      fi
      
      # If it's a workspace, stop here
      if [[ "$context_type" == "$CONTEXT_WORKSPACE" ]]; then
        break
      fi
    fi
    
    current_dir="$(dirname "$current_dir")"
  done
  
  # Determine final context
  if [[ "$found_envrc" == false ]]; then
    context_type="$CONTEXT_STANDALONE"
    context_path="$PWD"
  fi
  
  # Return context as JSON for easy parsing
  echo "{\"type\":\"$context_type\",\"path\":\"$context_path\",\"workspace_path\":\"$workspace_path\"}"
}

# Find parent workspace if in nested project
find_parent_workspace() {
  local current_dir="$1"
  local parent_dir="$(dirname "$current_dir")"
  
  while [[ "$parent_dir" != "/" ]]; do
    if [[ -f "$parent_dir/.envrc" ]]; then
      local parent_type=$(grep "^export ENVFORGE_TYPE=" "$parent_dir/.envrc" 2>/dev/null | \
                         cut -d'=' -f2 | tr -d '"' || echo "unknown")
      if [[ "$parent_type" == "$CONTEXT_WORKSPACE" ]]; then
        echo "$parent_dir"
        return 0
      fi
    fi
    parent_dir="$(dirname "$parent_dir")"
  done
  
  echo ""
}

# Parse context JSON and extract field
# Usage: get_context_field "type" or get_context_field "path"
get_context_field() {
  local field="$1"
  local context_json="${ENVFORGE_CONTEXT:-}"
  
  # Simple JSON extraction (no dependencies)
  echo "$context_json" | grep -o "\"$field\":\"[^\"]*\"" | cut -d'"' -f4
}

# Check if we're in a workspace
is_in_workspace() {
  local context_type=$(get_context_field "type")
  [[ "$context_type" == "$CONTEXT_WORKSPACE" ]]
}

# Check if we're in a project
is_in_project() {
  local context_type=$(get_context_field "type")
  [[ "$context_type" == "$CONTEXT_PROJECT" ]]
}

# Check if we're in a nested project (project with parent workspace)
is_nested_project() {
  local context_type=$(get_context_field "type")
  local workspace_path=$(get_context_field "workspace_path")
  [[ "$context_type" == "$CONTEXT_PROJECT" && -n "$workspace_path" ]]
}

# Get current context path
get_context_path() {
  get_context_field "path"
}

# Get workspace path if in nested project
get_workspace_path() {
  get_context_field "workspace_path"
}

# Get context type
get_context_type() {
  get_context_field "type"
}
