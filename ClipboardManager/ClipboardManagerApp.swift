import SwiftUI

@main
struct ClipboardManagerApp: App {
    @StateObject private var clipboardStore = ClipboardStore()
    @StateObject private var appSettings = AppSettings()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(clipboardStore)
                .environmentObject(appSettings)
                .onAppear {
                    // Connect settings and start monitoring once
                    appSettings.setClipboardStore(clipboardStore)
                    clipboardStore.startMonitoring()
                }
        } label: {
            // Use configurable emoji as menu bar icon
            Text(appSettings.menuBarIcon)
                .font(.system(size: 16))
        }
        .menuBarExtraStyle(.window)
    }
}