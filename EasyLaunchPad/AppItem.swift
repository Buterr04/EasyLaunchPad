import AppKit

struct AppItem: Identifiable, Equatable, Hashable {
    var id: URL { url }
    let name: String
    let url: URL
    let icon: NSImage
}
import Foundation

class AppLayoutStore {
    static let shared = AppLayoutStore()

    private let layoutKey = "AppLayoutOrder"

    func saveAppOrder(_ apps: [AppItem]) {
        let identifiers = apps.map { $0.url.path }
        UserDefaults.standard.set(identifiers, forKey: layoutKey)
    }

    func loadAppOrder(from apps: [AppItem]) -> [AppItem] {
        guard let savedPaths = UserDefaults.standard.stringArray(forKey: layoutKey) else {
            return apps
        }

        var appMap = Dictionary(uniqueKeysWithValues: apps.map { ($0.url.path, $0) })
        var orderedApps: [AppItem] = []

        for path in savedPaths {
            if let app = appMap.removeValue(forKey: path) {
                orderedApps.append(app)
            }
        }

        // Append new apps not yet saved
        orderedApps.append(contentsOf: appMap.values.sorted { $0.name < $1.name })

        return orderedApps
    }
}
