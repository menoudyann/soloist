import AppKit

@MainActor
final class SystemApplicationRepository: ApplicationRepository {
    var currentApplication: RunningApplication? {
        runningApplication(from: NSWorkspace.shared.frontmostApplication)
    }

    var visibleApplications: [RunningApplication] {
        NSWorkspace.shared.runningApplications
            .filter { application in
                application.activationPolicy == .regular && !application.isHidden && application.processIdentifier != ProcessInfo.processInfo.processIdentifier
            }
            .compactMap(runningApplication(from:))
    }

    func hide(_ application: RunningApplication) {
        NSRunningApplication(processIdentifier: application.id)?.hide()
    }

    func unhide(_ application: RunningApplication) {
        NSRunningApplication(processIdentifier: application.id)?.unhide()
    }

    private func runningApplication(from application: NSRunningApplication?) -> RunningApplication? {
        guard let application, application.activationPolicy == .regular else { return nil }

        return RunningApplication(
            id: application.processIdentifier,
            name: application.localizedName ?? "Unknown Application"
        )
    }
}
