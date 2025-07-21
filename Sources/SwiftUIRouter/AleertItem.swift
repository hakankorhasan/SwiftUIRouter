//
//  AleertItem.swift
//  SwiftUIRouter
//
//  Created by Hakan on 21.07.2025.
//

import Foundation

import Foundation

@available(iOS 16.0, macOS 13.0, *)
public struct AlertItem: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let button: String
    
    public init(title: String, message: String, button: String = "OK") {
        self.title = title
        self.message = message
        self.button = button
    }
}

