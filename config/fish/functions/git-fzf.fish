function git-fzf --description "Git browse commits"
    set -l log_line_to_hash "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 "
    set -l view_commit "$log_line_to_hash | xargs -I % sh -c 'git show --color=always % | less -R'"
    set -l copy_commit_hash "$log_line_to_hash | wl-copy"

    git log --color=always --format='%C(auto)%h%d %s %C(green)%C(bold)%cr% C(blue)%an' | \
        fzf --no-sort --reverse --tiebreak=index --no-multi --ansi \
            --preview="$view_commit" \
            --header-first \
            --header="ENTER to copy hash, CTRL-C to exit" \
            --bind "ENTER:execute:$copy_commit_hash"
end