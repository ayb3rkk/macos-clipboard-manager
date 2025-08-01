import Foundation
import Combine

class ClipboardStore: ObservableObject, ClipboardMonitorDelegate {
    @Published var items: [ClipboardItem] = []
    
    private let clipboardMonitor = ClipboardMonitor()
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "clipboardItems"
    private var appSettings: AppSettings?
    private var monitoringStarted = false
    private var isInternalCopy = false
    
    private var maxItems: Int {
        return appSettings?.maxItems ?? 10
    }
    
    init() {
        clipboardMonitor.delegate = self
        loadItems()
    }
    
    func setAppSettings(_ settings: AppSettings) {
        self.appSettings = settings
    }
    
    func startMonitoring() {
        guard !monitoringStarted else { 
            return 
        }
        monitoringStarted = true
        clipboardMonitor.startMonitoring()
    }
    
    func stopMonitoring() {
        clipboardMonitor.stopMonitoring()
    }
    
    // MARK: - ClipboardMonitorDelegate
    
    func clipboardDidChange(_ content: String) {
        // Don't add if this is an internal copy (clicking an item)
        if isInternalCopy {
            isInternalCopy = false
            return
        }
        
        // Don't add if it's the same as the most recent item
        if let lastItem = items.first, lastItem.content == content {
            return
        }
        
        // Create new clipboard item
        let itemType = ClipboardItemType.detectType(from: content)
        let newItem = ClipboardItem(content: content, type: itemType)
        
        DispatchQueue.main.async {
            // Add to beginning of array (most recent first)
            self.items.insert(newItem, at: 0)
            
            // Remove items beyond max limit (FIFO)
            while self.items.count > self.maxItems {
                self.items.removeLast()
            }
            
            // Save to UserDefaults
            self.saveItems()
        }
    }
    
    // MARK: - Public Methods
    
    func copyItemToClipboard(_ item: ClipboardItem) {
        // Mark this as an internal copy to prevent re-adding to list
        isInternalCopy = true
        clipboardMonitor.copyToClipboard(item.content)
        
        // Item stays in its current position in the list
    }
    
    func deleteItem(_ item: ClipboardItem) {
        DispatchQueue.main.async {
            self.items.removeAll { $0.id == item.id }
            self.saveItems()
        }
    }
    
    func clearAll() {
        DispatchQueue.main.async {
            self.items.removeAll()
            self.saveItems()
        }
    }
    
    // MARK: - Persistence
    
    private func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            userDefaults.set(data, forKey: itemsKey)
        } catch {
            // Silently fail - not critical
        }
    }
    
    private func loadItems() {
        guard let data = userDefaults.data(forKey: itemsKey) else {
            return
        }
        
        do {
            items = try JSONDecoder().decode([ClipboardItem].self, from: data)
        } catch {
            items = []
        }
    }
    
    // Update max items when settings change
    func updateMaxItems(_ newMax: Int) {
        DispatchQueue.main.async {
            while self.items.count > newMax {
                self.items.removeLast()
            }
            self.saveItems()
        }
    }
}