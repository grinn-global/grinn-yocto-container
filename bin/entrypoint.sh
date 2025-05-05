#!/bin/sh

set -eu

user="yoctouser"
user_uid="${CUSTOM_UID:-1000}"
user_gid="${CUSTOM_GID:-1000}"

unset CUSTOM_UID
unset CUSTOM_GID

if [ "$user_uid" != "$(id -u "$user")" ] || [ "$user_gid" != "$(id -g "$user")" ]; then
    groupmod --gid "$user_gid" "$user"
    usermod --uid "$user_uid" --gid "$user_gid" "$user"
    chown "$user_uid":"$user_gid" "/home/$user/.bashrc"
    chown "$user_uid":"$user_gid" "/home/$user/.sudo_as_admin_successful"
fi

exec gosu "$user" "$@"
