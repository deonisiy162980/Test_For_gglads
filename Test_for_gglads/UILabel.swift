//
//  UILable.swift
//  Test_for_gglads
//
//  Created by Denis on 08.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import UIKit

extension UILabel
{
    func calculateLines( forLabelHeight height : CGFloat ) -> Int
    {
        let charSize = self.font.pointSize
        return Int(height/charSize)
    }
}