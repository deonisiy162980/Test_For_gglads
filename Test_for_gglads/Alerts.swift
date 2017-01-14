//
//  Alerts.swift
//  Lifium
//
//  Created by Denis on 20.09.16.
//  Copyright © 2016 Denis. All rights reserved.
//

import Foundation
import UIKit

// Создает и уничтожает окно загрузки


class Alert
{
    static let instance = Alert()
    var alert : (containerView : UIView?, backgroundColor : UIView?, loadingIndicator : UIActivityIndicatorView?)?
    
    func showLoadingAlert( atView view : UIView, withNavigationController navController : UINavigationController?)
    {
        if alert == nil
        {
            let alertSize = UIApplication.sharedApplication().delegate!.window!!.frame.size.width/3
            
            let backgroundColor = UIView(frame: CGRectMake(0, 0, UIApplication.sharedApplication().delegate!.window!!.frame.size.width, UIApplication.sharedApplication().delegate!.window!!.frame.size.height))
            backgroundColor.backgroundColor = .blackColor()
            backgroundColor.alpha = 0.5
            
            let containerView = UIView(frame: CGRectMake(0, 0, alertSize, alertSize))
            if !navController!.navigationBar.translucent
            {
                let navBarHeight = navController!.navigationBar.frame.height
                containerView.center.x = view.center.x
                containerView.center.y = view.center.y - navBarHeight * 2 - 22
            }
            else
            {
                containerView.center = view.center
            }
            containerView.backgroundColor = .grayColor()
            containerView.alpha = 1.0
            containerView.layer.cornerRadius = 15.0
            
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 37, 37))
            loadingIndicator.center = containerView.center
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = .White
            loadingIndicator.startAnimating()
            
            UIView.animateWithDuration(0.2) {
                view.addSubview(containerView)
                view.addSubview(backgroundColor)
                view.addSubview(loadingIndicator)
            }
            
            self.alert = (containerView, backgroundColor, loadingIndicator)
        }
        else
        {
            return
        }
    }
    
    func closeLoadingAlert()
    {
        if let alertForRemove = self.alert
        {
            UIView.animateWithDuration(0.2, animations: {
                alertForRemove.containerView!.alpha = 0.0
                alertForRemove.backgroundColor!.alpha = 0.0
            }) { (hide) in
                alertForRemove.containerView!.removeFromSuperview()
                alertForRemove.backgroundColor!.removeFromSuperview()
                alertForRemove.loadingIndicator!.removeFromSuperview()
            }
        }
        else
        {
            return
        }
    }
}