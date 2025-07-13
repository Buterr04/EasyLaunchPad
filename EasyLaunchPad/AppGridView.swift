import SwiftUI

struct AppGridView: View {
    @StateObject private var viewModel = AppGridViewModel()
    @State private var currentPage = 0

    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 7)

    var body: some View {
        VStack(spacing: 10) {
            if viewModel.pages.isEmpty {
                ProgressView("加载中...")
                    .onAppear {
                        viewModel.loadApps()
                    }
            } else {
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.pages.count, id: \.self) { index in
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.pages[index]) { app in
                                    AppIconView(app: app)
                                }
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                        }
                    }
                    .frame(width: geometry.size.width * CGFloat(viewModel.pages.count), alignment: .leading)
                    .offset(x: -CGFloat(currentPage) * geometry.size.width)
                    .animation(.easeInOut, value: currentPage)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack {
                    Button(action: {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(currentPage == 0)

                    Spacer()

                    Button(action: {
                        if currentPage < viewModel.pages.count - 1 {
                            currentPage += 1
                        }
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(currentPage == viewModel.pages.count - 1)
                }
                .padding(.horizontal, 40)

                // 页码指示器
                HStack(spacing: 6) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.primary : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    AppGridView()
}
