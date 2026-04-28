FROM cgr.dev/chainguard/node:latest-dev@sha256:499f00f197f011b58a7441d3a24b62e33c48d50056f771011e54f79d576c9fd7

# openssh-client: ssh binary for git-over-SSH (PI_SSH_AGENT=1) and ssh-add.
USER root
RUN apk add --no-cache \
        curl \
        ca-certificates \
        git \
        openssh-client

# Install pi globally
RUN npm install -g "@mariozechner/pi-coding-agent@0.70.5"

# Prepend extension binaries (host-mounted via /pi-agent). Security: binaries
# here can shadow any command; no privilege escalation (--cap-drop=ALL,
# --no-new-privileges), but review ~/.pi/agent/npm-global/bin/ after installs.
ENV PATH="/pi-agent/npm-global/bin:${PATH}"

# /home/piuser: world-writable (1777) so any runtime UID can write here.
#   read mounts inside it (700 would block a non-matching UID).
# /etc/passwd: world-writable so the entrypoint can add the runtime UID.
# .npmrc sets prefix=/pi-agent/npm-global so extensions persist across restarts.
# Written as a literal file because ENV HOME is not yet set to /home/piuser.
RUN mkdir -p /home/piuser \
    && chmod 1777 /home/piuser \
    && chmod a+w /etc/passwd \
    && echo "prefix=/pi-agent/npm-global" > /home/piuser/.npmrc

ENV HOME=/home/piuser

# Install dev tools
RUN apk update && apk add go-1.26 php-8.4

# Register the runtime UID in /etc/passwd before starting pi.
# SSH calls getpwuid(3) and hard-fails without an entry; nss_wrapper is
# unavailable in Wolfi so we append directly.
RUN <<'EOF'
cat > /usr/local/bin/entrypoint.sh << 'ENTRYPOINT'
#!/bin/sh
set -e

if ! grep -q "^[^:]*:[^:]*:$(id -u):" /etc/passwd; then
    printf 'piuser:x:%d:%d:piuser:%s:/bin/sh\n' \
        "$(id -u)" "$(id -g)" "${HOME}" >> /etc/passwd
fi

echo $(hostname)

# Pass through to a shell when invoked via `pi:shell`; otherwise run pi.
case "${1:-}" in
    bash|sh) exec "$@" ;;
    *) exec pi "$@" ;;
esac
ENTRYPOINT
chmod +x /usr/local/bin/entrypoint.sh
EOF

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
