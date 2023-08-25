to MERGE

1. First, make sure that your local repository is up-to-date with the remote repository:

```bash
git pull
```

2. Switch to the branch `FM2023`:

```bash
git checkout FM2023
```

3. Create and switch to the new branch `FM2023-newbranch` from `FM2023`:

```bash
git checkout -b FM2023-newbranch
```

Now, you're in the new branch `FM2023-newbranch`, and you can start doing your work. When you're ready to commit your changes, use the standard commit process:

```bash
git add .
git commit -m "Your descriptive commit message here"
```

After you've made your changes and committed them, you'll want to push the branch to the remote repository:

```bash
git push origin FM2023-newbranch
```

After pushing the changes to the remote repository, you can open a pull request on your git platform (like GitHub, GitLab, Bitbucket, etc.).

When your changes have been reviewed and you're ready to merge them back into the `FM2023` branch, you'll want to switch back to that branch, pull the latest changes (in case anything has been updated while you were working), and then merge your `FM2023-newbranch` branch:

```bash
git checkout FM2023
git pull
git merge FM2023-newbranch
```

Resolve any merge conflicts, commit the merge if necessary, and then push your changes:

```bash
git push origin FM2023
```

And that's it! You've successfully created a new branch from an existing one, made changes, and then merged them back into the original branch.