//
//  Date+Utils.swift
//  CodingTest
//
//  Created by Andrés Padilla on 23/6/21.
//

import UIKit

extension Date {
    
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.short
        return dateFormatter.string(from: self)
    }
    
}
