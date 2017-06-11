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

class PackageSettingsViewController: UITableViewController {
    
    var listView:ListTableView?
    var doneButton:PrimaryButton?
    var viewModel:PackageSettingsViewModel!
    let throttleInterval = 0.1

    @IBOutlet weak var titleGroup: TitleGroupContent!
    @IBOutlet weak var titleTextField: TextfieldGroupContent!
    @IBOutlet weak var notificationOptionSelector: OptionSelectorContent!
    @IBOutlet weak var archiveToggle: ToggleSelectorContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavButton()
        hideKeyboardWhenTappedAround()
        generatePrimaryButton()
        bindViewModel()
        bindVisualComponents()
    }
    
    func configureTableView() {
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        tableView.backgroundView = gradientView
        tableView.delegate = self
        listView = tableView as? ListTableView
        listView?.setSectionHeader(height: 20)
        listView?.setSectionFooter(height: 100)
        listView?.generateNavBarOpacity(offset: 80, navigationController: self.navigationController)
    }
    func bindViewModel() {
        viewModel = PackageSettingsViewModel()
        viewModel.prettyPackage.value = .complete(prettyPackage: MockPackages.one)
        generateNotificationOptions()
        viewModel.saveable.observeOn(MainScheduler.instance).subscribe(onNext: { enable in
            self.doneButton?.isEnabled = enable
        }).addDisposableTo(self.viewModel.disposeBag)
        viewModel.prettyPackage.asObservable().subscribe(onNext:{ [weak self] prettyPackageStatus in
            switch prettyPackageStatus {
            case let .complete(prettyPackage):
                self?.titleGroup.prettyPackage = prettyPackage;
                break;
            default: break;
            }
        }).disposed(by: viewModel.disposeBag)
        viewModel.changes.asObservable().subscribe(onNext:{ [weak self] changeStatus in
            print(changeStatus)
            switch changeStatus {
            case let .setByPackage(changes):
                if let title = changes.title {
                    self?.titleTextField.input.text = title
                }
                let notifIndex = self?.viewModel.notificationOptions.index(where: { $0.notification == changes.notification});
                self?.notificationOptionSelector.activeIndex = notifIndex!
                self?.notificationOptionSelector.captionLabel.text = self?.viewModel.notificationOptions[notifIndex!].description
                self?.setArchiveStatus(archived:changes.archived)
                break;
            default: break;
            }
        }).disposed(by: viewModel.disposeBag)
        self.titleTextField.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] text in
            switch (self?.viewModel.changes.value)! {
            case let .complete(changes):
                var newChanges = changes
                newChanges.title = (text?.isEmpty)! ? nil : text
                self?.viewModel.changes.value = .complete(changes:newChanges)
            case let .setByPackage(changes):
                var newChanges = changes
                newChanges.title = (text?.isEmpty)! ? nil : text
                self?.viewModel.changes.value = .complete(changes:newChanges)
            default: break;
            }
        }).addDisposableTo(self.viewModel.disposeBag)
        self.notificationOptionSelector.activeIndexObservable?.subscribe(onNext: { [weak self] notifIndex in
            self?.notificationOptionSelector.captionLabel.text = self?.viewModel.notificationOptions[notifIndex].description
            switch (self?.viewModel.changes.value)! {
            case let .complete(changes):
                var newChanges = changes
                newChanges.notification = self?.viewModel.notificationOptions[notifIndex].notification
                self?.viewModel.changes.value = .complete(changes:newChanges)
            case let .setByPackage(changes):
                var newChanges = changes
                newChanges.notification = self?.viewModel.notificationOptions[notifIndex].notification
                self?.viewModel.changes.value = .complete(changes:newChanges)
            default: break;
            }
        }).addDisposableTo(self.viewModel.disposeBag)
        self.archiveToggle.toggleButton.rx.tap.subscribe(onNext: { [weak self] _ in
            switch (self?.viewModel.changes.value)! {
            case let .complete(changes):
                var newChanges = changes
                newChanges.archived = !newChanges.archived
                self?.setArchiveStatus(archived: newChanges.archived)
                self?.viewModel.changes.value = .complete(changes:newChanges)
            case let .setByPackage(changes):
                var newChanges = changes
                newChanges.archived = !newChanges.archived
                self?.viewModel.changes.value = .complete(changes:newChanges)
                self?.setArchiveStatus(archived: newChanges.archived)
            default: break;
            }
        }).addDisposableTo(self.viewModel.disposeBag)
        self.doneButton?.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel.savePackage()
        }).addDisposableTo(self.viewModel.disposeBag)
    }

    func setArchiveStatus(archived:Bool) {
        if archived {
            self.archiveToggle.titleLabel.text = "Unarchive?"
            self.archiveToggle.setToggleTitle(status: "Yes, bring it back!")
        } else {
            self.archiveToggle.titleLabel.text = "Archive?"
            self.archiveToggle.setToggleTitle(status: "Yes.")
        }
    }
    
    func bindVisualComponents() {
        self.notificationOptionSelector.tableview = tableView
        self.titleTextField.input.placeholder = "Edit what's inside"
    }
    
    func generateNotificationOptions() {
        self.viewModel.notificationOptions.forEach { [weak self] notificationOption in
            self?.notificationOptionSelector.addOption(label: notificationOption.label)
        }
        self.notificationOptionSelector.defaultIndex = self.viewModel.notificationOptionDefaultIndex
    }
    
    
    func configureNavButton() {
        var image = Assets.logo.cross.gray
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    func generatePrimaryButton() {
        doneButton = PrimaryButton()
        doneButton?.setTitle("SAVE CHANGES",for:.normal)
        self.navigationController?.view.addSubview(doneButton!)
        setButtonViewContraints(view:doneButton!,parent:(self.navigationController?.view)!)
    }
}

extension PackageSettingsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
