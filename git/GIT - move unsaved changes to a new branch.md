To move your unsaved changes to a new branch in git, you need to follow these steps:

1. **Stash your changes**: The first thing you need to do is to stash your unsaved changes. This will save your changes and revert your working directory to the last commit. Use the following command to do this:
    ```
    git stash
    ```
2. **Create a new branch**: Next, create a new branch where you want to apply your stashed changes. You can do this with the following command:
    ```
    git checkout -b FM2020-newbranch
    ```
   Replace `newbranch` with the name you want to give to your new branch.

3. **Apply stashed changes**: Finally, apply your stashed changes to your new branch with the following command:
    ```
    git stash pop
    ```
This will apply the changes and remove them from your stash. If you want to keep them in your stash, you can use `git stash apply` instead of `git stash pop`.

That's it! Your unsaved changes are now in your new branch. Remember to add and commit your changes to save them permanently in your new branch.