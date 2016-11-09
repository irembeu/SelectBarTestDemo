//
//  ViewController.swift
//  SelectBarTestDemo
//
//  Created by 劉光軍 on 2016/11/7.
//  Copyright © 2016年 劉光軍. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let strArr = ["迈克乔丹", "奥拉朱旺", "贾巴尔", "拉塞尔"]
    var labelBar: LGJLabelControlBar!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupBar()
        setupLabel()
        
    }
    fileprivate func setupBar() {
        let bar = LGJLabelControlBar(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 40))
        bar.backgroundColor = .white
        bar.setItemColor(color: .white)
        bar.setItemSelectedColor(color: .orange)
        bar.setSliderColor(color: .orange)
        bar.barItemSelected { (index: Int) in
            print("index clicked: \(index)")
            self.label.text = "点击了第\(index)项"
        }
        labelBar = bar
        self.view.addSubview(bar)
        
        //
        labelBar.setItemsTitle(itemTitles: strArr)
        labelBar.selectBarItem(index: 0)
    }
    
    fileprivate func setupLabel() -> Void {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 200)
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        
        self.view.addSubview(label)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

