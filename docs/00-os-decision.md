# ADR-000: Host OS, native Linux dual-boot

> **SUPERSEDED by [ADR-001](01-omarchy-decision.md), 2026-09-04.**
> The MacBook is off, so the premise this rested on is gone. Omarchy now owns
> layers 0 and 1. Kept because the reasoning about WSL2 and about distro choice
> still holds, and because a decision log you delete from is not a log.

**Status:** Superseded
**Date:** 2026-08-11
**Context:** ThinkPad laptop, blank slate, MacBook planned in ~1 year, high tolerance for breakage, willing to dual-boot.

## Decision

**Ubuntu 24.04 LTS as a dual-boot native install.** Windows stays on its own partition for the handful of things that need it.

## Why not WSL2

WSL2 is genuinely good and I'd recommend it to someone with low risk appetite. Three things ruled it out for you:

1. **The MacBook migration is the deciding factor.** Every hour you spend learning WSL-specific behaviour, the `/mnt/c` filesystem performance cliff, `wsl.conf`, the networking NAT layer, Docker Desktop's WSL backend, `wslg` for GUI apps, is an hour that evaporates next year. Native Linux and macOS are both POSIX, both run Homebrew, both use the same dotfiles, the same shell, the same `~/.config` layout. **Your setup will transfer to the MacBook nearly unchanged.** WSL2 knowledge will not.
2. **You said "I do whatever it takes."** The main argument for WSL2 is avoiding pain. That argument doesn't apply to you.
3. **You have no NVIDIA GPU.** WSL2's biggest technical selling point in 2026 is CUDA passthrough on a Windows gaming rig. Irrelevant here, your ML compute is going to be CPU + cloud burst regardless, so the GPU tiebreaker is off the table.

Bonus: ThinkPads have the best Linux hardware support of any laptop line. Fingerprint, trackpoint, suspend, and power management all work out of the box. You picked the right hardware to do this on.

## Why Ubuntu 24.04 LTS and not Fedora/Arch

| | Verdict |
|---|---|
| **Ubuntu 24.04 LTS** | ✅ Chosen. Every ML/data/Docker tutorial on earth assumes it. `apt` packages exist for everything. 5 years of support. When something breaks at 2am, the fix is the first StackOverflow result. |
| Fedora | Newer kernel, nicer defaults, but you'll hit "this guide assumes Debian" friction constantly in the data engineering world. |
| Arch | The learning is real but it taxes you daily. You want to be building agents, not rebuilding your bootloader. Revisit in year two if you're bored. |

Choosing the boring distro is not the same as choosing the easy path. Your complexity budget should be spent on the agent layer, not on `pacman -Syu` roulette.

## Dual-boot plan (do this in order)

1. **Back up first.** Non-negotiable. External drive or cloud, whatever you can't lose.
2. **Note your Windows BitLocker recovery key.** Windows disk encryption will panic when the bootloader changes. Get the key from your Microsoft account first. This is the #1 way people lose a weekend.
3. **Shrink the Windows partition** from inside Windows (Disk Management → Shrink Volume). Give Linux **at least 150 GB**, Docker images and datasets eat space faster than you expect. 250 GB if you have it.
4. **Disable Windows Fast Startup** (Control Panel → Power Options → "Choose what the power buttons do" → uncheck Fast Startup). If you skip this, Linux will refuse to mount the Windows partition and may corrupt it.
5. **Write the Ubuntu 24.04 ISO** to a USB stick with [Rufus](https://rufus.ie) or [balenaEtcher](https://etcher.balena.io).
6. **BIOS:** ThinkPad → F1 at boot. Leave Secure Boot **on** (Ubuntu signs its bootloader; keeping it on avoids problems with Windows). Set the USB as first boot device.
7. **Install** → choose "Install Ubuntu alongside Windows Boot Manager". Enable third-party drivers when asked (WiFi firmware).
8. **After first boot:** `sudo apt update && sudo apt full-upgrade -y && sudo reboot`.
9. Then run `bootstrap/bootstrap.sh` from this repo.

### Escape hatch
If the install goes sideways, Windows is untouched on its own partition, boot from the USB in "Try Ubuntu" mode, or use Windows recovery to repair the boot record. You are never more than one USB stick away from a working machine. This is why we dual-boot instead of wiping.

## Consequences

- **Good:** Native Docker (no Desktop VM tax), real systemd, the exact environment your production containers run in, and a setup that lifts cleanly onto macOS next year.
- **Cost:** Rebooting to reach Windows. In practice you'll reboot into Windows about twice a month and resent it both times.
- **Watch out for:** Battery life is worse on Linux out of the box. Install `tlp` (in the bootstrap script) and you'll recover most of it.

## Revisit this when

You get the MacBook. At that point Windows disappears from your life entirely, and the `bootstrap.sh` in this repo already has the macOS branch written, you run one script and you're home.
