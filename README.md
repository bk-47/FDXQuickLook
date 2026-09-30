# FDX Quick Look

Adds a Finder spacebar preview for Final Draft (.fdx) files, showing formatted
screenplay text instead of raw XML.

## Build (one time)

1. Open `FDXQuickLook.xcodeproj` in Xcode.
2. With the `FDXQuickLook` scheme selected, press Cmd-R to build and run.
   Signing is set to local ad-hoc ("Sign to Run Locally"), so no Apple Developer
   account is needed.
3. A small window appears confirming it's installed. Close it.

Running it once registers the preview extension with macOS. After that, select
any `.fdx` in Finder and press the space bar.

## If Xcode complains about signing

Open the `FDXQuickLook` target, then the `FDXPreview` target, go to
Signing & Capabilities, and either leave it as-is or pick your own team. Build again.

## If the preview doesn't show

- System Settings > General > Login Items & Extensions > Quick Look — check that
  `FDXPreview` is switched on.
- In Terminal: `qlmanage -r && qlmanage -r cache`, then re-select the file.
- The extension only works while the built `FDXQuickLook.app` stays on disk. If
  you build to DerivedData, move the app to /Applications and run it once so it
  keeps a stable home. Don't delete it.
- If the build errors on `import Quartz`, change that line in
  `FDXPreview/PreviewViewController.swift` to `import QuickLookUI`.

## Scope

Handles scene headings, action, character, dialogue, parenthetical, and
transitions, plus the title page if present. It's a readable approximation of
screenplay layout, not exact page geometry. Dual dialogue and revision marks
aren't handled.

It registers against the Final Draft type identifier `com.finaldraft.fdx`, which
the app declares itself, so it works whether or not Final Draft is installed.

## Regenerating the project (optional)

If the `.xcodeproj` ever misbehaves and you have XcodeGen installed, you can
rebuild it from `project.yml` by running `xcodegen` in this folder.
