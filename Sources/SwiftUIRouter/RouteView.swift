//
//  RouteView.swift
//  SwiftUIRouter
//
//  Created by Hakan on 21.07.2025.
//

import SwiftUI

// RouteView.swift

@available(iOS 16.0, macOS 13.0, *)
public struct RouteView<Screen: Hashable, Content: View>: View {
    @ObservedObject private var router: Router
    private let tabID: String
    private let content: Content
    private let destinationBuilder: (Screen) -> AnyView
    
    public init(
        router: Router,
        tabID: String,
        @ViewBuilder content: () -> Content,
        destinationBuilder: @escaping (Screen) -> AnyView
    ) {
        self.router = router
        self.tabID = tabID
        self.content = content()
        self.destinationBuilder = destinationBuilder
    }
    
    public var body: some View {
        NavigationStack(path: pathBinding()) {
            content
                .navigationDestination(for: Screen.self) { screen in
                    destinationBuilder(screen)
                }
//                .sheet(
//                    item: Binding<Router.ActiveSheetType?>(
//                        get: {
//                            if case .sheet(let view) = router.activeSheetType {
//                                return .sheet(view)
//                            }
//                            return nil
//                        },
//                        set: { newValue in
//                            if newValue == nil || (newValue != nil && !isSheet(newValue)) {
//                                router.dismissSheet()
//                            }
//                        }
//                    )
//                ) { sheet in
//                    if case .sheet(let view) = sheet {
//                        view
//                    }
//                }
//                .fullScreenCover(
//                    item: Binding<Router.ActiveSheetType?>(
//                        get: {
//                            if case .fullScreenSheet(let view) = router.activeSheetType {
//                                return .fullScreenSheet(view)
//                            }
//                            return nil
//                        },
//                        set: { newValue in
//                            if newValue == nil || (newValue != nil && !isFullScreenSheet(newValue)) {
//                                router.dismissSheet()
//                            }
//                        }
//                    )
//                ) { fullScreenSheet in
//                    if case .fullScreenSheet(let view) = fullScreenSheet {
//                        view
//                    }
//                }
                .sheet(
                    item: Binding<Router.ActiveSheetType?>(
                        get: {
                            if case let .sheet(id, view) = router.activeSheetType {
                                return .sheet(id: id, view: view)
                            }
                            return nil
                        },
                        set: { newValue in
                            if newValue == nil {
                                router.dismissSheet()
                            }
                        }
                    )
                ) { sheet in
                    if case .sheet(_, let view) = sheet {
                        view
                    }
                }

                .fullScreenCover(
                    item: Binding<Router.ActiveSheetType?>(
                        get: {
                            if case let .fullScreenSheet(id, view) = router.activeSheetType {
                                return .fullScreenSheet(id: id, view: view)
                            }
                            return nil
                        },
                        set: { newValue in
                            if newValue == nil {
                                router.dismissSheet()
                            }
                        }
                    )
                ) { fullScreenSheet in
                    if case .fullScreenSheet(_, let view) = fullScreenSheet {
                        view
                    }
                }

                .alert(item: $router.activeAlert) { alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: .default(Text(alert.button))
                    )
                }
        }
    }
    
    private func pathBinding() -> Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { router.tabPaths[tabID] ?? NavigationPath() },
            set: { router.tabPaths[tabID] = $0 }
        )
    }
}

private func isSheet(_ sheet: Router.ActiveSheetType?) -> Bool {
    guard let sheet else { return false }
    if case .sheet = sheet { return true }
    return false
}

private func isFullScreenSheet(_ sheet: Router.ActiveSheetType?) -> Bool {
    guard let sheet else { return false }
    if case .fullScreenSheet = sheet { return true }
    return false
}

@available(macOS 10.15, *)
public struct AnyIdentifiable: Identifiable, Equatable {
    public let id: UUID
    public let view: AnyView
    
    public static func == (lhs: AnyIdentifiable, rhs: AnyIdentifiable) -> Bool {
        lhs.id == rhs.id
    }
    
    public init(id: UUID, view: AnyView) {
        self.id = id
        self.view = view
    }
}
