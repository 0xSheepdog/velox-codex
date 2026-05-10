# Neptune Team - NXRM3 PRO Privilege & Role Design

## Overview

This document defines the RBAC configuration for the Neptune team in Nexus Repository Manager PRO 3.90.1. Users authenticate via Okta SAML and are mapped to one of two groups:

- **DevLead** - Full content control over team repositories (push, pull, overwrite, delete artifacts).
- **Dev** - Read-only access to team repositories (pull and browse only).

Both groups require access via the web UI, REST API, Docker CLI, and HTTP.

---

## QOL Privileges (Web UI)

These built-in privileges are included in both roles for a functional web UI experience.

| Privilege | Purpose |
|---|---|
| `nx-search-read` | Search bar functionality in the UI |
| `nx-healthcheck-read` | View repository health check results |

---

## User Token Privileges

User Tokens are the credential mechanism for non-interactive and CLI-based access (Docker CLI, REST API, HTTP PUT/POST, CI pipelines). They act as a proxy for the user's identity without exposing Okta SSO credentials and can be revoked independently.

Users generate their own token under **Account → User Token** in the UI. The token pair (username code + passcode) is used wherever Basic Auth is accepted. Token values are system-generated and cannot be user-specified. Users can only generate, view (once at creation), and reset their tokens.

**Prerequisite:** The **User Token realm** must be activated under **Security → Realms**.

| Privilege | Purpose | Assign To |
|---|---|---|
| `nx-usertoken-current` | Generate, view, and reset their own User Token | Both roles |

> **Note:** `nx-userschangepw` is intentionally excluded. That privilege controls local NXRM password changes, which are not applicable when authentication is handled by Okta SAML.

---

## Repository Inventory

| Repo Name | Format | Type | Group Membership |
|---|---|---|---|
| `neptune-internal-containers` | docker | hosted | Member of `neptune` (docker group) |
| `neptune` | docker | group | Writable member: `neptune-internal-containers` |
| `ironbank` | docker | hosted | Not a member of any group |
| `neptune-internal-artifacts` | raw | hosted | n/a |
| `neptune-helm` | helm | hosted | n/a |

---

## Repository Privileges

### Docker - `neptune` Group & `neptune-internal-containers`

The `neptune` Docker group repo has `neptune-internal-containers` configured as its writable member, allowing Docker clients to use the single group endpoint for both push and pull. Pushes are routed server-side to `neptune-internal-containers`, but privilege checks are still evaluated against the hosted repo.

| Repo | Type | DevLead | Dev |
|---|---|---|---|
| `neptune-internal-containers` | hosted | `nx-repository-view-docker-neptune-internal-containers-*` | `browse`, `read` |
| `neptune` | group | `browse`, `read` | `browse`, `read` |

### Docker - `ironbank`

The `ironbank` repo is a standalone hosted Docker repository, not a member of any group. Clients interact with it directly.

| Repo | Type | DevLead | Dev |
|---|---|---|---|
| `ironbank` | hosted | `nx-repository-view-docker-ironbank-*` | `browse`, `read` |

### Raw - `neptune-internal-artifacts`

| Repo | Type | DevLead | Dev |
|---|---|---|---|
| `neptune-internal-artifacts` | hosted | `nx-repository-view-raw-neptune-internal-artifacts-*` | `browse`, `read` |

### Helm - `neptune-helm`

| Repo | Type | DevLead | Dev |
|---|---|---|---|
| `neptune-helm` | hosted | `nx-repository-view-helm-neptune-helm-*` | `browse`, `read` |

---

## Role Definitions

### Role: `neptune-devlead`

Full content control across all Neptune repositories.

**Privileges:**

- `nx-search-read`
- `nx-healthcheck-read`
- `nx-usertoken-current`
- `nx-repository-view-docker-neptune-internal-containers-*`
- `nx-repository-view-docker-ironbank-*`
- `nx-repository-view-raw-neptune-internal-artifacts-*`
- `nx-repository-view-helm-neptune-helm-*`
- `nx-repository-view-docker-neptune-browse`
- `nx-repository-view-docker-neptune-read`

### Role: `neptune-dev`

Read-only access across all Neptune repositories.

**Privileges:**

- `nx-search-read`
- `nx-healthcheck-read`
- `nx-usertoken-current`
- `nx-repository-view-docker-neptune-internal-containers-browse`
- `nx-repository-view-docker-neptune-internal-containers-read`
- `nx-repository-view-docker-ironbank-browse`
- `nx-repository-view-docker-ironbank-read`
- `nx-repository-view-raw-neptune-internal-artifacts-browse`
- `nx-repository-view-raw-neptune-internal-artifacts-read`
- `nx-repository-view-helm-neptune-helm-browse`
- `nx-repository-view-helm-neptune-helm-read`
- `nx-repository-view-docker-neptune-browse`
- `nx-repository-view-docker-neptune-read`

---

## What's Not Included (By Design)

- **`repository-admin` privileges** - Repo configuration changes (write policy, blob store, cleanup policies, online/offline) remain with NXRM3 global admins.
- **`nx-all` / wildcard admin** - No team role receives blanket admin access.
- **`nexus:users:update`** - This is effectively admin-equivalent; users with it can modify any user's roles including their own.
- **`nx-userschangepw`** - Not applicable with Okta SAML authentication.

---

## Important Notes

- **Access is additive, not subtractive.** Access allowed by one privilege cannot be revoked by another. Structure roles with narrow scopes.
- **SAML group mapping.** The role `id` values (`neptune-devlead`, `neptune-dev`) must match the group names in your Okta SAML attribute mapping.
- **Privilege naming convention.** System-generated privilege names follow the pattern `nx-repository-view-{format}-{reponame}-{action}`. Verify these match what appears in **Security → Privileges** in your NXRM3 instance.
- **User Token realm.** The User Token realm must be activated under **Security → Realms** before users can generate tokens.
- **Docker group writable member.** Verify push routing through the `neptune` group endpoint with a DevLead account after role configuration is applied.
