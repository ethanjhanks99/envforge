#!/bin/bash

# ============================================================================
# Step 1 Tests: CLI Framework & Entry Point
# ============================================================================

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Setup
ENVFORGE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENVFORGE_SCRIPT="$ENVFORGE_ROOT/envforge"
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# ============================================================================
# TEST UTILITIES
# ============================================================================

test_start() {
  local test_name="$1"
  printf "%-70s " "Test: $test_name"
}

test_pass() {
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
}

test_fail() {
  local reason="$1"
  echo -e "${RED}FAIL${NC}"
  echo "  Reason: $reason"
  ((TESTS_FAILED++))
}

test_skip() {
  local reason="$1"
  echo -e "${YELLOW}SKIP${NC}"
  echo "  Reason: $reason"
  ((TESTS_SKIPPED++))
}

# ============================================================================
# TEST 1.1: Entry Point Exists and is Executable
# ============================================================================

test_start "envforge script exists"
if [[ -f "$ENVFORGE_SCRIPT" ]]; then
  test_pass
else
  test_fail "Script not found at $ENVFORGE_SCRIPT"
fi

test_start "envforge script is executable"
if [[ -x "$ENVFORGE_SCRIPT" ]]; then
  test_pass
else
  test_fail "Script is not executable"
fi

# ============================================================================
# TEST 1.2: Help Flag Works
# ============================================================================

test_start "--help flag displays usage"
output=$("$ENVFORGE_SCRIPT" --help 2>&1)
if echo "$output" | grep -q "Usage: envforge"; then
  test_pass
else
  test_fail "Help output missing 'Usage: envforge'"
fi

test_start "-h flag displays usage"
output=$("$ENVFORGE_SCRIPT" -h 2>&1)
if echo "$output" | grep -q "Usage: envforge"; then
  test_pass
else
  test_fail "Help output missing 'Usage: envforge'"
fi

test_start "help subcommand displays usage"
output=$("$ENVFORGE_SCRIPT" help 2>&1)
if echo "$output" | grep -q "Usage: envforge"; then
  test_pass
else
  test_fail "Help output missing 'Usage: envforge'"
fi

test_start "help contains workspace command"
output=$("$ENVFORGE_SCRIPT" --help 2>&1)
if echo "$output" | grep -q "workspace"; then
  test_pass
else
  test_fail "Help missing 'workspace' command"
fi

test_start "help contains project command"
output=$("$ENVFORGE_SCRIPT" --help 2>&1)
if echo "$output" | grep -q "project"; then
  test_pass
else
  test_fail "Help missing 'project' command"
fi

test_start "help contains tool command"
output=$("$ENVFORGE_SCRIPT" --help 2>&1)
if echo "$output" | grep -q "tool"; then
  test_pass
else
  test_fail "Help missing 'tool' command"
fi

test_start "help contains status command"
output=$("$ENVFORGE_SCRIPT" --help 2>&1)
if echo "$output" | grep -q "status"; then
  test_pass
else
  test_fail "Help missing 'status' command"
fi

test_start "help contains init command"
output=$("$ENVFORGE_SCRIPT" --help 2>&1)
if echo "$output" | grep -q "init"; then
  test_pass
else
  test_fail "Help missing 'init' command"
fi

# ============================================================================
# TEST 1.3: Version Flag Works
# ============================================================================

test_start "--version flag displays version"
output=$("$ENVFORGE_SCRIPT" --version 2>&1)
if echo "$output" | grep -q "envforge"; then
  test_pass
else
  test_fail "Version output missing 'envforge'"
fi

test_start "-v flag displays version"
output=$("$ENVFORGE_SCRIPT" -v 2>&1)
if echo "$output" | grep -q "envforge"; then
  test_pass
else
  test_fail "Version output missing 'envforge'"
fi

test_start "version subcommand displays version"
output=$("$ENVFORGE_SCRIPT" version 2>&1)
if echo "$output" | grep -q "envforge"; then
  test_pass
else
  test_fail "Version output missing 'envforge'"
fi

test_start "version output includes version number"
output=$("$ENVFORGE_SCRIPT" --version 2>&1)
if echo "$output" | grep -qE "[0-9]+\.[0-9]+\.[0-9]+"; then
  test_pass
else
  test_fail "Version output missing version number pattern"
fi

