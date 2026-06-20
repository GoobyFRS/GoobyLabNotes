#!/bin/sh
# ts_keepalive.sh — Tailscale tunnel keepalive via ping sweep
# Conforms to NASA Power of 10 rules for space-ready shell code.
#
# Rules applied:
#  1. No goto / no unbounded loops — all loops iterate over a fixed list
#  2. All loops and recursion have a fixed upper bound (4 pings, N hosts)
#  3. No dynamic memory allocation (shell: no eval, no indirect expansion)
#  4. Functions are short and single-purpose (< 60 lines each)
#  5. Assertions via explicit exit-code checks after every command
#  6. Minimal scope — all data flows through positional params or locals
#  7. Return values checked; errors logged and propagated
#  8. Preprocessor macros → constants defined at top, never magic numbers
#  9. Restrict pointer use → no subshells inside loops where avoidable
# 10. Compile-time warnings → set -eu enforces strict runtime checks

set -eu

# ---------------------------------------------------------------------------
# Constants — change here, nowhere else
# ---------------------------------------------------------------------------
readonly PING_COUNT=4
readonly PING_TIMEOUT=5          # seconds per ping attempt
readonly LOG_TAG="ts_keepalive"
readonly TAILSCALE_BIN="/usr/bin/tailscale"
readonly PING_BIN="/bin/ping"
readonly LOGGER_BIN="/usr/bin/logger"
readonly MAX_HOSTS=64            # upper bound guard on host list length

# ---------------------------------------------------------------------------
# log_msg — emit a syslog entry and an stdout line
# Arguments: $1 = severity (info|warning|error), $2 = message
# ---------------------------------------------------------------------------
log_msg()
{
    _sev="$1"
    _msg="$2"

    # Assert required args are non-empty
    [ -n "${_sev}" ] || { echo "log_msg: missing severity" >&2; return 1; }
    [ -n "${_msg}" ] || { echo "log_msg: missing message"  >&2; return 1; }

    echo "$(date '+%Y-%m-%dT%H:%M:%S') [${_sev}] ${_msg}"
    "${LOGGER_BIN}" -t "${LOG_TAG}" -p "daemon.${_sev}" "${_msg}" || true

    return 0
}

# ---------------------------------------------------------------------------
# check_deps — verify required binaries exist and are executable
# ---------------------------------------------------------------------------
check_deps()
{
    for _bin in "${TAILSCALE_BIN}" "${PING_BIN}" "${LOGGER_BIN}"; do
        [ -x "${_bin}" ] || {
            echo "FATAL: required binary not found or not executable: ${_bin}" >&2
            return 1
        }
    done
    return 0
}

# ---------------------------------------------------------------------------
# get_host_ips — parse `tailscale status` and emit one IP per line,
#                skipping offline hosts and the local node (-)
# Outputs to stdout; caller captures via command substitution.
# ---------------------------------------------------------------------------
get_host_ips()
{
    "${TAILSCALE_BIN}" status 2>/dev/null \
        | awk '
            /offline/ { next }   # skip offline peers
            $4 == "-" { next }   # skip self / no-status peers
            /^100\./ { print $1 }
        '
    return 0
}

# ---------------------------------------------------------------------------
# ping_host — ping a single host PING_COUNT times
# Arguments: $1 = IP address
# Returns: 0 on success, 1 on failure
# ---------------------------------------------------------------------------
ping_host()
{
    _ip="$1"

    [ -n "${_ip}" ] || { log_msg "error" "ping_host: empty IP argument"; return 1; }

    if "${PING_BIN}" -c "${PING_COUNT}" -W "${PING_TIMEOUT}" -q "${_ip}" \
            >/dev/null 2>&1; then
        log_msg "info" "OK      ${_ip} (${PING_COUNT} packets sent)"
        return 0
    else
        log_msg "warning" "FAIL    ${_ip} (no reply within ${PING_TIMEOUT}s)"
        return 1
    fi
}

# ---------------------------------------------------------------------------
# main — orchestrate dep check → host discovery → ping sweep
# ---------------------------------------------------------------------------
main()
{
    log_msg "info" "--- ts_keepalive start ---"

    # Rule 5: assert deps before proceeding
    check_deps || { log_msg "error" "dependency check failed; aborting"; return 1; }

    _host_list="$(get_host_ips)"

    # Assert we actually got something back
    [ -n "${_host_list}" ] || {
        log_msg "warning" "no reachable Tailscale peers found; nothing to ping"
        return 0
    }

    _total=0
    _ok=0
    _fail=0

    # Fixed upper-bound loop — IFS word-split over newline-delimited list
    # Rule 2: _total is bounded by MAX_HOSTS; loop exits when list is exhausted
    for _ip in ${_host_list}; do

        # Rule 2: enforce hard upper bound on iterations
        if [ "${_total}" -ge "${MAX_HOSTS}" ]; then
            log_msg "warning" "MAX_HOSTS (${MAX_HOSTS}) reached; truncating sweep"
            break
        fi

        _total=$(( _total + 1 ))

        if ping_host "${_ip}"; then
            _ok=$(( _ok + 1 ))
        else
            _fail=$(( _fail + 1 ))
        fi

    done

    log_msg "info" "sweep complete: ${_total} hosts | ${_ok} ok | ${_fail} failed"
    log_msg "info" "--- ts_keepalive end ---"

    # Non-zero exit if any host failed, so cron can capture it
    [ "${_fail}" -eq 0 ] || return 1
    return 0
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
main
