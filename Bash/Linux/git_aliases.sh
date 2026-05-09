  #region Git_Aliases
    alias git-log-pretty='git log --all --pretty=format:"%ae - %cd - %s" --date=short'
    alias git-stats='\
        AUTHOR="${1:-$(git config user.email)}"; \
        echo "Author email: $AUTHOR"; \
        echo ""; \
        git log --author="$AUTHOR" --pretty=tformat: --numstat 2>/dev/null | \
        awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { \
            printf "Lines added: %s\nLines removed: %s\nNet lines (changed): %s\n", add, subs, loc \
        }'\''; \
        echo ""; \
        echo "Total number of lines in the project (ignoring vendors):"; \
        find . -type f \
            ! -path '\''*/vendor/*'\'' \
            ! -path '\''*/node_modules/*'\'' \
            ! -path '\''*/.git/*'\'' \
            ! -path '\''*/dist/*'\'' \
            ! -path '\''*/build/*'\'' \
            ! -path '\''*/./*'\'' \
            -exec wc -l {} + 2>/dev/null | tail -1 | awk '\''{print $1}'\''; \
        echo "Total number of files in the project (ignoring vendors):"; \
        find . -type f \
            ! -path '\''*/vendor/*'\'' \
            ! -path '\''*/node_modules/*'\'' \
            ! -path '\''*/.git/*'\'' \
            ! -path '\''*/dist/*'\'' \
            ! -path '\''*/build/*'\'' \
            ! -path '\''*/./*'\'' \
            | wc -l 2>/dev/null; \
        echo ""; \
        echo "Total number of commits registered for the remote repository:"; \
        git rev-list --count --all 2>/dev/null || echo "No remote repository"; \
        echo "Total number of commits registered for the branch:"; \
        git rev-list --count HEAD 2>/dev/null;'
      ## @description Show Git work tree info: repo dir, common dir, top level, and superproject status.
      git_tree_info() { if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then printf "\n[Inside work tree]\n\nGit repo directory:\n%s\nGit repo common directory:\n%s\nPath to top level repo:\n%s\nSuperproject working tree:\n%s\n" "$(git rev-parse --git-dir)" "$(git rev-parse --git-common-dir)" "$(git rev-parse --show-toplevel)" "$(git rev-parse --show-superproject-working-tree 2>/dev/null | grep . || echo 'NOT A SUBMODULE')"; else printf "NO WORK TREE PRESENT FOR A REPO\n"; fi; }
      alias git-tree-info='git_tree_info'
      
    #region Git_Basic
      alias gra='git remote add'
      alias gra-o='git remote add origin'
      alias ga='git add'
      alias gal='git add .'
      alias gc='git commit'
      alias gca='git commit -a -m'
      alias galps='cd "$(git rev-parse --show-toplevel 2>/dev/null)" && git add . && git commit -am'
#endregion Git_Basic

    #region Git_Log_Status
      alias gl='git log'
      alias gl-o='git log --oneline'
      alias gs='git status'
      alias gsw='git show'
      alias grl='git reflog'
      alias gsl='git shortlog'
      alias gci='git check-ignore -v'
      alias glr='git ls-remote'
      alias glt='git ls-tree'
      alias glost='git fsck --lost-found'
      alias gfsckf='git fsck --full'
      alias gitgcagro='git gc --aggressive --prune=now'
#endregion Git_Log_Status

    #region Git_Remote
      alias gps='git push'
      alias gps-oh='git push origin HEAD'
      alias gps-ohm='git push origin HEAD:main'
      alias gpl='git pull'
      alias gf='git fetch'
#endregion Git_Remote

    #region Git_Branch_Diff
      alias gd='git diff'
      alias gb='git branch'
      alias gbv='git branch -v'
      alias gsc='git switch -c'
      alias gco='git checkout'
      alias gtop='git rev-parse --show-toplevel'
      alias gm='git merge'
      alias grb='git rebase'
#endregion Git_Branch_Diff

    #region Git_Reset_Revert
      alias grs='git reset'
      alias grs-h='git reset --hard'
      alias grs-s='git reset --soft'
      alias grs--1='git reset HEAD~1'
      alias grs-h--1='git reset --hard HEAD~1'
      alias grs-s--1='git reset --soft HEAD~1'
      alias grs--og='git reset origin'
      alias grs-h--og='git reset --hard origin'
      alias grs-s--og='git reset --soft origin'
      alias grv='git revert'
      alias grv-nc='git revert --no-commit'
      alias grv--h='git revert HEAD'
      alias grv-m--1='git revert -m 1'
#endregion Git_Reset_Revert

    #region Git_Stash
      alias gst='git stash'
      alias gst-ps='git statsh push'
      alias gst-pp-u='git stash push --include-untracked'
      alias gst-pp-a='git stash push --all'
      alias gst-pp-ki='git stash push --keep-index'
      alias gst-pp='git stash pop'
      alias gst-a='git stash apply'
      alias gst-d='git stash drop'
      alias gst-l='git stash list'
      alias gst-s='git stash show'
      alias gst-c='git stash clear'
      alias gst-filter-rdm='git filter-branch --force --prune-empty --index-filter "git rm --cached --ignore-unmatch README.md" cat -- --all'
#endregion Git_Stash
  #endregion Git_Aliases

