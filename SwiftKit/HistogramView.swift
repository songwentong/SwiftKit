//
//  HistogramView.swift
//  SwiftKit
//
//  Created by SongWentong on 8/21/15.
//  Copyright © 2015 swt. All rights reserved.
//

import UIKit


/*!
    数据源
*/
protocol HistogramViewDataSource:NSObjectProtocol{
//    柱状图数量
    func numberOfHistogramInHistogram(his:HistogramView)->Int
//    柱状图数值
    func histogramView(his:HistogramView , valueOfIndex:Int)->Float
//    柱状图颜色
    func histogramView(his:HistogramView , colorOfIndex:Int)->UIColor
    

}

/*!
    柱状图
*/
public class HistogramView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configModel()
    }
    
    
    var datasource:HistogramViewDataSource?
    var histogramViews:[UIView]?
    
//    处理数据
    func configModel(){
        histogramViews = [UIView]()
    }
    
    
    public func reloadData(){
        for view in histogramViews!{
            view.removeFromSuperview()
        }
//        得到柱形图数量
        let count = self.datasource?.numberOfHistogramInHistogram(self)
//        遍历数值
        for i in 0...count!-1{
            let value = self.datasource?.histogramView(self, valueOfIndex: i)
            let view = UIView()
            
//            获取颜色
            view.backgroundColor = self.datasource?.histogramView(self, colorOfIndex: i)
            
            histogramViews?.append(view)
            
            print(value)
        }
        
    }
    
    
    
    
    
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override public func drawRect(rect: CGRect) {
        // Drawing code
        
//    }
    

}
