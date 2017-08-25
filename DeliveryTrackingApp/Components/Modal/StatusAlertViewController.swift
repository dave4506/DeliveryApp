//
//  CustomAlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit
import Presentr

/// UIViewController subclass that displays the alert
public class StatusAlertViewController: UIViewController {

    var descriptionText:String = ""
    
    @IBOutlet weak var descriptionLabel: BodyLabel!
    
    override public func loadView() {
        let name = "StatusAlertViewController"
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Nib not found.")
        }
        self.view = view
    }

    fileprivate func setupLabels() {
        descriptionLabel.text = descriptionText
        descriptionLabel.textColor = .white
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    func configureView() {
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
