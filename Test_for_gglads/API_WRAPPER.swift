//
//  API_WRAPPER.swift
//  ACVK
//
//  Created by Denis on 26.06.16.
//  Copyright © 2016 Denis. All rights reserved.
//

import Foundation

class httpMethods
{
    static let get = "GET"
    static let post = "POST"
    static let delete = "DELETE"
}

//MARK: создание запроса
class API_WRAPPER
{
    private class func composeGenericHTTPRequest(withHTTPMethod httpMethod : String, withArguments arguments : NSDictionary, forBaseURL url : String ) -> NSURLRequest
    {
        var urlString = url + "?"
        let keysArray = arguments.allKeys
        
        for key in keysArray {
            let value = arguments[String(key)]
            
            if (key as! String == keysArray.last as! String) {
                urlString.appendContentsOf("\(String(key))=\(value!)")
            } else {
                urlString.appendContentsOf("\(String(key))=\(value!)&")
            }
        }
        
        
        let request = NSMutableURLRequest()
        request.HTTPMethod = httpMethod
        request.URL = NSURL(string: urlString)
        
//        print(request)
        BL_StatusBarActivityIndicator.defaultIndicator().fireUpIndicator()
        
        return request
    }
}

//MARK: Общий обработчик ответа
extension API_WRAPPER
{
    private class func generalCompletionCallback ( data : NSData?, response : NSURLResponse?, error : NSError?, succes : (JsonResponse : JSON) -> Void, failureBlock : ( errorCode : Int) -> Void)
    {
        BL_StatusBarActivityIndicator.defaultIndicator().switchOffIndicator()
        
        if (error?.code == -1009) { //no internet
            failureBlock(errorCode: 0)
            return
        }
        
        if (error?.code == -1001) { //timeout
            failureBlock(errorCode: 1)
            return
        }
        
        if (data != nil) {
            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let result = JSON(json)
                
                if (result != nil) {
//                    print(result)
                    succes(JsonResponse: result)
                }
            }
            catch
            {
                failureBlock(errorCode: 1)
            }
        } else {
            failureBlock(errorCode: 1)
        }
    }
}

//MARK: Получение списка продуктов
extension API_WRAPPER
{
    class func getProductList ( success : (JsonResponse : JSON) -> Void, failure : (errorCode : Int) -> Void ) -> NSURLSessionDataTask
    {
        let argsDictionary = NSMutableDictionary()
        
        argsDictionary.setObject(Const.AppApiConst.kAccessToken, forKey: Const.AppApiAttributes.kAccessToken)
        argsDictionary.setObject("0", forKey: Const.AppApiAttributes.kDay)
        argsDictionary.setObject("0", forKey: Const.AppApiAttributes.kDays_ago)
        
        let request = composeGenericHTTPRequest(withHTTPMethod: httpMethods.get, withArguments: argsDictionary, forBaseURL: Const.AppApiConst.kBaseMethod + Const.AppApiConst.kGetPosts)
        
        let timeOutError = DPClass.dispatchAfter(8) {
            generalCompletionCallback(nil, response: nil, error: NSError(domain: "d", code: -1001, userInfo: nil), succes: success, failureBlock: failure)
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            DPClass.cancel_dispatch_after(timeOutError)
            generalCompletionCallback(data, response: response, error: error, succes: success, failureBlock: failure)
        }
        
        task.resume()
        return task
    }
}


//MARK: Получение списка категорий
extension API_WRAPPER
{
    class func getCategoriesList ( success : (JsonResponse : JSON) -> Void, failure : (errorCode : Int) -> Void ) -> NSURLSessionDataTask
    {
        let argsDictionary = NSMutableDictionary()
        
        argsDictionary.setObject(Const.AppApiConst.kAccessToken, forKey: Const.AppApiAttributes.kAccessToken)
        
        let request = composeGenericHTTPRequest(withHTTPMethod: httpMethods.get, withArguments: argsDictionary, forBaseURL: Const.AppApiConst.kBaseMethod + Const.AppApiConst.kGetCategories)
        
                let timeOutError = DPClass.dispatchAfter(8) {
                    generalCompletionCallback(nil, response: nil, error: NSError(domain: "d", code: -1001, userInfo: nil), succes: success, failureBlock: failure)
                    return
                }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            DPClass.cancel_dispatch_after(timeOutError)
            generalCompletionCallback(data, response: response, error: error, succes: success, failureBlock: failure)
        }
        
        task.resume()
        return task
    }
}


//MARK: LIKE PRODUCT (not works with this access token)
extension API_WRAPPER
{
    class func likeProduct ( withId id : String, success : (JsonResponse : JSON) -> Void, failure : (errorCode : Int) -> Void ) -> NSURLSessionDataTask
    {
        let argsDictionary = NSMutableDictionary()
        
        argsDictionary.setObject(Const.AppApiConst.kAccessToken, forKey: Const.AppApiAttributes.kAccessToken)
        argsDictionary.setObject(id, forKey: Const.AppApiAttributes.kPostId)
        
        
        let request = composeGenericHTTPRequest(withHTTPMethod: httpMethods.post, withArguments: argsDictionary, forBaseURL: Const.AppApiConst.kBaseMethod + Const.AppApiConst.kLikeProdyct)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            generalCompletionCallback(data, response: response, error: error, succes: success, failureBlock: failure)
        }
        
        task.resume()
        return task
    }
}
