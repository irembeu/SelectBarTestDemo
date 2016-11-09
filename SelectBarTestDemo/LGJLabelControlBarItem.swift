//
//  LGJLabelControlBarItem.swift
//  SelectBarTestDemo
//
//  Created by 劉光軍 on 2016/11/7.
//  Copyright © 2016年 劉光軍. All rights reserved.
//

import UIKit

protocol LGJLabelControlBarItemDelegate {
    func barSelected(item: LGJLabelControlBarItem) -> Void
}

let DEFAULT_TITLE_FONTSIZE = CGFloat(15)
let DEFAULT_TITLE_SELECTED_FONTSIZE = CGFloat(16)
let DEFAULT_TITLE_COLOR = UIColor.black
let DEFAULT_TITLE_SELECTED_COLOR = UIColor.orange
let HORIZONTAL_MARGIN: CGFloat = 10

class LGJLabelControlBarItem: UIView {
    var selected: Bool! {
        didSet {
            //value changed, color & font also change
            setNeedsDisplay()
        }
    }
    var delegate: LGJLabelControlBarItemDelegate?
    private var title: String!
    private var fontSize: CGFloat!
    private var selectedFontSize: CGFloat!
    private var color: UIColor!
    private var selectedColor: UIColor!
    
    init() {
        super.init(frame:CGRect(x:0, y:0, width:0, height:0))
        self.fontSize = DEFAULT_TITLE_FONTSIZE
        self.selectedFontSize = DEFAULT_TITLE_SELECTED_FONTSIZE
        self.color = DEFAULT_TITLE_COLOR
        self.selectedColor = DEFAULT_TITLE_SELECTED_COLOR
        self.selected = false
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let size = self.frame.size
        let titleX = (size.width - titleSize().width) * 0.5
        let titleY = (size.height - titleSize().height) * 0.5
        let titleRect = CGRect(x: titleX, y: titleY, width: titleSize().width, height: titleSize().height)
        let attributes = [NSFontAttributeName : titleFont(), NSForegroundColorAttributeName: titleColor()]
        let str = NSString(string: title!)
        str.draw(in: titleRect, withAttributes: attributes)
    }
    
    // MARK: - public
    func setItem(title: String) -> Void {
        self.title = title
        self.setNeedsDisplay()
    }
    
    func setItem(titleFont: CGFloat) -> Void {
        self.fontSize = titleFont
        setNeedsDisplay()
    }
    
    func setItem(titleColor: UIColor) -> Void {
        self.color = titleColor
        setNeedsDisplay()
    }
    
    func setItemSelected(titleFont: CGFloat) -> Void {
        self.selectedFontSize = titleFont
        setNeedsDisplay()
    }
    
    func setItemSelected(titleColor: UIColor) -> Void {
        self.selectedColor = titleColor
        setNeedsDisplay()
    }
    
    // MARK: - Private
    fileprivate func titleSize() -> CGSize {
        let attributes = [NSFontAttributeName: titleFont()]
        let str = NSString(string: self.title!)
        var size = str.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        return size
    }
    
    fileprivate func titleFont() -> UIFont {
        var font: UIFont
        if self.selected! {
            font = UIFont.boldSystemFont(ofSize: self.selectedFontSize)
        } else {
            font = UIFont.systemFont(ofSize: self.fontSize)
        }
        return font
    }
    
    fileprivate func titleColor() -> UIColor {
        var color: UIColor
        if self.selected! {
            color = self.selectedColor
        } else {
            color = self.color
        }
        return color
    }
    
    // MARK: - Public Class Method
    
    class func widthForTitle(title: String) -> CGFloat {
        let attributes = [ NSFontAttributeName : UIFont.systemFont(ofSize: DEFAULT_TITLE_FONTSIZE)]
        let str = NSString(string: title)
        var size = str.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
        size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2
        return size.width
    }
    
    // MARK: - Responder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selected = true
        if (self.delegate != nil) {
            self.delegate!.barSelected(item: self)
        }
    }
}
