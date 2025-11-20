#!/usr/bin/env bash
set -e

echo "🔧 Configuring Git SSH commit signing..."

# 1. Ensure SSH signing is the Git signing mode
git config --global gpg.format ssh

# 2. Ensure Git uses the *real* SSH signer (NOT devpod-ssh-signature)
git config --global gpg.ssh.program "$(which ssh-keygen)"

# 3. Always sign commits
git config --global commit.gpgsign true

# 4. Auto-detect forwarded SSH key (1Password, macOS, Yubikey, etc.)
key=$(ssh-add -L 2>/dev/null | head -n 1 || true)

if [ -n "$key" ]; then
    echo "🔐 Using SSH signing key:"
    echo "$key"
    git config --global user.signingkey "$key"
else
    echo "⚠️ No SSH keys found in agent."
    echo "   Signing will work once your SSH agent is forwarded."
    echo "   Tip: Ensure 1Password SSH agent + ForwardAgent are enabled."
fi

echo "✅ SSH Git signing configured."
