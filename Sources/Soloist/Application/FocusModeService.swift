import Foundation

@MainActor
final class FocusModeService {
    private let applicationRepository: any ApplicationRepository
    private let workspaceObserver: any WorkspaceObserving
    private var hiddenApplications = Set<RunningApplication>()

    private(set) var isEnabled = false
    var onStateChanged: (() -> Void)?

    init(
        applicationRepository: any ApplicationRepository, workspaceObserver: any WorkspaceObserving
    ) {
        self.applicationRepository = applicationRepository
        self.workspaceObserver = workspaceObserver
        self.workspaceObserver.onApplicationActivated = { [weak self] application in
            self?.isolate(application)
        }
    }

    func enable() {
        guard !isEnabled else { return }

        isEnabled = true
        workspaceObserver.start()

        if let currentApplication = applicationRepository.currentApplication {
            isolate(currentApplication)
        }

        onStateChanged?()
    }

    func disable() {
        guard isEnabled else { return }

        workspaceObserver.stop()
        hiddenApplications.forEach(applicationRepository.unhide)
        hiddenApplications.removeAll()
        isEnabled = false
        onStateChanged?()
    }

    private func isolate(_ selectedApplication: RunningApplication) {
        guard isEnabled else { return }

        let applicationsToHide = applicationRepository.visibleApplications.filter { $0 != selectedApplication }
        applicationsToHide.forEach(applicationRepository.hide)
        hiddenApplications.formUnion(applicationsToHide)
    }
}
