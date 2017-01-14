//
//  LaunchViewController.swift
//  Test_for_gglads
//
//  Created by Denis on 13.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import CoreData

class LaunchViewController: UIViewController
{
    
    @IBOutlet weak var labelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var dataSource = [Product]()
    var categories = [Category]()
    var needCleanData = false
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if Product.loadToSwiftArray().count != 0
        {
            if let lastUpdateDate = NSUserDefaults.standardUserDefaults().objectForKey(Const.AppUserDefaults.kLastUpdateDate) as? String
            {
                if lastUpdateDate == NSDate().dateToString()
                {
                    categories.appendContentsOf(Category.loadToSwiftArray())
                    dataSource.appendContentsOf(Product.loadToSwiftArray(withCategory: categories.first!))
                    playAnimAndPerformSegue()
                }
                else
                {
                    needCleanData = true
                    playAnimAndPerformSegue()
                }
            }
            else
            {
                playAnimAndPerformSegue()
            }
        }
        else
        {
            playAnimAndPerformSegue()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toMain"
        {
            if dataSource.count != 0 && categories.count != 0
            {
                let navVC = segue.destinationViewController as! UINavigationController
                let destinationViewController = navVC.viewControllers.first as! ProductViewController
                
                destinationViewController.dataSource = self.dataSource
                destinationViewController.categories = self.categories
                destinationViewController.checkedCategory = self.categories.first
                destinationViewController.needToCleanDateWithFirstResponse = needCleanData
            }
        }
        
    }
    
    
    func playAnimAndPerformSegue()
    {
        self.imageCenterXConstraint.constant += 20
        UIView.animateWithDuration(0.25, delay: 0.0, options: [.CurveEaseOut], animations: {
            self.view.layoutIfNeeded()
            }) { (compl) in
                self.imageCenterXConstraint.constant -= 20 + (self.view.frame.width / 2) + self.logoImage.frame.width / 2
                UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseIn], animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
        }
        
        self.labelCenterXConstraint.constant += 20
        UIView.animateWithDuration(0.25, delay: 0.2, options: [.CurveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }) { (compl) in
            self.labelCenterXConstraint.constant -= 20 + (self.view.frame.width / 2) + self.label.frame.width / 2
            UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseIn], animations: {
                self.view.layoutIfNeeded()
                }, completion: { (compl) in
                    self.performSegueWithIdentifier("toMain", sender: self)
            })
        }
    }
}
