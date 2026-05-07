# libvirt-isolated-network

Ansible project to configure an isolated libvirt NAT network on an EL9
hypervisor. Guests on this network can reach the internet via NAT but
cannot reach the host services or other guests on the same bridge. The
host can initiate SSH connections to guests; conntrack handles return
traffic.

## Layout

```
.
├── ansible.cfg               # Project-local Ansible config
├── requirements.yml          # Collection dependencies
├── site.yml                  # Top-level playbook
├── inventory/
│   └── hosts.ini             # Inventory
└── roles/
    └── libvirt_isolated_network/
        ├── defaults/main.yml # Operator-overridable defaults
        ├── vars/main.yml     # Internal/computed values
        ├── tasks/main.yml    # Role tasks
        ├── handlers/main.yml # Handlers
        ├── templates/        # Jinja2 templates
        └── meta/main.yml     # Role metadata
```

## Usage

Install collection dependencies:

```bash
ansible-galaxy collection install -r requirements.yml
```

Run the playbook:

```bash
ansible-playbook site.yml
```

The playbook escalates via `become` (configured in `ansible.cfg` and
`site.yml`).

## Overriding Defaults

All operator-tunable values live in
`roles/libvirt_isolated_network/defaults/main.yml`. Override them in
group_vars, host_vars, or via `--extra-vars`. Example:

```bash
ansible-playbook site.yml \
  -e libvirt_net_name=my-isolated \
  -e libvirt_net_bridge=virbr20 \
  -e libvirt_net_subnet_cidr=10.50.0.0/24
```

## Validation

After the play completes:

```bash
# On the hypervisor
virsh net-list --all
nft list table inet libvirt_isolated
```

From a guest joined to this network: `curl -I https://access.redhat.com`
should succeed; `ssh <host_ip_on_bridge>` should time out.
