#!/usr/bin/env bash
#
# Generates the claude code buddy

cd "$(dirname "$0")" || exit 1

curl -fsSL https://bun.sh/install | bash
npx any-buddy@latest \
    --species owl \
    --rarity legendary \
    --eye '✦' \
    --hat propeller \
    --shiny yes \
    --peak WISDOM \
    --dump CHAOS \
    --yes

git checkout ../bash_profile
rm -r ~/.bun
