//
//  DateFormatter+Extension.swift
//  Project-2-BeReal
//
//  Created by Muskan Mankikar on 3/8/24.
//

import Foundation

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}
