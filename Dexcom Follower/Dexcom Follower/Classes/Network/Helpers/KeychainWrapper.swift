//
//  KeychainWrapper.swift
//  Dexcom Follower
//
//  Created by James Furlong on 28/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

class KeychainWrapper {
    static let shared: KeychainWrapper = KeychainWrapper()
    
    // MARK: - Functions
    
    subscript(key: String) -> String? {
        get {
            return load(withKey: key)
        }
        set {
            DispatchQueue.global().sync(flags: .barrier) {
                self.save(newValue, forKey: key)
            }
        }
    }
    
    // MARK: - Internal Functions
    
    private func keychainQuery(withKey key: String) -> NSMutableDictionary {
        return [
            (kSecClass as String): kSecClassGenericPassword,
            (kSecAttrService as String): key,
            (kSecAttrAccessible as String): kSecAttrAccessibleAlwaysThisDeviceOnly
        ]
    }
    
    private func save(_ string: String?, forKey key: String) {
        let query = keychainQuery(withKey: key)
        let objectData: Data? = string?.data(using: .utf8, allowLossyConversion: false)
        
        if SecItemCopyMatching(query, nil) == noErr {
            if let dictData = objectData {
                _ = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
            }
            else {
                _ = SecItemDelete(query)
            }
        }
        else {
            if let dictData = objectData {
                query.setValue(dictData, forKey: kSecValueData as String)
                _ = SecItemAdd(query, nil)
            }
        }
    }
    
    private func load(withKey key: String) -> String? {
        let query = keychainQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        
        guard let resultsDict = result as? NSDictionary else { return nil }
        guard let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data else {
            return nil
        }
        guard status == noErr else { return nil }
        
        return String(data: resultsData, encoding: .utf8)
    }
}
