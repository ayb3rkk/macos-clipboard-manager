import SwiftUI
import Foundation

// Settings View embedded within ContentView
struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
                Button("Done") {
                    isPresented = false
                }
                .keyboardShortcut(.escape)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Max Items:")
                    Spacer()
                    Stepper(value: $appSettings.maxItems, in: 5...50) {
                        Text("\(appSettings.maxItems)")
                            .frame(width: 30)
                    }
                }
                
                HStack {
                    Text("Menu Bar Icon:")
                    Spacer()
                    
                    Menu(appSettings.menuBarIcon) {
                        ForEach(AppSettings.iconOptions, id: \.self) { icon in
                            Button(icon) {
                                appSettings.menuBarIcon = icon
                            }
                        }
                    }
                    .frame(width: 60)
                }
                
                Toggle("Show Timestamps", isOn: $appSettings.showTimestamps)
            }
            
            Divider()
            
            HStack {
                Button("Reset to Defaults") {
                    appSettings.resetToDefaults()
                }
                .foregroundColor(.red)
                
                Spacer()
            }
        }
        .padding()
    }
}

struct ContentView: View {
    @EnvironmentObject var clipboardStore: ClipboardStore
    @EnvironmentObject var appSettings: AppSettings
    @State private var hoveredItemId: UUID? = nil
    @State private var showingSettings = false
    @State private var copiedItemId: UUID? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Clipboard Manager")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                
                Button(action: {
                    showingSettings.toggle()
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Settings")
                
                Button(action: {
                    NSApplication.shared.terminate(self)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Quit")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Clipboard items list
            if clipboardStore.items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No clipboard items yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Copy something to get started!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(clipboardStore.items) { item in
                            ClipboardItemRow(
                                item: item,
                                isHovered: hoveredItemId == item.id,
                                isCopied: copiedItemId == item.id
                            )
                            .onTapGesture {
                                clipboardStore.copyItemToClipboard(item)
                                
                                // Show copied indicator
                                copiedItemId = item.id
                                
                                // Hide indicator after 1 second
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    if copiedItemId == item.id {
                                        copiedItemId = nil
                                    }
                                }
                            }
                            .onHover { isHovering in
                                hoveredItemId = isHovering ? item.id : nil
                            }
                        }
                    }
                }
                .frame(maxHeight: 400)
            }
            
            Divider()
            
            // Footer with settings
            HStack {
                Text("Items: \(clipboardStore.items.count)/\(appSettings.maxItems)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Clear All") {
                    clipboardStore.clearAll()
                }
                .font(.caption)
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.red)
                .disabled(clipboardStore.items.isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(NSColor.controlBackgroundColor))
            
            // Settings panel
            if showingSettings {
                Divider()
                SettingsView(isPresented: $showingSettings)
            }
        }
        .frame(width: 450, height: showingSettings ? 500 : 300)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct ClipboardItemRow: View {
    let item: ClipboardItem
    let isHovered: Bool
    let isCopied: Bool
    @EnvironmentObject var appSettings: AppSettings

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Item type icon
            Image(systemName: item.type.iconName)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 16, height: 16)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.displayContent)
                    .font(.system(size: 13))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    if appSettings.showTimestamps {
                        Text(Self.shortDateFormatter.string(from: item.timestamp))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if item.content.count > 50 {
                        Text("\(item.content.count) chars")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer(minLength: 8)
            
            // Copy indicator (text only, always reserve space to prevent layout shifts)
            HStack {
                if isCopied {
                    Text("Copied!")
                        .font(.caption2)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                } else if isHovered {
                    Text("Copy")
                        .font(.caption2)
                        .foregroundColor(.accentColor)
                        .fontWeight(.medium)
                } else {
                    // Reserve space even when nothing is shown
                    Text("Copied!")
                        .font(.caption2)
                        .opacity(0)
                        .fontWeight(.medium)
                }
            }
            .frame(width: 40, alignment: .trailing)
        }
        .padding(.leading, 12)
        .padding(.trailing, 4)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    isCopied ? Color.green.opacity(0.15) :
                    isHovered ? Color.accentColor.opacity(0.1) :
                    Color.clear
                )
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
        .environmentObject(ClipboardStore())
        .environmentObject(AppSettings())
}