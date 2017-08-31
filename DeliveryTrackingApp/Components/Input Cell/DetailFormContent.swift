//
//  OptionSelectorContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/25/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailFormContent: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var buttonTwo: LinkButton!
    @IBOutlet weak var buttonOne: LinkButton!
    @IBOutlet weak var captionLabel: CaptionLabel!
    @IBOutlet weak var titleLabel: BodyLabel!
    @IBOutlet var view: UIView!

    var tableview: UITableView?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "DetailFormContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        tableview?.reloadData()
        super.layoutSubviews()
    }
}
