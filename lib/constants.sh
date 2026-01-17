#!/bin/bash

# ============================================================================
# Global Constants
# ============================================================================

readonly ENVFORGE_VERSION="0.1.0"
readonly ENVFORGE_HOME="${ENVFORGE_HOME:-$HOME/.envforge}"
readonly ENVFORGE_TOOLS_DIR="$ENVFORGE_HOME/tools"
readonly ENVFORGE_CACHE_DIR="$ENVFORGE_HOME/cache"
readonly ENVFORGE_AUDIT_LOG="$ENVFORGE_HOME/audit.log"

# Supported tools (Phase 1)
readonly SUPPORTED_TOOLS=(
  "java"
  "gradle"
  "maven"
  "cmake"
  "node"
  "python"
  "docker"
  "kubernetes"
)

# Context types
readonly CONTEXT_WORKSPACE="workspace"
readonly CONTEXT_PROJECT="project"
readonly CONTEXT_STANDALONE="standalone"
