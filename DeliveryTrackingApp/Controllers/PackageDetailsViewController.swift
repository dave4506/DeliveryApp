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

class PackageViewCell:UITableViewCell {
    @IBOutlet weak var detailContent: DetailDropDownContent!
}

enum DetailCellIdentifiers: String {
    case title
    case details
}

struct CellData {
    let identifier:DetailCellIdentifiers
    let content:AnyObject?
}

class PackageDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: ListTableView!
    
    let disposeBag = DisposeBag()
    var viewModel:PackageDetailsViewModel?
    var isCollapsed:Bool? = false
    var headerView:PackageDetailsBigPictureView?
    var titleSubContent:TitleSubContent?
    var websiteSubContent:TitleSubContent?
    var datasourceModel:PackageDetailsDataSourceModel?
    
    deinit {
        print("deiniting...")
    }
    
    enum Push {
        case dismiss, pushToSettings, pushToWebsite
    }
    
    enum State {
        case empty, loaded
    }

    func set(to state:State) {
        switch state {
        case .empty:
            headerView!.mapControl!.isHidden = true
            headerView!.titleGroup!.isHidden = true
            titleSubContent!.isHidden = true
            websiteSubContent!.isHidden = true
            break;
        case .loaded:
            headerView!.mapControl!.isHidden = false
            headerView!.titleGroup!.isHidden = false
            titleSubContent!.isHidden = false
            websiteSubContent!.isHidden = false
            break;
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
                let url = URL(string: Carrier.convertToUrlString(carrier: (prettyPackage.package?.carrier)!, trackingNum: prettyPackage.trackingNumber)!)
                let safari: SFSafariViewController = SFSafariViewController(url: url!)
                self.present(safari, animated: true, completion: nil);break;
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        configureBackground(addColorView: false, color: nil)
        tableView.delegate = self
        setUpHeaderView()
        generateHeaderView()
        generateFooterView()
        tableView.setSectionFooter(height: 100)
        bindViewModel()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewModel = self.viewModel {
            viewModel.pullPackage()
        }
    }
    
    func registerCells() {
            tableView.register(UINib(nibName: "SmallStateCardTableViewCell", bundle: nil), forCellReuseIdentifier: "loading")
    }
    
    func setUpHeaderView() {
        headerView = PackageDetailsBigPictureView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 164))
        setDefaultHeight()
        headerView?.minimumContentHeight = 154 + 64;
        headerView?.contentExpands = false;
        self.tableView.addSubview(headerView!)
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
        print("defaultHeaderHeight: \(defaultHeaderHeight)")
        headerView?.maximumContentHeight = defaultHeaderHeight;
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.prettyPackageVar.asObservable().subscribe(onNext:{ [unowned self] prettyPackageStatus in
            switch prettyPackageStatus {
            case .unintiated:
                self.set(to:.empty)
                self.headerView?.mapView?.trails = []
                break;
            case let .loadingNotrail(prettyPackage):
                self.set(to:.loaded)
                SVProgressHUD.dismiss()
                self.headerView?.titleGroup?.prettyPackage = prettyPackage;
                self.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                break;
            case let .complete(prettyPackage):
                self.set(to:.loaded)
                SVProgressHUD.dismiss()
                self.headerView?.titleGroup?.prettyPackage = prettyPackage;
                self.headerView?.mapView?.trails = [prettyPackage.trail!]
                self.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                break;
            default: break;
            }
        }).disposed(by: viewModel.disposeBag)
        datasourceModel = PackageDetailsDataSourceModel()
        datasourceModel!.generateDatasource()
        datasourceModel!.bind(observable: viewModel.prettyPackageVar.asObservable().map { [unowned self] status -> [DetailsListViewCellData] in
            switch status {
            case .loadingNotrail: fallthrough;
            case .complete:
                if viewModel.trackingHistoryVar.value.isEmpty {
                    return [.empty]
                } else {
                    return viewModel.trackingHistoryVar.value.map {
                        return DetailsListViewCellData.tracking($0)
                    };
                }
            default:
                return []
            }
        }.map { return [DetailsListViewSectionData(header:"",items:$0)] },disposeBy:disposeBag,tableView:tableView)
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
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.connectionModel?.connectionState.value == .connected {
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
}

extension PackageDetailsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setDefaultHeight()
        configureNavOnCollapse()
        DispatchQueue.main.async() { [unowned self] in
            self.setDefaultHeight()
            self.headerView?.titleGroup?.redrawProgress()
        }
    }
}

extension PackageDetailsViewController {
    func generateHeaderView() {
        tableView.setSectionHeader(height: 50)
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
