//
//  ChartView.swift
//  SwiftKit
//
//  Created by SongWentong on 8/15/15.
//  Copyright (c) 2015 mike. All rights reserved.
//

import UIKit

 public protocol ChartViewDataSource:NSObjectProtocol
{
//    竖直的分割线条数
    func numberOfVerticalLinesInChartView(chartView: ChartView) -> Int // Default is 3
//    水平的分割线条数
    func numberOfHorizontalLinesInChartView(chartView: ChartView) -> Int // Default is 3
//    线条的条数
    func numberOfLinesInChartView(chartView:ChartView) -> Int // Default is 0
//    对应的数值
    func valuesOfchartView(chartView:ChartView, withIndex:Int) -> [Float]?
//    每条线的颜色
    func colorOfChartView(chartView:ChartView, withIndex:Int) -> UIColor?
    

    /*
    @available(iOS 2.0, *)
    optional public func numberOfSectionsInTableView(tableView: UITableView) -> Int // Default is 1 if not implemented
    
    @available(iOS 2.0, *)
    optional public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? // fixed font style. use custom view (UILabel) if you want something different
    @available(iOS 2.0, *)
    optional public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?
    

    */
    
}

public class ChartView: UIView {
//数据源
    var dataSource:ChartViewDataSource?
    var delegate:AnyObject?
//    y方向边界缩进
    var yInset:CGFloat!
//    x方向边界缩进
    var xInset:CGFloat!
//    线条宽度
    var lineWidth:CGFloat!
//    debug模式
    var debugMode:Bool!
//    拖动手势
    var panGesture:UIPanGestureRecognizer!
//    所放手势
    var pinchGesture:UIPinchGestureRecognizer!
//    最大显示数量
    var maxNumberOfValue:Int = 1000
//    最小显示数量
    var minNumberOfValue:Int = 15
//    当前显示数量
    var currentNumberOfValue:Int = 100
    


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
        lineWidth = 0.8;
        debugMode = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: "reciveGestureRecognizer:")
        pinchGesture = UIPinchGestureRecognizer(target: self, action: "reciveGestureRecognizer:")
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
    }
    
    
    func reciveGestureRecognizer(gesture:UIGestureRecognizer){

//        let classForCoder:AnyClass = gesture.classForCoder
        if(gesture.isKindOfClass(UIPanGestureRecognizer.classForCoder())){
            
            print("pan----")
        }
        
        
        if(gesture.isKindOfClass(UIPinchGestureRecognizer.classForCoder())){
            print("pin----")
        }
        
        
    
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
        
    }
    
    
    //    画外框
    func drawOuterFrame(path:UIBezierPath){
        path.removeAllPoints()
        let bounds = self.bounds
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        path.moveToPoint(CGPointMake(xInset, yInset))
        path.addLineToPoint(CGPointMake(xInset, height-yInset))
        path.addLineToPoint(CGPointMake(width-xInset, height-yInset))
        path.addLineToPoint(CGPointMake(width-xInset, yInset))
        path.addLineToPoint(CGPointMake(xInset, yInset))
        
        path.stroke()
        
    }
    
    //    画分隔线
    func drawSeparateLines(path:UIBezierPath){
        path.removeAllPoints()
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
        path.stroke()
    }
    
    //    画数据
    func drawDataLines(path:UIBezierPath){
        var numberOfLines = 0

            numberOfLines = self.dataSource!.numberOfLinesInChartView(self)

        
        
        
        
        for i in 0...numberOfLines-1{
            
            let values = self.dataSource?.valuesOfchartView(self, withIndex: i)
            
            
            
            let color = dataSource?.colorOfChartView(self, withIndex: i)
            color?.setStroke()
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
                
                
                
                
                
                let dValue = max - min
                
                path.removeAllPoints()
                
                
                
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
                
                path.stroke()
                
                
            }
           
        }
        
        
    }
    
}
