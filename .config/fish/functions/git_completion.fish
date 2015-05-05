# fish completion for git
# Use 'command git' to avoid interactions for aliases from git to (e.g.) hub

function __fish_git_branches
  command git branch --no-color -a ^/dev/null | sgrep -v ' -> ' | sed -e 's/^..//' -e 's/^remotes\///'
end

function __fish_git_tags
  command git tag
end

function __fish_git_heads
  __fish_git_branches
  __fish_git_tags
end

function __fish_git_remotes
  command git remote
end

function __fish_git_modified_files
  command git ls-files -m --exclude-standard ^/dev/null
end

function __fish_git_add_files
  command git ls-files -mo --exclude-standard ^/dev/null
end

function __fish_git_ranges
  set -l from (commandline -ot | perl -ne 'if (index($_, "..") > 0) { my @parts = split(/\.\./); print $parts[0]; }')
  if test -z "$from"
    __fish_git_branches
    return 0
  end

  set -l to (commandline -ot | perl -ne 'if (index($_, "..") > 0) { my @parts = split(/\.\./); print $parts[1]; }')
  for from_ref in (__fish_git_heads | sgrep -e "$from")
    for to_ref in (__fish_git_heads | sgrep -e "$to")
      printf "%s..%s\n" $from_ref $to_ref
    end
  end
end


function __fish_git_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 ]
    if [ $argv[1] = $cmd[1] ]
      return 0
    end

    # aliased command
    set -l aliased (command git config --get "alias.$cmd[1]" ^ /dev/null | sed 's/ .*$//')
    if [ $argv[1] = "$aliased" ]
      return 0
    end
  end
  return 1
end

function __fish_git_stash_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 2 ]
    if [ $cmd[2] = 'stash' -a $argv[1] = $cmd[3] ]
      return 0
    end
  end
  return 1
end

function __fish_git_stash_not_using_subcommand
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 2 -a $cmd[2] = 'stash' ]
    return 1
  end
  return 0
end

function __fish_git_complete_stashes
    set -l IFS ':'
    command git stash list --format=%gd:%gs | while read -l name desc
        echo $name\t$desc
    end
end

function __fish_git_aliases
    set -l IFS \n
    command git config -z --get-regexp '^alias\.' | while read -lz key value
        begin
            set -l IFS "."
            echo -n $key | read -l _ name
            echo $name
        end
    end
end

function __fish_git_custom_commands
    # complete all commands starting with git-
    # however, a few builtin commands are placed into $PATH by git because
    # they're used by the ssh transport. We could filter them out by checking
    # if any of these completion results match the name of the builtin git commands,
    # but it's simpler just to blacklist these names. They're unlikely to change,
    # and the failure mode is we accidentally complete a plumbing command.
    set -l IFS \n
    for name in (builtin complete -Cgit- | sed 's/^git-\([^[:space:]]*\).*/\1/')
        switch $name
            case cvsserver receive-pack shell upload-archive upload-pack
                # skip these
            case \*
                echo $name
        end
    end
end

#### fetch
complete -f -c fetch -n '__fish_git_using_command fetch' -a '(__fish_git_remotes)' -d 'Remote'
complete -f -c fetch -n '__fish_git_using_command fetch' -s q -l quiet -d 'Be quiet'
complete -f -c fetch -n '__fish_git_using_command fetch' -s v -l verbose -d 'Be verbose'
complete -f -c fetch -n '__fish_git_using_command fetch' -s a -l append -d 'Append ref names and object names'

### remote
complete -f -c remote -n '__fish_git_using_command remote' -a '(__fish_git_remotes)'
complete -f -c remote -n '__fish_git_using_command remote' -s v -l verbose -d 'Be verbose'
complete -f -c remote -n '__fish_git_using_command remote' -a add -d 'Adds a new remote'
complete -f -c remote -n '__fish_git_using_command remote' -a rm -d 'Removes a remote'
complete -f -c remote -n '__fish_git_using_command remote' -a show -d 'Shows a remote'
complete -f -c remote -n '__fish_git_using_command remote' -a prune -d 'Deletes all stale tracking branches'
complete -f -c remote -n '__fish_git_using_command remote' -a update -d 'Fetches updates'

### show
complete -f -c show -n '__fish_git_using_command show' -a '(__fish_git_branches)' -d 'Branch'

