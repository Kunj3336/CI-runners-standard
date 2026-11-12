# Approved Self-Hosted Runner Toolchain

This document defines the standardized software baseline enforced across all self-hosted Linux GitHub Actions runners via the `ci_runner` Ansible role.

## Toolchain Matrix

| Tool / Package | Binary | Minimum / Target Standard | Installation Source | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **jq** | `jq` | `1.7+` | Ubuntu APT (`main`) | JSON parsing in CI scripts and API responses |
| **Unzip** | `unzip` | `6.00+` | Ubuntu APT (`main`) | Artifact and archive extraction |
| **Git** | `git` | `2.43+` | Ubuntu APT (`main`) | Source checkout and repository operations |
| **Python** | `python3.12` | `3.12.x` | Ubuntu APT (`main`) | Automation scripts, linters, and Python builds |
| **Pip** | `pip3` | `24.0+` | Ubuntu APT (`python3-pip`) | Python dependency management |
| **Node.js** | `node` | `v22.x` LTS | NodeSource Official Repo | JavaScript/TypeScript builds and tooling |
| **npm** | `npm` | `10.x+` | Bundled with Node.js 22 | Node package installation and scripts |
| **HashiCorp Vault** | `vault` | Latest Stable | HashiCorp Official APT Repo | Secret retrieval and dynamic credentials in CI |
| **GitHub CLI** | `gh` | `2.103.3+` | GitHub Official APT Repo | PR automation, workflow triggers, and releases |
| **Actions Runner** | `Runner.Listener` | `v2.338.2` | GitHub Actions Releases | Self-hosted CI job execution agent |

## Security & Repository Standards
* **No Deprecated `apt-key`:** All third-party GPG keys are stored as binary `.gpg` keyrings under `/etc/apt/keyrings/` and scoped via `signed-by=` in `/etc/apt/sources.list.d/`.
* **Least-Privilege Execution:** CI jobs execute under the dedicated non-root system user `runner` (`/opt/actions-runner`), never as `root`.