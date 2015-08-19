//
//  ChartViewController.swift
//  SwiftKit
//
//  Created by SongWentong on 8/15/15.
//  Copyright (c) 2015 QuantGroup. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController,ChartViewDataSource {
    
    @IBOutlet weak var chartView: ChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.dataSource = self
        self.view.addSubview(chartView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator){
        coordinator.animateAlongsideTransitionInView(self.chartView, animation: { (context) -> Void in
            
            self.chartView.frame = self.view.bounds;
            
            
            }) { (context) -> Void in
                
                
                
                if(context.isAnimated() == true){
                    self.chartView.setNeedsDisplay();
                }else{
                    print("not animated")
                }
                
        }
        
    }
    
    func numberOfVerticalLinesInChartView(chartView: ChartView) -> Int {return 0}
    func numberOfHorizontalLinesInChartView(chartView: ChartView) -> Int {return 0}
    func numberOfLinesInChartView(chartView:ChartView) -> Int {
        return 3
    }
    func colorOfChartView(chartView:ChartView, withIndex:Int) -> UIColor?{
//        var color:UIColor
        var colors = Array<UIColor>()
        colors.append(UIColor.blackColor())
        colors.append(UIColor.greenColor())
        colors.append(UIColor.blueColor())
        
        return colors[withIndex]
        
    }
    
    func valuesOfchartView(chartView:ChartView, withIndex index:Int) -> [Float]?{
        var values = [Float]()
        
        
        for _ in 0...49{
            var value = Float(rand()%50)
            value = value * Float(index+1)
            values.append(value)
//            values.append(1)
            print(value)
        }
        //        values.append(-100)
        //        values.append(-20)
        
        return values
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
