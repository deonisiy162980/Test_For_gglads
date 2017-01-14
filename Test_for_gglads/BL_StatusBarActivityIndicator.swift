//
//  BL_StatusBarActivityIndicator.swift
//  DateUp
//
//  Created by Nikita Pronchik on 22.06.15.
//  Copyright (c) 2015 Beet Lab. All rights reserved.
//

import UIKit

var pred : dispatch_once_t = 0 ;
var singletonInstance : BL_StatusBarActivityIndicator?


class BL_StatusBarActivityIndicator: NSObject
{
    var indicatorCounter : Int = 0
    
    static func defaultIndicator() -> BL_StatusBarActivityIndicator
    {
        dispatch_once( &pred ) {
            
            singletonInstance = BL_StatusBarActivityIndicator ()
        }
        
        return singletonInstance!
    }
    
    func fireUpIndicator () -> Void
    {
        objc_sync_enter(self)
        self.indicatorCounter += 1
        objc_sync_exit(self)
        updateIndicator()
    }
    
    func switchOffIndicator () -> Void
    {
        objc_sync_enter ( self )
        if ( self.indicatorCounter > 0 )
        {
            self.indicatorCounter -= 1
        }
        objc_sync_exit(self)
        updateIndicator()
    }
    
    func removeIndicator () -> Void
    {
        dispatch_async ( dispatch_get_main_queue())
        {
            self.indicatorCounter = 0
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    private func updateIndicator() -> Void
    {
        dispatch_async ( dispatch_get_main_queue())
        {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = self.indicatorCounter > 0
        }
        
    }
   
}
