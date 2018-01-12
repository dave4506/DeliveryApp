//
//  RootSplitViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AssistantKit

class RootSplitViewController: UISplitViewController {

    var pageVC:PageViewController?
    var detailVC:ClearNavigationViewController?
    var fabButton: FloatingActionButton?
    var snackBar: SnackBar?
    let disposeBag = DisposeBag()
    var viewModel: SplitViewModel!
    
    private enum Push { case toAdd,toOnboard }
    private enum Alert { case proPackLimit }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVCs()
        setUpSplitViewSettings()
        generateFabWRefresh()
        viewModel = SplitViewModel();
        setUpViewModel()
        configureOfflineStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.checkFirstTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setUpViewModel() {
        /*
        viewModel.firstTimeVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext:{ [unowned self] firstTime in
            if firstTime {
                self.push(.toOnboard)
            }
        }).disposed(by: viewModel.disposeBag)*/
    }
    
    func setUpVCs() {
        detailVC = UIStoryboard(name: "PackageDetails", bundle: nil).instantiateInitialViewController() as? ClearNavigationViewController
        pageVC = UIStoryboard(name: "PageView", bundle: nil).instantiateInitialViewController() as? PageViewController
        self.viewControllers = [pageVC!,detailVC!]
    }
    
    func setUpSplitViewSettings() {
        self.preferredDisplayMode = .allVisible
        if Device.screen.family == ScreenFamily.medium {
            self.maximumPrimaryColumnWidth = 400
            self.preferredPrimaryColumnWidthFraction = 0.5
        }
    }
    
    func generateFabWRefresh() {
        fabButton = FloatingActionButton(frame:CGRect(origin:.zero,size:CGSize(width:56,height:56)))
        snackBar = SnackBar(frame:CGRect(origin:.zero,size:CGSize(width:self.view.bounds.width,height:56)))
        snackBar!.fabButton = fabButton
        self.view.addSubview(fabButton!)
        self.view.bringSubview(toFront: fabButton!)
        self.view.addSubview(snackBar!)
        self.view.bringSubview(toFront: snackBar!)
        setFABButtonConstraints(view: fabButton!, snackBar: snackBar!, parent: self.view)
        fabButton?.rx.tap.subscribe(onNext: { [unowned self] _ in
            if self.viewModel.packageCountVar.value < 3 || self.viewModel.proPackStatus.value {
                self.push(.toAdd)
            } else {
                self.showAlert(.proPackLimit)
            }
        }).disposed(by: disposeBag)
    }
    
    func setFABButtonConstraints(view:UIView,snackBar:SnackBar,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        snackBar.translatesAutoresizingMaskIntoConstraints = false
        //snack bar
        let bottomConstraint = NSLayoutConstraint(item: snackBar, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: 56)
        let heightConstraint = NSLayoutConstraint(item: snackBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let leadingConstraint = NSLayoutConstraint(item: snackBar, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: snackBar, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0)
        //fab
        let bottomConstraintFAB = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: snackBar, attribute: .top, multiplier: 1, constant: -20)
        let heightConstraintFAB = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let widthConstraintFAB = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let trailingConstraintFAB = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -20)
    NSLayoutConstraint.activate([trailingConstraintFAB,bottomConstraintFAB,heightConstraintFAB,widthConstraintFAB,leadingConstraint,trailingConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
        snackBar.layoutIfNeeded()
    }
    
    func configureOfflineStatus() {
        var firstDisconnect = true
        DelegateHelper.connectionObservable().subscribe(onNext: { [unowned self] status in
            switch status {
            case .connected:break;
            case .disconnected:
                if firstDisconnect {
                    firstDisconnect = false
                } else {
                    self.snackBar?.animateSnackBar(with: "App is offline.")
                }
            default: break;
            }
        }).disposed(by: disposeBag)
    }

    private func push(_ p:Push) {
        switch p {
        case .toAdd:
            let add = UIStoryboard(name: "Add", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
            add.modalPresentationStyle = .formSheet
            self.present(add, animated: true, completion: nil);break;
        case .toOnboard:
            let onboardNav = UIStoryboard(name: "Onboard", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
            onboardNav.modalPresentationStyle = .formSheet
            let onboard = onboardNav.viewControllers[0] as! OnboardPageViewController
            onboard.pushToAdd = { [unowned self] in self.push(.toAdd) }
            self.present(onboardNav, animated: true, completion: nil);
        }
    }
    
    private func showAlert(_ alert:Alert) {
        switch alert {
        case .proPackLimit:
            let okAction = CustomAlertAction(title: "Got It", style: .custom(textColor:Color.primary),handler:nil)
            alertDefault(vc: self, alertViewStatus:AlertView.proPackPackageLimitWarning, actionOne: okAction, actionTwo: nil);break;
        }
    }
}
