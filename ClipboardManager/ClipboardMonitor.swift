import Foundation
import AppKit

protocol ClipboardMonitorDelegate: AnyObject {
    func clipboardDidChange(_ content: String)
}

class ClipboardMonitor: ObservableObject {
    weak var delegate: ClipboardMonitorDelegate?
    
    private var timer: Timer?
    private var lastChangeCount: Int = 0
    private let pasteboard = NSPasteboard.general
    
    var isMonitoring: Bool {
        return timer != nil
    }
    
    init() {
        lastChangeCount = pasteboard.changeCount
    }
    
    func startMonitoring() {
        guard timer == nil else { return }
        
        // Update initial change count
        lastChangeCount = pasteboard.changeCount
        
        // Start monitoring with 0.5 second intervals
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkForClipboardChanges()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkForClipboardChanges() {
        let currentChangeCount = pasteboard.changeCount
        
        // Check if clipboard content has changed
        if currentChangeCount != lastChangeCount {
            lastChangeCount = currentChangeCount
            
            // Get the clipboard content
            if let content = pasteboard.string(forType: .string), !content.isEmpty {
                delegate?.clipboardDidChange(content)
            }
        }
    }
    
    func copyToClipboard(_ content: String) {
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }
}