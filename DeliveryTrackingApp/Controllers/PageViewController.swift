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
    var settingsVC:ClearNavigationViewController!
    let disposeBag = DisposeBag()
    var fabButton: FloatingActionButton?
    var pagingMenu: PagingMenu?
    var presentAlert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.navigationController?.navigationBar.isHidden = true;
        configureBackground(addColorView: true, color: nil)
        generatePagingMenu()
        setupPageControllers()
        //configureOfflineStatus(disposeBag: disposeBag,view:self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkPagingMenuStatusBar() {
        guard let pagingMenu = self.pagingMenu else { return }
        pagingMenu.setStatusBar(!UIApplication.shared.isStatusBarHidden)
    }
    
    func setupPageControllers() {
        packageListVC = UIStoryboard(name: "PackageList", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        packageListVC.pageIndex = 0
        archiveListVC = UIStoryboard(name: "ArchiveList", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        archiveListVC.pageIndex = 1
        settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        settingsVC.pageIndex = 2
        self.setViewControllers([packageListVC], direction: .forward, animated: true, completion: nil)
    }
    
    func generatePagingMenu() {
        pagingMenu = PagingMenu()
        self.view.addSubview(pagingMenu!)
        setPagingMenuConstraints(view: pagingMenu!,parent: self.view)
        pagingMenu!.setActive(page:.home)
        pagingMenu!.archiveButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.setViewControllers([self.archiveListVC], direction: .forward, animated: true, completion: nil)
        }).disposed(by:disposeBag)
        pagingMenu!.homeButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.setViewControllers([self.packageListVC], direction: .reverse, animated: true, completion: nil)
        }).disposed(by:disposeBag)
        pagingMenu!.settingsButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.setViewControllers([self.settingsVC], direction: .forward, animated: true, completion: nil)
        }).disposed(by:disposeBag)
        checkPagingMenuStatusBar()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! ClearNavigationViewController).pageIndex
        if index == 0 {
            return archiveListVC
        }
        if index == 1 {
            return settingsVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! ClearNavigationViewController).pageIndex
        if index == 1 {
            return packageListVC
        }
        if index == 2 {
            return archiveListVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        let index = (pageViewController.viewControllers!.first! as! ClearNavigationViewController).pageIndex
        if index == 0 {
            pagingMenu!.setActive(page:.home)
        }
        if index == 1 {
            pagingMenu!.setActive(page:.archive)
        }
        if index == 2 {
            pagingMenu!.setActive(page:.settings)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async() { [unowned self] in
            self.checkPagingMenuStatusBar()
        }
    }
}
