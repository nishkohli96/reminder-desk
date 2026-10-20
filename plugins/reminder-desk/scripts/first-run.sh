#!/usr/bin/env bash
# Runs at session start. The first time only, it tells Claude to run Reminder Desk setup.
# A marker file in the plugin's data directory keeps it from firing again.
set -u
dir="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugin-data/reminder-desk}"
mkdir -p "$dir" 2>/dev/null || exit 0
marker="$dir/first-run-done"
[ -e "$marker" ] && exit 0
date -u +%Y-%m-%dT%H:%M:%SZ > "$marker" 2>/dev/null || exit 0

cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "The Reminder Desk plugin was just installed and this is its first session. Set it up automatically: at the start of your first reply, say in one line that you are setting up Reminder Desk, then follow the setup flow in the setup skill, /reminder-desk:setup (it checks for an existing Reminder Desk page and scheduled tasks first, so nothing is duplicated). If the user's first message is about something else, handle it after setup finishes. If the user says not now or no, skip setup and tell them they can say 'Set up my to-do reminders' any time. If this session lacks the Artifact or scheduled-task tools, do not attempt setup; tell the user in one line to open the Claude app and say 'Set up my to-do reminders'."
  }
}
JSON
exit 0
