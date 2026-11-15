# Required TrollStore RootHelper integration

## Important: this is not optional

A normal TrollStore-installed IPA does not automatically inherit the privileges
of TrollStore's RootHelper. The app must not call `com.apple.amfi.xpc` directly.
The app-side bridge in this project is intentionally fail-closed until a
matching privileged helper is installed.

## Verified TrollStore behavior to preserve

TrollStore's RootHelper `devmode.m` implements the privileged operations:
- check Developer Mode status and whether activation is armed
- arm Developer Mode so Apple's system prompt appears after reboot
- disable Developer Mode

The enable flow is not a silent toggle: the user must reboot and accept Apple's
system prompt.

## Integration work still required

Build a matching TrollStore fork/helper that:
1. Exposes a narrowly scoped XPC service named
   `com.neonx.devmode.helper`.
2. Authenticates the calling app by its expected bundle identifier and signing/
   installation context.
3. Implements only `status`, `arm`, and `disable`.
4. Delegates to TrollStore's existing `checkDeveloperMode`,
   `armDeveloperMode`, and `disableDeveloperMode` implementation.
5. Returns the documented status dictionary.
6. Is installed/authorized by TrollStore's own privileged installation path.

Do not copy the private AMFI entitlement into the ordinary app and do not
attempt to bypass Apple's Developer Mode confirmation screen.

Until this integration exists, the app correctly shows HELPER OFFLINE and
does not pretend that its buttons work.
