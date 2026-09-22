import SwiftUI

@main
@MainActor
struct SoloistApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var viewModel = SoloistViewModel(
        focusMode: FocusModeService(
            applicationRepository: SystemApplicationRepository(),
            workspaceObserver: WorkspaceActivationObserver()
        )
    )

    var body: some Scene {
        MenuBarExtra("Soloist", systemImage: viewModel.isEnabled ? "eye.fill" : "eye") {
            MenuBarView(viewModel: viewModel)
        }
        .menuBarExtraStyle(.window)
    }
}
