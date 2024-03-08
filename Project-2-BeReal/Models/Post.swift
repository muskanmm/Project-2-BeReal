//
//  Post.swift
//  Project-2-BeReal
//
//  Created by Muskan Mankikar on 3/8/24.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    // These are required by ParseObject
        var objectId: String?
        var createdAt: Date?
        var updatedAt: Date?
        var ACL: ParseACL?
        var originalData: Data?

        // Your own custom properties.
        var caption: String?
        var user: User?
        var imageFile: ParseFile?
}
