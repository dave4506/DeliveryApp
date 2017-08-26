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
    
    @IBOutlet var listTableView: ListTableView!
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detectAndPresentOfflineAlertView() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.connectionModel?.connectionState.value == .disconnected {
            showAlert(.offline)
        }
    }
    
    func bindViewModel() {
        // Initiate View Model
        self.viewModel = AddNewPackageViewModel()
        self.viewModel.userModel = UserModel()
        // Add options
        generateNotificationOptions()
        // Bind button creatable to enable
        self.viewModel.creatable.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] enable in
            self.doneButton.isEnabled = enable
        }).addDisposableTo(self.viewModel.disposeBag)
        // Input text bind for tracking number
        trackingInputCell.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] in
            self.viewModel.trackingPackageNumberVar.value = $0?.uppercased() ?? ""
        }).addDisposableTo(self.viewModel.disposeBag)
        // Input text bind for title input
        titleInputCell.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] in
            self.viewModel.packageTitleVar.value = $0 ?? ""
        }).addDisposableTo(self.viewModel.disposeBag)
        // Input options for notification options
        notificationsSelectorCell.activeIndexObservable?.subscribe(onNext: { [unowned self] in
            self.notificationsSelectorCell.captionLabel.text = notificationOptions[$0].description
            self.viewModel.notificationStatusVar.value = notificationOptions[$0].notification
        }).addDisposableTo(self.viewModel.disposeBag)
        
        copyButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.viewModel.copy()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.copyBoardTrackingPackageNumberVar.asObservable().subscribe(onNext: { [unowned self] copy in
            self.trackingInputCell.input.text = copy
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.alertStatusVar.asObservable().subscribe(onNext: { [unowned self] alert in
            self.showAlert(alert)
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.copyableVar.asObservable().subscribe(onNext: { [unowned self] hidden in
            self.copyButton.ishiddenSideways = hidden
        }).addDisposableTo(self.viewModel.disposeBag)

        self.viewModel.carrierOptionsVar.asObservable().subscribe(onNext: { [unowned self] in
            self.carrierSelectCell.selections = $0.map {
                return $0.1
            }
        }).addDisposableTo(self.viewModel.disposeBag)
        //NOTE THE CARRIER ONLY OVERWRITES THE LABEL DOESNT CHANGE INDEX ... NOT A GOOD SOLUTION
        self.viewModel.carrierVar.asObservable().subscribe(onNext:{ [unowned self] carrier in
            self.carrierSelectCell.selectedLabel.text = carrier.description
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.doneButton?.rx.tap.subscribe(onNext:{ [unowned self] _ in
            if self.viewModel.validatePackageForm() {
                self.createPackage()
            }
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.carrierSelectCell.rxCurrentSelection.subscribe(onNext:{ [unowned self] index in
            self.viewModel.carrierVar.value = self.viewModel.carrierOptionsVar.value[index].0
        }).addDisposableTo(self.viewModel.disposeBag)
    }
    
    func createPackage() {
        viewModel.createPackage()
        push(.dismissSuccess("Package Added!"))
    }
    
    func generateNotificationOptions() {
        notificationOptions.forEach { [weak self] notificationOption in
            self?.notificationsSelectorCell.addOption(label: notificationOption.label)
        }
        self.notificationsSelectorCell.defaultIndex = self.viewModel.notificationOptionDefaultIndex
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
        let okAction = CustomAlertAction(title: "Create", style: .custom(textColor: Color.primary)) { [unowned self] alert in
            self.createPackage()
        }
        switch alert {
        case let .invalidNumber(number):
            alertDefault(vc: self, alertViewStatus:AlertView.invalidTrackingNumberWarning(number), actionOne: AlertHelper.generateCancelAction(), actionTwo: okAction);break;
        case .offline:
            alertDefault(vc: self, alertViewStatus:AlertView.offlineWarning, actionOne: AlertHelper.generateCancelAction(), actionTwo: nil);break;
        case let .differentCarrier(carrier,chosen,guess):
            alertDefault(vc: self, alertViewStatus:AlertView.conflictCarrierWarning(carrier,chosen,guess), actionOne: AlertHelper.generateCancelAction(), actionTwo: okAction);break;
        default:break;
        }
    }
    
    func push(_ p:AddPush) {
        switch p {
        case let .dismissSuccess(s):
            self.dismiss(animated: true, completion: { _ in
                ProgressHUDStatus.showAndDismiss(.success(text: s))
            });break;
        case .asyncDismiss:
            DispatchQueue.main.async() { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            };break;
        }
    }
}