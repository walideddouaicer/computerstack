# Installing Omarchy alongside Windows

**Read this from your phone during the install.** Your laptop will be busy, and this repo
is on GitHub, so open it there.

---

## Your machine, checked 2026-09-04

```
1 disk    ADATA LEGEND 710, 954 GB, GPT (UEFI)
C:        953 GB total, 553 GB free      Windows
1 GB      no letter                       Windows Recovery  DO NOT TOUCH
~100 MB   no letter                       EFI boot          DO NOT TOUCH
BitLocker OFF, fully decrypted, no key protectors
```

**BitLocker being off is the important one.** It means disabling Secure Boot cannot lock
you out of Windows. That is the single most common way people lose a dual-boot weekend,
and it does not apply to you.

**One disk, not two.** So Omarchy and Windows share a drive. This is the normal case and
it works, but it is the reason to be careful at exactly one screen (step 6).

---

## The only two ways this goes wrong

Everything else is recoverable. These two are not.

1. **Choosing the default install instead of "Free space install."** The default wipes the
   whole disk. Its warning says *"Everything will be overwritten. There is no recovery
   possible."* Read every screen in the installer. Do not click through.
2. **Deleting the 1 GB Recovery or the ~100 MB EFI partition.** You never need to touch
   either. Omarchy will *use* the EFI one, which is correct and safe. Deleting it breaks
   the ability to boot anything.

Everything below exists to keep you away from those two.

---

## Step 1: Back up. Actually do it.

`computerstack` is on GitHub, so that is safe. Everything else is not.

Copy to an external drive or cloud: documents, photos, your PortNet work, anything in
Downloads you would miss, browser bookmarks.

**If you skip this and something goes wrong, there is no undo.** Take the twenty minutes.

## Step 2: Disable Fast Startup

Control Panel → Power Options → **Choose what the power buttons do** → *Change settings
that are currently unavailable* → untick **Turn on fast startup** → Save.

Why: with it on, Windows never fully shuts down. It leaves the disk in a half-open state,
and Linux will refuse to mount it, or worse, mount it anyway and corrupt it.

## Step 3: Make free space

**Start → type `disk management` → Create and format hard disk partitions.**

Right-click the **C:** partition → **Shrink Volume**.

Enter **400000** MB (about 400 GB) in "Enter the amount of space to shrink".

That leaves you:

```
Windows    ~553 GB total, ~150 GB free      plenty
Omarchy     ~400 GB unallocated             plenty for datasets
```

**Leave the new space UNALLOCATED.** Do not create a partition, do not format it, do not
give it a drive letter. Omarchy's installer wants raw unallocated space.

### If Windows will not let you shrink that far

Common, and fixable. Windows refuses because unmovable files sit near the end of the
volume. In an **Administrator** PowerShell:

```powershell
powercfg /h off                                  # removes hiberfil.sys
Disable-ComputerRestore -Drive "C:\"             # removes shadow copies
```

Reboot, try the shrink again. Turn restore back on afterwards if you want it:

```powershell
Enable-ComputerRestore -Drive "C:\"
```

## Step 4: Write the USB

Download the Omarchy ISO from [omarchy.org](https://omarchy.org).

Write it to a USB stick (8 GB or larger) with [balenaEtcher](https://etcher.balena.io) or
[Rufus](https://rufus.ie). **The USB gets wiped.** The laptop does not.

## Step 5: BIOS

Restart, press **F1** repeatedly at the ThinkPad logo.

- **Secure Boot: Disabled.** Omarchy requires it. Safe here because BitLocker is off.
- Leave TPM alone unless the installer complains.
- Boot order: put the USB first, or use **F12** at boot for a one-time boot menu. F12 is
  cleaner, it changes nothing permanently.

Save and exit.

## Step 6: The install, and the one screen that matters

Boot from the USB. When you reach disk selection:

> ### Choose **"Free space install"**
>
> **Not** the default. The default wipes the entire disk, Windows included.

It will use the ~400 GB you freed in step 3 and leave everything else alone.

Read every screen. If any screen says it will erase the disk, or shows a total larger than
400 GB, **stop and back out.** Nothing is written until you confirm.

## Step 7: Add Windows to the boot menu

Omarchy installs the **Limine** bootloader, which will not know about Windows yet. After
first boot into Omarchy, open a terminal:

```bash
limine-scan
```

Follow the prompts and add Windows Boot Manager. Reboot, and you get a menu with both.

**If you skip this, Windows appears to be gone.** It is not. Press **F12** at boot and
pick Windows Boot Manager manually, then run `limine-scan` properly.

## Step 8: computerstack

```bash
git clone https://github.com/walideddouaicer/computerstack.git ~/dev/computerstack
cd ~/dev/computerstack
bash bootstrap/bootstrap.sh --dry-run
```

**Read the dry run before running it for real.** The `system`, `brew` and `cli` phases
still assume `apt` and will fail on Arch. Run the phase that matters first:

```bash
bash bootstrap/bootstrap.sh --only claude
```

That is the layer you actually built. It is OS-independent and works today. The rest gets
rewritten for `pacman` once you are up.

---

## If something goes wrong

**Windows will not boot.** Almost always the bootloader, not your data. F12 at boot, pick
Windows Boot Manager. If it is not listed, boot a Windows recovery USB and run
`bootrec /rebuildbcd`.

**Omarchy will not boot.** F12, pick Windows, and you are back at work. Retry another day.

**You wiped the disk.** This is why step 1 exists.

The realistic worst case, having done step 1, is that you lose an evening. Not your data.
