//
//  RouteTab.swift
//  SwiftUIRouter
//
//  Created by Hakan on 21.07.2025.
//

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public struct RouteTab<Content: View>: Identifiable {
    public let id: String
    public let title: String
    public let icon: String
    public let content: () -> Content
    
    public init(
        id: String,
        title: String,
        icon: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.content = content
    }
    
    /// İçeriği AnyView olarak sarmalar, tip bilgisini siler
    public func erased() -> RouteTab<AnyView> {
        RouteTab<AnyView>(id: id, title: title, icon: icon) {
            AnyView(content())
        }
    }
}
