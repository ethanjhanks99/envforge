#!/bin/bash

# ============================================================================
# Step 1 Test Report Generator
# ============================================================================

set +e  # Don't exit on error, we want to capture all test results

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Setup
ENVFORGE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENVFORGE_SCRIPT="$ENVFORGE_ROOT/envforge"
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

echo "============================================================================"
echo "Step 1: CLI Framework & Entry Point - Test Suite"
echo "============================================================================"
echo "ENVFORGE_ROOT: $ENVFORGE_ROOT"
echo "ENVFORGE_SCRIPT: $ENVFORGE_SCRIPT"
echo "TEST_DIR: $TEST_DIR"
echo ""

# ============================================================================
# TEST 1: Entry Point Verification
# ============================================================================

echo "TEST GROUP 1: Entry Point Verification"
echo "─────────────────────────────────────────────────────────────────────────"

echo -n "1.1 envforge script exists: "
if [[ -f "$ENVFORGE_SCRIPT" ]]; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC} (not found at $ENVFORGE_SCRIPT)"
  ((TESTS_FAILED++))
fi

echo -n "1.2 envforge script is executable: "
if [[ -x "$ENVFORGE_SCRIPT" ]]; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC} (not executable)"
  ((TESTS_FAILED++))
fi

# ============================================================================
# TEST 2: Global Flags
# ============================================================================

echo ""
echo "TEST GROUP 2: Global Flags (--help, --version)"
echo "─────────────────────────────────────────────────────────────────────────"

echo -n "2.1 --help flag works: "
output=$("$ENVFORGE_SCRIPT" --help 2>&1)
if [[ $? -eq 0 ]] && echo "$output" | grep -q "Usage: envforge"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC} (exit code $? or missing 'Usage')"
  ((TESTS_FAILED++))
fi

echo -n "2.2 -h flag works: "
output=$("$ENVFORGE_SCRIPT" -h 2>&1)
if [[ $? -eq 0 ]] && echo "$output" | grep -q "Usage: envforge"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "2.3 help subcommand works: "
output=$("$ENVFORGE_SCRIPT" help 2>&1)
if [[ $? -eq 0 ]] && echo "$output" | grep -q "Usage: envforge"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "2.4 --version flag works: "
output=$("$ENVFORGE_SCRIPT" --version 2>&1)
if [[ $? -eq 0 ]] && echo "$output" | grep -q "envforge"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "2.5 -v flag works: "
output=$("$ENVFORGE_SCRIPT" -v 2>&1)
if [[ $? -eq 0 ]] && echo "$output" | grep -q "envforge"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "2.6 version subcommand works: "
output=$("$ENVFORGE_SCRIPT" version 2>&1)
if [[ $? -eq 0 ]] && echo "$output" | grep -q "envforge"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

# ============================================================================
# TEST 3: Help Content
# ============================================================================

echo ""
echo "TEST GROUP 3: Help Content Verification"
echo "─────────────────────────────────────────────────────────────────────────"

output=$("$ENVFORGE_SCRIPT" --help 2>&1)

echo -n "3.1 Help mentions 'workspace' command: "
if echo "$output" | grep -q "workspace"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "3.2 Help mentions 'project' command: "
if echo "$output" | grep -q "project"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "3.3 Help mentions 'tool' command: "
if echo "$output" | grep -q "tool"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "3.4 Help mentions 'status' command: "
if echo "$output" | grep -q "status"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "3.5 Help mentions 'init' command: "
if echo "$output" | grep -q "init"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

# ============================================================================
# TEST 4: Command Routing
# ============================================================================

echo ""
echo "TEST GROUP 4: Command Routing"
echo "─────────────────────────────────────────────────────────────────────────"

