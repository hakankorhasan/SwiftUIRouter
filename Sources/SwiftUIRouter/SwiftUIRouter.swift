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
    
    @Published public var activeSheet: AnyIdentifiable?
    @Published public var activeFullScreenSheet: AnyIdentifiable?
    @Published public var activeAlert: AlertItem?
    
    private let fullScreenSheetId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!

    
    private init() {}
    
    public func configureTabs(_ tabIDs: [String]) {
        for id in tabIDs {
            if tabPaths[id] == nil {
                tabPaths[id] = NavigationPath()
            }
        }
        selectedTabID = tabIDs.first ?? ""
    }
    
    public func binding(for tabID: String) -> Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { [weak self] in self?.tabPaths[tabID] ?? NavigationPath() },
            set: { [weak self] newValue in self?.tabPaths[tabID] = newValue }
        )
    }
    
    public func push<V: Hashable>(_ screen: V) {
        tabPaths[selectedTabID]?.append(screen)
    }
    
    public func pop() {
        guard var path = tabPaths[selectedTabID], !path.isEmpty else { return }
        path.removeLast()
        tabPaths[selectedTabID] = path
    }
    
    public func popToRoot(tabID: String? = nil) {
        let id = tabID ?? selectedTabID
        tabPaths[id] = NavigationPath()
    }
    
    public func switchTab(_ id: String) {
        selectedTabID = id
        tabPaths[id] = NavigationPath()
    }
    
    public func presentSheet<V: View>(_ view: V) {
        activeSheet = AnyIdentifiable(id: UUID(), view: AnyView(view))
    }
    
    func presentFullScreenSheet<V: View>(_ view: V) {
          activeFullScreenSheet = AnyIdentifiable(id: fullScreenSheetId, view: AnyView(view))
      }
      
    func dismissFullScreenSheet() {
        activeFullScreenSheet = nil
    }
    
    public func dismissSheet() {
        activeSheet = nil
    }
    
    public func deepLink<V: Hashable>(_ screens: [V]) {
        tabPaths[selectedTabID] = NavigationPath(screens)
    }
    
    public func showAlert(title: String, message: String, button: String = "OK") {
        activeAlert = AlertItem(title: title, message: message, button: button)
    }
}
