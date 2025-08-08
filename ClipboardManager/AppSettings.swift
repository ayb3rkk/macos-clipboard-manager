import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @Published var maxItems: Int {
        didSet {
            UserDefaults.standard.set(maxItems, forKey: "maxItems")
            clipboardStore?.updateMaxItems(maxItems)
        }
    }
    
    @Published var menuBarIcon: String {
        didSet {
            UserDefaults.standard.set(menuBarIcon, forKey: "menuBarIcon")
        }
    }
    
    @Published var showTimestamps: Bool {
        didSet {
            UserDefaults.standard.set(showTimestamps, forKey: "showTimestamps")
        }
    }
    
    private weak var clipboardStore: ClipboardStore?
    
    init() {
        // Load settings from UserDefaults with default values
        self.maxItems = UserDefaults.standard.object(forKey: "maxItems") as? Int ?? 10
        self.menuBarIcon = UserDefaults.standard.string(forKey: "menuBarIcon") ?? "📋"
        // Default to true when no value is stored yet
        self.showTimestamps = (UserDefaults.standard.object(forKey: "showTimestamps") as? Bool) ?? true
    }
    
    func setClipboardStore(_ store: ClipboardStore) {
        self.clipboardStore = store
        store.setAppSettings(self)
    }
    
    // Predefined emoji options for menu bar icon
    static let iconOptions = ["📋", "📄", "📝", "📑", "🗂", "📰", "📊", "💾", "⚡️", "🔄"]
    
    // Reset to defaults
    func resetToDefaults() {
        maxItems = 10
        menuBarIcon = "📋"
        showTimestamps = true
    }
}