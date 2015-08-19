//
//  ChartView.swift
//  SwiftKit
//
//  Created by SongWentong on 8/15/15.
//  Copyright (c) 2015 QuantGroup. All rights reserved.
//

import UIKit

protocol ChartViewDataSource:NSObjectProtocol
{
//    竖直的分割线条数
    func numberOfVerticalLinesInChartView(chartView: ChartView) -> Int // Default is 3
//    水平的分割线条数
    func numberOfHorizontalLinesInChartView(chartView: ChartView) -> Int // Default is 3
//    线条的条数
    func numberOfLinesInChartView(chartView:ChartView) -> Int // Default is 0
//    对应的竖直
    func valuesOfchartView(chartView:ChartView, withIndex:Int) -> [Float]?
    
    
    
}

public class ChartView: UIView {
    
    var dataSource:ChartViewDataSource?
    var delegate:AnyObject?
    var yInset:CGFloat!
    var xInset:CGFloat!
    var lineWidth:CGFloat!
    var debugMode:Bool!
    var panGesture:UIPanGestureRecognizer!
    var pinchGesture:UIPinchGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame:CGRect())
        self.frame = frame;
        
        
        configModel()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configModel()
    }
    
    
    public func reloadData(){
        
    }
    
    
    
    func configModel(){
        self.backgroundColor = UIColor.yellowColor()
        yInset = 10;
        xInset = 15;
        lineWidth = 0.5;
        debugMode = true
    }
    
    
    /*
    
    
    分割线
    v
    +-----------------------------------------------+
    |           |           |           |           |
    |           |           |           |           |
    |___________|___________|___________|___________|
    |           |        ___|_          |           |
    |           |     __/   | `-a       |           |
    |___________|____/______|___________|___________|
    |           |  _/       |           |           |
    |     _     |_/         |           |           |
    |____/_\___/|___________|___________|___________|
    |  _/   \_/ |           |           |           |
    | /         |           |           |           |
    |/          |           |           |           |
    +-----------------------------------------------+
    ^
    边界
    
    
    a:k线
    
    
    
    */
    override public func drawRect(rect: CGRect) {
        if(debugMode==true){
            print("drawRect")
        }
        let path = UIBezierPath()
        
        UIColor.redColor().setFill()
        UIColor.redColor().setStroke()
        path.lineWidth = lineWidth
        drawOuterFrame(path)
        drawSeparateLines(path);
        drawDataLines(path)
        path.stroke()
    }
    
    
    //    画外框
    func drawOuterFrame(path:UIBezierPath){
        let bounds = self.bounds
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        path.moveToPoint(CGPointMake(xInset, yInset))
        path.addLineToPoint(CGPointMake(xInset, height-yInset))
        path.addLineToPoint(CGPointMake(width-xInset, height-yInset))
        path.addLineToPoint(CGPointMake(width-xInset, yInset))
        path.addLineToPoint(CGPointMake(xInset, yInset))
        
        
        
    }
    
    //    画分隔线
    func drawSeparateLines(path:UIBezierPath){
        //        水平方向的分割线条数
        var h:Int = 4
        //        竖直方向的分割线条数
        var v:Int = 4
        
        
        //        var t = UITableView()
        //        t.dataSource?.numberOfSectionsInTableView!(t)
        if(dataSource?.respondsToSelector("numberOfVerticalLinesInChartView")==true){
            h = dataSource!.numberOfHorizontalLinesInChartView(self)
        }
        if(dataSource?.respondsToSelector("")==true){
            v = dataSource!.numberOfVerticalLinesInChartView(self)
        }
        
        
        //        竖线的步幅
        var verticalStride:CGFloat
        //      横线的步幅
        var horizontalStride:CGFloat
        
        let insetRect:CGRect = CGRectInset(self.bounds, xInset, yInset)
        let insetHeight = CGRectGetHeight(insetRect)
        let insetWidth = CGRectGetWidth(insetRect)
        
        verticalStride = CGFloat(insetWidth)/CGFloat(v+1)
        horizontalStride = CGFloat(insetHeight)/CGFloat(h+1)
        
        
        
        //        竖线
        for i in 0...v {
            
            let x = CGFloat(verticalStride * CGFloat(i+1)) + CGFloat(xInset)
            let p1 = CGPoint(x: x, y: yInset)
            let p2 = CGPoint(x: x, y: yInset+insetHeight)
            path.moveToPoint(p1)
            path.addLineToPoint(p2)
            
            
            
        }
        
        //        横线
        for i in 0...h{
            
            let y = CGFloat(horizontalStride * CGFloat(i+1)) + CGFloat(yInset)
            let p1 = CGPoint(x: xInset, y: y)
            let p2 = CGPoint(x: xInset + insetWidth, y: y )
            path.moveToPoint(p1)
            path.addLineToPoint(p2)
        }
        
    }
    
    //    画数据
    func drawDataLines(path:UIBezierPath){
        var numberOfLines = 0
        if(self.dataSource?.respondsToSelector("numberOfLinesInChartView")==true){
            numberOfLines = self.dataSource!.numberOfLinesInChartView(self)
        }
        
        
        
        
        for i in 0...numberOfLines{
            let values = self.dataSource?.valuesOfchartView(self, withIndex: i)
            
            
            
            
            if let valueArray = values {
                var max:Float = 0
                var min:Float = 0;
                let count = valueArray.count
                let localYInset = yInset + 50
                let insetRect:CGRect = CGRectInset(self.bounds, xInset, localYInset)
                let xStride = CGRectGetWidth(insetRect)/CGFloat(count-1)
                
                
                if (count>0){
                    min = valueArray[0]
                }
                
                //                遍历去的最大值和最小值
                for value in valueArray {
                    if(value > max)
                    {
                        max = value
                    }
                    if(value < min){
                        min = value
                    }
                }
                
                
                if(max>0){
                    //                    max = 1.1*max
                }else{
                    //                    max = 0.9*max
                }
                
                
                if(min>0){
                    //                    min = 0.9*min
                }else{
                    //                    min = 1.1*min
                }
                
                
                
                
                
                
                let dValue = max - min
                
                
                //                遍历画出所有的数据
                for i in 0...count-1 {
                    var point:CGPoint
                    
                    var percent:CGFloat = CGFloat(valueArray[i] - min)/CGFloat(dValue)
//                    如果数值没有发生变化,所有的percent设置成0.5
                    if(dValue == 0){
                        percent = 0.5
                    }
                    //                    println(percent)
                    let x = CGFloat(xInset) + (CGFloat(xStride)*CGFloat(i))
                    
                    
                    
                    
                    let y = localYInset + (1-percent) * CGRectGetHeight(insetRect)
                    
                    
                    
                    point = CGPoint(x: x, y: y)
                    
                    
                    if(i==0){
                        path.moveToPoint(point)
                        //                        path.lineWidth = 2;
                        path.lineCapStyle = CGLineCap.Round
                    }else{
                        path.addLineToPoint(point)
                    }
                }
                
                
            }
        }
    }
}