### add
complete -c add -n '__fish_git_using_command add' -s n -l dry-run -d "Don't actually add the file(s)"
complete -c add -n '__fish_git_using_command add' -s v -l verbose -d 'Be verbose'
complete -c add -n '__fish_git_using_command add' -s f -l force -d 'Allow adding otherwise ignored files'
complete -c add -n '__fish_git_using_command add' -s i -l interactive -d 'Interactive mode'
complete -c add -n '__fish_git_using_command add' -s p -l patch -d 'Interactively choose hunks to stage'
complete -c add -n '__fish_git_using_command add' -s e -l edit -d 'Manually create a patch'
complete -c add -n '__fish_git_using_command add' -s u -l update -d 'Only match tracked files'
complete -c add -n '__fish_git_using_command add' -s A -l all -d 'Match files both in working tree and index'
complete -c add -n '__fish_git_using_command add' -s N -l intent-to-add -d 'Record only the fact that the path will be added later'
complete -c add -n '__fish_git_using_command add' -l refresh -d "Don't add the file(s), but only refresh their stat"
complete -c add -n '__fish_git_using_command add' -l ignore-errors -d 'Ignore errors'
complete -c add -n '__fish_git_using_command add' -l ignore-missing -d 'Check if any of the given files would be ignored'
complete -f -c add -n '__fish_git_using_command add; and __fish_contains_opt -s p patch' -a '(__fish_git_modified_files)'
complete -f -c add -n '__fish_git_using_command add' -a '(__fish_git_add_files)'

### checkout
complete -f -c co -n '__fish_git_using_command checkout'  -a '(__fish_git_branches)' --description 'Branch'
complete -f -c co -n '__fish_git_using_command checkout'  -a '(__fish_git_tags)' --description 'Tag'
complete -f -c co -n '__fish_git_using_command checkout' -a '(__fish_git_modified_files)' --description 'File'
complete -f -c co -n '__fish_git_using_command checkout' -s b -d 'Create a new branch'
complete -f -c co -n '__fish_git_using_command checkout' -s t -l track -d 'Track a new branch'

### branch
complete -f -c br -n '__fish_git_using_command branch' -a '(__fish_git_branches)' -d 'Branch'
complete -f -c br -n '__fish_git_using_command branch' -s d -d 'Delete branch'
complete -f -c br -n '__fish_git_using_command branch' -s D -d 'Force deletion of branch'
complete -f -c br -n '__fish_git_using_command branch' -s m -d 'Rename branch'
complete -f -c br -n '__fish_git_using_command branch' -s M -d 'Force renaming branch'
complete -f -c br -n '__fish_git_using_command branch' -s a -d 'Lists both local and remote branches'
complete -f -c br -n '__fish_git_using_command branch' -s t -l track -d 'Track remote branch'
complete -f -c br -n '__fish_git_using_command branch' -l no-track -d 'Do not track remote branch'
complete -f -c br -n '__fish_git_using_command branch' -l set-upstream -d 'Set remote branch to track'
complete -f -c br -n '__fish_git_using_command branch' -l merged -d 'List branches that have been merged'
complete -f -c br -n '__fish_git_using_command branch' -l no-merged -d 'List branches that have not been merged'

### commit
complete -c ci -n '__fish_git_using_command commit' -l amend -d 'Amend the log message of the last commit'

### diff
complete -c d -n '__fish_git_using_command diff' -a '(__fish_git_ranges)' -d 'Branch'
complete -c d -n '__fish_git_using_command diff' -l cached -d 'Show diff of changes in the index'

### merge
complete -f -c merge -n '__fish_git_using_command merge' -a '(__fish_git_branches)' -d 'Branch'
complete -f -c merge -n '__fish_git_using_command merge' -l commit -d "Autocommit the merge"
complete -f -c merge -n '__fish_git_using_command merge' -l no-commit -d "Don't autocommit the merge"
complete -f -c merge -n '__fish_git_using_command merge' -l edit -d 'Edit auto-generated merge message'
complete -f -c merge -n '__fish_git_using_command merge' -l no-edit -d "Don't edit auto-generated merge message"
complete -f -c merge -n '__fish_git_using_command merge' -l ff -d "Don't generate a merge commit if merge is fast-forward"
complete -f -c merge -n '__fish_git_using_command merge' -l no-ff -d "Generate a merge commit even if merge is fast-forward"
complete -f -c merge -n '__fish_git_using_command merge' -l ff-only -d 'Refuse to merge unless fast-forward possible'
complete -f -c merge -n '__fish_git_using_command merge' -l log -d 'Populate the log message with one-line descriptions'
complete -f -c merge -n '__fish_git_using_command merge' -l no-log -d "Don't populate the log message with one-line descriptions"
complete -f -c merge -n '__fish_git_using_command merge' -l stat -d "Show diffstat of the merge"
complete -f -c merge -n '__fish_git_using_command merge' -s n -l no-stat -d "Don't show diffstat of the merge"
complete -f -c merge -n '__fish_git_using_command merge' -l squash -d "Squash changes from other branch as a single commit"
complete -f -c merge -n '__fish_git_using_command merge' -l no-squash -d "Don't squash changes"
complete -f -c merge -n '__fish_git_using_command merge' -s q -l quiet -d 'Be quiet'
complete -f -c merge -n '__fish_git_using_command merge' -s v -l verbose -d 'Be verbose'
complete -f -c merge -n '__fish_git_using_command merge' -l progress -d 'Force progress status'
complete -f -c merge -n '__fish_git_using_command merge' -l no-progress -d 'Force no progress status'
complete -f -c merge -n '__fish_git_using_command merge' -s m -d 'Set the commit message'
complete -f -c merge -n '__fish_git_using_command merge' -l abort -d 'Abort the current conflict resolution process'

