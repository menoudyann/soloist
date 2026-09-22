import Testing
@testable import Soloist

@MainActor
struct FocusModeServiceTests {
    @Test func enablingHidesOtherVisibleApplications() {
        let selected = RunningApplication(id: 1, name: "Selected")
        let other = RunningApplication(id: 2, name: "Other")
        let repository = ApplicationRepositorySpy(currentApplication: selected, visibleApplications: [selected, other])
        let observer = WorkspaceObserverSpy()
        let service = FocusModeService(applicationRepository: repository, workspaceObserver: observer)

        service.enable()

        #expect(service.isEnabled)
        #expect(observer.didStart)
        #expect(repository.hiddenApplications == [other])
    }

    @Test func disablingRestoresOnlyApplicationsHiddenBySoloist() {
        let selected = RunningApplication(id: 1, name: "Selected")
        let other = RunningApplication(id: 2, name: "Other")
        let repository = ApplicationRepositorySpy(currentApplication: selected, visibleApplications: [selected, other])
        let observer = WorkspaceObserverSpy()
        let service = FocusModeService(applicationRepository: repository, workspaceObserver: observer)

        service.enable()
        service.disable()

        #expect(!service.isEnabled)
        #expect(observer.didStop)
        #expect(repository.unhiddenApplications == [other])
    }
}

@MainActor
private final class ApplicationRepositorySpy: ApplicationRepository {
    let currentApplication: RunningApplication?
    let visibleApplications: [RunningApplication]
    private(set) var hiddenApplications: [RunningApplication] = []
    private(set) var unhiddenApplications: [RunningApplication] = []

    init(currentApplication: RunningApplication?, visibleApplications: [RunningApplication]) {
        self.currentApplication = currentApplication
        self.visibleApplications = visibleApplications
    }

    func hide(_ application: RunningApplication) {
        hiddenApplications.append(application)
    }

    func unhide(_ application: RunningApplication) {
        unhiddenApplications.append(application)
    }
}

@MainActor
private final class WorkspaceObserverSpy: WorkspaceObserving {
    var onApplicationActivated: ((RunningApplication) -> Void)?
    private(set) var didStart = false
    private(set) var didStop = false

    func start() {
        didStart = true
    }

    func stop() {
        didStop = true
    }
}
