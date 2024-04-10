////
////  SettingsViewModel.swift
////  MyXcodeShortcuts
////
////  Created by Brent Michalski on 4/1/24.
////
//
//import SwiftUI
//import Combine
//
//class SettingsViewModel: ObservableObject {
//    @Published var pdfTitle: String = Constants.defaultTitle {
//        didSet {
//            saveSettings()
//        }
//    }
//    
//    @Published var separator: String = Constants.defaultSeparator {
//        didSet {
//            saveSettings()
//        }
//    }
//    
//    static let shared = SettingsViewModel()
//    
//    private init() {}
//
//    private func saveSettings() {
//        UserDefaults.standard.set(pdfTitle, forKey: Constants.Keys.pdfTitle.rawValue)
//        UserDefaults.standard.set(separator, forKey: Constants.Keys.customSeparatorKey.rawValue)
//    }
//
//    func loadSettings() {
//        pdfTitle = UserDefaults.standard.string(forKey: Constants.Keys.pdfTitle.rawValue) ?? Constants.defaultTitle
//        customSeparator = UserDefaults.standard.string(forKey: Constants.Keys.customSeparatorKey.rawValue) ?? Constants.defaultSeparator
//    }
//    
//    func clearSettings() {
//        UserDefaults.standard.removeObject(forKey: Constants.Keys.pdfTitle.rawValue)
//        UserDefaults.standard.removeObject(forKey: Constants.Keys.customSeparatorKey.rawValue)
//    }
//}
//
