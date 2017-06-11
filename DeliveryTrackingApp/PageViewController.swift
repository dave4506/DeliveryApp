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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        let coloredView = ColoredView()
        gradientView.addSubview(coloredView)
        generateColoredViewConstraints(view: coloredView,parent: gradientView)
        self.view.addSubview(gradientView)
        self.delegate = self
        self.dataSource = self
        packageListVC = UIStoryboard(name: "PackageList", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        packageListVC.pageIndex = 0
        archiveListVC = UIStoryboard(name: "ArchiveList", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
        archiveListVC.pageIndex = 1
        self.setViewControllers([packageListVC], direction: .forward, animated: true, completion: nil)
        stylePageControl()
        generateFabButton(refView: self.view)
        self.view.gestureRecognizers?.forEach {
            print("herllo?")
            $0.cancelsTouchesInView = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stylePageControl() {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = Color.secondary
        pageControl.currentPageIndicatorTintColor = Color.primary
        pageControl.backgroundColor = .clear
    }
    
    func generateFabButton(refView: UIView) {
        let refViewFrame = refView.frame
        let cornerPoint = CGPoint(x: refViewFrame.maxX, y: refViewFrame.maxY)
        let cornerX = cornerPoint.x - 56 - 20
        let cornerY = cornerPoint.y - 56 - 20
        let fabButton = FloatingActionButton(frame:CGRect(origin:CGPoint(x:cornerX,y:cornerY),size:CGSize(width:56,height:56)))
        fabButton.rx.tap.subscribe(onNext: { [weak self] _ in
            let add = UIStoryboard(name: "Add", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
            self?.present(add, animated: true, completion: nil)
            print("tap?")
        }).disposed(by: disposeBag)
        self.view.addSubview(fabButton)
        self.view.bringSubview(toFront: fabButton)
    }
    
    func generateColoredViewConstraints(view: UIView,parent:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 210)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: -10)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: -70)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -50)
        NSLayoutConstraint.activate([heightConstraint,topConstraint,leadingConstraint,trailingConstraint])
        view.layoutIfNeeded()
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
    /*
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    */
}
