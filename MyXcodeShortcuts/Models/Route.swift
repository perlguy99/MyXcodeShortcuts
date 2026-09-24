//
//  Route.swift
//  MyXcodeShortcuts
//
//  Typed navigation destinations for the app's single NavigationStack, registered once via
//  navigationDestination(for: Route.self) in ContentView. Lets every push in the app go
//  through NavigationLink(value:), instead of mixing that with NavigationLink(destination:)
//  pushes and magic-string routes, which Apple explicitly warns causes real problems when
//  combined in one navigation hierarchy.
//

import Foundation

enum Route: Hashable {
    case settings
    case collections
    case categorySelection(Shortcut)
    case pdfPreview(Data)
    case help
}
