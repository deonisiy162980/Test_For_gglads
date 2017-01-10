//
//  NSDate.swift
//  Test_for_gglads
//
//  Created by Denis on 10.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation

extension NSDate
{
    func dateToString() -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.stringFromDate(self)
    }
}