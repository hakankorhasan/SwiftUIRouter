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
    
    /// Tab ID'lerini ayarlar ve ilkini seçili yapar
    public func configureTabs(_ tabIDs: [String]) {
        for id in tabIDs {
            if tabPaths[id] == nil {
                tabPaths[id] = NavigationPath()
            }
        }
        selectedTabID = tabIDs.first ?? ""
    }
    
    /// Seçili tab için NavigationPath binding'i verir
    public func bindingForSelectedPath() -> Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { [weak self] in self?.tabPaths[self?.selectedTabID ?? ""] ?? NavigationPath() },
            set: { [weak self] newValue in self?.tabPaths[self?.selectedTabID ?? ""] = newValue }
        )
    }
    
    /// Seçili tab'a generic Hashable ekran kimliği push eder
    public func push<V: Hashable>(_ screen: V) {
        tabPaths[selectedTabID]?.append(screen)
    }
    
    /// Seçili tabda bir ekran geri gider
    public func pop() {
        guard var path = tabPaths[selectedTabID], !path.isEmpty else { return }
        path.removeLast()
        tabPaths[selectedTabID] = path
    }
    
    /// Seçili tabdaki navigation stack'i root'a döndürür
    public func popToRoot() {
        tabPaths[selectedTabID] = NavigationPath()
    }
    
    /// Aktif tabı değiştirir
    public func switchTab(_ id: String) {
        selectedTabID = id
    }
    
    /// Sheet olarak bir view gösterir
    public func presentSheet<V: View>(_ view: V) {
        activeSheet = AnyView(view)
    }
    
    /// Sheet'i kapatır
    public func dismissSheet() {
        activeSheet = nil
    }
    
    /// Seçili tab için deep link navigasyonunu ayarlar
    public func deepLink<V: Hashable>(_ screens: [V]) {
        tabPaths[selectedTabID] = NavigationPath(screens)
    }
    
    /// Alert gösterir
    public func showAlert(title: String, message: String, button: String = "Tamam") {
        activeAlert = AlertItem(title: title, message: message, button: button)
    }
}
