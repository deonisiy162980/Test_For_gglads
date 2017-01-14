//
//  ShowAllButton.swift
//  Test_for_gglads
//
//  Created by Denis on 06.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class ShowAllButton: UIButton
{
    private var animDidEnd = true
    
    
    
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
                self.setImage(UIImage(named: "arrowUp"), forState: .Normal)
            }
            else
            {
                self.setImage(UIImage(named: "arrowDown"), forState: .Normal)
            }
            layoutSubviews()
        }
    }
}


//MARK: BUTTON ANIMS
extension ShowAllButton
{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        //---------anim settings----------\\
        let scaleSize : CGFloat = 0.4
        let animDuration = 0.15
        //--------------------------------\\
        
        if animDidEnd
        {
            super.touchesBegan(touches, withEvent: event)
            
            animDidEnd = false
            
            UIView.animateWithDuration(animDuration, animations: {
                self.transform.a = scaleSize
                self.transform.d = scaleSize
                }, completion: { (hide) in
                    self.isSelect = true ? !self.isSelect : self.isSelect
                    
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
