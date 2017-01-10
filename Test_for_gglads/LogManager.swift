//
//  LogManager.swift
//  Lifium
//
//  Created by Denis on 27.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

import Foundation

class LogManager
{
    private static let logName = "gglads_test.txt"
    
    class func addStringToLog( withText text : String )
    {
        print(text)
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let textWithTS = "\(text) || \(timestamp)\n\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let dir : NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask).last! as NSURL
        let fileURL =  dir.URLByAppendingPathComponent(logName)
        
//        print(fileURL)
        
        if NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)
        {
            do
            {
                let fileAvailability = try NSFileHandle(forWritingToURL: fileURL)
                fileAvailability.seekToEndOfFile()
                fileAvailability.writeData(textWithTS)
                fileAvailability.closeFile()
            }
            catch { print("Cannot append new string to log file") }
        }
        else
        {
            do
            {
                try textWithTS.writeToURL(fileURL, options: .DataWritingWithoutOverwriting)
            }
            catch { print("Cannot create log file") }
        }
    }
    
    
    class func returnTextFromLog() -> String
    {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(logName)
            
            do
            {
                let text = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                return text as String
            }
            catch {/* error handling here */}
        }
        
        return ""
    }
    
    
    class func deleteLog()
    {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(logName)
            
//            getDateOfCreatingLog()
            do
            {
                try NSFileManager.defaultManager().removeItemAtURL(path)
            }
            catch {print("Cannot delete log")}
        }
    }
    
    
    private class func getDateOfCreatingLog()
    {
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        let path = NSURL(fileURLWithPath: dir!).URLByAppendingPathComponent(logName)
        let fileManager = NSFileManager.defaultManager()
        
        do
        {
            let attributes = try fileManager.attributesOfItemAtPath(path.absoluteString)
            
            print(attributes)
        }
        catch {print("Cannot get attributes of log")}
    }
}