//
//  UserDefaults Helper.swift
//  contactsApp3
//
//  Created by t2023-m0119 on 7/17/24.
//

import Foundation

class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    private let contactsKey = "contacts"
    
    func saveContact(_ contact: Contact) {
        var contacts = fetchContacts()
        contacts.append(contact)
        if let data = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(data, forKey: contactsKey)
        }
    }
    
    func fetchContacts() -> [Contact] {
        if let data = UserDefaults.standard.data(forKey: contactsKey),
           let contacts = try? JSONDecoder().decode([Contact].self, from: data) {
            return contacts
        }
        return []
    }
}
