import SwiftUI

@main
struct FDXQuickLookApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 12) {
                Text("FDX Quick Look is installed")
                    .font(.headline)
                Text("You can close this window. Select any .fdx file in Finder and press the space bar to preview the screenplay.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: 360)
            }
            .padding(40)
        }
        .windowResizability(.contentSize)
    }
}
