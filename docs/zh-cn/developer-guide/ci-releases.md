---
title: 持续集成和发布
description: 验证、持续集成、签名和发布工作流。
---
# 持续集成和发布

验证门、持续集成任务、发布管道和版本规则。

有关软件包本身，请参见 [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)]；有关主题，请参见 [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)]。

## 验证

`tools/sh/validate.sh` 是必需的门禁：

- 需要 `bash`、`makepkg`、`shellcheck`；
- `shellcheck` + `bash -n` 在 `tools/sh/*.sh` 和 `packaging/arch/common/*.sh` 上；
- 获取 PKGBUILD 并比较提取的元数据——远程和本地必须匹配；
- `makepkg -p PKGBUILD --printsrcinfo` 在 `ci/` 和 `local/` 中（像 makepkg 一样解析文件）；
- `git diff --check`（空白/冲突标记）。

## 持续集成

`.github/workflows/ci.yml`（推送/PR 到 `main`、`archlinux:latest` 容器）：

1. 安装 `base-devel git namcap pacman-contrib shellcheck sudo`；
2. `make validate`；
3. 以 **非特权** `builder` 用户身份构建（`sudo -u builder env HOME=/home/builder make build`）——makepkg 拒绝以 root 身份运行，并且工作区首先被 `chown`；
4. 一个单独的 `spellcheck` 任务使用 cspell.json 运行 `cspell-action@v6`。

 `cspell.json` `namcap` 安装时在 `pkgbuild_local.sh` 内运行，因此本地构建显示的 lint 与 CI 相同。拼写检查配置为 `cspell.json`，工作区词典在 `.cspell/custom-dictionary-workspace.txt`——新技术术语（shell 标志、工具名称）属于该词典，否则 CI 将失败。

## 发布流水线

`.github/workflows/release.yml` —— 触发条件：推送 `v*` 标签，或使用现有标签的 `workflow_dispatch`（受控重建）。并发组 `release-<ref>`，无取消。

步骤：

1. **签出** 标签（dispatch 使用 `inputs.tag`）。
2. **版本步骤**：将标签与 `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$` 验证，如果 `url` 在 `packaging/arch/remote/PKGBUILD` 中为空则失败，然后从标签重写 `pkgver`。
3. **验证**：`make validate`。
4. **以非特权用户构建** `builder`：`updpkgsums`（解析并验证真实的 `sha256sums`）然后 `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`。
   定位 `.pkg.tar.zst`，如果不存在则失败。
5. 对软件包进行 **namcap** 检查。
6. **签名**：将 `GPG_PRIVATE_KEY` 导入到临时 `GNUPGHOME`（`mktemp -d`，模式 700），验证导入的私钥是否匹配 `GPG_KEY_ID`（短 ID 或指纹），并使用 --pinentry-mode loopback --passphrase-fd 0 创建独立的 `.sig`。
7. 在新的  `--pinentry-mode loopback --passphrase-fd 0` `GNUPGHOME` 中 **验证签名**——如果签名验证失败，发布将失败。
8. **上传制品**（`upload-artifact@v4`、`retention-days: 1`、软件包 +
   签名, `if-no-files-found: error`)。
9. **发布**：使用 PACKAGES_REPO_TOKEN 检出 `argvus/packages`，将包和  `PACKAGES_REPO_TOKEN` `.sig` 复制到 `public/arch/x86_64`，运行 `repo-add -R argvus.db.tar.gz <pkg>`，签署 `argvus.db.tar.gz`、`argvus.files.tar.gz`、`argvus.db` 和 `argvus.files`，然后作为 `github-actions[bot]` 提交并推送。没有变化的差异将以 0 退出而不会提交。
10. **GitHub 发布**：`softprops/action-gh-release@v2` 生成的说明以及作为资源的包和签名。

## 校验和、签名与秘密

- 没有 `SKIP`：`sha256sums` 总是一个真实的摘要，在构建时（本地）或通过 `updpkgsums`（发布 CI）计算。
- 在仓库中保持 `sha256sums=()` **为空**。
- 发布时使用 GPG 签名（包 `.sig`、`argvus.db.tar.gz`、`argvus.files.tar.gz`、`argvus.db`、`argvus.files`）。
- `GPG_PASSPHRASE` 必须非空；工作流会拒绝空的密码短语。

准备密钥：

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
在仓库的 **设置 → 密钥和变量 → Actions** 中：

| 密钥 | 值 |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` 输出 |
| `GPG_KEY_ID` | 预期的密钥 ID 或指纹 |
| `GPG_PASSPHRASE` | 签名密钥的非空密码 |
| `PACKAGES_REPO_TOKEN` | 在 argvus/packages 上带有 `contents:write` 的 PAT |

## 发布版本

在打标签之前：

1. 在 `argvus/packages` 中填写 `url` 的真实仓库：
   - GitHub： `packaging/arch/remote/PKGBUILD` `url="https://github.com/argvus/argvus-boot-splash"`（源代码使用 `${url}/archive/refs/tags/v${pkgver}.tar.gz`）；
   - GitLab：将 `source=` 调整为 `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`；
   - 没有 `url` 时，发布**会故意失败**并显示清晰的消息。
2. 同步 `packaging/arch/local/PKGBUILD` 和 `packaging/arch/remote/PKGBUILD` 中的版本/元数据。
3. 打标签并推送：

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
还可以使用现有的 `v*` 标签作为其手动启动工作流程
   `tag` 输入，这对于受控重建很有用。

## 版本控制

- SemVer 在 `pkgver` 中，发布计数在 `pkgrel` 中。

## 开发人员故障排除

**发布在“检索源”时失败。** `url` 为空、缺少 `v*` 标签或
存档 URL 格式与主机不匹配（GitHub 与 GitLab tarball
布局）。工作流程验证标签模式并在空的情况下早期失败
`url`。

**`updpkgsums` 找不到来源。** 该标签必须存在且之前推送过
发布作业运行；使用仅本地存在的标签进行调度在此处失败。

**`make validate` 报告“远程和本地 PKGBUILD 元数据不同步”。**
将元数据字段（不是 `source=`）从一个 PKGBUILD 复制到另一个。

**新术语的拼写检查失败。** 将其添加到
`.cspell/custom-dictionary-workspace.txt`（`argvus` 字典，`addWords：
true`), not to `ignorePaths`。

**`sudo` 请求在 `make install` 或 `libfakeroot.so … LD_PRELOAD` 内部出现错误。** 一个 `package()` 调用 `make install` 而不是使用 `install -Dm*`。两个 PKGBUILD 都调用 `arch_package_splash_payload`，而它并没有；确保没有人重新引入 `make` 调用。

**`makepkg` 拒绝运行。** 它不能以 root 身份运行。请以普通用户或 `sudo -u <user> make build` 运行构建。

**软件包已安装，但启动画面未更改。** initramfs 未重建。对于本地测试，请调用 `sudo plymouth --show-splash` 而不是重启，或者使用 `sudo mkinitcpio -P` / `sudo dracut --regenerate-all` 重新构建。
