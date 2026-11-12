# Standardization & Drift Remediation Demo Walkthrough

This document logs the end-to-end validation of the standardized self-hosted runner environment (`Kunj3336/CI-runners-standard`).

---

## Phase 1: Idempotent Provisioning & Tool Verification
1. Executed `ansible-playbook -i inventory.ini site.yml --ask-become-pass` twice against `localhost`.
2. Confirmed zero configuration drift on the second run (`ok=3 changed=0 unreachable=0 failed=0`) — see `docs/evidence/01-ansible-idempotency.png`.
3. Validated automated binary assertions in `roles/ci_runner/tasks/verify.yml` across `jq`, `unzip`, `python3.12`, `node`, `npm`, `vault`, `gh`, and `git` — see `docs/evidence/02-tool-verification-success.png`.

---

## Phase 2: Runner Service Registration & Baseline CI Check
1. Upgraded the runner agent to `v2.338.2` to meet GitHub's minimum runner version enforcement (`>= 2.329.0`).
2. Registered `DESKTOP-DOR1O2P-runner` under user `runner` and verified **Idle** status in GitHub Settings — see `docs/evidence/03-org-runner-idle.png`.
3. Pushed `.github/workflows/runner-self-check.yml` and verified a clean green execution across all job steps — see `docs/evidence/04-self-check-green.png`.

---

## Phase 3: Break-and-Fix Drift Simulation
1. **Injected Drift:** Uninstalled `jq` on the runner host (`sudo apt remove -y jq`).
2. **Triggered CI Check:** Manually dispatched `Runner Self-Check` via GitHub Actions; the workflow failed at `Check System & Core Utilities` with `jq: command not found` (exit code `127`) — see `docs/evidence/05-drift-failure-red.png`.
3. **Remediated via Ansible:** Re-ran `ansible-playbook -i inventory.ini site.yml --ask-become-pass` to restore `jq` automatically.
4. **Verified Recovery:** Re-ran `Runner Self-Check` via GitHub Actions and confirmed all steps passed green — see `docs/evidence/06-drift-recovery-green.png`.