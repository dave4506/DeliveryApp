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

class DetailsPackageDetailsCell: UITableViewCell {
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

    
    @IBOutlet weak var bigPictureView: PackageDetailsBigPictureView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var listTableView: ListTableView!
    var titleSubContent:TitleSubContent?
    
    var closedValue: CGFloat = 64
    var defaultHeaderHeight: CGFloat = 400 + 60
    var snapBackValue: CGFloat = 80 + 60

    let disposeBag = DisposeBag()
    var animated = false
    var viewModel:PackageDetailsViewModel?
    var isCollapsed:Bool?
    
    enum Push {
        case dismiss, pushToSettings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        configureBackground(addColorView: false, color: nil)
        listTableView.delegate = self
        listTableView?.setSectionHeader(height: 164)
        listTableView?.setSectionFooter(height: 80)
        generateHeaderView()
        bindViewModel()
        setDefaultHeight()
        setToHiddenState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewModel = self.viewModel {
            viewModel.pullPackage()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setToHiddenState() {
        bigPictureView.mapControl.isHidden = false
        bigPictureView.titleGroup.isHidden = true
        titleSubContent!.isHidden = true
    }
    
    func setToDefaultState() {
        bigPictureView.mapControl.isHidden = false
        bigPictureView.titleGroup.isHidden = false
        titleSubContent!.isHidden = false
    }
    
    func setDefaultHeight() {
        let height = self.view.bounds.height
        if height > 464 {
            defaultHeaderHeight = 464;
        }
        if height < 464 {
            defaultHeaderHeight = height * 0.4;
        }
        bigPictureView.defaultHeight = defaultHeaderHeight
        headerHeightConstraint.constant = defaultHeaderHeight
        self.bigPictureView.defaultHeight = defaultHeaderHeight
    }
    
    func setFooterHeight() {
        guard let viewModel = self.viewModel else { return }
        let tableViewHeight = self.view.bounds.height - 164 - 64
        let remainder = tableViewHeight - CGFloat(50) - CGFloat(viewModel.trackingHistoryVar.value.count * 120)
        if remainder > 0 {
            listTableView?.setSectionFooter(height: remainder)
        } else {
            listTableView?.setSectionFooter(height: 80)
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
        }
    }
    
    func settingsTap() {
        if let prettyPackage = self.viewModel?.getPrettyPackage() {
            let packageSettingsNav = UIStoryboard(name: "PackageSettings", bundle: nil).instantiateInitialViewController() as! ClearNavigationViewController
            let packageSettings = packageSettingsNav.viewControllers[0] as! PackageSettingsViewController
            let viewModel = PackageSettingsViewModel(prettyPackage)
            packageSettings.viewModel = viewModel
            packageSettings.packageDetailsVC = self
            packageSettingsNav.modalPresentationStyle = .formSheet
            self.present(packageSettingsNav, animated: true, completion: nil)
        }
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.prettyPackageVar.asObservable().subscribe(onNext:{ [weak self] prettyPackageStatus in
            switch prettyPackageStatus {
            case .unintiated:
                self?.setToHiddenState()
                self?.bigPictureView.mapView.trails = []
                break;
            case let .loadingNotrail(prettyPackage):
                self?.setToDefaultState()
                SVProgressHUD.dismiss()
                self?.setFooterHeight()
                self?.bigPictureView.titleGroup.prettyPackage = prettyPackage;
                self?.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                break;
            case let .complete(prettyPackage):
                self?.setToDefaultState()
                SVProgressHUD.dismiss()
                self?.setFooterHeight()
                self?.bigPictureView.titleGroup.prettyPackage = prettyPackage;
                self?.bigPictureView.mapView.trails = [prettyPackage.trail!]
                self?.titleSubContent!.descriptionLabel.text = prettyPackage.trackingNumber
                break;
            default: break;
            }
        }).disposed(by: viewModel.disposeBag)
        viewModel.trackingHistoryVar.asObservable().bind(to: listTableView.rx.items(cellIdentifier: "dropdownCell", cellType: DetailsPackageDetailsCell.self)) { [weak self] (row, element, cell) in
            if Date().since(element.time, in: .day) < 2 {
                cell.detailContent.titleLabel.text = element.time.toStringWithRelativeTime().capitalized
            } else {
                cell.detailContent.titleLabel.text = element.time.toString(dateStyle: .short, timeStyle: .none)
            }
            cell.detailContent.descriptionLabel.text = "@\(element.location?.city ?? "") \(element.location?.state ?? "") \(element.location?.country ?? "")"
            cell.detailContent.selections = element.trackingHistory.map {
                SimpleTableData(title:$0.details,description: $0.time.toString(dateStyle: .none, timeStyle: .short))
            }
            cell.detailContent.tableView = self?.listTableView
            cell.detailContent.indexPath = IndexPath(row: row, section: 0)
        }.disposed(by: viewModel.disposeBag)
    }
}

extension PackageDetailsViewController:UIScrollViewDelegate {
    
    func animateHeader(duration:Double,to height:CGFloat) {
        if animated == false {
            self.animated = true
            self.headerHeightConstraint.constant = height
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
                self.view.layoutIfNeeded()
                self.bigPictureView.changeAlpha(height: self.headerHeightConstraint.constant)
            }, completion: { _ in
                self.animated = false
            })
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.y)
        if animated == false {
            if scrollView.contentOffset.y < 0 {
                self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
                bigPictureView.changeAlpha(height: self.headerHeightConstraint.constant)
                //Animate to open position
                if self.headerHeightConstraint.constant > snapBackValue && self.headerHeightConstraint.constant < defaultHeaderHeight {
                    animateHeader(duration:1.2,to:defaultHeaderHeight)
                }
            } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= closedValue {
                self.headerHeightConstraint.constant -= scrollView.contentOffset.y/55
                bigPictureView.changeAlpha(height: self.headerHeightConstraint.constant)
                if self.headerHeightConstraint.constant >= closedValue && self.headerHeightConstraint.constant <= defaultHeaderHeight {
                    
                    listTableView.contentOffset.y -= scrollView.contentOffset.y/55
                }
                if self.headerHeightConstraint.constant < closedValue {
                    self.headerHeightConstraint.constant = closedValue
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //Animate back to open position
        if self.headerHeightConstraint.constant > defaultHeaderHeight {
            animateHeader(duration:0.4,to:defaultHeaderHeight)
        }
        //Animate back to close position
        if self.headerHeightConstraint.constant > closedValue && self.headerHeightConstraint.constant <= snapBackValue {
            animateHeader(duration:0.4,to:closedValue)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //Animate back to open position
        if self.headerHeightConstraint.constant > defaultHeaderHeight {
            animateHeader(duration:0.3,to:defaultHeaderHeight)
        }
        //Animate back to close position
        if self.headerHeightConstraint.constant > closedValue && self.headerHeightConstraint.constant <= snapBackValue {
            animateHeader(duration:0.3,to:closedValue)
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
            self.bigPictureView.titleGroup.redrawProgress()
            self.setFooterHeight()
        }
    }
}

extension PackageDetailsViewController {
    
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
    
    func generateHeaderView() {
        listTableView.setSectionHeader(height: 164 + 50)
        titleSubContent = TitleSubContent()
        titleSubContent!.settingsButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.pushToSettings)
        }).disposed(by: disposeBag)
        listTableView.tableHeaderView?.addSubview(titleSubContent!)
        setDetailsViewConstraints(view: titleSubContent!, parent: listTableView.tableHeaderView!)
    }
    
    func setDetailsViewConstraints(view:UIView,parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,bottomConstraint,heightConstraint])
        view.layoutIfNeeded()
    }
}
