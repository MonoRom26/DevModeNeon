import SwiftUI

private enum NeonTheme {
    static let green = Color(red: 0.10, green: 0.96, blue: 0.55)
    static let panel = Color(red: 0.075, green: 0.095, blue: 0.09)
    static let muted = Color.white.opacity(0.58)
}

struct ContentView: View {
    @State private var showingGuide = false
    @State private var completedSteps: Set<Int> = []

    private let instructions: [String] = [
        "Open TrollStore on your iPhone.",
        "Open TrollStore's Settings section.",
        "Use TrollStore's built-in Enable Developer Mode option, if available.",
        "Follow the system restart instructions.",
        "After restarting, accept Apple's Developer Mode confirmation if it appears.",
        "Check Settings > Privacy & Security > Developer Mode."
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Circle()
                .fill(NeonTheme.green.opacity(0.13))
                .frame(width: 280, height: 280)
                .blur(radius: 90)
                .offset(x: 130, y: -300)
                .accessibilityHidden(true)

            ScrollView {
                VStack(spacing: 24) {
                    header

                    ZStack {
                        Circle()
                            .stroke(NeonTheme.green.opacity(0.15), lineWidth: 2)
                            .frame(width: 172, height: 172)

                        Circle()
                            .stroke(NeonTheme.green.opacity(0.55), lineWidth: 1)
                            .frame(width: 145, height: 145)

                        Image(systemName: "hammer.fill")
                            .font(.system(size: 54, weight: .medium))
                            .foregroundStyle(NeonTheme.green)
                            .shadow(color: NeonTheme.green.opacity(0.8), radius: 18)
                    }
                    .padding(.top, 18)
                    .accessibilityLabel("Developer tools icon")

                    VStack(spacing: 8) {
                        Text("Developer Mode")
                            .font(.system(size: 29, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("TROLLSTORE ACTIVATION COMPANION")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(NeonTheme.green)
                    }

                    statusPanel

                    Button {
                        showingGuide = true
                    } label: {
                        Label("VIEW ACTIVATION GUIDE", systemImage: "power")
                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                            .tracking(0.6)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(NeonTheme.green)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: NeonTheme.green.opacity(0.25), radius: 14)
                    }
                    .buttonStyle(.plain)

                    Text("This app is a guide. It does not change or read the protected iOS Developer Mode setting.")
                        .font(.system(size: 11))
                        .foregroundStyle(NeonTheme.muted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)

                    footer
                }
                .padding(22)
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $showingGuide) {
            guideSheet
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack(spacing: 9) {
            Image(systemName: "terminal.fill")
                .foregroundStyle(NeonTheme.green)
            Text("DEVMODE NEON")
                .font(.system(size: 15, weight: .heavy, design: .monospaced))
                .foregroundStyle(.white)
            Spacer()
            Text("TROLLSTORE")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(NeonTheme.green)
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .overlay(Capsule().stroke(NeonTheme.green.opacity(0.5), lineWidth: 1))
        }
    }

    private var statusPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 9) {
                Circle()
                    .fill(.orange)
                    .frame(width: 8, height: 8)
                Text("STATUS: NOT VERIFIED")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(.orange)
            }

            Text("Use TrollStore's own Developer Mode activation option and Apple's confirmation flow. This companion cannot activate Developer Mode by itself.")
                .font(.system(size: 13))
                .foregroundStyle(NeonTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NeonTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(NeonTheme.green.opacity(0.35), lineWidth: 1))
    }

    private var footer: some View {
        Text("DEV MODE UTILITY  •  iOS 16+")
            .font(.system(size: 9, weight: .medium, design: .monospaced))
            .tracking(1.2)
            .foregroundStyle(.gray)
            .padding(.top, 8)
    }

    private var guideSheet: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 18) {
                    Text("Activation checklist")
                        .font(.title2.bold())
                        .foregroundStyle(NeonTheme.green)

                    Text("Complete these steps on your iPhone. Checkboxes are only a personal checklist; they do not execute system actions.")
                        .font(.system(size: 12))
                        .foregroundStyle(NeonTheme.muted)

                    ForEach(instructions.indices, id: \.self) { index in
                        Button {
                            if completedSteps.contains(index) {
                                completedSteps.remove(index)
                            } else {
                                completedSteps.insert(index)
                            }
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: completedSteps.contains(index) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(completedSteps.contains(index) ? NeonTheme.green : .gray)
                                    .font(.title3)
                                Text(instructions[index])
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                Spacer(minLength: 0)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer(minLength: 8)
                }
                .padding(22)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { showingGuide = false }
                        .foregroundStyle(NeonTheme.green)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
