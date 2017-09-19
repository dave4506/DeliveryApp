//
//  StateCard.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class SmallStateCard: UIView {

    var status:PrettyStatus? {
        didSet {
            guard let _ = status else { return }
            setStatusContent(status: status!)
        }
    }
    
    var tableView:UITableView?
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var descriptionLabel: BodyLabel!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "SmallStateCard", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        descriptionLabel.textFocus = .muted
        iconImageView.tintColor = Color.secondary;
    }
    
    func setStatusContent(status:PrettyStatus) {
        iconImageView.image = status.icon!.withRenderingMode(.alwaysTemplate)
        descriptionLabel.text = status.description
    }
    
    override func layoutSubviews() {
        tableView?.reloadData()
        super.layoutSubviews()
    }
}
