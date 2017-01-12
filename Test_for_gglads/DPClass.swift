//
//  DPClass.swift
//  Test_for_gglads
//
//  Created by Denis on 12.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//
import Foundation

class DPClass
{
    typealias cancellable_closure = (() -> ())?
    
    class func dispatchAfter(seconds:Double, queue: dispatch_queue_t = dispatch_get_main_queue(), closure:()->()) -> cancellable_closure
    {
        var cancelled = false
        let cancel_closure: cancellable_closure = {
            cancelled = true
        }
        
        dispatch_after ( dispatch_time(DISPATCH_TIME_NOW, Int64( seconds * Double(NSEC_PER_SEC))), queue, {
            if !cancelled {
                closure()
            }
        })
        
        return cancel_closure
    }
    
    class func cancel_dispatch_after(cancel_closure: cancellable_closure) {
        cancel_closure?()
    }
}