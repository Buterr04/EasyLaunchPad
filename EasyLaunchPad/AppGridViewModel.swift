import SwiftUI
import AppKit
import UniformTypeIdentifiers

class AppGridViewModel: ObservableObject {
    @Published var apps: [AppItem] = []
    @Published var pages: [[AppItem]] = []

    let itemsPerPage = 35 // 5 行 x 7 列

    func loadApps() {
        let appDirs = [
            "/Applications",
/*            NSHomeDirectory() + "/Applications",
            "/System/Applications",
            "/System/Library/CoreServices"
 */
        ]

        var foundApps: [AppItem] = []

        for dir in appDirs {
            let url = URL(fileURLWithPath: dir)
            if let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.contentTypeKey], options: [.skipsHiddenFiles]) {
                for fileURL in contents {
                    guard fileURL.pathExtension == "app" else { continue }

                    // 判断是否为有效主程序
                    if let type = try? fileURL.resourceValues(forKeys: [.contentTypeKey]).contentType,
                       !type.conforms(to: .application) {
                        continue
                    }

                    // 读取 App 名称
                    let infoPlistURL = fileURL.appendingPathComponent("Contents/Info.plist")
                    var name = fileURL.deletingPathExtension().lastPathComponent
                    if let plist = NSDictionary(contentsOf: infoPlistURL) {
                        name = (plist["CFBundleDisplayName"] as? String) ??
                               (plist["CFBundleName"] as? String) ??
                               name
                    }

                    // 过滤后台服务类 App
                    let lower = name.lowercased()
                    if lower.contains("helper") || lower.contains("service") || lower.contains("agent") {
                        continue
                    }

                    // 图标
                    let icon = NSWorkspace.shared.icon(forFile: fileURL.path)
                    icon.size = NSSize(width: 64, height: 64)

                    foundApps.append(AppItem(name: name, url: fileURL, icon: icon))
                }
            }
        }

        DispatchQueue.main.async {
            let sorted = foundApps.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            self.apps = sorted
            self.pages = stride(from: 0, to: sorted.count, by: self.itemsPerPage).map {
                Array(sorted[$0..<min($0 + self.itemsPerPage, sorted.count)])
            }
        }
    }
}