# ============================================================================
# TEST 1.4: Command Routing Works
# ============================================================================

test_start "workspace subcommand is recognized"
output=$("$ENVFORGE_SCRIPT" workspace --help 2>&1)
if echo "$output" | grep -q "workspace create"; then
  test_pass
else
  test_fail "workspace subcommand not recognized"
fi

test_start "project subcommand is recognized"
output=$("$ENVFORGE_SCRIPT" project --help 2>&1)
if echo "$output" | grep -q "project create"; then
  test_pass
else
  test_fail "project subcommand not recognized"
fi

test_start "tool subcommand is recognized"
output=$("$ENVFORGE_SCRIPT" tool --help 2>&1)
if echo "$output" | grep -q "tool"; then
  test_pass
else
  test_fail "tool subcommand not recognized"
fi

test_start "status subcommand is recognized"
output=$("$ENVFORGE_SCRIPT" status --help 2>&1)
if echo "$output" | grep -q "status"; then
  test_pass
else
  test_fail "status subcommand not recognized"
fi

test_start "init subcommand is recognized"
output=$("$ENVFORGE_SCRIPT" init --help 2>&1)
if echo "$output" | grep -q "init"; then
  test_pass
else
  test_fail "init subcommand not recognized"
fi

test_start "unknown command fails with error"
output=$("$ENVFORGE_SCRIPT" unknown-command 2>&1 || true)
if echo "$output" | grep -q "Unknown command"; then
  test_pass
else
  test_fail "Unknown command did not produce error message"
fi

test_start "no arguments displays usage"
output=$("$ENVFORGE_SCRIPT" 2>&1 || true)
if echo "$output" | grep -q "Usage: envforge"; then
  test_pass
else
  test_fail "No arguments should display usage"
fi

# ============================================================================
# TEST 1.5: Context Detection Works
# ============================================================================

# Test 1: Standalone context (outside any project/workspace)
test_start "standalone context detected correctly"
cd "$TEST_DIR"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "standalone"; then
  test_pass
else
  test_fail "Standalone context not detected"
fi

# Test 2: Project context detection
test_start "project context detected correctly"
mkdir -p "$TEST_DIR/test-project"
cat > "$TEST_DIR/test-project/.envrc" <<'EOF'
export ENVFORGE_TYPE=project
EOF
cd "$TEST_DIR/test-project"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "project"; then
  test_pass
else
  test_fail "Project context not detected"
fi

# Test 3: Workspace context detection
test_start "workspace context detected correctly"
mkdir -p "$TEST_DIR/test-workspace"
cat > "$TEST_DIR/test-workspace/.envrc" <<'EOF'
export ENVFORGE_TYPE=workspace
EOF
cd "$TEST_DIR/test-workspace"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "workspace"; then
  test_pass
else
  test_fail "Workspace context not detected"
fi

# Test 4: Nested project context detection
test_start "nested project context detected correctly"
mkdir -p "$TEST_DIR/test-workspace/test-project"
cat > "$TEST_DIR/test-workspace/.envrc" <<'EOF'
export ENVFORGE_TYPE=workspace
EOF
cat > "$TEST_DIR/test-workspace/test-project/.envrc" <<'EOF'
export ENVFORGE_TYPE=project
EOF
cd "$TEST_DIR/test-workspace/test-project"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "project" && echo "$output" | grep -q "nested"; then
  test_pass
else
  test_fail "Nested project context not detected correctly"
fi

# ============================================================================
# TEST 1.6: Debug Flag Works
# ============================================================================

test_start "--debug flag enables debug output"
output=$("$ENVFORGE_SCRIPT" --debug status 2>&1 || true)
if echo "$output" | grep -q "DEBUG\|ENVFORGE_TYPE"; then
  test_pass
else
  test_fail "Debug output not visible with --debug flag"
fi

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "============================================================================"
echo "Step 1 Test Results"
echo "============================================================================"
echo -e "Passed:  ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed:  ${RED}$TESTS_FAILED${NC}"
echo -e "Skipped: ${YELLOW}$TESTS_SKIPPED${NC}"
echo "Total:   $((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))"
echo "============================================================================"

if [[ $TESTS_FAILED -eq 0 ]]; then
  echo -e "${GREEN}✓ All tests passed!${NC}"
  exit 0
else
  echo -e "${RED}✗ Some tests failed${NC}"
  exit 1
fi
