import SwiftUI

struct AppIconView: View {
    let app: AppItem

    var body: some View {
        VStack(spacing: 4) {
            Image(nsImage: app.icon)
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(12)

            Text(app.name)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 72)
        }
        .padding(4)
        .onTapGesture {
            NSWorkspace.shared.open(app.url)
        }
    }
}
