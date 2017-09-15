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

class TestPackageViewCell:UITableViewCell {
    @IBOutlet weak var detailContent: DetailDropDownContent!
}

class TestPackageDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: ListTableView!
    
    let disposeBag = DisposeBag()
    var viewModel:PackageDetailsViewModel?
    var isCollapsed:Bool = false
    var headerView:PackageDetailsBigPictureViewTest?
    var titleSubContent:TitleSubContent?
    var websiteSubContent:TitleSubContent?
    
    deinit {
        print("deiniting...")
    }
    
    enum Push {
        case dismiss
    }
    
    func push(_ p:Push) {
        switch p {
        case .dismiss:
            self.dismiss(animated: true, completion: nil);break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        configureBackground(addColorView: false, color: nil)
        tableView.delegate = self
        setUpHeaderView()
        //tableView.setSectionHeader(height: 164)
        tableView.setSectionFooter(height: 100)
        bindViewModel()
        generateHeaderView()
        generateFooterView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewModel = self.viewModel {
            viewModel.pullPackage()
        }
    }
    
    func setUpHeaderView() {
        headerView = PackageDetailsBigPictureViewTest(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 164))
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
            defaultHeaderHeight = height * 0.4;
        }
        headerView?.maximumContentHeight = defaultHeaderHeight;

    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.prettyPackageVar.asObservable().subscribe(onNext:{ [unowned self] prettyPackageStatus in
            switch prettyPackageStatus {
            case .unintiated:
                //self?.setToHiddenState()
                self.headerView?.mapView?.trails = []
                break;
            case let .loadingNotrail(prettyPackage):
                //self?.setToDefaultState()
                SVProgressHUD.dismiss()
                //self?.setFooterHeight()
                self.headerView?.titleGroup?.prettyPackage = prettyPackage;
                self.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                break;
            case let .complete(prettyPackage):
                //self?.setToDefaultState()
                SVProgressHUD.dismiss()
                //self?.setFooterHeight()
                self.headerView?.titleGroup?.prettyPackage = prettyPackage;
                self.headerView?.mapView?.trails = [prettyPackage.trail!]
                self.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                break;
            default: break;
            }
        }).disposed(by: viewModel.disposeBag)
        viewModel.trackingHistoryVar.asObservable().bind(to: tableView.rx.items(cellIdentifier: "dropdownCell", cellType: TestPackageViewCell.self)) { [weak self] (row, element, cell) in
            if Date().since(element.time, in: .day) < 2 {
                cell.detailContent.titleLabel.text = element.time.toStringWithRelativeTime().capitalized
            } else {
                cell.detailContent.titleLabel.text = element.time.toString(dateStyle: .short, timeStyle: .none)
            }
            cell.detailContent.descriptionLabel.text = "@\(element.location?.city ?? "") \(element.location?.state ?? "") \(element.location?.country ?? "")"
            cell.detailContent.selections = element.trackingHistory.map {
                SimpleTableData(title:$0.details,description: $0.time.toString(dateStyle: .none, timeStyle: .short))
            }
            cell.detailContent.tableView = self?.tableView
            cell.detailContent.indexPath = IndexPath(row: row, section: 0)
            print("hello and here?")
        }.disposed(by: viewModel.disposeBag)
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
    }
}

extension TestPackageDetailsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension TestPackageDetailsViewController {
    func generateHeaderView() {
        tableView.setSectionHeader(height: 50)
        titleSubContent = TitleSubContent()
        /*titleSubContent!.settingsButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.pushToSettings)
        }).disposed(by: disposeBag)*/
        tableView.tableHeaderView?.addSubview(titleSubContent!)
        setTitleSubViewContraints(view: titleSubContent!, parent: tableView.tableHeaderView!)
    }
    
    func generateFooterView() {
        websiteSubContent = TitleSubContent()
        tableView.tableFooterView?.addSubview(websiteSubContent!)
        setWebsiteSubViewContraints(view: websiteSubContent!, parent: tableView.tableFooterView!)
        websiteSubContent?.descriptionLabel.text = "Track on Website"
        /*websiteSubContent!.settingsButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.pushToWebsite)
        }).disposed(by: disposeBag)*/
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
