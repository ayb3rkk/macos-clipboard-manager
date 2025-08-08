import Foundation

class SavedStore: ObservableObject {
    @Published var items: [ClipboardItem] = []
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "savedClipboardItems"
    
    init() {
        loadItems()
    }
    
    // MARK: - Public API
    func isSaved(_ item: ClipboardItem) -> Bool {
        return items.contains { $0.content == item.content }
    }
    
    func toggleSaved(_ item: ClipboardItem) {
        if let index = items.firstIndex(where: { $0.content == item.content }) {
            // Unsave existing
            items.remove(at: index)
            saveItems()
            return
        }
        
        // Save a copy to keep immutable snapshot
        let savedCopy = ClipboardItem(content: item.content, type: item.type)
        items.insert(savedCopy, at: 0)
        saveItems()
    }
    
    func remove(_ item: ClipboardItem) {
        items.removeAll { $0.content == item.content }
        saveItems()
    }
    
    func clearAll() {
        items.removeAll()
        saveItems()
    }
    
    // MARK: - Persistence
    private func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            userDefaults.set(data, forKey: itemsKey)
        } catch {
            // Silently ignore
        }
    }
    
    private func loadItems() {
        guard let data = userDefaults.data(forKey: itemsKey) else { return }
        do {
            items = try JSONDecoder().decode([ClipboardItem].self, from: data)
        } catch {
            items = []
        }
    }
}

