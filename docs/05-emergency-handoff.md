# Emergency handoff

**If something goes wrong and you are talking to a fresh Claude, paste the block below.**

It gives a new session everything it needs without you having to explain from scratch.
Read it on your phone at
`github.com/walideddouaicer/computerstack/blob/main/docs/05-emergency-handoff.md`

---

## Paste this into a new chat

```
I am mid-way through installing Omarchy Linux alongside Windows on my ThinkPad
and something has gone wrong. Here is the full context.

MACHINE
  ThinkPad laptop, 16 GB RAM, no NVIDIA GPU
  Disk: ADATA LEGEND 710, 953.85 GB, GPT / UEFI, single disk
  BitLocker: OFF, fully decrypted, no recovery key exists or is needed
  I log into Windows with a PIN or fingerprint. I do not know the account password.

DISK LAYOUT BEFORE THE INSTALL
  100 MB     EFI System partition
  781.83 GB  C: Windows NTFS
  170.90 GB  unallocated, intended for Omarchy
  1.02 GB    Windows Recovery

WHAT I ALREADY DID
  Shrank C: from 953 GB to 781.83 GB, leaving 170.90 GB unallocated
  Disabled Windows Fast Startup
  Flashed omarchy-4.0.2.iso to a 7.45 GB USB with balenaEtcher, validated OK
  Disabled Secure Boot in the ThinkPad BIOS (F1 at boot)

BACKUP STATUS, IMPORTANT
  Google Drive backup is INCOMPLETE. I cancelled it.
    Documents  backed up
    Pictures   about 95%
    Downloads  about 91%
    Desktop    NOT BACKED UP, about 16 GB
  My computerstack repo is safe on GitHub (private):
    github.com/walideddouaicer/computerstack

WHAT I WAS TRYING TO DO
  Install Omarchy into the 170.90 GB of free space using the installer's
  "Free space install" option, NOT the default which wipes the whole disk.
  Then run `limine-scan` so the Limine bootloader also lists Windows.

WHAT WENT WRONG
  <describe here, and attach a photo of the screen if you can>

HOW I NEED YOU TO HELP
  English is not my first language. Use simple, direct words and short sentences.
  Show me the disk layout as a diagram when it is relevant, I understand things
  visually. Give me one step at a time and wait for me to confirm before the next.
  Tell me plainly if something is unrecoverable rather than being reassuring.
  Do not use em dashes.
```

---

## Before you ask anyone, check these

Most "disasters" here are one of four things, and three are not disasters.

### "Windows is gone"

**Almost certainly not.** The new bootloader just does not list it yet.

1. Restart, tap **F12** repeatedly
2. Look for **Windows Boot Manager** in the list
3. Select it

If Windows boots, nothing is lost. You only need `limine-scan` in Omarchy to add it to
the menu permanently.

### "Omarchy will not boot"

Same move. **F12**, pick **Windows Boot Manager**, and you are back at a working machine.
Nothing is on fire. Ask for help from Windows, at your leisure.

### "The screen is black"

Wait three full minutes first. First boots are slow.

Then hold the power button for ten seconds, restart, and use **F12**.

### "I think I wiped the disk"

Check before assuming. Boot the USB again and look at the partition list. If you still
see an NTFS partition around 781 GB, Windows is intact and this is a bootloader problem,
not a data problem.

---

## Facts a fresh Claude will need and might get wrong

- **There is no BitLocker recovery key.** BitLocker was verified off before starting.
  Nobody needs to hunt for one.
- **The disk is GPT / UEFI**, not MBR / Legacy. Advice assuming MBR is wrong.
- **The 100 MB EFI and 1.02 GB Recovery partitions must never be deleted.** Omarchy uses
  the EFI one, which is correct.
- **Omarchy uses the Limine bootloader**, not GRUB. `grub-mkconfig` and `os-prober`
  advice does not apply. The command is `limine-scan`.
- **Desktop is not backed up.** Do not suggest anything that risks the Windows partition
  casually.

---

## Recovering Windows if the bootloader really is broken

Only if F12 does not show Windows Boot Manager.

You need a Windows installation USB, made on another computer with the Media Creation
Tool. Boot it, choose **Repair your computer → Troubleshoot → Command Prompt**:

```
bootrec /fixboot
bootrec /scanos
bootrec /rebuildbcd
```

This rebuilds the Windows boot entry. It does not touch your files.

---

## The calm version

Powered off, your machine loses nothing. There is no timer. If you are tired, confused,
or it is 2am, **shut it down and come back tomorrow.** Every problem in this document is
still solvable in the morning, and most bad outcomes in a dual-boot come from someone
tired trying one more thing.
