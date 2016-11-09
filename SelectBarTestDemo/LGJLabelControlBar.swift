//
//  LGJLabelControlBar.swift
//  SelectBarTestDemo
//
//  Created by 劉光軍 on 2016/11/7.
//  Copyright © 2016年 劉光軍. All rights reserved.
//

import UIKit

typealias LGJLabelControlBarItemSelectedCallback = (_ index: Int) -> Void

let DEFAULT_SLIDER_COLOR = UIColor.orange
let SLIDER_VIEW_HEIGHT: CGFloat = 2


class LGJLabelControlBar: UIView, LGJLabelControlBarItemDelegate {
    var itemsTitle: [String]!
    var itemColor: UIColor!
    var sliderView: UIView!
    var itemSelectedColor: UIColor!
    var sliderColor: UIColor!
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var items: [LGJLabelControlBarItem]!
    fileprivate var selectedItem: LGJLabelControlBarItem! {
        willSet(newValue) {
            if selectedItem != nil {
                selectedItem.selected = false
            }
        }
        didSet {
            selectedItem.selected = true
        }
    }
    fileprivate var callback: LGJLabelControlBarItemSelectedCallback!
    
    // MARK: - lifecicle
    override init(frame: CGRect) {
        super.init(frame: frame)
        items = [LGJLabelControlBarItem]()
        setupScrollView()
        setupSliderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func barItemSelected(closure: @escaping LGJLabelControlBarItemSelectedCallback) -> Void {
        callback = closure
    }
    
    func selectBarItem(index: Int) -> Void {
        let item = items[index]
        if item == selectedItem {
            return
        }
        item.selected = true
        scrollToVisibleItem(item: item)
        addAnimationOnSelectedItem(item: item)
        selectedItem = item
    }
    
    
    // MARK: - Custom Accessors
    func setItemsTitle(itemTitles: [String]) {
        itemsTitle = itemTitles
        setupItems()
    }
    
    func setItemColor(color: UIColor) {
        for i in 0..<items.count {
            let item = items[i]
            item.setItem(titleColor: color)
        }
    }
    
    func setItemSelectedColor(color: UIColor) {
        for i in 0..<items.count {
            let item = items[i]
            item.setItemSelected(titleColor: color)
        }
    }
    
    func setSliderColor(color: UIColor) {
        sliderColor = color
        sliderView.backgroundColor = color
    }
    
    
    // MARK: - Private method
    fileprivate func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
    }
    
    fileprivate func setupSliderView() {
        sliderView = UIView()
        sliderColor = DEFAULT_SLIDER_COLOR
        sliderView.backgroundColor = sliderColor
        scrollView.addSubview(sliderView)
    }
    
    fileprivate func setupItems() {
        var itemX:CGFloat = 0
        for it in items {
            it.removeFromSuperview()
        }
        items.removeAll()
        for i in 0..<itemsTitle.count {
            let item = LGJLabelControlBarItem()
            item.delegate = self
            //set up current item's frame
            let title = itemsTitle[i]
            let itemWidth = LGJLabelControlBarItem .widthForTitle(title: title)
            item.setItem(title: title)
            item.frame = CGRect(x: itemX, y: 0, width: itemWidth, height: scrollView.frame.size.height)
            items.append(item)
            itemX = item.frame.maxX
            scrollView.addSubview(item)
        }
        scrollView.contentSize = CGSize(width: itemX , height: scrollView.frame.height)
        if scrollView.contentSize.width < self.frame.width {
            let width = scrollView.contentSize.width
            let x = (self.frame.width - scrollView.contentSize.width) / 2
            scrollView.frame = CGRect(x: x, y: 0, width: width , height: scrollView.frame.size.height)
        } else {
            scrollView.frame = CGRect(x: 0, y: 0, width:self.frame.width, height: scrollView.frame.size.height)
        }
        
        // set the default selected item, the first default
        let firstItem = self.items.first
        firstItem?.selected = true
        selectedItem = firstItem
        
        //set frame of sliderView by selected item
        sliderView.frame = CGRect(x: 0, y: self.frame.size.height - SLIDER_VIEW_HEIGHT, width: firstItem!.frame.size.width, height: SLIDER_VIEW_HEIGHT)
    }
    
    fileprivate func scrollToVisibleItem(item:LGJLabelControlBarItem) {
        let selectedItemIndex = items.index(of: selectedItem)
        let visibleItemIndex = items.index(of: item)
        if selectedItemIndex == visibleItemIndex {
            return
        }
        var offset = scrollView.contentOffset
        // If the item to be visible is in the screen, nothing to do
        if item.frame.minX >= offset.x && item.frame.maxX <= (offset.x + scrollView.frame.size.width) {
            return
        }
        
        // Update the scrollView's contentOffset according to different situation
        if (selectedItemIndex! < visibleItemIndex!) {
            // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
            if (selectedItem.frame.maxX < offset.x) {
                offset.x = item.frame.minX
            } else {
                offset.x = item.frame.maxX - scrollView.frame.size.width
            }
        } else {
            // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
            if selectedItem.frame.minX > (offset.x + scrollView.frame.size.width) {
                offset.x = item.frame.maxX - scrollView.frame.size.width
            } else {
                offset.x = item.frame.minX
            }
        }
        scrollView.contentOffset = offset;
    }
    
    fileprivate func addAnimationOnSelectedItem(item: LGJLabelControlBarItem) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            var rect = self.sliderView.frame
            rect.origin.x = item.frame.minX
            rect.size.width = item.frame.width
            self.sliderView.frame = rect
        }) { (finish: Bool) in
            
        }
    }
    
    // MARK: - Bar Item Delegate
    func barSelected(item: LGJLabelControlBarItem) {
        if item == selectedItem {
            return
        }
        scrollToVisibleItem(item: item)
        addAnimationOnSelectedItem(item: item)
        selectedItem = item
        callback(items.index(of: item)!)
    }
    
}

