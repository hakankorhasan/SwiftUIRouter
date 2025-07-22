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
        TabView(selection: Binding(
            get: { router.selectedTabID },
            set: { newValue in
                guard router.selectedTabID != newValue else { return }
               
                router.popToRoot(tabID: newValue)
                router.selectedTabID = newValue
            }
        )) {
            ForEach(tabs) { tab in
                RouteView<Screen, AnyView>(
                    router: router,
                    tabID: tab.id,
                    content: {
                        tab.content()
                    },
                    destinationBuilder: destinationBuilder
                )
                .id(tab.id)
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
    }
}
