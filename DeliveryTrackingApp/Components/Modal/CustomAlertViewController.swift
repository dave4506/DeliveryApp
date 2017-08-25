//
//  CustomAlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit
import Presentr

public typealias AlertActionHandler = (() -> Void)

public struct CustomAlertAction {
    let title:String
    let style:CustomAlertStyle
    let handler:AlertActionHandler?
}

public enum CustomAlertStyle {

    case `default`
    case cancel
    case destructive
    case custom(textColor: UIColor)

    func color() -> UIColor {
        switch self {
        case .default:
            return ColorPalette.greenColor
        case .cancel:
            return ColorPalette.grayColor
        case .destructive:
            return ColorPalette.redColor
        case let .custom(color):
            return color
        }
    }

}

private struct ColorPalette {

    static let grayColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
    static let greenColor = UIColor(red: 58.0/255.0, green: 213.0/255.0, blue: 91.0/255.0, alpha: 1)
    static let redColor = UIColor(red: 255.0/255.0, green: 103.0/255.0, blue: 100.0/255.0, alpha: 1)

}

/// UIViewController subclass that displays the alert
public class CustomAlertViewController: UIViewController {

    /// Text that will be used as the title for the alert
    public var titleText: String?

    /// Text that will be used as the body for the alert
    public var bodyText: String?

    /// If set to false, alert wont auto-dismiss the controller when an action is clicked. Dismissal will be up to the action's handler. Default is true.
    public var autoDismiss: Bool = true

    /// If autoDismiss is set to true, then set this property if you want the dismissal to be animated. Default is true.
    public var dismissAnimated: Bool = true

    fileprivate var actions = [CustomAlertAction]()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButtonWidthConstraint: NSLayoutConstraint!

    override public func loadView() {
        let name = "CustomAlertViewController"
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Nib not found.")
        }
        self.view = view
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if actions.isEmpty {
            let okAction = CustomAlertAction(title: "ok 🕶", style: .default, handler: nil)
            addAction(okAction)
        }
        setupFonts()
        setupLabels()
        setupButtons()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override public func updateViewConstraints() {
        if actions.count == 1 {
            // If only one action, second button will have been removed from superview
            // So, need to add constraint for first button trailing to superview
            if let constraint = firstButtonWidthConstraint {
                view.removeConstraint(constraint)
            }
            let views: [String: UIView] = ["button" : firstButton]
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[button]-0-|",
                                                                             options: NSLayoutFormatOptions(rawValue: 0),
                                                                             metrics: nil,
                                                                             views: views)
            view.addConstraints(constraints)
        }
        super.updateViewConstraints()
    }

    // MARK: AlertAction's

    /**
     Adds an 'AlertAction' to the alert controller. There can be maximum 2 actions. Any more will be ignored. The order is important.

     - parameter action: The 'AlertAction' to be added
     */
    public func addAction(_ action: CustomAlertAction) {
        guard actions.count < 2 else { return }
        actions += [action]
    }

    // MARK: Setup

    fileprivate func setupFonts() {
        titleLabel.font =  UIFont(name: Assets.typeFace.regular, size: 16)
        bodyLabel.font =  UIFont(name: Assets.typeFace.regular, size: 14)
        firstButton.titleLabel?.font =  UIFont(name: Assets.typeFace.regular, size: 12)
        secondButton.titleLabel?.font =  UIFont(name: Assets.typeFace.regular, size: 12)
    }

    fileprivate func setupLabels() {
        titleLabel.text = titleText ?? "Alert"
        bodyLabel.text = bodyText ?? "This is an alert."
    }

    fileprivate func setupButtons() {
        guard let firstAction = actions.first else { return }
        apply(firstAction, toButton: firstButton)
        if actions.count == 2 {
            let secondAction = actions.last!
            apply(secondAction, toButton: secondButton)
        } else {
            secondButton.removeFromSuperview()
        }
    }

    fileprivate func apply(_ action: CustomAlertAction, toButton: UIButton) {
        let title = action.title.uppercased()
        let style = action.style
        toButton.setTitle(title, for: UIControlState())
        toButton.setTitleColor(style.color(), for: UIControlState())
    }

    // MARK: IBAction's

    @IBAction func didSelectFirstAction(_ sender: AnyObject) {
        guard let firstAction = actions.first else { return }
        if let handler = firstAction.handler {
            handler()
        }
        dismiss()
    }

    @IBAction func didSelectSecondAction(_ sender: AnyObject) {
        guard let secondAction = actions.last, actions.count == 2 else { return }
        if let handler = secondAction.handler {
            handler()
        }
        dismiss()
    }

    // MARK: Helper's

    func dismiss() {
        guard autoDismiss else { return }
        self.dismiss(animated: dismissAnimated, completion: nil)
    }

}
