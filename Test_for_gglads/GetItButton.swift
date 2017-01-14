//
//  GetItButton.swift
//  Test_for_gglads
//
//  Created by Denis on 13.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class GetItButton: UIButton
{
    private var animDidEnd = true
    private var image = UIImageView()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
}


//MARK: BUTTON ANIMS
extension GetItButton
{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        //---------anim settings----------\\
        let scaleSize : CGFloat = 1.15
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
