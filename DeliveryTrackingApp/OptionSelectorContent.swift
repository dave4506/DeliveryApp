//
//  OptionSelectorContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class OptionSelectorContent: UIView {

    @IBOutlet weak var optionStackView: UIStackView!
    @IBOutlet weak var captionLabel: CaptionLabel!
    @IBOutlet weak var titleLabel: BodyLabel!
    @IBOutlet var view: UIView!

    var totalOptions = 0;
    var activeIndex = 0 {
        didSet {
            switchActive(from:oldValue,to:activeIndex)
        }
    }
    var optionViews:[OptionView] = []
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "OptionSelectorContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
        addOption(label:"test 1")
        addOption(label:"test 2")
        addOption(label:"test 3")
        activeIndex = 0
    }
    
    func addOption(label:String) {
        let optionView = OptionView(frame: CGRect(origin:.zero,size:CGSize(width:optionStackView.frame.width / 3,height:optionStackView.frame.height)))
        optionView.selectorLabel.text = label
        optionView.tag = totalOptions
        optionStackView.addArrangedSubview(optionView)
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        optionView.isUserInteractionEnabled = true
        optionView.addGestureRecognizer(oneTap)
        optionViews.append(optionView)
        totalOptions += 1
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        let v = sender.view!
        let tag = v.tag
        activeIndex = tag
        print("whatw \(tag)")
    }
    
    func switchActive(from:Int,to:Int) {
        let currentActive = optionViews[from]
        let newActive = optionViews[to]
        currentActive.status = false
        newActive.status = true
    }
}
