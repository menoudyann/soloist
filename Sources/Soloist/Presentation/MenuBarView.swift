import AppKit
import SwiftUI

@MainActor
struct MenuBarView: View {
    @ObservedObject var viewModel: SoloistViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Soloist")
                        .font(.headline)
                    Text("Keep only the active app visible")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Toggle("Focus mode", isOn: viewModel.focusModeBinding)
                    .labelsHidden()
                    .toggleStyle(.switch)
                    .accessibilityLabel("Focus mode")
            }

            Divider()

            Button("Quit Soloist") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding(16)
        .frame(width: 280)
    }
}
