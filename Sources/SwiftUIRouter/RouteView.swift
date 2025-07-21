//
//  RouteView.swift
//  SwiftUIRouter
//
//  Created by Hakan on 21.07.2025.
//

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public struct RouteView<Screen: Hashable, Content: View>: View {
    @ObservedObject private var router: Router
    private let content: Content
    private let destinationBuilder: (Screen) -> AnyView
    
    public init(
        router: Router,
        @ViewBuilder content: () -> Content,
        destinationBuilder: @escaping (Screen) -> AnyView
    ) {
        self.router = router
        self.content = content()
        self.destinationBuilder = destinationBuilder
    }
    
    public var body: some View {
        NavigationStack(path: router.bindingForSelectedPath()) {
            content
                .navigationDestination(for: Screen.self) { screen in
                    destinationBuilder(screen)
                }
                .sheet(item: Binding(
                    get: { router.activeSheet.map { AnyIdentifiable(id: UUID(), view: $0) } },
                    set: { _ in router.dismissSheet() }
                )) { item in
                    item.view
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
}

@available(macOS 10.15, *)
struct AnyIdentifiable: Identifiable {
    let id: UUID
    let view: AnyView
}
