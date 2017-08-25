//
//  StateCard.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class StateCard: UIView {

    var status:PrettyStatus? {
        didSet {
            guard let _ = status else { return }
            setStatusContent(status: status!)
        }
    }
    
    var tableView:UITableView?
    
    @IBOutlet weak var captionLabel: CaptionLabel!
    @IBOutlet weak var actionButton: PrimaryButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var statusTitleLabel: TitleLabel!
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
        UINib(nibName: "StateCard", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        statusTitleLabel.setFontSize(at: 22)
        statusTitleLabel.textFocus = .standard
        descriptionLabel.textFocus = .standard
        captionLabel.textFocus = .muted
        actionButton.setToDefaultSize()
    }
    
    func setStatusContent(status:PrettyStatus) {
        statusTitleLabel.text = status.title
        iconImageView.image = status.icon
        descriptionLabel.text = status.description
        captionLabel.text = status.caption
        setActionable(for: status.actionable!, with: status.buttonTitle)
    }
    
    func setActionable(for actionable:Bool, with buttonTitle:String?) {
        if actionable {
            captionLabel.alpha = 0
            actionButton.alpha = 1
        } else {
            captionLabel.alpha = 1
            actionButton.alpha = 0
        }
    }
    
    override func layoutSubviews() {
        tableView?.reloadData()
        super.layoutSubviews()
    }
}