### pull
complete -f -c pull -n '__fish_git_using_command pull' -s q -l quiet -d 'Be quiet'
complete -f -c pull -n '__fish_git_using_command pull' -s v -l verbose -d 'Be verbose'
# Options related to fetching
complete -f -c pull -n '__fish_git_using_command pull' -l all -d 'Fetch all remotes'
complete -f -c pull -n '__fish_git_using_command pull' -s a -l append -d 'Append ref names and object names'
complete -f -c pull -n '__fish_git_using_command pull' -s f -l force -d 'Force update of local branches'
complete -f -c pull -n '__fish_git_using_command pull' -s k -l keep -d 'Keep downloaded pack'
complete -f -c pull -n '__fish_git_using_command pull' -l no-tags -d 'Disable automatic tag following'
complete -f -c pull -n '__fish_git_using_command pull' -l progress -d 'Force progress status'
complete -f -c pull -n '__fish_git_using_command pull' -a '(git remote)' -d 'Remote alias'
complete -f -c pull -n '__fish_git_using_command pull' -a '(__fish_git_branches)' -d 'Branch'

### push
complete -f -c push -n '__fish_git_using_command push' -a '(git remote)' -d 'Remote alias'
complete -f -c push -n '__fish_git_using_command push' -a '(__fish_git_branches)' -d 'Branch'
complete -f -c push -n '__fish_git_using_command push' -l all -d 'Push all refs under refs/heads/'
complete -f -c push -n '__fish_git_using_command push' -l prune -d "Remove remote branches that don't have a local counterpart"
complete -f -c push -n '__fish_git_using_command push' -l mirror -d 'Push all refs under refs/'
complete -f -c push -n '__fish_git_using_command push' -l delete -d 'Delete all listed refs from the remote repository'
complete -f -c push -n '__fish_git_using_command push' -l tags -d 'Push all refs under refs/tags'
complete -f -c push -n '__fish_git_using_command push' -s n -l dry-run -d 'Do everything except actually send the updates'
complete -f -c pull -n '__fish_git_using_command push' -l porcelain -d 'Produce machine-readable output'
complete -f -c push -n '__fish_git_using_command push' -s f -l force -d 'Force update of remote refs'
complete -f -c push -n '__fish_git_using_command push' -s u -l set-upstream -d 'Add upstream (tracking) reference'
complete -f -c push -n '__fish_git_using_command push' -s q -l quiet -d 'Be quiet'
complete -f -c push -n '__fish_git_using_command push' -s v -l verbose -d 'Be verbose'
complete -f -c push -n '__fish_git_using_command push' -l progress -d 'Force progress status'

