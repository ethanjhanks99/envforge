## Phase 1 Actionable Items

### 1. CLI Framework & Entry Point
- [ ] Create main `envforge` bash script entry point
- [ ] Implement command routing/dispatch mechanism
- [ ] Add help text and usage information
- [ ] Support `--version` and `--help` flags
- [ ] Implement context detection (workspace/project/standalone)

### 2. Workspace Creation
- [ ] Implement `envforge workspace create <name>` command
- [ ] Generate `.envrc` with `ENVFORGE_TYPE=workspace` marker
- [ ] Create `.bin/` directory with placeholder scripts
- [ ] Create `.envforge/tools.yaml` with empty tools section
- [ ] Generate initial `README.md`
- [ ] Support `--path` flag to create in specific directory
- [ ] Support `--tools` flag to pre-populate tool declarations

### 3. Project Creation
- [ ] Implement `envforge project create <name>` command
- [ ] Generate `.envrc` with `ENVFORGE_TYPE=project` marker
- [ ] Create `.bin/` directory with default scripts (build, run, test, clean, brun)
- [ ] Create `.envforge/tools.yaml` with empty tools section
- [ ] Generate initial `README.md`
- [ ] Support `--path` flag to create in specific directory
- [ ] Support `--tools` flag to pre-populate tool declarations
- [ ] Fail gracefully if already inside a workspace/project

### 4. Tool Installation Infrastructure
- [ ] Implement `envforge tool install <tool>` command
- [ ] Create global cache directory structure (`~/.envforge/tools/`, `~/.envforge/cache/`)
- [ ] Implement tool registry with supported tools (Java, Gradle, Maven, CMake, Node, Next.js, Kubernetes, etc.)
- [ ] Download binary/archive matching OS and architecture
- [ ] Extract to correct cache location
- [ ] Update project/workspace `tools.yaml` with installed tool
- [ ] Support version selection: `envforge tool install gradle@8.5`
- [ ] Handle missing/network failures with retry logic and clear error messages
- [ ] Check compatibility (OS/arch) before installing

### 5. YAML Configuration Handling
- [ ] Implement YAML parser for `tools.yaml`
- [ ] Validate YAML syntax and structure
- [ ] Read tool declarations and versions from YAML
- [ ] Support manual YAML editing with validation
- [ ] Handle missing or malformed YAML gracefully
- [ ] Track tool paths in YAML for custom installations

### 6. `.envrc` Generation & Management
- [ ] Generate `.envrc` templates for workspace and project
- [ ] Inject tool declarations into `.envrc` based on `tools.yaml`
- [ ] Set `ENVFORGE_TYPE` and `ENVFORGE_CACHE` variables
- [ ] Implement `path_add` function for direnv compatibility
- [ ] Ensure `.envrc` is idempotent and side-effect-free
- [ ] Allow `.envrc` to be regenerated without losing customizations

### 7. `.bin` Script Generation & Delegation
- [ ] Create default `.bin/build` script with project-type detection (Gradle, CMake, Makefile)
- [ ] Create default `.bin/run` script
- [ ] Create default `.bin/test` script
- [ ] Create default `.bin/clean` script
- [ ] Create default `.bin/brun` script (build + run)
- [ ] Implement graceful fallback when tool is not detected
- [ ] Support custom `.bin/` scripts (user-extensible)

### 8. Context Detection & Management
- [ ] Implement `envforge status` command to show current context
- [ ] Detect workspace vs. project vs. standalone context
- [ ] Walk filesystem to find parent workspace when in nested project
- [ ] Support nested project environment merging
- [ ] Warn on ambiguous contexts (multiple `.envrc` at same level)

### 9. Tool Removal & Cleanup
- [ ] Implement `envforge tool remove <tool>` command
- [ ] Remove tool from project/workspace `tools.yaml`
- [ ] Implement `envforge tool prune` to clean unused global cache versions
- [ ] Provide cleanup confirmation prompts for destructive operations

### 10. Core Error Handling & Validation
- [ ] Validate `.envrc` syntax before activation
- [ ] Validate `tools.yaml` structure and content
- [ ] Check OS/architecture compatibility before tool installation
- [ ] Verify `~/.envforge/tools/` directory is writable
- [ ] Provide clear, actionable error messages for all failure modes
- [ ] Create `.envforge/audit.log` for tracking installations/removals
- [ ] Prevent nested workspace creation without confirmation

### 11. direnv Integration
- [ ] Ensure `.envrc` files are compatible with direnv
- [ ] Test with `direnv allow` workflow
- [ ] Verify `path_add` and environment variables work correctly
- [ ] Document direnv installation requirement with helpful links

### 12. Testing & Validation
- [ ] Unit tests for context detection logic
- [ ] Integration tests for workspace creation workflow
- [ ] Integration tests for project creation workflow
- [ ] Integration tests for tool installation (with mock downloads)
- [ ] Test nested project environment merging
- [ ] Test `.envrc` generation and direnv compatibility
- [ ] Test YAML parsing and validation
- [ ] Test error handling for all major failure paths

---
