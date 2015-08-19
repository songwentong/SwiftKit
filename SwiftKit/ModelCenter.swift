//
//  ModelCenter.swift
//  SwiftKit
//
//  Created by SongWentong on 8/19/15.
//  Copyright © 2015 QuantGroup. All rights reserved.
//

import UIKit

public class ModelCenter: NSObject {
    public static let sharedInstance: ModelCenter = {
        return ModelCenter()
        }()
    
    var userName:String
    var userPwd:String
    
    
    override init() {
        userName = ""
        userPwd = ""
        
        super.init()
    }
}
