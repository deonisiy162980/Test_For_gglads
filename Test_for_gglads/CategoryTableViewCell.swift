//
//  CategoryTableViewCell.swift
//  Test_for_gglads
//
//  Created by Denis on 09.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var categoryName: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    func configureCell( withCategory category : Category, isSelected : Bool )
    {
        categoryName.text = category.name
        
        if isSelected
        {
            self.categoryName.textColor = Const.appColors.defaultBlueColor
        }
    }
    
    
    override func prepareForReuse()
    {
        self.categoryName.textColor = UIColor.blackColor()
        
    }
}
