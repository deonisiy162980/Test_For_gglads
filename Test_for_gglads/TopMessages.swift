//
//  TopMessages.swift
//  Lifium
//
//  Created by Denis on 10.10.16.
//  Copyright © 2016 Denis. All rights reserved.
//

import Foundation
import UIKit

class TopMessages
{
    class func showMessageTop( labelText : String , viewController : UIViewController, hasTopBar : Bool)
    {
        let errorLabel = UILabel()
        var ofensiveForTopAnchor : CGFloat
        var verticalConstraint : NSLayoutConstraint?
        
        //--------------------\\
        let animateDuration = 0.5
        let delay : Double = 3
        //--------------------\\
        
        //Функция  doAfterTime
        func doAfterTime( delay : Double, closure: ()->())
        {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64( delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(),
                closure
            )
        }
        //Функция авторазмера
        func heightForLabel( text : String, font : UIFont, width : CGFloat ) -> CGFloat
        {
            let label : UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = font
            label.text = text
            
            label.sizeToFit()
            return label.frame.height + 20
        }
        //Настройки отображения текста
        errorLabel.text = labelText
        errorLabel.textAlignment = .Center
        errorLabel.font = errorLabel.font.fontWithSize(25)
        errorLabel.backgroundColor = .lightGrayColor()
        errorLabel.textColor = .whiteColor()
        errorLabel.numberOfLines = 0
        //Добавление на view
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(errorLabel)
        //Настройка constrains
        let screenWidth = UIApplication.sharedApplication().delegate!.window!!.frame.size.width
        if hasTopBar
        {
            ofensiveForTopAnchor = 62
        }
        else
        {
            ofensiveForTopAnchor = 20
        }
        let autoHeight = heightForLabel(labelText, font: errorLabel.font, width: screenWidth)
        
        let horizontalConstraint = errorLabel.centerXAnchor.constraintEqualToAnchor(viewController.view.centerXAnchor)
        let heightConstraint = errorLabel.heightAnchor.constraintEqualToAnchor(nil, constant: autoHeight)
        let widthConstraint = errorLabel.widthAnchor.constraintEqualToAnchor(viewController.view.widthAnchor)
        
        NSLayoutConstraint.activateConstraints([horizontalConstraint, widthConstraint, heightConstraint])
        viewController.view.layoutIfNeeded()
        
        //Анимация появления
        UIView.animateWithDuration(animateDuration)
        {
            verticalConstraint = errorLabel.topAnchor.constraintEqualToAnchor(viewController.view.topAnchor, constant: ofensiveForTopAnchor)
            NSLayoutConstraint.activateConstraints([verticalConstraint!])
            
            viewController.view.layoutIfNeeded()
        }
        
        //Анимация уничтожения
        doAfterTime(delay) {
            UIView.animateWithDuration(animateDuration, animations:
                {
                    verticalConstraint?.constant = 0
                    viewController.view.layoutIfNeeded()
                    
                }, completion: { (nil) in
                    errorLabel.removeFromSuperview()
            })
        }
    }
    
    class func showMessageTop( labelText : String , viewController : UIViewController, hasTopBar : Bool, successBlock success : ()->Void )
    {
        let errorLabel = UILabel()
        var ofensiveForTopAnchor : CGFloat
        var verticalConstraint : NSLayoutConstraint?
        
        //--------------------\\
        let animateDuration = 0.5
        let delay : Double = 2.5
        //--------------------\\
        
        //Функция  doAfterTime
        func doAfterTime( delay : Double, closure: ()->())
        {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64( delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(),
                closure
            )
        }
        //Функция авторазмера
        func heightForLabel( text : String, font : UIFont, width : CGFloat ) -> CGFloat
        {
            let label : UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = font
            label.text = text
            
            label.sizeToFit()
            return label.frame.height + 20
        }
        //Настройки отображения текста
        errorLabel.text = labelText
        errorLabel.textAlignment = .Center
        errorLabel.font = errorLabel.font.fontWithSize(25)
        errorLabel.backgroundColor = .lightGrayColor()
        errorLabel.textColor = .whiteColor()
        errorLabel.numberOfLines = 0
        //Добавление на view
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(errorLabel)
        //Настройка constrains
        let screenWidth = UIApplication.sharedApplication().delegate!.window!!.frame.size.width
        if hasTopBar
        {
            ofensiveForTopAnchor = 62
        }
        else
        {
            ofensiveForTopAnchor = 0
        }
        let autoHeight = heightForLabel(labelText, font: errorLabel.font, width: screenWidth)
        
        let horizontalConstraint = errorLabel.centerXAnchor.constraintEqualToAnchor(viewController.view.centerXAnchor)
        let heightConstraint = errorLabel.heightAnchor.constraintEqualToAnchor(nil, constant: autoHeight)
        let widthConstraint = errorLabel.widthAnchor.constraintEqualToAnchor(viewController.view.widthAnchor)
        verticalConstraint = errorLabel.topAnchor.constraintEqualToAnchor(viewController.view.topAnchor, constant: ofensiveForTopAnchor - autoHeight)
        
        NSLayoutConstraint.activateConstraints([horizontalConstraint, widthConstraint, heightConstraint, verticalConstraint!])
        viewController.view.layoutIfNeeded()
        
        //Анимация появления
        UIView.animateWithDuration(animateDuration)
        {
            verticalConstraint?.constant = ofensiveForTopAnchor
            
            viewController.view.layoutIfNeeded()
        }
        
        //Анимация уничтожения
        doAfterTime(delay) {
            UIView.animateWithDuration(animateDuration, animations:
                {
                    verticalConstraint?.constant = ofensiveForTopAnchor - autoHeight
                    viewController.view.layoutIfNeeded()
                    
                }, completion: { (nil) in
                    errorLabel.removeFromSuperview()
                    success()
            })
        }
    }
}