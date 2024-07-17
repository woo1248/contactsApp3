//
//  appControlModel.swift
//  contactsApp3
//
//  Created by t2023-m0119 on 7/17/24.
//

import Foundation

struct Contact: Codable {
    var name: String
    var phoneNumber: String
    var profileImageData: Data?
}
