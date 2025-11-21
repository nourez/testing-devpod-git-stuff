#!/usr/bin/env bash
set -e

echo "🔧 Configuring SSH signing for THIS repo..."

# ------------------------------------------------------------
# 1. Ensure Git uses SSH signing at repo level (cannot be overridden)
# ------------------------------------------------------------
git config --local gpg.format ssh
git config --local gpg.ssh.program "$(which ssh-keygen)"
git config --local commit.gpgsign true

# ------------------------------------------------------------
# 2. Auto-detect forwarded SSH key from the host (1Password, macOS, YubiKey, etc.)
# ------------------------------------------------------------
key=$(ssh-add -L 2>/dev/null | head -n 1 || true)

if [ -n "$key" ] && [[ "$key" == ssh-* ]]; then
    echo "🔐 Using SSH signing key:"
    echo "$key"
    git config --local user.signingkey "$key"
else
    echo "⚠️ No SSH signing key detected via ssh-agent forwarding."
    echo "   Signing will work once your SSH agent is forwarded."
    echo "   (1Password users: ensure the SSH Agent is enabled and ForwardAgent is on.)"
fi

echo "✅ Repo-level SSH signing configured successfully."
