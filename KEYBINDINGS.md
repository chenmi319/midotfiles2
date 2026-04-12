# 快捷键清单

本文档整理了 dotfiles 中自定义的快捷键、别名和常用操作，方便查询和记忆。

> **约定**：`C-` = Ctrl，`M-` = Alt/Option，`<leader>` = `,`（英文逗号），`prefix` = `C-b`（tmux 默认前缀键）

---

## 目录

- [Neovim](#neovim)
  - [基础操作](#基础操作)
  - [文件与 Buffer](#文件与-buffer)
  - [Tab 管理](#tab-管理)
  - [NERDTree 文件树](#nerdtree-文件树)
  - [搜索与替换](#搜索与替换)
  - [Telescope 模糊搜索](#telescope-模糊搜索)
  - [LSP](#lsp)
  - [Git (Gitsigns)](#git-gitsigns)
  - [Flash.nvim 快速跳转](#flashnvim-快速跳转)
  - [Treesitter 代码跳转](#treesitter-代码跳转)
  - [补全 (blink.cmp)](#补全-blinkcmp)
  - [代码编辑辅助](#代码编辑辅助)
  - [Session 管理](#session-管理)
  - [路径复制](#路径复制)
- [tmux](#tmux)
  - [Pane / Window 导航](#pane--window-导航)
  - [分屏与窗口管理](#分屏与窗口管理)
  - [复制模式 (vi)](#复制模式-vi)
  - [其他](#其他-tmux)
- [Shell (zsh)](#shell-zsh)
  - [常用别名](#常用别名)
  - [常用函数](#常用函数)
  - [历史记录](#历史记录)
  - [代理](#代理)
- [Git 别名](#git-别名)
  - [日常操作](#日常操作)
  - [查看日志](#查看日志)
  - [暂存与撤销](#暂存与撤销)
- [Kubernetes / Helm 别名](#kubernetes--helm-别名)

---

## Neovim

**Leader 键**：`,`（英文逗号）

### 基础操作

| 按键 | 模式 | 作用 |
|------|------|------|
| `0` | n | 跳到首个非空字符（与 `^` 互换） |
| `^` | n | 跳到行首第 0 列 |
| `j` / `k` | n | 按屏幕行移动（折行友好） |
| `,.` | n | 跳到上次编辑位置 |
| `//` | n | 取消搜索高亮 |
| `'` / `` ` `` | n | 互换：`'` 跳到精确位置（行+列），`` ` `` 跳到行 |
| `<` / `>` | v | 缩进/反缩进后保持选区 |
| `F8` | n/i | 切换折行显示（wrap） |
| `[e` / `]e` | n | 将当前行上移/下移（支持 count） |
| `[e` / `]e` | v | 将选中行整体上移/下移 |
| `[<Space>` / `]<Space>` | n | 在上方/下方插入空行（支持 count） |

### 文件与 Buffer

| 按键 | 作用 |
|------|------|
| `,ww` | 保存文件（`:w`） |
| `,xx` | 保存并退出（`:x`） |
| `,qq` | 退出所有窗口（`:qa`） |
| `,bd` | 关闭当前 buffer |

### Tab 管理

| 按键 | 作用 |
|------|------|
| `H` / `L` | 切换到上一个/下一个 tab |
| `,tc` | 新建 tab |
| `,tx` | 关闭当前 tab |
| `,t]` / `,t[` | 向右/向左移动当前 tab |
| `,1` ~ `,9` | 按编号切换 tab |
| `,0` | 跳到最后一个 tab |

### NERDTree 文件树

| 按键 | 作用 |
|------|------|
| `C-\` | 智能切换：定位当前文件 / 切换 NERDTree |
| `,tn` | 跨所有 tab 同步切换 NERDTree |

### 搜索与替换

| 按键 | 模式 | 作用 |
|------|------|------|
| `*` | v | 向前搜索选中文本 |
| `#` | v | 向后搜索选中文本 |
| `,qo` / `,qc` | n | 打开/关闭 quickfix 窗口 |

### Telescope 模糊搜索

| 按键 | 作用 |
|------|------|
| `,ff` | 查找文件 |
| `,fF` | 查找文件（含隐藏文件） |
| `,fA` | 查找所有文件（含 gitignore） |
| `,fg` | 全文搜索（live grep） |
| `,fb` | 搜索 buffer 列表 |
| `,fh` | 搜索 help tags |
| `,fo` | 最近打开的文件 |
| `,f/` | 当前 buffer 内模糊搜索 |
| `,fr` | LSP 引用（references） |
| `,fd` | LSP 定义（definitions） |
| `,fi` | LSP 实现（implementations） |
| `,ft` | LSP 类型定义（type definitions） |
| `,fa` | 诊断列表 |
| `tt` | 恢复上次 Telescope 搜索 |

Telescope 内部：

| 按键 | 作用 |
|------|------|
| `<CR>` | 在新 tab 打开（已有则跳转） |
| `C-o` | 在当前窗口打开 |

### LSP

| 按键 | 模式 | 作用 |
|------|------|------|
| `gd` | n | 跳转到定义 |
| `,rn` | n | 重命名符号 |
| `,a` | n/v | Code action |
| `,qf` | n | Quick fix（自动应用首个修复） |
| `,fm` | n/v | 格式化文件/选区（conform） |
| `th` | n | 切换 inlay hints |
| `to` | n | 切换 Outline 面板 |
| `W` | n (Outline) | 折叠所有符号 |
| `E` | n (Outline) | 展开所有符号 |
| `R` | n (Outline) | 重置折叠状态 |
| `<Space>a` | n | 打开/关闭 Trouble 诊断面板 |
| `<Space>s` | n | 工作区符号搜索 |

> Neovim 0.11+ 内置 LSP 键位：`K`（hover）、`grr`（references）、`gri`（implementation）、`gra`（code action）、`grt`（type definition）、`gO`（document symbols）、`[d` / `]d`（诊断跳转）

### Git (Gitsigns)

| 按键 | 作用 |
|------|------|
| `]c` / `[c` | 跳到下一个/上一个 hunk |
| `]C` / `[C` | 跳到下一个/上一个已暂存 hunk |
| `,hp` | 弹窗预览当前 hunk diff |
| `,hb` | 显示当前行完整 blame |
| `,hd` | 分屏 diff（与 index 对比） |
| `,hD` | 分屏 diff（与上一个 commit 对比） |
| `,th` | 切换 hunk 行高亮 |
| `,tb` | 切换行尾 inline blame |
| `ih` | （operator/visual）text object：选中当前 hunk |

### Flash.nvim 快速跳转

| 按键 | 模式 | 作用 |
|------|------|------|
| `s` | n/v/o | 输入字符搜索并跳转 |
| `S` | n/v/o | Treesitter 节点跳转 |
| `r` | o（operator） | 远程操作（在远处执行 motion） |
| `C-s` | 命令行 | 在 `/` `?` 搜索时切换 flash 标签 |

### Treesitter 代码跳转

基于 treesitter 语法树的函数/类间跳转（`nvim-treesitter-textobjects` move 模块），支持 normal / visual / operator-pending 三种模式。

| 按键 | 作用 |
|------|------|
| `]m` / `[m` | 跳到下一个/上一个函数开头 |
| `]M` / `[M` | 跳到下一个/上一个函数结尾 |
| `]]` / `[[` | 跳到下一个/上一个类开头 |
| `][` / `[]` | 跳到下一个/上一个类结尾 |

> 跳转会记入 jumplist，`C-o` 可回。支持 operator 组合，如 `d]m` 删到下一个函数头。

### 补全 (blink.cmp)

| 按键 | 作用 |
|------|------|
| `C-Space` | 手动触发补全 / 切换文档 |
| `C-e` | 关闭补全菜单 |
| `<CR>` | 确认选中项 |
| `<Tab>` / `<S-Tab>` | 选择下一项/上一项（或 snippet 占位符） |
| `C-n` / `C-p` | 选择下一项/上一项 |
| `C-b` / `C-f` | 向上/向下滚动文档 |

### 代码编辑辅助

**treesj（展开/合并）**

| 按键 | 作用 |
|------|------|
| `,j` | 展开为多行（split） |
| `,k` | 合并为单行（join） |

**nvim-surround（括号包裹）**

| 按键 | 作用 |
|------|------|
| `ys{motion}{char}` | 添加包裹，如 `ysiw)` → `(word)` |
| `ds{char}` | 删除包裹，如 `ds"` → 去掉引号 |
| `cs{旧}{新}` | 替换包裹，如 `cs'"` → 单引号改双引号 |

**coerce.nvim（命名风格转换）**

| 按键 | 作用 |
|------|------|
| `crs` | 转为 snake_case |
| `crp` | 转为 PascalCase |
| `crc` | 转为 camelCase |
| `cru` | 转为 UPPER_CASE |
| `crk` | 转为 kebab-case |
| `crd` | 转为 dot.case |

> Visual/Motion 模式使用 `gcr` 前缀

**mini.align（文本对齐）**

| 按键 | 作用 |
|------|------|
| `ga` | 进入对齐模式（输入分隔符） |
| `gA` | 带实时预览的对齐模式 |

**treesitter-context**

| 按键 | 作用 |
|------|------|
| `tc` | 切换 treesitter context 顶部显示 |

### Session 管理

| 按键 | 作用 |
|------|------|
| `,sd` | 删除当前目录 session |
| `,ss` | Telescope 搜索/切换 session |

### 路径复制

| 按键 | 模式 | 作用 |
|------|------|------|
| `,cf` | n | 复制路径（`~/` 开头） |
| `,cr` / `,cs` | n | 复制相对路径（两者相同，冗余保留方便记忆） |
| `,cn` | n | 复制文件名 |
| `,cl` | n | 复制绝对路径 |
| `,cs` | v | 复制 `相对路径:行号范围` + 选中内容 |
| `,cl` | v | 复制 `绝对路径:行号范围` + 选中内容 |

### 粘贴与寄存器

| 按键 | 模式 | 作用 |
|------|------|------|
| `,p` / `,P` | v | 从 yank 寄存器粘贴（不被 d/x 污染） |
| `,Y` | n | 复制整个文件到系统剪贴板 |

### 窗口导航（与 tmux 联动）

| 按键 | 作用 |
|------|------|
| `C-h` / `C-j` / `C-k` / `C-l` | 在 Neovim split 和 tmux pane 间无缝移动 |

---

## tmux

**前缀键**：`C-b`（默认）  
**复制模式**：vi 键位 | **命令行**：emacs 键位

### Pane / Window 导航

| 按键 | 作用 |
|------|------|
| `C-h` / `C-j` / `C-k` / `C-l` | 跨 pane 移动（Vim 感知，与 Neovim 联动） |
| `M-h`（Alt+h） | 切换到上一个 window |
| `M-l`（Alt+l） | 切换到下一个 window |

### 分屏与窗口管理

| 按键 | 作用 |
|------|------|
| `prefix + "` | 纵向分割 pane（继承当前路径） |
| `prefix + %` | 横向分割 pane（继承当前路径） |
| `prefix + c` | 新建 window（继承当前路径） |
| `M-c`（Alt+c） | 在当前目录新建 window |
| `prefix + S` | 交互选择 session（树形视图） |
| `prefix + e` | 切换 pane 同步输入模式 |

### 复制模式 (vi)

| 按键 | 作用 |
|------|------|
| `v` | 开始选择 |
| `y` | 复制到系统剪贴板并退出 |
| 鼠标拖拽结束 | 复制到剪贴板（不退出复制模式） |
| 双击 | 选中并复制单词 |
| 三击 | 选中并复制整行 |

### 其他 {#其他-tmux}

| 按键 | 作用 |
|------|------|
| `prefix + r` | 重新加载 tmux 配置 |
| `prefix + m` | 在竖直分割中打开 man 页 |
| `prefix + M` | 在新 window 中打开 man 页 |
| `prefix + I` | 安装 TPM 插件（TPM 内置） |

---

## Shell (zsh)

### 常用别名

| 别名 | 作用 |
|------|------|
| `genpass` | 生成 16 位随机密码 |
| `uvs` | 激活当前目录 `.venv` |
| `uvsb` | 激活全局 base venv（`~/uv_venv/base`） |
| `conda` | → `micromamba` |
| `oc` | `opencode`（强制中文 locale） |
| `occ` | `opencode --continue`（强制中文 locale） |

### 常用函数

| 函数 | 作用 |
|------|------|
| `fixssh` | 在 tmux 中同步 SSH agent 环境变量 |
| `proxy` | 设置 HTTP/SOCKS5 代理（127.0.0.1:7890） |
| `unproxy` | 取消代理 |
| `update_mi_dot_files` | `git pull` 更新 dotfiles 仓库 |
| `mysql57` | Docker 运行 MySQL 5.7 客户端 |
| `psql13` / `psql11` / `psql10` | Docker 运行对应版本 PostgreSQL 客户端 |
| `redis-cli` | Docker 运行 Redis CLI |
| `load-uv-venv` | chpwd hook：自动激活/反激活目录下的 `.venv` |

### 键绑定说明

- `WORDCHARS` 不含 `_` 和 `-`，因此 `C-w` 删词时 `foo_bar` 会分两次删除
- 插件 `history-substring-search`：上/下箭头按前缀搜索历史
- 插件 `zsh-autosuggestions`：右箭头接受建议

### 历史记录

- 上箭头只浏览当前 shell 执行过的命令
- 每条命令执行完立即写入 `~/.zsh_history`（`INC_APPEND_HISTORY_TIME`）
- 新开 shell/pane 时自动加载完整历史文件，包含所有终端的命令
- 如需在当前 shell 中立即加载其他终端的历史，手动执行 `fc -R`

---

## Git 别名

在 `~/.gitconfig` 中定义，使用方式：`git <别名>`

### 日常操作

| 别名 | 展开 | 说明 |
|------|------|------|
| `a` | `add` | 暂存 |
| `chunkyadd` | `add --patch` | 按块交互暂存 |
| `b` | `branch -v` | 查看分支 |
| `co` | `checkout` | 切换分支 |
| `nb` | `checkout -b` | 新建分支 |
| `c` | `commit -m` | 带消息提交 |
| `ca` | `commit -am` | add + commit |
| `ci` | `commit` | 打开编辑器提交 |
| `amend` | `commit --amend` | 修改上次提交 |
| `cp` | `cherry-pick -x` | cherry-pick |
| `d` | `diff` | 查看差异 |
| `dc` | `diff --cached` | 查看已暂存差异 |
| `last` | `diff HEAD^` | 查看上次提交差异 |
| `pl` | `pull` | 拉取 |
| `ps` | `push` | 推送 |
| `s` / `st` | `status` | 状态 |
| `r` | `remote -v` | 远程仓库 |
| `t` | `tag -n` | 标签 |

### 查看日志

| 别名 | 说明 |
|------|------|
| `l` | 图形化 log（含日期） |
| `lg` | 美化彩色 graph log |
| `changes` | log 显示变更文件名 |
| `short` | 简洁 log |
| `simple` | 极简 log（仅 subject） |
| `shortnocolor` | 无颜色简洁 log |
| `filelog` | 逐文件历史 |
| `recent-branches` | 按提交时间列出最近 15 个分支 |

### 暂存与撤销

| 别名 | 展开 | 说明 |
|------|------|------|
| `ss` | `stash` | 暂存工作区 |
| `sl` | `stash list` | 查看暂存列表 |
| `sa` | `stash apply` | 应用暂存 |
| `sd` | `stash drop` | 删除暂存 |
| `snapshot` | — | stash 快照（推入后立刻 apply 保留工作区） |
| `snapshots` | — | 列出所有 snapshot stash |
| `unstage` | `reset HEAD` | 取消暂存 |
| `uncommit` | `reset --soft HEAD^` | 撤销上次提交（保留改动） |
| `rc` | `rebase --continue` | 继续 rebase |
| `rs` | `rebase --skip` | 跳过 rebase 当前步 |

---

## Kubernetes / Helm 别名

zshrc 中定义了多组集群快捷命令，命名规则统一：

| 格式 | 说明 | 示例 |
|------|------|------|
| `kube_{环境}` | `kubectl --context={环境}` | `kube_prod`、`kube_ali_dev` |
| `helm_{环境}` | `helm --kube-context={环境}` | `helm_ali_prod`、`helm_mycluster` |

具体集群名见 `zshrc` 第 260-317 行。使用方式与原生 `kubectl` / `helm` 完全一致，只是自动绑定了 context。
