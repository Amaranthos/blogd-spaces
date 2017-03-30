#!/bin/bash
set -e

sourceBranch="master"
targetBranch="gh-pages"

if [[ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$sourceBranch" ]]; then
	echo "Skipping ddox for branch: $TRAVIS_BRANCH"
	exit 0
fi

repo=$(git config remote.origin.url)
sshRepo=${repo/https:\/\/github.com\//git@github.com:}
sha=$(git rev-parse --verify HEAD)
# echo $sshRepo

git clone $repo docs
cd docs/
git checkout $targetBranch || git checkout --orphan $targetBranch
cd ..

rm -rf docs/**/* || exit 0

dub build -b ddox
echo "Docs built, commiting and pushing"

cd docs/
git config user.name "Travis CI"
git config user.email "joshua.hodkinson.42@gmail.com"

if [[ -z $(git diff --exit-code) ]]; then
	echo "No changes to docs"
	exit 0
fi

# git status
git add .
git commit -m "Deploying updated docs: ${sha}"

# cd ..

encryptedKeyVar="encrypted_${ENCRYPTION_LABEL}_key"
encryptedIvVar="encrypted_${ENCRYPTION_LABEL}_iv"
encryptedKey=${!encryptedKeyVar}
encryptedIv=${!encryptedIvVar}
openssl aes-256-cbc -K "$encryptedKey" -iv "$encryptedIv" -in deploy_key.enc -out deploy_key -d
chmod 600 deploy_key
eval $(ssh-agent -s)
ssh-add deploy_key

git push "$sshRepo" "$targetBranch"
# git push $sshRepo "HEAD:master"
