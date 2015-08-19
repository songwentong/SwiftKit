//
//  TestDraw.swift
//  SwiftKit
//
//  Created by SongWentong on 8/19/15.
//  Copyright © 2015 QuantGroup. All rights reserved.
//

import UIKit

class TestDraw: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        
        let path = UIBezierPath()
        path.lineWidth = 1
        
        
        let p1 = UIBezierPath()
        let p2 = UIBezierPath()
        UIColor.redColor().setStroke()
        p1.moveToPoint(CGPoint(x: 0, y: 0))
        p1.addLineToPoint(CGPoint(x: 100, y: 100))
        p1.closePath()
        path.appendPath(p1)
        
        
        
        UIColor.yellowColor().setStroke()
        p2.moveToPoint(CGPoint(x: 100, y: 0))
        p2.addLineToPoint(CGPoint(x: 0, y: 100))
        p2.closePath()
        path.appendPath(p2)
        path.closePath()
        path.stroke()
    }


}
