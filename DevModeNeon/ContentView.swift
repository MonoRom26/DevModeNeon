import SwiftUI

struct ContentView: View {
    @StateObject private var model = DeveloperModeModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.015, green: 0.035, blue: 0.04),
                                    Color(red: 0.015, green: 0.015, blue: 0.025)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(.green)
                    Text("DEVMODE")
                        .font(.system(size: 25, weight: .black, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(.white)
                    Text("NEON")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 9).padding(.vertical, 5)
                        .background(Color.green, in: Capsule())
                    Spacer()
                    Circle().fill(model.connected ? .green : .orange)
                        .frame(width: 8, height: 8)
                    Text(model.connected ? "HELPER READY" : "HELPER OFFLINE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(model.connected ? .green : .orange)
                }

                VStack(spacing: 8) {
                    ZStack {
                        Circle().stroke(Color.green.opacity(0.12), lineWidth: 12)
                        Circle().trim(from: 0, to: model.isEnabled ? 1 : 0.28)
                            .stroke(LinearGradient(colors: [.green, .mint],
                                                   startPoint: .top, endPoint: .bottom),
                                    style: StrokeStyle(lineWidth: 7, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .shadow(color: .green.opacity(0.7), radius: 12)
                        VStack(spacing: 5) {
                            Image(systemName: model.isEnabled ? "checkmark.shield.fill" : "lock.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.green)
                            Text(model.statusTitle)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text(model.statusDetail)
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(30)
                    }
                    .frame(width: 210, height: 210)
                    .padding(.top, 10)
                }

                VStack(spacing: 12) {
                    actionButton("ENABLE DEVELOPER MODE", subtitle: "Arm Apple's activation prompt",
                                 icon: "power", color: .green, disabled: !model.connected) {
                        Task { await model.enable() }
                    }
                    actionButton("DISABLE DEVELOPER MODE", subtitle: "Turn Developer Mode off",
                                 icon: "power.circle", color: .orange, disabled: !model.connected) {
                        Task { await model.disable() }
                    }
                    actionButton("CHECK STATUS", subtitle: "Read status from the privileged helper",
                                 icon: "arrow.clockwise", color: .cyan, disabled: !model.connected) {
                        Task { await model.refresh() }
                    }
                }

                if model.pending {
                    Label("Activation is armed. Restart iPhone, then confirm Apple's system prompt.",
                          systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.yellow)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.yellow.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                }

                Text(model.message)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 28)

                Spacer(minLength: 0)
                Text("Developer Mode changes are handled by the authorized TrollStore helper.")
                    .font(.system(size: 9))
                    .foregroundStyle(.gray.opacity(0.75))
                    .multilineTextAlignment(.center)
            }
            .padding(22)
        }
        .task { await model.refresh() }
    }

    private func actionButton(_ title: String, subtitle: String, icon: String,
                              color: Color, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 13) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 34, height: 34)
                    .background(color.opacity(0.13), in: RoundedRectangle(cornerRadius: 9))
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.system(size: 12, weight: .heavy, design: .rounded))
                    Text(subtitle).font(.system(size: 9)).foregroundStyle(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(color)
            }
            .foregroundStyle(color)
            .padding(13)
            .background(Color.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.35), lineWidth: 1))
        }
        .disabled(disabled)
        .opacity(disabled ? 0.42 : 1)
    }
}

@MainActor
final class DeveloperModeModel: ObservableObject {
    @Published var connected = false
    @Published var isEnabled = false
    @Published var pending = false
    @Published var message = "Checking authorized helper…"

    var statusTitle: String { isEnabled ? "ENABLED" : (pending ? "PENDING" : "DISABLED") }
    var statusDetail: String {
        isEnabled ? "Developer Mode is active" :
        (pending ? "Restart and approve prompt" : "Developer Mode is not active")
    }

    private let bridge = TrollStoreHelperBridge()

    func refresh() async {
        do {
            let status = try await bridge.status()
            connected = true
            isEnabled = status.enabled
            pending = status.armed
            message = status.armed ? "Activation is armed for the next reboot." : "Status updated successfully."
        } catch {
            connected = false
            message = "Helper unavailable. Install the matching TrollStore helper integration first."
        }
    }

    func enable() async {
        do {
            try await bridge.arm()
            connected = true
            pending = true
            message = "Activation armed. Restart iPhone and accept Apple's prompt."
        } catch { message = error.localizedDescription }
    }

    func disable() async {
        do {
            try await bridge.disable()
            isEnabled = false
            pending = false
            connected = true
            message = "Disable command completed. Re-check status."
            await refresh()
        } catch { message = error.localizedDescription }
    }
}
