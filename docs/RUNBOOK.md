# Self-Hosted Runner Operations Runbook

## Prerequisites
* **OS:** Ubuntu 24.04 LTS (VM or WSL2 lab environment)
* **Control Dependencies:** Ansible `2.16+`, Git, and `sudo` privileges
* **Network Access:** Outbound HTTPS (`443`) to `github.com`, `api.github.com`, `deb.nodesource.com`, `apt.releases.hashicorp.com`, and `cli.github.com`

---

## 1. Initial Node Provisioning
Run the baseline playbook to install all required packages, runtimes, security CLIs, and extract the GitHub Actions runner binary:

```bash
ansible-playbook -i inventory.ini site.yml --ask-become-pass
```

Verify idempotency by running the playbook a second time and confirming `changed=0` and `failed=0`.

---

## 2. Registering the Runner with GitHub
1. Open the target repository or organization on GitHub and navigate to **Settings > Actions > Runners > New self-hosted runner**.
2. Select **Linux** and **x64**, then copy the temporary registration token.
3. Execute the registration playbook:

```bash
ansible-playbook -i inventory.ini site.yml -e "runner_token=<YOUR_TOKEN>" --ask-become-pass
```

4. Confirm the runner appears in GitHub Settings with status **Idle** and labels `self-hosted`, `linux`, `intern-lab`.

---

## 3. Routine Maintenance & Drift Remediation
If a binary is accidentally removed, corrupted, or modified on the runner host:

```bash
ansible-playbook -i inventory.ini site.yml --ask-become-pass
```

* Because `runner.yml` checks for `/opt/actions-runner/.runner` before attempting registration, maintenance runs do **not** require a new `runner_token`.

---

## 4. Service Management & Troubleshooting

| Task | Command |
| :--- | :--- |
| **Check service status** | `sudo /opt/actions-runner/svc.sh status` |
| **Start runner service** | `sudo /opt/actions-runner/svc.sh start` |
| **Restart runner service** | `sudo /opt/actions-runner/svc.sh restart` |
| **View runner service logs** | `journalctl -u actions.runner.* -n 50 --no-pager` |
| **Force re-registration** | `sudo rm -f /opt/actions-runner/.runner` then re-run Step 2 with a fresh token |