### rebase
complete -f -c rb -n '__fish_git_using_command rebase' -a '(git remote)' -d 'Remote alias'
complete -f -c rb -n '__fish_git_using_command rebase' -a '(__fish_git_branches)' -d 'Branch'
complete -f -c rb -n '__fish_git_using_command rebase' -l continue -d 'Restart the rebasing process'
complete -f -c rb -n '__fish_git_using_command rebase' -l abort -d 'Abort the rebase operation'
complete -f -c rb -n '__fish_git_using_command rebase' -l keep-empty -d "Keep the commits that don't cahnge anything"
complete -f -c rb -n '__fish_git_using_command rebase' -l skip -d 'Restart the rebasing process by skipping the current patch'
complete -f -c rb -n '__fish_git_using_command rebase' -s m -l merge -d 'Use merging strategies to rebase'
complete -f -c rb -n '__fish_git_using_command rebase' -s q -l quiet -d 'Be quiet'
complete -f -c rb -n '__fish_git_using_command rebase' -s v -l verbose -d 'Be verbose'
complete -f -c rb -n '__fish_git_using_command rebase' -l stat -d "Show diffstat of the rebase"
complete -f -c rb -n '__fish_git_using_command rebase' -s n -l no-stat -d "Don't show diffstat of the rebase"
complete -f -c rb -n '__fish_git_using_command rebase' -l verify -d "Allow the pre-rebase hook to run"
complete -f -c rb -n '__fish_git_using_command rebase' -l no-verify -d "Don't allow the pre-rebase hook to run"
complete -f -c rb -n '__fish_git_using_command rebase' -s f -l force-rebase -d 'Force the rebase'
complete -f -c rb -n '__fish_git_using_command rebase' -s i -l interactive -d 'Interactive mode'
complete -f -c rb -n '__fish_git_using_command rebase' -s p -l preserve-merges -d 'Try to recreate merges'
complete -f -c rb -n '__fish_git_using_command rebase' -l root -d 'Rebase all reachable commits'
complete -f -c rb -n '__fish_git_using_command rebase' -l autosquash -d 'Automatic squashing'
complete -f -c rb -n '__fish_git_using_command rebase' -l no-autosquash -d 'No automatic squashing'
complete -f -c rb -n '__fish_git_using_command rebase' -l no-ff -d 'No fast-forward'

### reset
complete -f -c rs -n '__fish_git_using_command reset' -l hard -d 'Reset files in working directory'
complete -c rs -n '__fish_git_using_command reset' -a '(__fish_git_branches)'

### status
complete -f -c st -n '__fish_git_using_command status' -s s -l short -d 'Give the output in the short-format'
complete -f -c st -n '__fish_git_using_command status' -s b -l branch -d 'Show the branch and tracking info even in short-format'
complete -f -c st -n '__fish_git_using_command status'      -l porcelain -d 'Give the output in a stable, easy-to-parse format'
complete -f -c st -n '__fish_git_using_command status' -s z -d 'Terminate entries with null character'
complete -f -c st -n '__fish_git_using_command status' -s u -l untracked-files -x -a 'no normal all' -d 'The untracked files handling mode'
complete -f -c st -n '__fish_git_using_command status' -l ignore-submodules -x -a 'none untracked dirty all' -d 'Ignore changes to submodules'

### tag
complete -f -c tag -n '__fish_git_using_command tag; and __fish_not_contain_opt -s d; and __fish_not_contain_opt -s v; and test (count (commandline -opc | sgrep -v -e \'^-\')) -eq 3' -a '(__fish_git_branches)' -d 'Branch'
complete -f -c tag -n '__fish_git_using_command tag' -s a -l annotate -d 'Make an unsigned, annotated tag object'
complete -f -c tag -n '__fish_git_using_command tag' -s s -l sign -d 'Make a GPG-signed tag'
complete -f -c tag -n '__fish_git_using_command tag' -s d -l delete -d 'Remove a tag'
complete -f -c tag -n '__fish_git_using_command tag' -s v -l verify -d 'Verify signature of a tag'
complete -f -c tag -n '__fish_git_using_command tag' -s f -l force -d 'Force overwriting exising tag'
complete -f -c tag -n '__fish_git_using_command tag' -s l -l list -d 'List tags'
complete -f -c tag -n '__fish_contains_opt -s d' -a '(__fish_git_tags)' -d 'Tag'
complete -f -c tag -n '__fish_contains_opt -s v' -a '(__fish_git_tags)' -d 'Tag'

### stash
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a list -d 'List stashes'
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a show -d 'Show the changes recorded in the stash'
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a pop -d 'Apply and remove a single stashed state'
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a apply -d 'Apply a single stashed state'
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a clear -d 'Remove all stashed states'
complete -f -c git -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a drop -d 'Remove a single stashed state from the stash list'
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a create -d 'Create a stash'
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a save -d 'Save a new stash'
complete -f -c stash -n '__fish_git_using_command stash; and __fish_git_stash_not_using_subcommand' -a branch -d 'Create a new branch from a stash'
complete -f -c stash -n '__fish_git_stash_using_command apply' -a '(__fish_git_complete_stashes)'
complete -f -c stash -n '__fish_git_stash_using_command branch' -a '(__fish_git_complete_stashes)'
complete -f -c stash -n '__fish_git_stash_using_command drop' -a '(__fish_git_complete_stashes)'
complete -f -c stash -n '__fish_git_stash_using_command pop' -a '(__fish_git_complete_stashes)'
complete -f -c stash -n '__fish_git_stash_using_command show' -a '(__fish_git_complete_stashes)'

