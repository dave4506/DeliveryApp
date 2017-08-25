//
//  PageViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 6/4/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var packageListVC:ClearNavigationViewController!
    var archiveListVC:ClearNavigationViewController!
    let disposeBag = DisposeBag()
    var fabButton: FloatingActionButton?
    var pageIndicator: PageViewIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.navigationController?.navigationBar.isHidden = true;
        configureBackground(addColorView: true, color: nil)
        stylePageControl()
        setupPageControllers()
        configureOfflineStatus(disposeBag: disposeBag,view:self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPageControllers() {
        packageListVC = UIStoryboard(name: "PackageList", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        packageListVC.pageIndex = 0
        archiveListVC = UIStoryboard(name: "ArchiveList", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        archiveListVC.pageIndex = 1
        self.setViewControllers([packageListVC], direction: .forward, animated: true, completion: nil)
    }
    
    
    func stylePageControl() {
        pageIndicator = PageViewIndicator()
        self.view.addSubview(pageIndicator!)
        setPageViewIndicatorConstraints(view: pageIndicator!,parent: self.view)
        pageIndicator!.animateButton(pageIndicator!.archiveButton, active: false)
        pageIndicator!.animateButton(pageIndicator!.homeButton, active: true)
        pageIndicator!.archiveButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.setViewControllers([(self?.archiveListVC)!], direction: .forward, animated: true, completion: nil)
        }).disposed(by:disposeBag)
        pageIndicator!.homeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.setViewControllers([(self?.packageListVC)!], direction: .reverse, animated: true, completion: nil)
        }).disposed(by:disposeBag)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! ClearNavigationViewController).pageIndex
        if index == 0 {
            return archiveListVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! ClearNavigationViewController).pageIndex
        if index == 1 {
            return packageListVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        let index = (pageViewController.viewControllers!.first! as! ClearNavigationViewController).pageIndex
        if index == 0 {
            pageIndicator!.animateButton(pageIndicator!.archiveButton, active: false)
            pageIndicator!.animateButton(pageIndicator!.homeButton, active: true)
        }
        if index == 1 {
            pageIndicator!.animateButton(pageIndicator!.archiveButton, active: true)
            pageIndicator!.animateButton(pageIndicator!.homeButton, active: false)
        }
    }
}
