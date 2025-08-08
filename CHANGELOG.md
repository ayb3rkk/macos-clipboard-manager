# Changelog

All notable changes during Session 1 (2025-08-08 12:14 +03) are listed chronologically.

- Fix: Apply `showTimestamps` toggle in UI so timestamps can be hidden/shown in `ClipboardItemRow`.
- Change: Default `showTimestamps` to true when no setting exists (first launch).
- Docs: Revise `README.md` to match actual structure and build process; clarify defaults, heuristics, sandbox note, and limitations.
- UX: Include date in timestamps; later switch to concise format `MMM d, HH:mm` (e.g., "Aug 8, 14:32").
- Feature: Add Saved tab with persistent favorites.
  - Add `SavedStore` with `UserDefaults` persistence.
  - Provide `SavedStore` via environment in `ClipboardManagerApp`.
  - Add segmented tabs (Recent/Saved) in `ContentView`.
  - Add star icon per row to save/unsave items; saved items not pruned by FIFO.
  - Add Saved empty state and "Clear Saved" action.
- UX: Center the tabs and remove the visible "Tab" label.
- UX: Remove extra padding around the tab control to align with header.
- UX: Prevent star icon from shifting on hover by reserving fixed width for the copy indicator.
- Build: Replace Intel-only `swiftc` build with universal (arm64 + x86_64) build using macOS SDK and `lipo`.
- Build: Fix shell unicode (ellipsis) causing an "unbound variable" error; re-run successfully.
- Build: Remove auto-launch from build script; now prints app path and manual run hint.
