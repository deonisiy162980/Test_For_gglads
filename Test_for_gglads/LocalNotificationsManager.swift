//
//  LocalNotificationsManager.swift
//  Test_for_gglads
//
//  Created by Denis on 10.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import UIKit


class LocalNotificationsManager
{
    class func sendNotification( withTitle title : String, withBody body : String )
    {
        let notification = UILocalNotification()
        notification.alertTitle = title
        notification.alertBody = body
        notification.alertAction = "Посмотреть!"
//        notification.fireDate = NSDate(timeIntervalSinceNow: 3)
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}