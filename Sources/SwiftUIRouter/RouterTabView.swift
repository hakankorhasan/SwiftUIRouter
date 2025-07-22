//
//  RouterTabView.swift
//  SwiftUIRouter
//
//  Created by Hakan on 21.07.2025.
//
import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public struct RouteTabView<Screen: Hashable>: View {
    @ObservedObject var router: Router
    public let tabs: [RouteTab<AnyView>]
    private let destinationBuilder: (Screen) -> AnyView

    public init(
        router: Router,
        tabs: [RouteTab<AnyView>],
        destinationBuilder: @escaping (Screen) -> AnyView
    ) {
        self.router = router
        self.tabs = tabs
        self.destinationBuilder = destinationBuilder
    }

    public var body: some View {
        TabView(selection: tabSelectionBinding) {
            ForEach(tabs) { tab in
                RouteView<Screen, AnyView>(
                    router: router,
                    tabID: tab.id,
                    content: {
                        tab.content()
                    },
                    destinationBuilder: destinationBuilder
                )
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab.id)
            }
        }
        .onAppear {
            if router.tabPaths.isEmpty {
                router.configureTabs(tabs.map { $0.id })
            }
        }
        // Sheet
        .sheet(item: sheetBinding) { wrapper in
            wrapper.view
        }
        // Fullscreen Cover
        .fullScreenCover(item: fullScreenBinding) { wrapper in
            wrapper.view
        }
        .overlay {
            popupOverlay
        }
    }
    
    private var popupOverlay: some View {
        Group {
            if let _ = router.activePopupID, let popup = router.activePopup {
                ZStack {
                    router.activePopupBackgroundColor
                        .ignoresSafeArea()
                        .onTapGesture {
                            router.dismissPopup()
                        }
                    popup
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }

    // MARK: - Bindings
    private var tabSelectionBinding: Binding<String> {
        Binding<String>(
            get: { router.selectedTabID },
            set: { newValue in
                guard router.selectedTabID != newValue else { return }
                router.popToRoot(tabID: newValue)
                router.selectedTabID = newValue
            }
        )
    }

    private var sheetBinding: Binding<ViewWrapper?> {
        Binding<ViewWrapper?>(
            get: {
                if let id = router.activeSheetID, let view = router.activeSheet {
                    return ViewWrapper(id: id, view: view)
                }
                return nil
            },
            set: { newValue in
                if newValue == nil { router.dismissSheet() }
            }
        )
    }

    private var fullScreenBinding: Binding<ViewWrapper?> {
        Binding<ViewWrapper?>(
            get: {
                if let id = router.activeFullScreenID, let view = router.activeFullScreen {
                    return ViewWrapper(id: id, view: view)
                }
                return nil
            },
            set: { newValue in
                if newValue == nil { router.dismissFullScreen() }
            }
        )
    }
}

public struct ViewWrapper: Identifiable {
    public let id: String
    public let view: AnyView
}
