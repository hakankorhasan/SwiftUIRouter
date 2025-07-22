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
                if router.selectedTabID != newValue {
                    router.dismissSheet()
                    router.popToRoot(tabID: newValue)
                }
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
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab.id)
            }
        }
        .onAppear {
            router.configureTabs(tabs.map { $0.id })
        }
    }
}
