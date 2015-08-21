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
//    柱状图颜色
    

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
    
    
    
    var histogramViews:[UIView]?
    
//    处理数据
    func configModel(){
        histogramViews = [UIView]()
    }
    
    
    public func reloadData(){
        for view in histogramViews!{
            view.removeFromSuperview()
        }
        
        
    }
    
    
    
    
    
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override public func drawRect(rect: CGRect) {
        // Drawing code
        
//    }
    

}
