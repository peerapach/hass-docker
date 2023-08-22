#!/usr/bin/dumb-init /bin/sh

USER="autossh"

# Set up key file
KEY_FILE=${SSH_KEY_FILE:=/home/${USER}/.ssh/id_rsa}
if [ ! -f "${KEY_FILE}" ]; then
    echo "[FATAL] No SSH Key file found"
    exit 1
fi
eval $(ssh-agent -s)
ssh-add ${SSH_KEY_FILE}

# If known_hosts is provided, STRICT_HOST_KEY_CHECKING=yes
# Default CheckHostIP=yes unless SSH_STRICT_HOST_IP_CHECK=false
STRICT_HOSTS_KEY_CHECKING=no
KNOWN_HOSTS=${SSH_KNOWN_HOSTS_FILE:=/home/${USER}/.ssh/known_hosts}
if [ -f "${KNOWN_HOSTS}" ]; then
    KNOWN_HOSTS_ARG="-o UserKnownHostsFile=${KNOWN_HOSTS} "
    if [ "${SSH_STRICT_HOST_IP_CHECK}" = false ]; then
        KNOWN_HOSTS_ARG="${KNOWN_HOSTS_ARG}-o CheckHostIP=no "
        echo "[WARN ] Not using STRICT_HOSTS_KEY_CHECKING"
    fi
    STRICT_HOSTS_KEY_CHECKING=yes
    echo "[INFO ] Using STRICT_HOSTS_KEY_CHECKING"
fi

echo "Create Reverse Tunnel"
COMMAND="autossh "\
    "-M 0 "\
    "-N "\
    "-o StrictHostKeyChecking=${STRICT_HOSTS_KEY_CHECKING} ${KNOWN_HOSTS_ARG:=}"\
    "-o ServerAliveInterval=${SSH_SERVER_ALIVE_INTERVAL:-30} "\
    "-o ServerAliveCountMax=${SSH_SERVER_ALIVE_COUNT_MAX:-3} "\
    "-o ExitOnForwardFailure=yes "\
    "${SSH_OPTIONS} "\
    "-t -t "\
    "${SSH_MODE:=-R} ${SSH_BIND_IP}:${SSH_TUNNEL_PORT}:${SSH_TARGET_HOST}:${SSH_TARGET_PORT} "\
    "-p ${SSH_REMOTE_PORT:=22} "\
    "${SSH_REMOTE_USER}@${SSH_REMOTE_HOST}"

echo "[INFO ] # ${COMMAND}"

# Run command
exec ${COMMAND}
# eval $(ssh-agent -k)