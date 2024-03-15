//
//  Comment.swift
//  Project-2-BeReal
//
//  Created by Muskan Mankikar on 3/15/24.
//

import Foundation
import ParseSwift

struct Comment : ParseObject {
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var comment: String?
    var user: User?
}
