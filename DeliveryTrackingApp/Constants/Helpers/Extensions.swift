//
//  Extensions.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/24/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Presentr

extension UIViewController {
    func configureBackground(addColorView:Bool, color:UIColor?) {
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        if addColorView {
            let coloredView = ColoredView()
            gradientView.addSubview(coloredView)
            generateColoredViewConstraints(view: coloredView,parent: gradientView)
        }
        self.view.addSubview(gradientView)
        self.view.sendSubview(toBack: gradientView)
        setGradientContraints(view: gradientView, parent: self.view)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PageViewController:PresentrDelegate {
    func configureOfflineStatus(disposeBag:DisposeBag,view:UIView) {
        let alertController = generateStatusAlerViewController(description:"App is offline")
        alertController.handler = { [unowned self] _ in self.presentAlert = false; }
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.connectionModel?.connectionState.asObservable().subscribe(onNext: { [unowned self] status in
            print("status \(status) \(self.presentAlert)")
            switch status {
            case .connected: alertController.dismiss(animated: true, completion: nil);break;
            case .disconnected:
                if !self.presentAlert {
                    statusViewPresenter.viewControllerForContext = self;
                    self.customPresentViewController(statusViewPresenter, viewController: alertController, animated: true, completion: nil);

                };self.presentAlert = true;break;
            default: break;
            }
        }).disposed(by: disposeBag)
    }
}

extension UIViewController {
    func generateColoredViewConstraints(view: UIView,parent:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 210)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: -10)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: -70)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -50)
        NSLayoutConstraint.activate([heightConstraint,topConstraint,leadingConstraint,trailingConstraint])
        view.layoutIfNeeded()
    }
    
    func setGradientContraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,bottomConstraint,topConstraint])
        view.layoutIfNeeded()
    }
    func setFABButtonConstraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -20)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -20)
        NSLayoutConstraint.activate([widthConstraint,trailingConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
    }
    
    func setPageViewIndicatorConstraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        let xConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([widthConstraint,xConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
    }
    
    func setPagingMenuConstraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,topConstraint,trailingConstraint])
        view.layoutIfNeeded()
    }
}
