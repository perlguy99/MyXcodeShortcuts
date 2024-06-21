//
//  MockUserDefaults.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/20/24.
//

import Foundation

class MockUserDefaults: UserDefaults {
    private var storage: [String: Any]
    
    init?(initialValues: [String: Any] = [:]) {
        self.storage = initialValues
        super.init(suiteName: nil) // Not needed but required by subclassing rules
    }
    
    override func integer(forKey defaultName: String) -> Int {
        let testVal = storage[defaultName] as? Int ?? 0
        print("Getting Integer for key: \(defaultName) - Value: \(testVal)")
        return storage[defaultName] as? Int ?? 0
    }
    
    override func string(forKey defaultName: String) -> String? {
        let testVal = storage[defaultName] as? String
        print("Getting String for key: \(defaultName) - Value: \(String(describing: testVal))")
        return storage[defaultName] as? String
    }
    
    override func bool(forKey defaultName: String) -> Bool {
        let testVal = storage[defaultName] as? Bool ?? true
        print("Getting Bool for key: \(defaultName) - Value: \(testVal)")
        return storage[defaultName] as? Bool ?? true
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        print("Setting: \(String(describing: value)) for key: \(defaultName)")
        storage[defaultName] = value
    }
    
    override func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }
}

