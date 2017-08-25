//
//  OnboardViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardPageViewController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {

    let disposeBag = DisposeBag()
    
    var onboardCards:[OnboardCardViewController] = []
    var pushToAdd:(() -> Void)?

    private enum Push { case toAdd, dismiss }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        configureNavButton()
        configureBackground(addColorView: false, color: nil)
        generateOnboardCards()
        self.setViewControllers([onboardCards[0]], direction: .forward, animated: true, completion: nil)
        stylePageControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateOnboardCards() {
        for i in 0...3 {
            let vc = UIStoryboard(name: "Onboard", bundle: nil).instantiateViewController(withIdentifier: "onboardCard") as! OnboardCardViewController
            vc.pageIndex = i;
            vc.onboardContent = onboardCardsContent[i];
            vc.onboardVC = self
            vc.pushToAdd = { [unowned self] in self.push(.toAdd) }
            vc.pushToDismiss = { [unowned self] in self.push(.dismiss) }
            onboardCards.append(vc)
        }
    }
    
    func stylePageControl() {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = Color.secondary
        pageControl.currentPageIndicatorTintColor = Color.primary
    }
    
    func configureNavButton() {
        var image = Assets.logo.cross.gray
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] in
            self.push(.dismiss)
        }).disposed(by: disposeBag)
    }
    
    private func push(_ p:Push) {
        switch p {
        case .dismiss: dismiss(animated: true, completion: nil);break;
        case .toAdd: pushToAdd!();break;
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardCardViewController).pageIndex!
        if index < 3 {
            return onboardCards[index + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardCardViewController).pageIndex!
        if index > 0 {
            return onboardCards[index - 1]
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

