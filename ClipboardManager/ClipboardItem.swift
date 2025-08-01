import Foundation

struct ClipboardItem: Identifiable, Codable {
    let id: UUID
    let content: String
    let timestamp: Date
    let type: ClipboardItemType
    
    init(content: String, type: ClipboardItemType = .text) {
        self.id = UUID()
        self.content = content
        self.timestamp = Date()
        self.type = type
    }
    
    var displayContent: String {
        // Clean up the content for display
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Replace multiple whitespaces/newlines with single space
        let cleaned = trimmed.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // Limit length for display
        if cleaned.count > 100 {
            return String(cleaned.prefix(100)) + "..."
        }
        
        return cleaned.isEmpty ? "(Empty)" : cleaned
    }
}

enum ClipboardItemType: String, Codable, CaseIterable {
    case text = "text"
    case url = "url"
    case email = "email"
    case phone = "phone"
    case code = "code"
    
    var iconName: String {
        switch self {
        case .text:
            return "doc.text"
        case .url:
            return "link"
        case .email:
            return "envelope"
        case .phone:
            return "phone"
        case .code:
            return "curlybraces"
        }
    }
    
    static func detectType(from content: String) -> ClipboardItemType {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // URL detection
        if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") || trimmed.hasPrefix("www.") {
            return .url
        }
        
        // Email detection
        if trimmed.contains("@") && trimmed.contains(".") && !trimmed.contains(" ") {
            let emailRegex = try? NSRegularExpression(pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
            if let regex = emailRegex {
                let range = NSRange(location: 0, length: trimmed.count)
                if regex.firstMatch(in: trimmed, options: [], range: range) != nil {
                    return .email
                }
            }
        }
        
        // Phone number detection (basic)
        let phonePattern = "^[\\+]?[1-9]?[0-9]{7,15}$"
        let phoneRegex = try? NSRegularExpression(pattern: phonePattern)
        let digitsOnly = trimmed.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        if let regex = phoneRegex {
            let range = NSRange(location: 0, length: digitsOnly.count)
            if regex.firstMatch(in: digitsOnly, options: [], range: range) != nil {
                return .phone
            }
        }
        
        // Code detection (contains common programming patterns)
        let codePatterns = ["{", "}", "(", ")", "[", "]", "func ", "def ", "class ", "import ", "#include", "var ", "let ", "const "]
        if codePatterns.contains(where: trimmed.contains) {
            return .code
        }
        
        return .text
    }
}