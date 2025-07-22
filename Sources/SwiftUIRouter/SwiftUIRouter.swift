// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
@MainActor
public final class Router: ObservableObject {
    
    public static let shared = Router()
    
    @Published public var selectedTabID: String = ""
    @Published public var tabPaths: [String: NavigationPath] = [:]
    
    @Published public var activeSheet: AnyView?
    @Published public var activeAlert: AlertItem?
    
    private init() {}
    
    // Tab ID'lerini ayarlar
    public func configureTabs(_ tabIDs: [String]) {
        for id in tabIDs {
            if tabPaths[id] == nil {
                tabPaths[id] = NavigationPath()
            }
        }
        selectedTabID = tabIDs.first ?? ""
    }
    
    // ✅ Tab bazlı NavigationPath binding
    public func binding(for tabID: String) -> Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { [weak self] in self?.tabPaths[tabID] ?? NavigationPath() },
            set: { [weak self] newValue in self?.tabPaths[tabID] = newValue }
        )
    }
    
    // Seçili tab'a ekran push
    public func push<V: Hashable>(_ screen: V) {
        tabPaths[selectedTabID]?.append(screen)
    }
    
    // Geri git
    public func pop() {
        guard var path = tabPaths[selectedTabID], !path.isEmpty else { return }
        path.removeLast()
        tabPaths[selectedTabID] = path
    }
    
    // Root'a dön
    public func popToRoot(tabID: String? = nil) {
        let id = tabID ?? selectedTabID
        tabPaths[id] = NavigationPath()
    }
    
    // ✅ Tab değiştirme (artık resetleme yok, sadece seçimi değiştiriyor)
    public func switchTab(_ id: String) {
        selectedTabID = id
    }
    
    // Sheet göster
    public func presentSheet<V: View>(_ view: V) {
        activeSheet = AnyView(view)
    }
    
    // Sheet kapat
    public func dismissSheet() {
        activeSheet = nil
    }
    
    // Deep link navigation
    public func deepLink<V: Hashable>(_ screens: [V]) {
        tabPaths[selectedTabID] = NavigationPath(screens)
    }
    
    // Alert
    public func showAlert(title: String, message: String, button: String = "Tamam") {
        activeAlert = AlertItem(title: title, message: message, button: button)
    }
}
