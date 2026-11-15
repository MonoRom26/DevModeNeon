# DevMode Neon

SwiftUI iOS app project for the Developer Mode controller UI.

## Build
- Open `project.yml` with XcodeGen (`xcodegen generate`), then open the generated
  `DevModeNeon.xcodeproj` in Xcode.
- Or use the included GitHub Actions workflow to compile an unsigned IPA
  artifact.

## Critical functionality note
This project includes the complete app UI and a fail-closed helper client
contract. It does **not** yet change Developer Mode on its own. A normal
TrollStore IPA cannot automatically call TrollStore's privileged RootHelper.
The matching RootHelper integration described in `HelperIntegration/README.md`
must be implemented and installed first. The app will show HELPER OFFLINE
until that exists; this is intentional, not a fake success state.

Enable means arm Apple's Developer Mode activation for the next reboot. You
must restart the device and approve Apple's system prompt. Disable is handled
by TrollStore's privileged helper.
