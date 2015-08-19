//
//  ChartViewController.swift
//  SwiftKit
//
//  Created by SongWentong on 8/15/15.
//  Copyright (c) 2015 QuantGroup. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController,ChartViewDataSource {

    var c:ChartView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        c = ChartView(frame: self.view.bounds)
        c.dataSource = self
        self.view.addSubview(c)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator){
        coordinator.animateAlongsideTransitionInView(c, animation: { (context) -> Void in
            self.c.frame = self.view.bounds;
            }) { (context) -> Void in
                if(context.isAnimated() == true){
                    self.c.setNeedsDisplay();
                }else{
                    print("not animated")
                }
                
        }
    }
    
    func numberOfVerticalLinesInChartView(chartView: ChartView) -> Int {return 0}
    func numberOfHorizontalLinesInChartView(chartView: ChartView) -> Int {return 0}
    func numberOfLinesInChartView(chartView:ChartView) -> Int {return 3}
    func valuesOfchartView(chartView:ChartView, withIndex index:Int) -> [Float]?{
        var values = [Float]()
        
        
        for _ in 0...150{
            var value = Float(rand()%50)
            value = value * Float(index)
            values.append(value)
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
