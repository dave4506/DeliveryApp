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

class RootSplitViewController: UISplitViewController {

    var pageVC:PageViewController?
    var detailVC:ClearNavigationViewController?
    var fabButton: FloatingActionButton?
    let disposeBag = DisposeBag()
    var viewModel: SplitViewModel!
    
    private enum Push { case toAdd,toOnboard }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVCs()
        setUpSplitViewSettings()
        generateFabButton(refView: self.view)
        viewModel = SplitViewModel();
        setUpViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.checkFirstTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setUpViewModel() {
        viewModel.firstTimeVar.asObservable().subscribe(onNext:{ [unowned self] firstTime in
            if firstTime {
                self.push(.toOnboard)
            }
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setUpVCs() {
        detailVC = UIStoryboard(name: "PackageDetails", bundle: nil).instantiateInitialViewController() as? ClearNavigationViewController
        pageVC = UIStoryboard(name: "PageView", bundle: nil).instantiateInitialViewController() as? PageViewController
        self.viewControllers = [pageVC!,detailVC!]
    }
    
    func setUpSplitViewSettings() {
        self.preferredDisplayMode = .allVisible
    }
    
    func generateFabButton(refView: UIView) {
        fabButton = FloatingActionButton(frame:CGRect(origin:.zero,size:CGSize(width:56,height:56)))
        self.view.addSubview(fabButton!)
        self.view.bringSubview(toFront: fabButton!)
        setFABButtonConstraints(view: fabButton!, parent: view)
        fabButton?.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.toAdd)
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
            self.present(onboardNav, animated: true, completion: nil);break;
        }
    }
}
