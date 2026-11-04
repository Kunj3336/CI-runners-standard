# Standard Self-Hosted CI Runner Tools

## Objective
Establish a single source of truth for all software packages installed on self-hosted GitHub Actions runners within the intern organization to ensure consistent CI execution and prevent environment drift.

## Standard Tool Inventory

| Tool | Proposed Version | Installation Method | Purpose in CI Pipelines |
| :--- | :--- | :--- | :--- |
| **Python 3** | `3.12.x` (Distro default) | `apt` (`python3.12`) | Script execution, testing frameworks, and tooling |
| **pip & venv** | Distro default | `apt` (`python3-pip`, `python3-venv`) | Dependency management and isolated virtual environments |
| **Node.js** | `22.x LTS` | NodeSource APT repository | JavaScript/TypeScript builds, linting, frontend actions |
| **npm** | Bundled with Node 22 | NodeSource package | Package manager for Node dependencies |
| **jq** | Distro default | `apt` | Parsing JSON outputs from API queries and CLI tools |
| **unzip / zip** | Distro default | `apt` | Packaging and extracting build artifacts and archives |
| **Vault** | `1.18.x` | HashiCorp APT repository | Pulling secrets during automated test and deploy stages |
| **Git** | Distro default | `apt` | Repository checkout, tagging, and branch operations |
| **cURL / wget** | Distro default | `apt` | Downloading remote assets, payloads, and endpoint health checks |
| **GitHub CLI (`gh`)**| Latest stable | GitHub official APT repository | CI PR automation, release drafting, and GitHub API queries |
| **build-essential** | Distro default | `apt` | Compiling native binaries and C extensions |
| **make** | Distro default | `apt` | Standard build and automation entry points |

## Exclusions & Constraints
- **Docker:** Excluded from base runner footprint to conserve compute resources on lightweight VMs (2 GB RAM, 2 vCPU). Workflows requiring container builds will be evaluated separately.