### Revert specific commit

`git revert <commit>`


### Revert last 3 commits 

`git reset --soft HEAD~3`


### Apply current changes in another branch

```
git stash
git checkout other-branch
git stash pop
```

### Copy commit from another branch

```
git cherry-pick <commit>
```

### Remove all local changes
```
git reset --hard
```

### Roll back to commit 
```
git reset --hard <commit>
```

### Completely push local branch to origin
```
git push origin master --force
```

### Remove all files ignored by Git 
```
git clean -fdx
```

### It's not my commit
https://github.com/jayphelps/git-blame-someone-else


[Git branch Best Practices](http://nvie.com/files/Git-branching-model.pdf)

look here https://github.com/tiimgreen/github-cheat-sheet

commit structure https://habrahabr.ru/company/Voximplant/blog/276695/


### How to Write a Git Commit Message
http://chris.beams.io/posts/git-commit/

### Git terminal autocomplete 
https://gist.github.com/trey/2722934
