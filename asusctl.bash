_get_cmds() {
#    asusctl $@ --help | awk '/^  [a-z]/ {print $1}'
    asusctl "$@" --help 2>/dev/null | awk '
        /^Commands?:/ {printing=1; next}
        /^[^[:space:]].*:/ {printing=0} 
        printing && /^[[:space:]]*[[:alnum:]_-]+/ {gsub(/^[ \t]+/, "", $1); print $1}
    '
}
_get_opts() {
#    asusctl $@ --help | awk '/^  --/ {print $1}'
    asusctl "$@" --help 2>/dev/null | awk '
        /^Options?:/ {printing=1; next}
        /^[^[:space:]].*:/ {printing=0}
        printing && /^[[:space:]]*[[:alnum:]_-]+/ {
            gsub(/^[ \t]+/, "", $1)
            gsub(/,$/, "", $1)
            print $1
        }
    '
}

_asusctl() {
    compopt +o default
    local args
    args=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()
    opts='$(_get_opts ${args[@]})'
    cmds='$(_get_cmds ${args[@]})'
    COMPREPLY=( $(compgen -W "${cmds} ${opts}" -- ${cur}) )
    return 0
}

complete -F _asusctl asusctl