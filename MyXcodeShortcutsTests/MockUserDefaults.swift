//
//  MockUserDefaults.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/20/24.
//

import Foundation

//class MockUserDefaultsOLD: UserDefaults {
//    var store = [String: Any]()
//    
//    init?(initialValues: [String: Any] = [:]) {
//        self.store = initialValues
//        
//        super.init(suiteName: nil)
//    }
//    
//    override func set(_ value: Any?, forKey key: String) {
//        print("Setting: \(String(describing: value)) for key: \(key)")
//        store[key] = value
//    }
//    
//    override func integer(forKey key: String) -> Int {
//        print("Getting Integer for key: \(key)")
//        return store[key] as? Int ?? 0
//    }
//    
//    override func string(forKey key: String) -> String? {
//        print("Getting String for key: \(key)")
//        return store[key] as? String
//    }
//    
//    override func bool(forKey key: String) -> Bool {
//        print("Getting Bool for key: \(key)")
//        return store[key] as? Bool ?? true
//    }
//    
//    override func removeObject(forKey key: String) {
//        print("Removing Object for key: \(key)")
//        store.removeValue(forKey: key)
//    }
//}


class MockUserDefaults: UserDefaults {
    private var storage: [String: Any]
    
    init?(initialValues: [String: Any] = [:]) {
        self.storage = initialValues
        
        print("\n-------------initialValues-----------------")
        print(initialValues)
        print("--------------initialValues----------------\n")
        
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

