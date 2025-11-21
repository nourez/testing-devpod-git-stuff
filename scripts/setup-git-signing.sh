#!/usr/bin/env bash
set -e

echo "🔧 Configuring SSH signing for THIS repo..."

# 1. Force SSH-based signing at the *repo* level
git config --local gpg.format ssh
git config --local gpg.ssh.program "$(which ssh-keygen)"
git config --local commit.gpgsign true

# 2. Do NOT touch user.signingkey here.
#    DevPod is already populating a correct global user.signingkey
#    from your host config, and that will be used automatically.

echo "✅ Repo-level SSH signing configured (using global user.signingkey)."
