//
//  ChatModel.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 6..
//  Copyright © 2018년 admin2. All rights reserved.
//

import ObjectMapper

class ChatModel: Mappable {
    
    
    
    public var users: Dictionary<String,Bool> = [:] //people info
    public var comments : Dictionary<String,Comment> = [:]  // blabla
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    
    public class Comment:Mappable{
        public func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
        }
        
        public var uid: String?
        public var message: String?
        
        public required init?(map: Map) {
        
        }
    }
}
