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
import GSKStretchyHeaderView

class PackageDetailsViewController: UITableViewController {
    
    @IBOutlet var listView: ListTableView!
    
    let disposeBag = DisposeBag()
    var viewModel:PackageDetailsViewModel?
    var isCollapsed:Bool? = false
    var stretchyHeader:PackageDetailsBigPictureView?
    var titleSubContent:TitleSubContent?
    var websiteSubContent:TitleSubContent?
    var datasourceModel:PackageDetailsDataSourceModel?
    
    enum Push {
        case dismiss, pushToSettings, pushToWebsite
    }
    
    enum State {
        case empty, loaded
    }

    func set(to state:State) {
        switch state {
        case .empty:
            stretchyHeader?.mapControl!.isHidden = true
            stretchyHeader?.titleGroup!.isHidden = true
            titleSubContent!.isHidden = true
            websiteSubContent!.isHidden = true
            break;
        case .loaded:
            stretchyHeader?.mapControl!.isHidden = false
            stretchyHeader?.titleGroup!.isHidden = false
            titleSubContent!.isHidden = false
            websiteSubContent!.isHidden = false
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("😀😀😀😀😀 view did load for package details")
        (navigationController as! ClearNavigationViewController).configureBackground(addColorView: false, color: nil)
        configureNavButton()
        setUpHeaderView()
        generateHeaderView()
        generateFooterView()
        listView.setSectionFooter(height: 100)
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewModel = self.viewModel {
            viewModel.pullPackage()
        }
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.prettyPackageVar.asObservable().observeOn(MainScheduler.instance).subscribe(onNext:{ [unowned self] prettyPackageStatus in
            switch prettyPackageStatus {
            case .unintiated:
                self.set(to:.empty)
                self.stretchyHeader?.mapView?.trails = []
                break;
            case let .loadingNotrail(prettyPackage):
                self.set(to:.loaded)
                SVProgressHUD.dismiss()
                self.stretchyHeader?.titleGroup?.prettyPackage = prettyPackage;
                self.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                self.stretchyHeader?.mapView?.isLoading = true
                break;
            case let .complete(prettyPackage):
                self.set(to:.loaded)
                SVProgressHUD.dismiss()
                self.stretchyHeader?.titleGroup?.prettyPackage = prettyPackage;
                self.stretchyHeader?.mapView?.isLoading = false
                self.stretchyHeader?.mapView?.trails = [prettyPackage.trail!]
                self.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                break;
            default: break;
            }
        }).disposed(by: viewModel.disposeBag)
        tableView.dataSource = nil
        let datasourceModel = PackageDetailsDataSourceModel(tableView: tableView)
        datasourceModel.registerCells()
        datasourceModel.bindTableView(observable: viewModel.prettyPackageVar.asObservable().map { status -> [DetailsListViewCellData] in
            switch status {
            case .loadingNotrail: fallthrough;
            case .complete:
                var arr:[DetailsListViewCellData] = [];
                arr.append(DetailsListViewCellData.topCap)
                viewModel.trackingHistoryVar.value.forEach {
                    arr.append(DetailsListViewCellData.trackingTitle($0))
                    $0.trackingHistory.forEach { h in
                        arr.append(DetailsListViewCellData.trackingContent(h))
                    }
                };
                arr.append(DetailsListViewCellData.bottomCap)
                if arr.count == 2 {
                    return [DetailsListViewCellData.empty]
                }
                return arr
            default:
                return []
            }
            }.map { return [DetailsListViewSectionData(header:"",items:$0)] }, disposeBy: disposeBag)
    }
    
    func configureNavButton() {
        var image = Assets.logo.cross.gray
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.dismiss)
        }).disposed(by: disposeBag)
        image = Assets.logo.refresh
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] _ in
            if DelegateHelper.connectionState() == .connected {
                if let viewModel = self?.viewModel {
                    switch viewModel.prettyPackageVar.value {
                    case .unintiated: break;
                    default: viewModel.pullPackage(); ProgressHUDStatus.generateStatusHudStyle(); SVProgressHUD.show();
                    }
                }
            } else {
                ProgressHUDStatus.showAndDismiss(.error(text:"Can't update now."))
            }
        }).disposed(by: disposeBag)
        configureNavOnCollapse()
    }
    
    func configureNavOnCollapse() {
        if let collapsed = isCollapsed {
            if !collapsed {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
        if let collapsed = self.splitViewController?.isCollapsed {
            if !collapsed {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    func push(_ p:Push) {
        switch p {
        case .dismiss:
            self.dismiss(animated: true, completion: nil);break;
        case .pushToSettings:
            if let prettyPackage = self.viewModel?.getPrettyPackage() {
                let packageSettingsNav = UIStoryboard(name: "PackageSettings", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
                let packageSettings = packageSettingsNav.viewControllers[0] as! PackageSettingsViewController
                let viewModel = PackageSettingsViewModel(prettyPackage)
                packageSettings.viewModel = viewModel
                packageSettings.packageDetailsVC = self
                packageSettingsNav.modalPresentationStyle = .formSheet
                self.present(packageSettingsNav, animated: true, completion: nil)
            };break;
        case .pushToWebsite:
            if let prettyPackage = self.viewModel?.getPrettyPackage() {
                let url = URL(string: Carrier.convertToUrl(carrier: (prettyPackage.package?.carrier)!, trackingNum: prettyPackage.trackingNumber)!)
                let safari: SFSafariViewController = SFSafariViewController(url: url!)
                self.present(safari, animated: true, completion: nil);break;
            }
        }
    }
}

extension PackageDetailsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setDefaultHeight()
        configureNavOnCollapse()
        DispatchQueue.main.async() { [unowned self] in
            self.setDefaultHeight()
            self.stretchyHeader?.titleGroup?.redrawProgress()
        }
    }
}

extension PackageDetailsViewController {
    
    func setUpHeaderView() {
        stretchyHeader = PackageDetailsBigPictureView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 164))
        self.tableView.addSubview(stretchyHeader!)
        setDefaultHeight()
        stretchyHeader?.minimumContentHeight = 154 + 64;
        stretchyHeader?.contentExpands = false;
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func setDefaultHeight() {
        let height = self.view.bounds.height
        var defaultHeaderHeight:CGFloat = 0.0;
        if height > 528 {
            defaultHeaderHeight = 528;
        }
        if height < 528 {
            defaultHeaderHeight = height - 50;
        }
        stretchyHeader?.maximumContentHeight = defaultHeaderHeight;
    }
    
    func generateHeaderView() {
        listView.setSectionHeader(height: 50)
        titleSubContent = TitleSubContent()
        titleSubContent!.settingsButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.pushToSettings)
        }).disposed(by: disposeBag)
        tableView.tableHeaderView?.addSubview(titleSubContent!)
        setTitleSubViewContraints(view: titleSubContent!, parent: tableView.tableHeaderView!)
    }
    
    func generateFooterView() {
        websiteSubContent = TitleSubContent()
        tableView.tableFooterView?.addSubview(websiteSubContent!)
        setWebsiteSubViewContraints(view: websiteSubContent!, parent: tableView.tableFooterView!)
        websiteSubContent?.descriptionLabel.text = "Track on Website"
        websiteSubContent?.descriptionLabel.isUserInteractionEnabled = false
        websiteSubContent!.settingsButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.pushToWebsite)
        }).disposed(by: disposeBag)
        websiteSubContent?.settingsButton.customSpacing = false
        websiteSubContent?.settingsButton.setTitle("View", for: .normal)
    }
    
    func setTitleSubViewContraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
    }
    
    func setWebsiteSubViewContraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,heightConstraint])
        view.layoutIfNeeded()
    }

}
