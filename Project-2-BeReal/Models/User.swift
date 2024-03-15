//
//  User.swift
//  Project-2-BeReal
//
//  Created by Muskan Mankikar on 3/8/24.
//

import Foundation
import ParseSwift


struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?

    var lastPostedDate: Date?

}
