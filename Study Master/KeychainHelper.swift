//
//  KeychainHelper.swift
//  Study Master
//
//  Created by Finley Room on 7/14/25.
//


import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper() // Singleton

    private init() {}

    func save(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword, // Password-type item
                kSecAttrAccount as String: key,                // Unique name (e.g. "canvasAccessToken")
                kSecValueData as String: data                  // The actual secret data
            ]

            SecItemDelete(query as CFDictionary) // Make sure it's not already stored
            SecItemAdd(query as CFDictionary, nil) // Add new item
        }
    }

    func read(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }

        return string
    }

    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
}
