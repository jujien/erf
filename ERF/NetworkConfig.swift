//
//  NetworkConfig.swift
//  ERF
//
//  Created by Do Duong on 7/31/16.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import AFNetworking



class NetworkConfig: NSObject {
    var socket : SocketIOClient!
    
    let url = NSURL(string: urlClasses)!
    
    let urlSocketIO = NSURL(string :"https://dataforiliat.herokuapp.com")!
    
    let manager = AFHTTPRequestSerializer()
    
    static let shareInstance = NetworkConfig()
    
    
    
    func postDataToURL(postParams :[String: AnyObject]) -> Void {
        
        // Setup the session to make REST POST call
        
        let session = NSURLSession.sharedSession()
//        let postParams : [String: AnyObject] = ["name": "Hello POST world"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch let error {
            print("\(error)")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
                
            }
            
        }).resume()
    }
    
    func socketTakePush(callback: ([AnyObject]) -> Void) -> Void {
        socket = SocketIOClient(socketURL: urlSocketIO)
        socket.connect()
        //        socket.on("user-connected") { (data, ack) in
        //            print("socket test ")
        //        }
        socket.on("notiWithName") { (data, ack) in
            // ham push o day , data la ten instructor moi
            callback(data)
        }
    }
    
    
    func socketServerEvent(data : String) -> Void {
        socket = SocketIOClient(socketURL: urlSocketIO)
        socket.connect()
        
        // data la name cua new instructor
        
        socket.emit("notification", data)
    }
    
    
    
    func getSocketNoti() -> Void {
        socket = SocketIOClient(socketURL: urlSocketIO)
        socket.connect()
        socket.on("user-connected") { (data, ack) in
            print("socket test ")
        }
    }
}
