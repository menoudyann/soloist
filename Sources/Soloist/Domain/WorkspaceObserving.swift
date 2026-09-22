import Foundation

@MainActor
protocol WorkspaceObserving: AnyObject {
    var onApplicationActivated: ((RunningApplication) -> Void)? { get set }

    func start()
    func stop()
}
