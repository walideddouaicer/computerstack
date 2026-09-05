# Omarchy install runbook

**Read this from your phone.** Your laptop is the thing being operated on.

Every step has a **STOP IF**. If you hit one, stop and do not improvise. Nothing is
written to your disk until Step 7, so anything before that you can abandon by holding
the power button.

---

## State before you begin

Confirmed on 2026-09-05:

```
Disk        ADATA LEGEND 710, 953.85 GB, GPT (UEFI)
  100 MB    EFI System                    NEVER TOUCH
  781.83 GB C: Windows NTFS
  170.90 GB UNALLOCATED                   <-- Omarchy goes here
  1.02 GB   Recovery                      NEVER TOUCH

BitLocker       OFF, fully decrypted. No recovery key needed.
Fast Startup    disabled
USB             7.45 GB, omarchy-4.0.2.iso flashed and validated
Login           PIN or fingerprint. You do not know the account password.
```

**Backup status, be honest with yourself:**

```
Documents    backed up to Google Drive
Pictures     ~95%
Downloads    ~91%
Desktop      NOT BACKED UP  (~16 GB)
computerstack  safe on GitHub, private
```

**Your number: `170.90 GB`.** Memorise it. Every disk screen must match it.

---

## Step 1: last checks in Windows

```powershell
cd $env:USERPROFILE\Desktop\computerstack
git status -sb
git push ; git push --tags
```

**You should see:** `## main...origin/main` with nothing ahead.

**STOP IF:** it says "ahead 1" or more after pushing. Your work is not on GitHub. Fix
that before continuing.

Then confirm Fast Startup is really off. Control Panel → Power Options → "Choose what
the power buttons do". The **Turn on fast startup** box must be unticked and you must
have clicked **Save changes**.

---

## Step 2: shut down properly

**Start → Power → Shut down.**

**Not Restart. Not closing the lid.** A full shutdown, with Fast Startup off, is what
leaves the disk in a state Linux can read safely.

Wait until the machine is fully off. Fans stopped, no lights.

---

## Step 3: BIOS, disable Secure Boot

Plug in the USB. Press the power button, then tap **F1** repeatedly and immediately.

**You should see:** the ThinkPad BIOS setup screen.

- Navigate to **Security → Secure Boot**
- Set **Secure Boot** to **Disabled**
- Change nothing else
- **F10** to save and exit, confirm Yes

**If F1 does nothing:** power off fully and try again, tapping from the instant you press
power. Some ThinkPads use **Enter** first, then F1.

**STOP IF:** you see anything mentioning BitLocker, a recovery key, or encryption.
That should not happen, BitLocker is off. If it does, back out without saving and tell
me before going further.

---

## Step 4: boot the USB

The machine restarts. Tap **F12** repeatedly.

**You should see:** a boot menu listing your options.

Pick the entry for the USB. It may be named after the stick, or shown as "USB HDD" or
"Linpus lite". If two USB entries appear, prefer the one **without** "UEFI:" removed,
that is, prefer a UEFI entry.

**STOP IF: no USB entry appears.** Do not proceed. Power off, reseat the USB in a
different port, and try again. If it still does not appear, the flash may have failed
and you should boot back into Windows and re-flash.

---

## Step 5: the installer starts

Omarchy boots. This takes a minute or two. Text will scroll.

**STOP IF:** you get a black screen for more than three minutes with no disk activity
light. Hold the power button, restart, and tell me what the last text on screen was.

Work through the early screens: language, keyboard, timezone, WiFi. These are all safe
and reversible.

**Connect to WiFi if it asks.** The installer downloads packages.

---

## Step 6: THE DISK SCREEN. STOP HERE.

This is the only screen that matters.

> ### Take a photo with your phone. Send it to me. Do not click anything.

If you cannot reach me, apply these rules yourself:

**CHOOSE the option that says:**
- "Free space install", or
- an option showing roughly **170 GB**, or
- an option that lists your existing partitions and offers to use only the free space

**NEVER choose an option that:**
- says "erase disk", "wipe", "use entire disk", "automatic"
- shows **953 GB** or **781 GB** as the target
- warns "Everything will be overwritten. There is no recovery possible."

**STOP IF you are unsure at all.** Hold the power button for ten seconds. The machine
turns off, nothing has been written, Windows is untouched, and you try again later.

**Being wrong here costs you Desktop, which is not backed up. Being slow here costs
nothing.**

---

## Step 7: the install runs

Once confirmed, it writes. 20 to 40 minutes.

**Keep the laptop plugged into power.** Do not close the lid. Do not let it sleep.

**STOP IF:** it errors out partway. Do not reboot immediately. Photograph the error and
send it. A half-finished install is recoverable, a panicked reboot on top of one is
worse.

---

## Step 8: first boot

It reboots. You should land in Omarchy.

**Windows will appear to be gone. It is not.** The new bootloader does not know about it
yet. This is expected and Step 9 fixes it.

**STOP IF:** black screen or a boot error. Hold power, restart, tap **F12**, choose
**Windows Boot Manager**. You are back in Windows and safe. Then tell me.

---

## Step 9: put Windows back in the boot menu

In Omarchy, open a terminal. **Super key** (the Windows key) then type `terminal`, or
try **Super + Enter**.

```bash
limine-scan
```

Follow the prompts and add Windows Boot Manager. Reboot and you should get a menu with
both.

**If `limine-scan` is not found**, do not panic. Windows is still reachable with **F12**
at boot. Ask me and we will fix the bootloader properly.

---

## Step 10: bring your workshop over

```bash
sudo pacman -S --needed git
git clone https://github.com/walideddouaicer/computerstack.git ~/dev/computerstack
cd ~/dev/computerstack
bash bootstrap/bootstrap.sh --only claude
```

Only the `claude` phase. The others assume `apt` and will fail on Arch. We rewrite them
later.

---

## The three things to remember when it goes wrong

1. **Holding the power button for ten seconds is always safe** before Step 7 confirms.
2. **F12 at boot reaches Windows** even when the boot menu looks broken.
3. **Nothing is urgent.** A machine sitting powered off loses nothing. Stop, take a
   photo, ask, resume tomorrow if you need to.
