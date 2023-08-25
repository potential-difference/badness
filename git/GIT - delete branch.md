To delete a Git branch, you can use the `git branch` command with the `-d` or `-D` flag, followed by the branch name you want to delete. The `-d` flag stands for "delete" and will only delete the branch if it has been fully merged into the current branch. The `-D` flag stands for "force delete" and will delete the branch regardless of its merge status. Here's how you can do it:

1. **Delete a fully merged branch:**
   If the branch you want to delete has been fully merged into the current branch (usually the `main` or `master` branch), you can use the following command:

   ```bash
   git branch -d branch_name
   ```

   Replace `branch_name` with the name of the branch you want to delete.

2. **Force delete an unmerged branch:**
   If you want to forcefully delete a branch that hasn't been fully merged, you can use the following command:

   ```bash
   git branch -D branch_name
   ```

   Again, replace `branch_name` with the name of the branch you want to delete.

Remember that deleting a branch is a permanent action, so make sure you have a backup or you're absolutely sure you won't need the branch again before proceeding.

Here's a step-by-step breakdown:

1. Open a terminal or command prompt.
2. Navigate to the Git repository directory using the `cd` command.
3. Check your current branches using `git branch` to confirm the branch you want to delete.
4. Choose one of the commands mentioned above (`-d` for merged branches, or `-D` for unmerged branches).
5. Replace `branch_name` with the actual name of the branch you want to delete.
6. Press Enter to execute the command.
7. The branch will be deleted, and you'll see a confirmation message.

For example, to delete a branch named "feature/new-feature," you would use the following command:

```bash
git branch -d feature/new-feature
```

Or, to forcefully delete the same branch:

```bash
git branch -D feature/new-feature
```

Remember that if you delete a branch accidentally, it might be challenging to recover it, so proceed with caution.