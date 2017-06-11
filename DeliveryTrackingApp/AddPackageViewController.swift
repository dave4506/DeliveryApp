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

class AddPackageViewController: UITableViewController {
    
    @IBOutlet var listTableView: ListTableView!
    @IBOutlet weak var copyButton: SideActionButton!
    @IBOutlet weak var notificationsSelectorCell: OptionSelectorContent!
    @IBOutlet weak var titleInputCell: TextfieldGroupContent!
    @IBOutlet weak var carrierSelectCell: SelectorContent!
    @IBOutlet weak var trackingInputCell: TextfieldGroupContent!
    
    let throttleInterval = 0.1
    var listView:ListTableView?
    var doneButton:PrimaryButton?
    let disposeBag = DisposeBag()
    var viewModel: AddNewPackageViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        configureTableView()
        generatePrimaryButton()
        hideKeyboardWhenTappedAround()
        bindVisualComponents()
        configureViewModels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.checkCopyable()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func generateMapConstraints(view: UIView,parent:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 210)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: -10)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: -70)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: -50)
        NSLayoutConstraint.activate([heightConstraint,topConstraint,leadingConstraint,trailingConstraint])
        view.layoutIfNeeded()
    }
    
    func configureViewModels() {
        // Initiate View Model
        self.viewModel = AddNewPackageViewModel()
        self.viewModel.userModel = UserModel()
        // Add options
        generateNotificationOptions()
        // Bind button creatable to enable
        self.viewModel.creatable.observeOn(MainScheduler.instance).subscribe(onNext: { enable in
            self.doneButton?.isEnabled = enable
        }).addDisposableTo(self.viewModel.disposeBag)
        // Input text bind for tracking number
        trackingInputCell.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: {
            self.viewModel.trackingPackageNumber.value = $0 ?? ""
        }).addDisposableTo(self.viewModel.disposeBag)
        // Input text bind for title input
        titleInputCell.input.rx.text.throttle(throttleInterval, scheduler: MainScheduler.instance).subscribe(onNext: {
            self.viewModel.packageTitle.value = $0 ?? ""
        }).addDisposableTo(self.viewModel.disposeBag)
        // Input options for notification options
        self.notificationsSelectorCell.activeIndexObservable?.subscribe(onNext: {
            self.notificationsSelectorCell.captionLabel.text = self.viewModel.notificationOptions[$0].description
            self.viewModel.notificationStatus.value = self.viewModel.notificationOptions[$0].notification
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.copyBoardTrackingPackageNumber.asObservable().subscribe(onNext: { [weak self] copy in
            self?.trackingInputCell.input.text = copy
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.copyButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel.copy()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.copyable.subscribe(onNext: { [weak self] hidden in
            self?.copyButton.ishiddenSideways = hidden
        }).addDisposableTo(self.viewModel.disposeBag)
        //test
        self.viewModel.carrierOptions.asObservable().subscribe(onNext: { [weak self] carrierOptions in
            self?.carrierSelectCell.selections = carrierOptions.map {
                return $0.simpleTableData
            }
        }).addDisposableTo(self.viewModel.disposeBag)
        //NOTE THE CARRIER ONLY OVERWRITES THE LABEL DOESNT CHANGE INDEX ... NOT A GOOD SOLUTION
        self.viewModel.carrier.asObservable().subscribe(onNext:{ [weak self] carrier in
            self?.carrierSelectCell.selectedLabel.text = carrier.description
        }).addDisposableTo(self.viewModel.disposeBag)
        self.doneButton?.rx.tap.subscribe(onNext:{ [weak self] _ in
            print("tap?????")
            self?.viewModel.createPackage()
        }).addDisposableTo(self.viewModel.disposeBag)
        self.carrierSelectCell.rxCurrentSelection.subscribe(onNext:{ [weak self] index in
            print("Index tapped: \(index)")
            self?.viewModel.carrier.value = (self?.viewModel.carrierOptions.value[index].carrier)!
        }).addDisposableTo(self.viewModel.disposeBag)
    }
    
    func generateNotificationOptions() {
        // Add options
        self.viewModel.notificationOptions.forEach { [weak self] notificationOption in
            self?.notificationsSelectorCell.addOption(label: notificationOption.label)
        }
        // Set default notification setting
        self.notificationsSelectorCell.defaultIndex = self.viewModel.notificationOptionDefaultIndex
    }
    
    func bindVisualComponents() {
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
    
    func configureTableView() {
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        let coloredView = ColoredView()
        coloredView.backgroundColor = Color.secondary
        coloredView.alpha = 0.2
        gradientView.addSubview(coloredView)
        generateMapConstraints(view: coloredView,parent: gradientView)
        tableView.backgroundView = gradientView
        tableView.delegate = self
        listView = tableView as! ListTableView?
        listView?.setSectionHeader(height: 20)
        listView?.setSectionFooter(height: 100)
        listView?.generateNavBarOpacity(offset: 80, navigationController: self.navigationController)
    }
    
    func configureNavButton() {
        var image = Assets.logo.cross.gray
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    func generatePrimaryButton() {
        doneButton = PrimaryButton()
        doneButton?.setTitle("START TRACKING",for:.normal)
        self.navigationController?.view.addSubview(doneButton!)
        setButtonViewContraints(view:doneButton!,parent:(self.navigationController?.view)!)
    }
}
