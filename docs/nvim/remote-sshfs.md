# remote-sshfs

[remote-sshfs.nvim](https://github.com/nosduco/remote-sshfs.nvim) mounts a
remote host with SSHFS so you can edit remote files like local ones. Requires
`sshfs` locally; remote search needs `ripgrep` (grep) and `rg`/`fd`/`where`
(find) on the server. Hosts are read from your `~/.ssh/config`.

Config: `custom/plugins/remote-sshfs.lua` (Telescope extension loaded).

## Keys

| Key | Does |
| --- | --- |
| `Space f R c` | Connect (host picker) |
| `Space f R f` | Find files on the remote host |
| `Space f R g` | Live grep on the remote host |
| `Space f R e` | Pick and edit an ssh config |

## Commands

```vim
:RemoteSSHFSConnect                       " pick from ssh config hosts
:RemoteSSHFSConnect user@host:/srv -p 2222
:RemoteSSHFSDisconnect
:RemoteSSHFSEdit
:RemoteSSHFSReload                        " re-read ssh configs
:RemoteSSHFSFindFiles
:RemoteSSHFSLiveGrep
```

Mount points live under `~/.sshfs/<host>`; nvim's working directory switches to
the mount, and it unmounts on exit. After connecting, the ordinary file tools
(`Space f f`, `\`) work on the remote files, but `Space s g` greps locally over
sshfs (slow); prefer `Space f R g`.
