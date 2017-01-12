//
//  StarButton.swift
//  Test_for_gglads
//
//  Created by Denis on 12.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class StarButton: UIButton
{
    var animDidEnd = true
    var image = UIImageView()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
    
    @IBInspectable
    var isSelect: Bool = false
        {
        didSet {
            if isSelect
            {
                image.image = UIImage(named: "star")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.tintColor = Const.appColors.intrestingCellColor
                self.setImage(image.image, forState: .Normal)
            }
            else
            {
                image.image = UIImage(named: "star")
//                self.tintColor = UIColor.blackColor()
                self.setImage(image.image, forState: .Normal)
            }
            layoutSubviews()
        }
    }
}


//MARK: BUTTON ANIMS
extension StarButton
{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        //---------anim settings----------\\
        let scaleSize : CGFloat = 1.25
        let animDuration = 0.15
        //--------------------------------\\
        
        if animDidEnd
        {
            super.touchesBegan(touches, withEvent: event)
            
            animDidEnd = false
            
            if self.isSelect
            {
                self.isSelect = false
            }
            else
            {
                self.isSelect = true
            }
            UIView.animateWithDuration(animDuration, animations: {
                self.transform.a = scaleSize
                self.transform.d = scaleSize
                }, completion: { (hide) in
                    UIView.animateWithDuration(animDuration, animations: {
                        self.transform.a = 1.0
                        self.transform.d = 1.0
                        }, completion: { (hode) in
                            self.animDidEnd = true
                            
                    })
            })
        }
    }
}