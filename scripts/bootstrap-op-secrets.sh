#!/usr/bin/env bash
# Bootstrap 1Password -> GitHub Actions secrets on a repo. Never prints values.
# Usage: scripts/bootstrap-op-secrets.sh <owner>/<repo>
set -euo pipefail
REPO="${1:?usage: bootstrap-op-secrets.sh <owner>/<repo>}"
VAULT_ID="dfncpo4o2wrkjf6f3zo6zu35ta"           # Development: Global Fallback
SA_ITEM_ID="zn4exefxr4kxiwzgrvamcan3nm"        # 1Password - Development - Service Account Token (GitHub Actions)
CANARY_REF="op://${VAULT_ID}/2abogizfsusjkpz2432bastcdq/credential"
export OP_SERVICE_ACCOUNT_TOKEN="${OP_SERVICE_ACCOUNT_TOKEN:-$(cat "$HOME/.config/1password/service-account-token")}"
op read "op://${VAULT_ID}/${SA_ITEM_ID}/credential" | gh secret set OP_SERVICE_ACCOUNT_TOKEN --repo "$REPO"
printf '%s' "$CANARY_REF" | gh secret set OP_SA_CANARY_REF --repo "$REPO"
echo "OK: OP_SERVICE_ACCOUNT_TOKEN + OP_SA_CANARY_REF set on $REPO (values not printed)."
