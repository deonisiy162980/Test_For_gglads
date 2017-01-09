//
//  DetailViewController.swift
//  Test_for_gglads
//
//  Created by Denis on 10.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController
{
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productText: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    var productModel : Product?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        productImage.sd_setImageWithURL(NSURL(string: (productModel?.productImage)!))
        productText.text = productModel?.productText
        productName.text = productModel?.productName
    }
    
    
    @IBAction func getItTapped(sender: AnyObject)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: productModel!.redirectURL!)!)
    }
}
