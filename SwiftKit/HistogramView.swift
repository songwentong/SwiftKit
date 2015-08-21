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
    func numberOfHistogramInHistogram(his:HistogramView)->Int
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
    
//    处理数据
    func configModel(){
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        
    }
    

}
