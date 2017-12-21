//
//  PackageSettingsViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 3/3/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AssistantKit

class PackageSettingsViewController: FormTableViewController {
    
    @IBOutlet weak var saveButton: PrimaryButton!
    @IBOutlet weak var titleGroup: TitleGroupContent!
    @IBOutlet weak var titleTextField: TextfieldGroupContent!
    @IBOutlet weak var notificationOptionSelector: OptionSelectorContent!
    @IBOutlet weak var archiveToggle: ToggleSelectorContent!
    @IBOutlet weak var deleteToggle: ToggleSelectorContent!
    
    var viewModel:PackageSettingsViewModel?
    weak var packageDetailsVC: PackageDetailsViewController?
    
    enum Alert {
        case delete,offlineNotification,archive,offlineDelete,proPackArchive,proPackNotification
    }
    
    enum SettingsPush {
        case pushToRoot(detail:String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavButton()
        hideKeyboardWhenTappedAround()
        bindViewModel()
        configureVisualComponents()
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        generateNotificationOptions()
        
        viewModel.saveableVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] enable in
            self.saveButton.isEnabled = enable
        }).disposed(by: viewModel.disposeBag)
        
        self.titleGroup.prettyPackage = viewModel.prettyPackage;

        viewModel.formObservable.subscribe(onNext:{ [unowned self] (t,n,a) in
            self.titleTextField.input.text = t
            let notifIndex = notificationOptions.index(where: { $0.notification == n});
            self.notificationOptionSelector.setActiveIndex(by: .defaultActive, index: notifIndex!)
            self.notificationOptionSelector.captionLabel.text = notificationOptions[notifIndex!].description
            self.setArchiveStatus(archived:a)
        }).disposed(by: viewModel.disposeBag)
        
        self.titleTextField.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: { text in
            viewModel.titleInputVar.value = text ?? ""
        }).disposed(by: viewModel.disposeBag)
        
        self.notificationOptionSelector.activeIndexObservable?.filter({ $0 != -1 }).subscribe(onNext: { [unowned self] notifIndex in
            self.notificationOptionSelector.captionLabel.text = notificationOptions[notifIndex].description
            if DelegateHelper.connectionState() == .disconnected {
                self.showAlert(.offlineNotification)
            }
            viewModel.notificationInputVar.value = notificationOptions[notifIndex].notification
        }).disposed(by: viewModel.disposeBag)
        
        self.archiveToggle.toggleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if viewModel.proPackStatus.value {
                if viewModel.showArchiveWarning() {
                    self.showAlert(.archive)
                } else {
                    viewModel.archivedInputVar.value = !viewModel.archivedInputVar.value
                    self.setArchiveStatus(archived: (self.viewModel!.archivedInputVar.value))
                }
            } else {
                self.showAlert(.proPackArchive)
            }
        }).disposed(by: viewModel.disposeBag)
        
        self.deleteToggle.toggleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if DelegateHelper.connectionState() == .disconnected {
                self.showAlert(.offlineDelete)
            } else {
                self.showAlert(.delete)
            }
        }).disposed(by: viewModel.disposeBag)
        
        self.saveButton!.rx.tap.subscribe(onNext: { [unowned self] _ in
            if viewModel.proPackStatus.value {
                viewModel.updatePackage()
                ProgressHUDStatus.showAndDismiss(.success(text: "Package Saved!"))
                self.push(Push.dismiss)
            } else if viewModel.notificationInputVar.value != .none {
                self.showAlert(.proPackNotification)
            } else {
                viewModel.updatePackage()
                ProgressHUDStatus.showAndDismiss(.success(text: "Package Saved!"))
                self.push(Push.dismiss)
            }
        }).disposed(by: viewModel.disposeBag)
    }

    func setArchiveStatus(archived:Bool) {
        if archived {
            self.archiveToggle.titleLabel.text = "Unarchive?"
            self.archiveToggle.setToggleTitle(status: "Bring it back!")
        } else {
            self.archiveToggle.titleLabel.text = "Archive?"
            self.archiveToggle.setToggleTitle(status: "Yes")
        }
    }
    
    func configureVisualComponents() {
        self.notificationOptionSelector.tableview = tableView
        self.titleTextField.input.placeholder = "Edit what's inside"
        self.deleteToggle.titleLabel.text = "Delete Package"
        self.deleteToggle.setToggleTitle(status: "Yes,take it away!")
    }
    
    func generateNotificationOptions() {
        notificationOptions.forEach { [weak self] notificationOption in
            self?.notificationOptionSelector.addOption(label: notificationOption.label)
        }
        self.notificationOptionSelector.setActiveIndex(by: .defaultActive, index: 1)
    }
}

extension PackageSettingsViewController {
    func showAlert(_ alert:Alert) {
        switch alert {
        case .delete:
            let okAction = CustomAlertAction(title: "Delete", style: .destructive) { [unowned self] in
                self.viewModel?.deletePackage();
                self.push(.pushToRoot(detail:"Package is deleted!"))
            }
            alertDefault(vc: self, alertViewStatus:AlertView.deleteConfirmation, actionOne: AlertHelper.generateCancelAction(), actionTwo: okAction);break;
        case .archive:
            let okAction = CustomAlertAction(title: "Got It", style: .destructive) { [unowned self] in
                self.viewModel!.archivedInputVar.value = !self.viewModel!.archivedInputVar.value
                self.setArchiveStatus(archived: (self.viewModel!.archivedInputVar.value))
            }
            alertDefault(vc: self, alertViewStatus:AlertView.archiveConfirmation, actionOne: AlertHelper.generateCancelAction(), actionTwo: okAction);break;
        case .offlineDelete:
            let cancelAction = CustomAlertAction(title: "Got It.", style: .custom(textColor: Color.primary),handler:nil)
            alertDefault(vc: self, alertViewStatus:AlertView.deleteDisabledWarning, actionOne: cancelAction, actionTwo: nil);break;
        case .offlineNotification:
            let okAction = CustomAlertAction(title: "Got It", style: .custom(textColor:Color.primary),handler:nil)
            alertDefault(vc: self, alertViewStatus:AlertView.offlineNotificationWarning, actionOne: okAction, actionTwo: nil);break;
        case .proPackArchive:
            let okAction = CustomAlertAction(title: "Got It", style: .custom(textColor:Color.primary),handler:nil)
            alertDefault(vc: self, alertViewStatus:AlertView.proPackArchiveWarning, actionOne: okAction, actionTwo: nil);break;
        case .proPackNotification:
            let okAction = CustomAlertAction(title: "Got It", style: .custom(textColor:Color.primary),handler:nil)
            alertDefault(vc: self, alertViewStatus:AlertView.proPackNotificationWarning, actionOne: okAction, actionTwo: nil);break;
        }
    }
    
    func push(_ p:SettingsPush) {
        switch p {
        case let .pushToRoot(detail):
            DispatchQueue.main.async() { [unowned self] in
                self.dismiss(animated: true, completion: { [unowned self] in
                    self.packageDetailsVC?.dismiss(animated: true, completion: {
                        ProgressHUDStatus.showAndDismiss(.success(text: detail))
                    })
                })
            };break;
        }
    }
}
