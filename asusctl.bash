_get_cmds() {
    asusctl "$@" --help 2>/dev/null | awk '
        /^Commands?:/ {printing=1; next}
        /^[^[:space:]].*:/ {printing=0} 
        printing && /^[[:space:]]*[[:alnum:]_-]+/ {gsub(/^[ \t]+/, "", $1); print $1}
    '
}
_get_opts() {
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
    local args cur prev opts cmds
    args=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ "${prev}" == --help ]] ; then
        return 0
    fi
    COMPREPLY=()

    if [[ "${cur}" == -* ]]; then
        opts="$(_get_opts "${args[@]}")"
        mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
        return 0
    else
        cmds="$(_get_cmds "${args[@]}")"
        mapfile -t COMPREPLY < <(compgen -W "${cmds}" -- "${cur}")
        return 0
    fi
}

complete -F _asusctl asusctl