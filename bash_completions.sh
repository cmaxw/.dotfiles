#!/bin/sh

# Include ports' version of bash_completion (if it exists)
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi


# FIXME: This does not work. Something about the colon causes the
# expander to wonk. I think maybe complete treats : as a separate
# token? Dono. Anyway, here's what happens:
#
# You type...                You get...
# 
# rake db:<TAB>              rake db:db:
# rake db:mig<TAB>           rake db:migrate
# # Custom expansion of rake tasks. WOO!
# _rake_tasks()
# {
#     local curw
#     COMPREPLY=()
#     curw=${COMP_WORDS[COMP_CWORD]}
#     # The bit of ruby in there eats the first line of output. Wish
#     # head/tail had the ability to show all but the n first/last lines
#     # of a file.
#     local tasks="$(rake -T | ruby -n -e 'puts $_ if $seen; $seen=true' | awk '{ print $2 }')"
#     COMPREPLY=($(compgen -W '$tasks' -- $curw));
#     return 0
# }
# complete -F _rake_tasks rake

# dbrady 2008-12-03: Commented out because ports bash_completion does this better than me.
# Custom expansion of ssh, using hostnames from .ssh/config
# _sshhosts()
# {
#   # cat ~/.ssh/config | grep -Ei '^Host' | awk '{ print $2}'
#     local curw
#     COMPREPLY=()
#     curw=${COMP_WORDS[COMP_CWORD]}
#     local hosts="$(cat ~/.ssh/config | grep -Ei '^Host' | awk '{ print $2}')"
#     COMPREPLY=($(compgen -W '$hosts' -- $curw));
#     return 0
# }
# complete -o default -o nospace -F _sshhosts ssh
# complete -o default -o nospace -F _sshhosts scp

# Custom expansion for mysql-D <databasename>
_mysqldbs()
{
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ ${prev} == -D ]] ; then
        local dbs="$(mysql -e 'show databases')"
        COMPREPLY=( $(compgen -W "${dbs}" -- ${cur}) )
        return 0
    fi
}
complete -o default -o nospace -F _mysqldbs mysql

# Custom expansion for mategem
_gemdirs()
{
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    local gems="$(gem environment gemdir)/gems"
    COMPREPLY=($(compgen -W '$(ls $gems)' -- $curw));
    return 0
}
complete -F _gemdirs -o dirnames mategem
complete -F _gemdirs -o dirnames emgem
# cdgem is just an alias script for "cd", but this lets me get
# tab-completion into the gems folder. Why yes, I am that
# lazy^H^H^H^Hclever, thank you for asking.
complete -F _gemdirs -o dirnames cdgem

