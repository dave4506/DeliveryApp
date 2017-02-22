//
//  StatsView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/21/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit

class StatsView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var awaitingStatsLabel: BodyLabel!
    @IBOutlet weak var travelingStatsLabel: BodyLabel!
    @IBOutlet weak var deliveredStatsLabel: BodyLabel!
    
    var stats: Statistics? {
        didSet  {
            guard let _ = stats else { return }
            setStatLabels(with: stats!)
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func commonInit() {
        UINib(nibName: "StatsView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        awaitingStatsLabel.textColor = Color.secondary
        deliveredStatsLabel.textColor = Color.success
        travelingStatsLabel.textColor = Color.accent
    }
    
    func setStatLabels(with statistics:Statistics) {
        awaitingStatsLabel.text = "\(statistics.awaiting!)"
        travelingStatsLabel.text = "\(statistics.traveling!)"
        deliveredStatsLabel.text = "\(statistics.delivered!)"
    }
}
