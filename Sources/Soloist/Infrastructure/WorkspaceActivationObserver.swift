import AppKit

@MainActor
final class WorkspaceActivationObserver: WorkspaceObserving {
    var onApplicationActivated: ((RunningApplication) -> Void)?

    private var activationObserver: NSObjectProtocol?

    func start() {
        guard activationObserver == nil else { return }

        activationObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                  application.activationPolicy == .regular else { return }

            let runningApplication = RunningApplication(
                id: application.processIdentifier,
                name: application.localizedName ?? "Unknown Application"
            )

            Task { @MainActor [weak self] in
                self?.onApplicationActivated?(runningApplication)
            }
        }
    }

    func stop() {
        guard let activationObserver else { return }

        NSWorkspace.shared.notificationCenter.removeObserver(activationObserver)
        self.activationObserver = nil
    }
}
