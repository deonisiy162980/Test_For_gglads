//
//  TitleButton.swift
//  Test_for_gglads
//
//  Created by Denis on 09.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class TitleButton: UIButton
{
    private var animDidEnd = true
    private var image = UIImage(named: "arrowDownTitle")
    var delegate : TitleButtonDelegate?
    var titleColor = UIColor.blackColor()
    
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
                image = UIImage(named: "arrowUpTitle")?.imageWithRenderingMode(.AlwaysTemplate)
                self.tintColor = titleColor
                self.setImage(image, forState: .Normal)
                self.delegate?.openCategories()
            }
            else
            {
                image = UIImage(named: "arrowDownTitle")?.imageWithRenderingMode(.AlwaysTemplate)
                self.tintColor = titleColor
                self.setImage(image, forState: .Normal)
                self.delegate?.closeCategories()
            }
            layoutSubviews()
        }
    }
}


//MARK: BUTTON ANIMS
extension TitleButton
{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        //---------anim settings----------\\
        let scaleSize : CGFloat = 1.05
        let animDuration = 0.07
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


//MARK: BUTTONS FUNCTONS
extension TitleButton
{
    override func setTitle(title: String?, forState state: UIControlState)
    {
        super.setTitle(title, forState: state)
                
        self.setTitleColor(.blackColor(), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "Arial", size: 22)
        
        self.setImage(image, forState: .Normal)
        self.frame = CGRectMake(0, 0, self.intrinsicContentSize().width + image!.size.width + 30, self.intrinsicContentSize().height)
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, image!.size.width);
        self.imageEdgeInsets = UIEdgeInsetsMake(4.2, self.frame.size.width + (image!.size.width) - 35, 0.0, 0.0)
    }
    
    
    func setTitle(withHexColor hex : String, withTitle title : String?, forState state : UIControlState)
    {
        super.setTitle(title, forState: state)
        
        titleColor = UIColor(rgba: hex)
        self.setTitleColor(titleColor, forState: .Normal)
        self.titleLabel?.font = UIFont(name: "Arial", size: 22)
        
        let coloredImage = UIImageView()
        coloredImage.image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.tintColor = titleColor
        
        self.setImage(coloredImage.image, forState: .Normal)
        self.frame = CGRectMake(0, 0, self.intrinsicContentSize().width + image!.size.width + 30, self.intrinsicContentSize().height)
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, image!.size.width);
        self.imageEdgeInsets = UIEdgeInsetsMake(4.2, self.frame.size.width + (image!.size.width) - 35, 0.0, 0.0)
        
        self.layoutIfNeeded()
    }
}