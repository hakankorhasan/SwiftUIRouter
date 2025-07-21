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
        router.configureTabs(tabs.map { $0.id })
    }
    
    public var body: some View {
        TabView(selection: $router.selectedTabID) {
            ForEach(tabs) { tab in
                RouteView<Screen, AnyView>(router: router, content: {
                    tab.content()
                }, destinationBuilder: destinationBuilder)
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab.id)
            }
        }
    }
}
