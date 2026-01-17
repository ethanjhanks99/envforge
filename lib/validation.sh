#!/bin/bash

# ============================================================================
# Input Validation Module
# ============================================================================

# Validate that a name is valid for workspace/project
# Valid names: alphanumeric, hyphens, underscores, start with letter
validate_name() {
  local name="$1"
  
  if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    error "Invalid name: '$name'"
    error "Names must start with a letter and contain only letters, numbers, hyphens, and underscores"
    return 1
  fi
  
  return 0
}

# Validate directory path
validate_path() {
  local path="$1"
  
  if [[ -z "$path" ]]; then
    error "Path cannot be empty"
    return 1
  fi
  
  # Expand ~ to home directory
  path="${path/#\~/$HOME}"
  
  # Check if parent directory exists
  local parent_dir="$(dirname "$path")"
  if [[ ! -d "$parent_dir" ]]; then
    error "Parent directory does not exist: $parent_dir"
    return 1
  fi
  
  return 0
}

# Check if directory is empty
is_empty_directory() {
  local dir="$1"
  
  if [[ ! -d "$dir" ]]; then
    return 0  # Doesn't exist, so "empty"
  fi
  
  # Check if directory has any files (including hidden)
  [[ -z "$(find "$dir" -maxdepth 1 -type f -o -type d)" ]]
}

# Validate tool name
validate_tool_name() {
  local tool="$1"
  
  if [[ -z "$tool" ]]; then
    error "Tool name cannot be empty"
    return 1
  fi
  
  # Check if tool is in supported list
  local tool_base="${tool%@*}"  # Remove @version if present
  
  for supported_tool in "${SUPPORTED_TOOLS[@]}"; do
    if [[ "$tool_base" == "$supported_tool" ]]; then
      return 0
    fi
  done
  
  error "Unsupported tool: $tool_base"
  error "Supported tools: $(join_by ', ' "${SUPPORTED_TOOLS[@]}")"
  return 1
}

# Parse tool specification (name@version)
parse_tool_spec() {
  local spec="$1"
  local tool_name="${spec%@*}"
  local tool_version="${spec#*@}"
  
  # If no version specified, set to empty
  if [[ "$tool_name" == "$tool_version" ]]; then
    tool_version=""
  fi
  
  echo "{\"name\":\"$tool_name\",\"version\":\"$tool_version\"}"
}
