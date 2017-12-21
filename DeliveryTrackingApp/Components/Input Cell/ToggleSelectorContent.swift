//
//  ToggleSelectorContent.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/26/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TKSwitcherCollection

class ToggleSelectorContent: UIView {

    @IBOutlet weak var toggleButton: LinkButton!
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: BodyLabel!
    var switchComp:TKSimpleSwitch?
    var switchCompRx = Variable<SwitchState>(.unintiated)
    let disposeBag = DisposeBag()
    
    enum SwitchState {
        case unintiated, on, off
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
        UINib(nibName: "ToggleSelectorContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        switchComp = TKSimpleSwitch()
        switchComp!.center = toggleButton.center;
        switchComp!.isHidden = true
        switchComp!.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
        switchComp!.config = TKSimpleSwitchConfig(onColor: Color.primary, offColor: Color.primary.withAlphaComponent(0.5), lineColor: .white, circleColor: Color.background, lineSize: 0.0)
        switchComp!.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] _ in
            if self.switchComp!.isOn {
                self.switchCompRx.value = .on
            } else {
                self.switchCompRx.value = .off
            }
        }).disposed(by: disposeBag)
        view.addSubview(switchComp!)
        setSwitchCompConstraints()
        self.backgroundColor = .clear
    }
    
    func enableSwitch() {
        toggleButton.isHidden = true
        switchComp?.isHidden = false
    }
    
    func disableSwitch() {
        toggleButton.isHidden = false
        switchComp?.isHidden = true
    }
    
    func setSwitchCompConstraints() {
        guard let switchComp = self.switchComp else { return }
        switchComp.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: switchComp, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -40)
        let verticalCenterConstraint = NSLayoutConstraint(item: switchComp, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: switchComp, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        let heightConstraint = NSLayoutConstraint(item: switchComp, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        NSLayoutConstraint.activate([widthConstraint,heightConstraint,verticalCenterConstraint,trailingConstraint])
        switchComp.layoutIfNeeded()
    }
    
    func setToggleTitle(status:String) {
        toggleButton.setTitle(status, for: .normal)
    }
}
