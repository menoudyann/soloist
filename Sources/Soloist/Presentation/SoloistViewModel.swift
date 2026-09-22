import SwiftUI

@MainActor
final class SoloistViewModel: ObservableObject {
    @Published private(set) var isEnabled = false

    private let focusMode: FocusModeService

    init(focusMode: FocusModeService) {
        self.focusMode = focusMode
        focusMode.onStateChanged = { [weak self] in
            self?.isEnabled = focusMode.isEnabled
        }
    }

    func toggle() {
        isEnabled ? focusMode.disable() : focusMode.enable()
    }

    var focusModeBinding: Binding<Bool> {
        Binding(
            get: { self.isEnabled },
            set: { _ in self.toggle() }
        )
    }
}
