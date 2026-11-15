import Foundation

/// IPC contract for a separately installed, authorized TrollStore RootHelper extension.
/// This app deliberately does NOT call com.apple.amfi.xpc directly.
struct DeveloperModeStatus: Decodable {
    let success: Bool
    let status: Bool
    let armed: Bool

    var enabled: Bool { status }
}

enum HelperBridgeError: LocalizedError {
    case helperNotInstalled
    case invalidResponse
    case rejected(String)

    var errorDescription: String? {
        switch self {
        case .helperNotInstalled:
            return "The DevMode Neon RootHelper integration is not installed."
        case .invalidResponse:
            return "The helper returned an invalid response."
        case .rejected(let reason):
            return "Helper rejected the request: \(reason)"
        }
    }
}

final class TrollStoreHelperBridge {
    /*
     IMPORTANT:
     This is the app-side contract only. A standard TrollStore IPA cannot gain
     RootHelper privileges by itself. The companion RootHelper integration must
     implement this XPC service and be installed/authorized through a modified
     TrollStore build. Until then, all commands fail closed.

     Service name expected by this app:
       com.neonx.devmode.helper

     Required operations:
       status  -> { success: Bool, status: Bool, armed: Bool }
       arm     -> { success: Bool }
       disable -> { success: Bool }

     The privileged side must call TrollStore's existing checkDeveloperMode(),
     armDeveloperMode(), and disableDeveloperMode() functions. Never expose
     arbitrary AMFI XPC operations to this client.
    */

    func status() async throws -> DeveloperModeStatus {
        throw HelperBridgeError.helperNotInstalled
    }

    func arm() async throws {
        throw HelperBridgeError.helperNotInstalled
    }

    func disable() async throws {
        throw HelperBridgeError.helperNotInstalled
    }
}
