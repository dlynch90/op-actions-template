# op-actions-template

Fact: One bootstrap secret per repo: `OP_SERVICE_ACCOUNT_TOKEN` (dedicated
1Password service account "GitHub Actions", read-only, Development vault).
Every other secret loads live in workflows via `op://` refs with
`1password/load-secrets-action@v5`. Rotate in 1Password only.

## Use in a workflow

```yaml
- uses: 1password/load-secrets-action@v5
  id: op_secrets
  env:
    OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}
    MY_SECRET: op://<vault-id>/<item-id>/credential
- run: echo "loaded (masked): ${{ steps.op_secrets.outputs.MY_SECRET }}"
```

## New repo checklist

1. Create repo from this template (or copy `.github/workflows/`).
2. Run `scripts/bootstrap-op-secrets.sh <owner>/<repo>` from a machine
   with `op` (read SA) + `gh` (repo scope). It sets
   `OP_SERVICE_ACCOUNT_TOKEN` + `OP_SA_CANARY_REF` without printing values.
3. Dispatch `op-secrets-smoke` workflow; expect "1Password load OK".

Org repos (Empathy-First-Media): prefer ONE org-level
`OP_SERVICE_ACCOUNT_TOKEN` secret (visibility: all repositories) once
`gh auth refresh -h github.com -s admin:org` has been run; new org repos
then need zero per-repo setup. Per-repo secrets already set are overrides.

Bad Pattern: `op run` in CI, copying secret values into GitHub secrets,
name-based `op://` refs (use vault/item IDs).
