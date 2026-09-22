import Foundation

@MainActor
protocol ApplicationRepository {
    var currentApplication: RunningApplication? { get }
    var visibleApplications: [RunningApplication] { get }

    func hide(_ application: RunningApplication)
    func unhide(_ application: RunningApplication)
}
