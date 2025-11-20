# Repository Guidelines

## Project Structure & Module Organization
- Repo lives in `~/.midotfiles2`; key dotfiles map straight to home: `zshrc`, `p10k.zsh`, `vimrc`, `coc-settings.json`, `tmux.conf`, `gitconfig`, `gitignore`, `gitmessage`, `liquidpromptrc`.
- Use the `try_link` helper in `README.md` for symlinks (e.g., `try_link ~/.midotfiles2/zshrc ~/.zshrc`). Neovim reads `~/.config/nvim/init.vim`; Vim points to the same file.
- Put custom binaries or language servers in `~/bin` or under nvm/conda to avoid machine-specific paths.

## Build, Test, and Development Commands
- Clone: `git clone https://gh-proxy.com/https://github.com/chenmi319/midotfiles2.git ~/.midotfiles2`.
- Zsh: install oh-my-zsh, clone the plugins listed in `README.md`, then `try_link` `zshrc` and `p10k.zsh`; quick check with `zsh -n ~/.zshrc`.
- Vim/Neovim: install `vim-plug`, run `vim +PlugInstall +qall`; update with `+PlugUpdate`; clean with `+PlugClean`. Use nvm Node 22 for coc.nvim, then install Coc extensions noted in `vimrc`.
- Tmux: install tpm at `~/.tmux/plugins/tpm`, symlink `tmux.conf`, run `prefix + I` inside tmux to pull plugins.
- Git: link `gitconfig`, `gitignore`, `gitmessage`; keep `~/.gitconfig.user` for name/email and host-local overrides.

## Coding Style & Naming Conventions
- Shell edits: favor POSIX-compatible syntax, explicit guards (`command -v tool >/dev/null`), and clear `lower_snake_case` variable names. Keep aliases/functions single-purpose and reversible.
- Vimscript/Lua changes: mirror existing `vimrc` structure—group related options and plugins, keep comments short and instructional.
- Avoid clever one-liners; prefer boring, readable commands that new machines can reproduce.

## Testing Guidelines
- Validate shell configs with `zsh -n` or `bash -n` before sourcing. Reload tmux via `tmux source-file ~/.tmux.conf` after edits. Reopen Vim/Neovim and run `:checkhealth` when touching LSP or plugin settings.
- Aim for deterministic behavior: gate optional tools with existence checks and avoid machine-specific absolute paths.

## Commit & Pull Request Guidelines
- Follow `gitmessage`: `<type>: <summary>` where `type` is one of `feat|fix|docs|style|refactor|test|chore`; keep the first line under ~50 characters and add detail plus `Closes #` lines when relevant.
- Prefer small, staging-friendly commits that leave the shell usable after each change. Note validation commands in commit or PR descriptions.
- PRs (if used) should include a short what/why, steps to validate (commands above), and screenshots for visual prompt/theme tweaks.

## Security & Configuration Tips
- Never commit secrets; keep host-specific overrides in `~/.gitconfig.user` or separate files sourced conditionally.
- When adding plugins or themes, prefer shallow clones (`--depth=1`) or pinned versions to keep bootstrap fast and avoid surprises.
