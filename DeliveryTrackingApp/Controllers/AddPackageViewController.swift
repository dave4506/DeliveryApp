//
//  AddPackageViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AssistantKit
import Presentr

class AddPackageViewController: FormTableViewController {
    
    @IBOutlet weak var listTableView: ListTableView!
    @IBOutlet weak var copyButton: SideActionButton!
    @IBOutlet weak var notificationsSelectorCell: OptionSelectorContent!
    @IBOutlet weak var titleInputCell: TextfieldGroupContent!
    @IBOutlet weak var carrierSelectCell: SelectorContent!
    @IBOutlet weak var trackingInputCell: TextfieldGroupContent!
    @IBOutlet weak var doneButton: PrimaryButton!
    
    var viewModel: AddNewPackageViewModel!
    
    enum AddPush {
        case asyncDismiss,dismissSuccess(String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        configureTableView()
        hideKeyboardWhenTappedAround()
        bindViewModel()
        configureVisualComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        detectAndPresentOfflineAlertView()
    }
    
    func detectAndPresentOfflineAlertView() {
        if DelegateHelper.connectionState() == .disconnected {
            showAlert(.offline)
        }
    }
    
    func bindViewModel() {
        // Initiate View Model
        self.viewModel = AddNewPackageViewModel()
        // Add options
        generateNotificationOptions()
        // Bind button creatable to enable
        self.viewModel.creatable.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] enable in
            self.doneButton.isEnabled = enable
        }).disposed(by: self.viewModel.disposeBag)
        // Input text bind for tracking number
        trackingInputCell.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] in
            self.viewModel.trackingPackageNumberVar.value = $0?.uppercased() ?? ""
        }).disposed(by: self.viewModel.disposeBag)
        // Input text bind for title input
        titleInputCell.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] in
            self.viewModel.packageTitleVar.value = $0 ?? ""
        }).disposed(by: self.viewModel.disposeBag)
        // Input options for notification options
        notificationsSelectorCell.activeIndexObservable?.filter({ $0 != -1 }).subscribe(onNext: { [unowned self] in
            self.notificationsSelectorCell.captionLabel.text = notificationOptions[$0].description
            self.viewModel.notificationStateVar.value = notificationOptions[$0].notification
        }).disposed(by: self.viewModel.disposeBag)
        
        copyButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.trackingInputCell.input.text = self.viewModel.copy()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.copyableVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] hidden in
            self.copyButton.ishiddenSideways = hidden
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.alertStatusVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] alert in
            self.showAlert(alert)
        }).disposed(by: self.viewModel.disposeBag)

        self.viewModel.carrierOptionsVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] in
            self.carrierSelectCell.selections = $0.map {
                return $0.1
            }
        }).disposed(by: self.viewModel.disposeBag)
        //NOTE THE CARRIER ONLY OVERWRITES THE LABEL DOESNT CHANGE INDEX ... NOT A GOOD SOLUTION
        self.viewModel.carrierVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext:{ [unowned self] carrier in
            self.carrierSelectCell.selectedLabel.text = carrier.description
        }).disposed(by: self.viewModel.disposeBag)
        
        self.doneButton?.rx.tap.subscribe(onNext:{ [unowned self] _ in
            if self.viewModel.proPackStatus.value {
                if self.viewModel.validatePackageForm() {
                    self.createPackage()
                }
            } else if self.viewModel.notificationStateVar.value != .none {
                self.showAlert(.proPackNotification)
            } else {
                if self.viewModel.validatePackageForm() {
                    self.createPackage()
                }
            }
        }).disposed(by: self.viewModel.disposeBag)
        
        self.carrierSelectCell.rxCurrentSelection.subscribe(onNext:{ [unowned self] index in
            self.viewModel.carrierVar.value = self.viewModel.carrierOptionsVar.value[index].0
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.proPackStatus.asObservable().subscribe(onNext:{ [unowned self] val in
            self.notificationsSelectorCell.setActiveIndex(by: .defaultActive, index: val ? 1:0)
            self.notificationsSelectorCell.captionLabel.text = notificationOptions[val ? 1:0].description
            self.viewModel.notificationStateVar.value = notificationOptions[val ? 1:0].notification
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    func createPackage() {
        viewModel.createPackage()
        push(.dismissSuccess("Package Added!"))
    }
    
    func generateNotificationOptions() {
        notificationOptions.forEach { [weak self] notificationOption in
            self?.notificationsSelectorCell.addOption(label: notificationOption.label)
        }
        self.notificationsSelectorCell.setActiveIndex(by: .defaultActive, index: 1)
    }
    
    func configureVisualComponents() {
        self.carrierSelectCell.indexPath = IndexPath(row: 1, section: 0)
        self.carrierSelectCell.tableView = tableView
        self.notificationsSelectorCell.tableview = tableView
        self.trackingInputCell.icon = Assets.logo.label
        self.trackingInputCell.input.placeholder = "What's the tracking number?"
        self.trackingInputCell.input.autocorrectionType = .no
        self.titleInputCell.input.placeholder = "What's inside?"
        self.carrierSelectCell.titleLabel.text = "Carrier: "
        self.trackingInputCell.bringSubview(toFront: self.copyButton)
    }
}

extension AddPackageViewController {

    func showAlert(_ alert:AddNewPackageAlert) {
        let okAction = CustomAlertAction(title: "Create", style: .custom(textColor: Color.primary)) { [unowned self] in
            self.createPackage()
            self.push(.asyncDismiss)
        }
        switch alert {
        case let .invalidNumber(number):
            alertDefault(vc: self, alertViewStatus:AlertView.invalidTrackingNumberWarning(number), actionOne: AlertHelper.generateCancelAction(), actionTwo: okAction);break;
        case .offline:
            alertDefault(vc: self, alertViewStatus:AlertView.offlineWarning, actionOne: AlertHelper.generateCancelAction(), actionTwo: nil);break;
        case let .differentCarrier(carrier,chosen,guess):
            alertDefault(vc: self, alertViewStatus:AlertView.conflictCarrierWarning(carrier,chosen,guess), actionOne: AlertHelper.generateCancelAction(), actionTwo: okAction);break;
        case .proPackNotification:
            let okAction = CustomAlertAction(title: "Got It", style: .custom(textColor:Color.primary),handler:{ [unowned self] in
                self.notificationsSelectorCell.activeIndex = 0
            })
            alertDefault(vc: self, alertViewStatus:AlertView.proPackNotificationWarning, actionOne: okAction, actionTwo: nil);break;
        default:break;
        }
    }
    
    func push(_ p:AddPush) {
        switch p {
        case let .dismissSuccess(s):
            self.dismiss(animated: true, completion: {
                ProgressHUDStatus.showAndDismiss(.success(text: s))
            });break;
        case .asyncDismiss:
            DispatchQueue.main.async() { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            };break;
        }
    }
}
