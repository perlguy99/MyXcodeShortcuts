//
//  MockUserDefaults.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/20/24.
//

import Foundation

class MockUserDefaults: UserDefaults {
    var store = [String: Any]()
    
    override func set(_ value: Any?, forKey key: String) {
        store[key] = value
    }
    
    override func integer(forKey key: String) -> Int {
        return store[key] as? Int ?? 0
    }
    
    override func string(forKey key: String) -> String? {
        return store[key] as? String
    }
    
    override func bool(forKey key: String) -> Bool {
        return store[key] as? Bool ?? false
    }
    
    override func removeObject(forKey key: String) {
        store.removeValue(forKey: key)
    }
}
