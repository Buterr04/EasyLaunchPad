import SwiftUI

@main
struct GeniusLaunchpadApp: App {
    var body: some Scene {
        WindowGroup {
            AppGridView()
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
