# Advent of Code(aoc)
Advent of code can be found [here](https://adventofcode.com).
This is a repo for placing solutions of Advent of Code puzzles.
Everyone participating in our private leaderboard is welcome to upload their solutions and check what others wrote.

## Leaderboard invitation
For leaderboard invitation contact me here or create a new Issue and I'll send you an invite.

## How to use

### Git submodules
1. clone this repo
2. Add your repo as a submodule under correct year and name `git submodule add [repo_url] [year]/[desiredName]`
3. Push changes
4. (later on) When you do updates in your git, run **at the top of repo** `git submodule foreach git pull` and push

### Same repo
1. Go into current years folder.
2. Create your folder with whatever name you want.
3. Push your solves into your folder.
4. (View others solves if you're interested)

## Troubleshooting
1. **If you are having gitmodules problems (with adding or syncing):**
- make sure all submodules are there `git submodule` should show list of them all.
- remove all or broken submodules with commands 
```bash 
git submodule deinit [path]
git rm --cached [path]
rm -rf [path]
git config -f .gitmodules --remove-section submodule.[path]
```
- force add submodules again `git submodule add --force [repo_url] [year]/[desiredName]`
- Example fix:
```bash
> git submodule deinit 2023/brendonas
Cleared directory '2023/brendonas'
Submodule '2023/brendonas' (https://github.com/brendonsa/AOC2023) unregistered for path '2023/brendonas'

> git rm --cached 2023/brendonas
rm '2023/brendonas'

> rm -rf '2023/brendonas'

> git config -f .gitmodules --remove-section submodule.2023/brendonas

> git submodule add --force https://github.com/brendonsa/AOC2023 2023/brendonas
Reactivating local git directory for submodule '2023/brendonas'
```

