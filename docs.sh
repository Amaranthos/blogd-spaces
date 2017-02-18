#!/bin/bash
set -e

repo=$(git config remote.origin.url)
sshRepo=${repo/https:\/\/github.com\//git@github.com:}
sha=$(git rev-parse --verify HEAD)

dub build -b ddox
cd "docs/"

if [[ -z $(git diff --exit-code) ]]; then
	echo "No changes to docs"
	exit 0
fi

git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

git add docs/\*
git commit -m "Deploying updated docs"

encryptedKeyVar="encrypted_${ENCRYPTION_LABEL}_key"
encryptedIvVar="encrypted_${ENCRYPTION_LABEL}_iv"
encryptedKey=${!encryptedKeyVar}
encryptedIv=${!encryptedIvVar}
openssl aes-256-cbc -K "$encryptedKey" -iv $encryptedIv -in deploy_key.enc -out deploy_key -d
chmod 600 deploy key
eval $(ssh-agent -s)
ssh-add deploy_key

git push $sshRepo "master"