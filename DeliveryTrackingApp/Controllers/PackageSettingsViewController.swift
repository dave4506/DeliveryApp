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
        case delete,offlineNotification,archive,offlineDelete,proPackArchive
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
        viewModel.saveableVar.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] enable in
            self.saveButton.isEnabled = enable
        }).addDisposableTo(viewModel.disposeBag)
        viewModel.prettyPackageVar.asObservable().subscribe(onNext:{ [unowned self] in
            if case let .complete(prettyPackage) = $0 {
                self.titleGroup.prettyPackage = prettyPackage;
            }
        }).disposed(by: viewModel.disposeBag)
        viewModel.changesVar.asObservable().subscribe(onNext:{ [unowned self] in
            if case let .setByPackage(changes) = $0 {
                self.titleTextField.input.text = changes.title
                let notifIndex = notificationOptions.index(where: { $0.notification == changes.notification});
                self.notificationOptionSelector.activeIndex = notifIndex!
                self.notificationOptionSelector.captionLabel.text = notificationOptions[notifIndex!].description
                self.setArchiveStatus(archived:changes.archived)
            }
        }).disposed(by: viewModel.disposeBag)
        self.titleTextField.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: { text in
            viewModel.modifyChanges(.title(text ?? ""))
        }).addDisposableTo(viewModel.disposeBag)
        self.notificationOptionSelector.activeIndexObservable?.subscribe(onNext: { [unowned self] notifIndex in
            self.notificationOptionSelector.captionLabel.text = notificationOptions[notifIndex].description
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.connectionModel?.connectionState.value == .disconnected {
                self.showAlert(.offlineNotification)
            }
            viewModel.modifyChanges(.notification(notificationOptions[notifIndex].notification))
        }).addDisposableTo(viewModel.disposeBag)
        self.archiveToggle.toggleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if viewModel.testForProPack() {
                if viewModel.provideArchiveWarning() {
                    self.showAlert(.archive)
                } else {
                    viewModel.modifyChanges(.archived)
                    self.setArchiveStatus(archived: viewModel.getArchive()!)
                }
            } else {
                self.showAlert(.proPackArchive)
            }
        }).addDisposableTo(viewModel.disposeBag)
        self.deleteToggle.toggleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.connectionModel?.connectionState.value == .disconnected {
                self.showAlert(.offlineDelete)
            } else {
                self.showAlert(.delete)
            }
        }).addDisposableTo(viewModel.disposeBag)
        self.saveButton?.rx.tap.subscribe(onNext: { _ in
            viewModel.savePackage()
            ProgressHUDStatus.showAndDismiss(.success(text: "Package Saved!"))
        }).addDisposableTo(viewModel.disposeBag)
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
        self.notificationOptionSelector.defaultIndex = (self.viewModel?.notificationOptionDefaultIndex)!
    }
}

extension PackageSettingsViewController {
    func showAlert(_ alert:Alert) {
        switch alert {
        case .delete:
            let okAction = CustomAlertAction(title: "Delete", style: .destructive) { [unowned self] alert in
                self.viewModel?.deletePackage();
                self.push(.pushToRoot(detail:"Package is deleted!"))
            }
            alertDefault(vc: self, alertViewStatus:AlertView.deleteConfirmation, actionOne: AlertHelper.generateCancelAction(), actionTwo: okAction);break;
        case .archive:
            let okAction = CustomAlertAction(title: "Got It", style: .destructive) { [unowned self] alert in
                self.viewModel?.modifyChanges(.archived)
                self.setArchiveStatus(archived: (self.viewModel?.getArchive())!)
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
        }
    }
    
    func push(_ p:SettingsPush) {
        switch p {
        case let .pushToRoot(detail):
            DispatchQueue.main.async() { [unowned self] in
                self.dismiss(animated: true, completion: { [unowned self] in
                    //self.packageDetailsVC?.setToDefaultState()
                    self.packageDetailsVC?.viewModel?.clearPackage()
                    self.packageDetailsVC?.dismiss(animated: true, completion: {
                        ProgressHUDStatus.showAndDismiss(.success(text: detail))
                    })
                })
            };break;
        }
    }
}
