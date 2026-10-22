# Contributing to Reminder Desk

Thanks for helping. Bug reports, fixes and ideas are all welcome.

## Reporting a bug or asking for a feature

Open an [issue](https://github.com/nishkohli96/reminder-desk/issues) and include:

- Where you ran it: Claude app (chat or Cowork) or Claude Code, and your plugin version (from `/plugin` or Customize > Plugins).
- What you said or which command you ran (`/reminder-desk:setup`, `:update`, `:uninstall`).
- What Claude replied, and what you expected instead.
- For a missing or wrong push: the task's time, your timezone, and roughly when the push arrived (if at all).

Please leave out your task titles, artifact links and scheduled task IDs.

## How the repo is laid out

```
.claude-plugin/marketplace.json           # the marketplace (this repo)
plugins/reminder-desk/                    # the plugin; only this folder ships in releases
├── .claude-plugin/plugin.json            # name, version, author
├── .claude-plugin/icon.png               # 512×512 listing icon, made from assets/logo.svg
├── hooks/hooks.json                      # first-run SessionStart hook
├── scripts/first-run.sh
└── skills/
    ├── setup/                            # /reminder-desk:setup, the main skill
    │   ├── SKILL.md
    │   ├── assets/reminder-desk.html     # the Reminder Desk page
    │   └── references/*-prompt.md        # prompts for the three scheduled tasks
    ├── update/SKILL.md                   # /reminder-desk:update
    └── uninstall/SKILL.md                # /reminder-desk:uninstall
scripts/release.sh                        # builds the release zip and publishes a GitHub Release
```

## Making a change

1. Fork the repo and create a branch from `main`.
2. Make your change. Keep these rules:
   - **Never lose user data.** Task and settings documents live in each user's Reminder Desk page. Don't rename or remove fields. If you add a settings field, give it a default and teach `skills/update/SKILL.md` to add it for existing users.
   - **Keep the page and the prompts in step.** If you change the data model in `assets/reminder-desk.html`, update the three files in `references/` and the data model in `skills/setup/SKILL.md` too.
   - **Scheduled tasks run at most once an hour.** Any cron you generate must never fire runs less than 60 minutes apart, or `update_trigger` rejects it.
   - **No personal data** in examples: no real task names, artifact links, trigger IDs, emails or phone numbers.
3. Validate:
   ```bash
   claude plugin validate .
   claude plugin validate ./plugins/reminder-desk
   ```
4. Test it locally in Claude Code:
   ```bash
   claude plugin marketplace add ./
   claude plugin install reminder-desk@reminder-desk
   ```
   Run `/reload-plugins` after each edit. Setup itself needs the Claude app's page and scheduled-task tools, so test setup, update and uninstall in the Claude app as well: zip the plugin with `bash scripts/release.sh` and upload `dist/*.zip` in Customize > Plugins.
5. Add a line under **Unreleased** in [Changelog.md](Changelog.md).
6. Open a pull request that says what changed, why, and how you tested it.

## Releasing (maintainer)

1. Raise `version` in `plugins/reminder-desk/.claude-plugin/plugin.json`. Without a new version, existing users don't receive the update.
2. Move the **Unreleased** entries in `Changelog.md` under the new version and date.
3. Commit and push, then run:
   ```bash
   bash scripts/release.sh --publish
   ```
   This validates, builds `dist/reminder-desk-plugin-v<version>.zip`, tags `v<version>` and creates the GitHub Release with the zip attached.
4. After installing the new version, run "Update Reminder Desk" once on your own account so your page and reminders pick it up.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
