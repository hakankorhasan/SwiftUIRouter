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
                .sheet(item: Binding<SheetWrapper?>(
                    get: {
                        if let id = router.activeSheetID, let view = router.activeSheet {
                            return SheetWrapper(id: id, view: view)
                        }
                        return nil
                    },
                    set: { newValue in
                        if newValue == nil { router.dismissSheet() }
                    }
                )) { (wrapper: SheetWrapper) in
                    wrapper.view
                }
                .fullScreenCover(item: Binding<SheetWrapper?>(
                    get: {
                        if let id = router.activeFullScreenID, let view = router.activeFullScreen {
                            return SheetWrapper(id: id, view: view)
                        }
                        return nil
                    },
                    set: { newValue in
                        if newValue == nil { router.dismissFullScreen() }
                    }
                )) { (wrapper: SheetWrapper) in
                    wrapper.view
                }
                .alert(item: $router.activeAlert) { alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: .default(Text(alert.button))
                    )
                }
                    

        }
        .id(tabID)
    }
    
    private func pathBinding() -> Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { router.tabPaths[tabID] ?? NavigationPath() },
            set: { router.tabPaths[tabID] = $0 }
        )
    }
}


struct SheetWrapper: Identifiable {
    let id: String
    let view: AnyView
}

