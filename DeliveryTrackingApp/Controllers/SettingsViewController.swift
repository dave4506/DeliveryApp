//
//  PackageDetailsViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import SafariServices

class SettingsViewController: UITableViewController {
    
    @IBOutlet var listView: ListTableView!
    @IBOutlet weak var privacyPolicyToggleSelector: ToggleSelectorContent!
    @IBOutlet weak var inAppPurchaseContent: DetailFormContent!
    @IBOutlet weak var creditSubContent: TitleSubContent!
    @IBOutlet weak var titleContent: TitleLabelContent!
    @IBOutlet weak var notificationSelectorContent: ToggleSelectorContent!
    
    let disposeBag = DisposeBag()

    var viewModel:SettingsViewModel?
    
    enum Push {
        case toCredits,toPrivacy,toEula
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVisualComponents()
        bindViewModel()
        listView.setSectionFooter(height: 80)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.dismiss()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        viewModel = SettingsViewModel()
        self.creditSubContent.settingsButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.toCredits)
        }).disposed(by: disposeBag)
        self.privacyPolicyToggleSelector.toggleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.toPrivacy)
        }).disposed(by: disposeBag)
        self.notificationSelectorContent.toggleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.tapNotification(toggle:(self.viewModel?.notificationStatus.value)!)
        }).disposed(by: disposeBag)
        viewModel?.notificationStatus.asObservable().subscribe(onNext: { [unowned self] toggle in
            self.setNotificationToggle(toggle:toggle)
        }).disposed(by: disposeBag)
        viewModel?.proPackStatus.asObservable().subscribe(onNext: { [unowned self] status in
            self.setProPackButtons(status: status)
        }).disposed(by: disposeBag)
        self.inAppPurchaseContent.buttonOne.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.viewModel?.restorePurchases()
        }).disposed(by: disposeBag)
        self.inAppPurchaseContent.buttonTwo.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.viewModel?.buyProPack()
        }).disposed(by: disposeBag)
        viewModel?.iapModel.transactionStatusVar.asObservable().subscribe(onNext: { [unowned self] status in
            switch status {
            case .dismiss: SVProgressHUD.dismiss();
            case .loading: SVProgressHUD.show();break;
            case .success: SVProgressHUD.dismiss();ProgressHUDStatus.showAndDismiss(.success(text: "Pro Pack Purchased"));break;
            case .error: SVProgressHUD.dismiss();ProgressHUDStatus.showAndDismiss(.error(text:"Something went wrong. Try again"));break;
            default:break;
            }
        }).disposed(by: disposeBag)
    }
    
    func configureVisualComponents() {
        self.titleContent.titleLabel.text = "Your Settings"
        self.notificationSelectorContent.titleLabel.text = "Notifications"
        self.privacyPolicyToggleSelector.titleLabel.text = "Privacy Policy"
        self.privacyPolicyToggleSelector.setToggleTitle(status: "View")
        self.creditSubContent.descriptionLabel.text = "Credits"
        self.creditSubContent.descriptionLabel.isUserInteractionEnabled = true
        self.creditSubContent.settingsButton.setTitle("View", for: .normal)
        self.inAppPurchaseContent.tableview = self.tableView
        self.inAppPurchaseContent.titleLabel.text = "Pro Pack for pro humans"
        self.inAppPurchaseContent.captionLabel.text = "Includes:\n-Unlimited Packages\n-Archived Packages\n-Different Notification Options\n-Just $2.99"
        self.inAppPurchaseContent.backgroundView.backgroundColor = UIColor(patternImage: Assets.confetti)
        self.inAppPurchaseContent.buttonOne.customSpacing = false
        self.inAppPurchaseContent.buttonTwo.customSpacing = false
    }
    
    func setProPackButtons(status:Bool) {
        if status {
            inAppPurchaseContent.buttonOne.setTitle("Purchased", for: .normal)
            inAppPurchaseContent.buttonOne.alpha = 0.5;
            inAppPurchaseContent.buttonOne.isUserInteractionEnabled = false
            inAppPurchaseContent.buttonTwo.isUserInteractionEnabled = false
            inAppPurchaseContent.buttonTwo.setTitle(" ", for: .normal)
        } else {
            if IAPModel.canMakePayments() {
                inAppPurchaseContent.buttonOne.isUserInteractionEnabled = true
                inAppPurchaseContent.buttonTwo.isUserInteractionEnabled = true
                inAppPurchaseContent.buttonOne.setTitle("Restore Purchases", for: .normal)
                inAppPurchaseContent.buttonTwo.setTitle("Buy Pro Pack", for: .normal)
                inAppPurchaseContent.buttonOne.alpha = 1;
            } else {
                inAppPurchaseContent.buttonOne.setTitle("Can't Purchase", for: .normal)
                inAppPurchaseContent.buttonOne.alpha = 0.5;
                inAppPurchaseContent.buttonOne.isUserInteractionEnabled = false
                inAppPurchaseContent.buttonTwo.isUserInteractionEnabled = false
                inAppPurchaseContent.buttonTwo.setTitle(" ", for: .normal)
            }
        }
    }
    
    func setNotificationToggle(toggle:NotificationSetting) {
        if toggle == .on {
            self.notificationSelectorContent.setToggleTitle(status: "Disable")
        } else if toggle == .unintiated {
            self.notificationSelectorContent.setToggleTitle(status: " ")
        } else {
            self.notificationSelectorContent.setToggleTitle(status: "Enable")
        }
    }
    
    func tapNotification(toggle:NotificationSetting) {
        if toggle == .on {
            viewModel?.notificationStatus.value = .off
            viewModel?.updateNotificationStatus()
        } else if toggle == .off {
            viewModel?.notificationStatus.value = .on
            viewModel?.updateNotificationStatus()
        }
    }
    
    private func push(_ p:Push) {
        switch p {
        case .toCredits:
            let text = UIStoryboard(name: "Text", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
            text.modalPresentationStyle = .formSheet
            (text.viewControllers[0] as! TextViewController).viewModel = creditViewModel
            self.present(text, animated: true, completion: nil);break;
        case .toPrivacy:
            let url = URL(string: "https://shipmnt.co/privacy/")!
            let safari: SFSafariViewController = SFSafariViewController(url: url)
            self.present(safari, animated: true, completion: nil);break;
        case .toEula:
            let text = UIStoryboard(name: "Text", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
            text.modalPresentationStyle = .formSheet
            (text.viewControllers[0] as! TextViewController).viewModel = eulaViewModel
            self.present(text, animated: true, completion: nil);break;
        }
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
