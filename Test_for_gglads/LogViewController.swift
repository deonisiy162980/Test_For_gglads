//
//  LogViewController.swift
//  Lifium
//
//  Created by Denis on 27.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit

class LogViewController: UIViewController
{
    
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    @IBAction func deleteLog(sender: AnyObject)
    {
        LogManager.deleteLog()
        textView.text = ""
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        textView.text = LogManager.returnTextFromLog()
//        textView.scrollRangeToVisible(NSMakeRange(textView.text.characters.count - 1, 0))
//        let rect = CGPointMake(0, 40)
//        textView.setContentOffset(rect, animated: false)
    }
    
    
    @objc func didReciveNewLog()
    {
        textView.text = LogManager.returnTextFromLog()
    }
}
