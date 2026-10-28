# Changelog

All notable changes to Reminder Desk are listed here. Versions follow `version` in `plugins/reminder-desk/.claude-plugin/plugin.json`.


## [1.1.0](https://github.com/nishkohli96/reminder-desk/releases/tag/v1.1.0)

**Released - 29 October, 2026**

### ✨ Added
- README guide to add Reminder Desk to your phone's home screen (iPhone Safari and Android Chrome), so you can open it in one tap.
- **Quick add**: type or dictate one sentence, like "Book flight tickets to Goa on 30 Oct at 4pm", and the page fills in the title, date and time for you to check before adding. Understands today/tomorrow, weekdays ("next Monday"), "30th Oct", "Nov 5", "15/11", "the 5th", "4pm", "16:30", "noon" and "in 2 hours", and runs entirely in the page.
- Setup now offers to pin the Reminder Desk page to your Claude sidebar (only with your yes), and its final message tells you how to rename and star the setup chat.
- Pull to refresh on the Reminder Desk page, for home-screen installs that have no browser refresh.
- After "Update Reminder Desk", Claude also shows **What's new**: the changes in every version since the one your account was on, taken from this changelog.
- `scripts/release.sh` removes older zips from `dist/`, so only the current version's zip is left.
- New setting **Auto Delete Reminders** (off by default). When on, a task is deleted a day after you tick it off, whenever the page is open. Turning it on also clears tasks that were done more than a day ago.
- Adding a task at a time that has already passed today now shows a note saying when the first reminder will come (with the follow-up, in tonight's end-of-day nudge, or tomorrow), plus a one-tap "Remind me at <next hour> instead".

### 🐛 Fixed
- On wider screens the Task field in the add form now gets the most room, instead of the Time field.
- The page now reloads your tasks and settings when you come back to it (switching apps, unlocking the phone, reconnecting). Before, a home-screen install could keep showing a task you'd deleted elsewhere until you closed the app.
- On phones, the time list (hour, minute, AM/PM) no longer runs off the screen and makes the page scroll sideways. It now opens from the right edge of the time field with narrower columns, so all three fit on screen.


## [1.0.1](https://github.com/nishkohli96/reminder-desk/releases/tag/v1.0.1)

**Released - 22 October, 2026**

### ✨ Added
- The Reminder Desk page shows its version next to the title, in a smaller font (e.g. `v1.0.1`).
- `.github/FUNDING.yml`, which adds a Sponsor button to the GitHub repo with links to GitHub Sponsors, Buy Me a Coffee and PayPal.
- An "Upgrading manually" section in the README with the update steps for Claude Code and the Claude app.
- A "Why updating takes two steps" section in the README explaining why a plugin update alone doesn't upgrade your page and reminders.
- `CONTRIBUTING.md` with how to report bugs, the repo layout, rules for changes (keep user data safe, keep the page and prompts in step, hour-safe schedules), local testing and the release steps.

### 🐛 Fixed
- Removed a leftover copy of the main skill (`skills/reminder-desk/`) from the plugin. Installs showed two setup skills, `/reminder-desk:reminder-desk` and `/reminder-desk:setup`; only `/reminder-desk:setup` remains.
- When setup is started where Claude can't create pages or scheduled tasks (such as the Claude Code terminal), Claude no longer claims you have no Reminder Desk page. That session can't see your page or reminders, so it now only points you to the Claude app, where setup checks for an existing page first.

### ⬆️ Upgrading
- Claude Code: `/plugin marketplace update reminder-desk`, then `/plugin update reminder-desk@reminder-desk`, or say "Update Reminder Desk".
- Claude app: update Reminder Desk from Customize > Plugins, or upload the 1.0.1 zip from the release.
- Your tasks, settings and reminders are not affected.

## [1.0.0](https://github.com/nishkohli96/reminder-desk/releases/tag/v1.0.0)

**Released - 21 October, 2026**

First release.
- Private Reminder Desk page to add, edit, tick off and delete tasks.
- Push reminders at the start of the day, at each task's time, a follow-up 1–12 hours later and at the end of the day, repeating until a task is done.
- Carried over list with a "(day N)" counter, collapsed when today has tasks.
- Settings for reminder times, follow-up gap, 12/24-hour time and Light / Dark / System theme.
- Timezone-aware tasks, safe across daylight-saving changes.
- `/reminder-desk:setup`, `/reminder-desk:update` and `/reminder-desk:uninstall`.
- Automatic setup in the first Claude Code or Cowork session after install.

