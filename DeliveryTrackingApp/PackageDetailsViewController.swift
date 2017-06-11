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
    var cellIdentifiers:[CellData] = [CellData(identifier:.title,content:nil)]
    var defaultHeaderHeight: CGFloat {
        get {
            return 400
        }
    }
    let disposeBag = DisposeBag()
    var animated = false
    var viewModel:PackageDetailsViewModel!
    var footerView:SubcellContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButton()
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        self.view.addSubview(gradientView)
        self.view.sendSubview(toBack: gradientView)
        listTableView.delegate = self
        listTableView?.setSectionHeader(height: 164)
        listTableView?.setSectionFooter(height: 80)
        bigPictureView.defaultHeight = defaultHeaderHeight
        headerHeightConstraint.constant = defaultHeaderHeight
        viewModel = PackageDetailsViewModel()
        viewModel.package = Package(id: "", trackingNumber: "734524769489", carrier: .fedex, title: "Books", status: .unknown, trackingDetailsDict: nil,notificationStatus:.basic,archived:false)
        bindViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavButton() {
        var image = Assets.logo.leftArrow
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        var settings = Assets.logo.settings
        settings = settings.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: settings, style: .plain, target: nil, action: nil)
    }
    
    func bindViewModel() {
        viewModel.prettyPackage.asObservable().subscribe(onNext:{ [weak self] prettyPackageStatus in
            switch prettyPackageStatus {
            case let .loadingNotrail(prettyPackage):
                self?.bigPictureView.titleGroup.prettyPackage = prettyPackage;
            case let .complete(prettyPackage):
                self?.bigPictureView.titleGroup.prettyPackage = prettyPackage;
                self?.bigPictureView.mapView.trails = [prettyPackage.trail!]
                break;
            default: break;
            }
        }).disposed(by: viewModel.disposeBag)
        viewModel.trackingHistory.asObservable().bind(to: listTableView.rx.items(cellIdentifier: "dropdownCell", cellType: DetailsPackageDetailsCell.self)) { [weak self] (row, element, cell) in
            if Date().since(element.time, in: .day) < 2 {
                cell.detailContent.titleLabel.text = element.time.toStringWithRelativeTime()
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
    
    func testCells() {
        let items = Observable.just(
            (0..<10).map { "\($0)" }
        )
        
        items
            .bind(to: listTableView.rx.items(cellIdentifier: "dropdownCell", cellType: DetailsPackageDetailsCell.self)) { (row, element, cell) in
                cell.detailContent.titleLabel.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
    }
}

extension PackageDetailsViewController:UIScrollViewDelegate {
    
    func animateHeader(duration:Double) {
        if animated == false {
            self.animated = true
            self.headerHeightConstraint.constant = defaultHeaderHeight
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
                self.view.layoutIfNeeded()
                self.bigPictureView.changeMapViewAlpha(height: self.headerHeightConstraint.constant)
            }, completion: { _ in
                self.animated = false
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if animated == false {
            if scrollView.contentOffset.y < 0 {
                self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
                bigPictureView.changeMapViewAlpha(height: self.headerHeightConstraint.constant)
                if self.headerHeightConstraint.constant > 60 && self.headerHeightConstraint.constant < 90 {
                    animateHeader(duration:1.2)
                }
            } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= 0 {
                self.headerHeightConstraint.constant -= scrollView.contentOffset.y/55
                bigPictureView.changeMapViewAlpha(height: self.headerHeightConstraint.constant)
                if self.headerHeightConstraint.constant >= 0 && self.headerHeightConstraint.constant <= defaultHeaderHeight {
                    listTableView.contentOffset.y -= scrollView.contentOffset.y/55
                }
                if self.headerHeightConstraint.constant < 0 {
                    self.headerHeightConstraint.constant = 0
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > 400 {
            animateHeader(duration:0.4)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > 400 {
            animateHeader(duration:0.4)
        }
    }
}

extension PackageDetailsViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
