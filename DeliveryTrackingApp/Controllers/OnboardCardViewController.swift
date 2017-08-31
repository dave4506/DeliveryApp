//
//  OnboardCardViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/10/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardCardViewController: UIViewController {
    
    @IBOutlet weak var onboardCard: OnboardCard!
    
    var pushToAdd:(() -> Void)?
    var pushToDismiss:(() -> Void)?
    
    let disposeBag = DisposeBag()
    var pageIndex: Int!
    var onboardContent: OnboardCardContent?
    weak var onboardVC: OnboardPageViewController?
    var viewModel:OnboardViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderCard()
        addOnboardCardControls()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        viewModel = OnboardViewModel()
        viewModel?.seenOnboard()
    }
    
    func renderCard() {
        onboardCard.onboardTitle.text = onboardContent?.title
        onboardCard.onboardImageView.image = onboardContent?.image ?? UIImage()
        onboardCard.onboardDescription.text = onboardContent?.paragraph
        specialOnboardStyling(at: pageIndex,for: onboardCard)
    }
    
    func addOnboardCardControls(){
        guard pageIndex == 3 else { return }
        let onboardControl = onboardCard.subviews[1] as! FloatingActionButton
        onboardControl.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push()
        }).disposed(by: disposeBag)
    }
    
    private func push() {
        self.pushToDismiss!()
        self.pushToAdd!()
    }
}