echo -n "4.1 workspace command recognized: "
output=$("$ENVFORGE_SCRIPT" workspace --help 2>&1)
if echo "$output" | grep -q "workspace create"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "4.2 project command recognized: "
output=$("$ENVFORGE_SCRIPT" project --help 2>&1)
if echo "$output" | grep -q "project create"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "4.3 tool command recognized: "
output=$("$ENVFORGE_SCRIPT" tool --help 2>&1)
if echo "$output" | grep -q "tool"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "4.4 status command recognized: "
output=$("$ENVFORGE_SCRIPT" status --help 2>&1)
if echo "$output" | grep -q "status"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "4.5 init command recognized: "
output=$("$ENVFORGE_SCRIPT" init --help 2>&1)
if echo "$output" | grep -q "init"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "4.6 unknown command produces error: "
output=$("$ENVFORGE_SCRIPT" unknown-command 2>&1)
exit_code=$?
if [[ $exit_code -ne 0 ]] && echo "$output" | grep -q "Unknown command"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC} (exit code $exit_code, no error message)"
  ((TESTS_FAILED++))
fi

echo -n "4.7 no arguments displays usage: "
output=$("$ENVFORGE_SCRIPT" 2>&1)
exit_code=$?
if [[ $exit_code -ne 0 ]] && echo "$output" | grep -q "Usage: envforge"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

# ============================================================================
# TEST 5: Context Detection
# ============================================================================

echo ""
echo "TEST GROUP 5: Context Detection"
echo "─────────────────────────────────────────────────────────────────────────"

echo -n "5.1 Standalone context detected: "
cd "$TEST_DIR"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "standalone"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "5.2 Project context detected: "
mkdir -p "$TEST_DIR/test-project"
cat > "$TEST_DIR/test-project/.envrc" <<'EOF'
export ENVFORGE_TYPE=project
EOF
cd "$TEST_DIR/test-project"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "project"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "5.3 Workspace context detected: "
mkdir -p "$TEST_DIR/test-workspace"
cat > "$TEST_DIR/test-workspace/.envrc" <<'EOF'
export ENVFORGE_TYPE=workspace
EOF
cd "$TEST_DIR/test-workspace"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "workspace"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "5.4 Nested project context detected: "
mkdir -p "$TEST_DIR/test-workspace/nested-project"
cat > "$TEST_DIR/test-workspace/nested-project/.envrc" <<'EOF'
export ENVFORGE_TYPE=project
EOF
cd "$TEST_DIR/test-workspace/nested-project"
output=$("$ENVFORGE_SCRIPT" status 2>&1)
if echo "$output" | grep -q "project" && echo "$output" | grep -q "Workspace"; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

# ============================================================================
# TEST 6: Module Loading
# ============================================================================

echo ""
echo "TEST GROUP 6: Module Loading & Utilities"
echo "─────────────────────────────────────────────────────────────────────────"

echo -n "6.1 lib/constants.sh exists: "
if [[ -f "$ENVFORGE_ROOT/lib/constants.sh" ]]; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "6.2 lib/utils.sh exists: "
if [[ -f "$ENVFORGE_ROOT/lib/utils.sh" ]]; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "6.3 lib/context.sh exists: "
if [[ -f "$ENVFORGE_ROOT/lib/context.sh" ]]; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "6.4 lib/validation.sh exists: "
if [[ -f "$ENVFORGE_ROOT/lib/validation.sh" ]]; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

echo -n "6.5 lib/commands/ directory exists: "
if [[ -d "$ENVFORGE_ROOT/lib/commands" ]]; then
  echo -e "${GREEN}PASS${NC}"
  ((TESTS_PASSED++))
else
  echo -e "${RED}FAIL${NC}"
  ((TESTS_FAILED++))
fi

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "============================================================================"
echo "Test Results Summary"
echo "============================================================================"
echo -e "Passed:  ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed:  ${RED}$TESTS_FAILED${NC}"
TOTAL=$((TESTS_PASSED + TESTS_FAILED))
echo "Total:   $TOTAL"
echo "============================================================================"

if [[ $TESTS_FAILED -eq 0 ]]; then
  echo -e "${GREEN}✓ All tests passed!${NC}"
  echo ""
  echo "Step 1 Implementation Status: COMPLETE ✓"
  exit 0
else
  echo -e "${RED}✗ Some tests failed${NC}"
  exit 1
fi
