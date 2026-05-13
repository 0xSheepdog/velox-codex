# Nexus 3 User Management (Ansible)

Operator-run Ansible project for managing users, roles, and privileges on a
Sonatype Nexus 3 Pro repository server. Authenticates via **Nexus User
Tokens** (not the admin password).

## Prerequisites

1. **Nexus 3 Pro** with User Tokens enabled (Security → User Tokens).
2. A dedicated Nexus service account with the privileges needed for these
   playbooks (user create/read, role read). Generate a User Token for that
   account in the Nexus UI under your profile → User Token.
3. Ansible installed on the operator's laptop (`ansible-core` 2.14+).
4. Ansible Vault password file or prompt for decrypting the token vault.
5. Required Ansible collections installed **into the project**, not the
   system. Run this from the project root:

   ```bash
   ansible-galaxy collection install -r requirements.yml -p ./collections
   ```

   `ansible.cfg` sets `collections_path = ./collections`, which tells
   Ansible to look there for collections. The `collections/` directory
   is gitignored.

## One-time setup

Encrypt your User Token credentials with Ansible Vault:

```bash
ansible-vault create inventory/group_vars/all/vault.yml
```

Add the following content:

```yaml
vault_nexus_token_user: "NuByxxxxxxxxxxxxxxxx"     # token "name code"
vault_nexus_token_pass: "abcd1234efgh5678ijkl"     # token "pass code"
```

Edit `inventory/group_vars/all/main.yml` and set `nexus_url` to your Nexus
server.

## Playbooks

> **All playbooks must be run from the project root directory.** Ansible
> resolves the `inventory` path in `ansible.cfg` relative to your current
> working directory, not the config file. Running `ansible-playbook` from
> the `playbooks/` subdirectory will cause `group_vars/` to not load and
> the playbook will fail with an "undefined variable" error. Each playbook
> includes a preflight check that detects this and prints a clear
> diagnostic.

### 1. Create user accounts (bulk, from CSV)

```bash
ansible-playbook playbooks/create_users.yml --ask-vault-pass
```

The playbook will prompt for the path to a CSV file. A template is provided
at `files/users_template.csv`. Copy it, fill in your users, and provide the
path when prompted.

- All accounts are created with status `disabled`.
- A random throw-away password is generated for each account (not recorded).
- Operators activate accounts and set real passwords through Nexus directly.

### 2. Display privileges for a role

```bash
ansible-playbook playbooks/show_role_privileges.yml --ask-vault-pass
```

Prompts for a role ID (e.g., `nx-admin`, `nx-developer`, or a custom role).

### 3. Display account details and privileges for a user

```bash
ansible-playbook playbooks/show_user_details.yml --ask-vault-pass
```

Prompts for a userId. Shows the user record plus the privileges granted by
each of the user's assigned roles.

### 4. List all local users

```bash
ansible-playbook playbooks/list_local_users.yml --ask-vault-pass
```

Lists every user in the built-in Nexus realm (`source=default`) with their
basic details and assigned roles. Excludes SAML, LDAP, and other external
realm users. Takes no input.

## Notes

- These playbooks run on `localhost`; no managed nodes are required.
- All API traffic uses your User Token, not the admin password. Token
  compromise is mitigated by revoking the token in Nexus without changing
  any account passwords.
