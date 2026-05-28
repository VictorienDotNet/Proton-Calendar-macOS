import SwiftUI
import AppKit

struct WindowTitleHider: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)

        DispatchQueue.main.async {
            guard let window = view.window else { return }
            window.title = ""
            window.titleVisibility = .hidden
        }

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

