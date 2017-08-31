//
//  PackageTableView.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/22/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum PackageListViewCellData {
    case state(status:PrettyStatus)
    case empty
    case package(package:PrettyPackage)
    case loadingPackage(package:PrettyPackage)
}

struct PackageTableViewSectionData {
    var header: String
    var items: [Item]
}

extension PackageTableViewSectionData: SectionModelType {
    typealias Item = PackageListViewCellData
    
    init(original: PackageTableViewSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}

class PackageTableView: UIView {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var packagesViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var packagesView: UITableView!
    @IBOutlet var view: UIView!
    
    weak var tableView: UITableView?
    
    let datasource = RxTableViewSectionedReloadDataSource<PackageTableViewSectionData>()
    
    var indexPath: IndexPath?
    var minCount = 3
    
    struct cellIdentifiers {
        static let packageCell="package"
        static let emptyCell="empty"
        static let stateCell="state"
    }

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func tableViewUpdate() {
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
    
    func commonInit() {
        UINib(nibName: "PackageTableView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        packagesView.backgroundColor = .clear
        packagesView.register(UINib(nibName: "PackageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.packageCell)
        packagesView.register(UINib(nibName: "LoadingPackageCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.emptyCell)
        packagesView.register(UINib(nibName: "StateCardTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.stateCell)
        packagesView.separatorStyle = .none
        packagesView.isScrollEnabled = false
        packagesView.layer.cornerRadius = 10
        packagesView.clipsToBounds = true
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        packagesView.estimatedRowHeight = 100.0
        packagesView.rowHeight = UITableViewAutomaticDimension
        packagesView.autoresizesSubviews = true
        generateDatasource()
    }
    
    func generateDatasource() {
        datasource.configureCell = { [weak self] (dataSource, table, idxPath, item) in
            switch item {
            case .empty:
                let cell: LoadingPackageCell = table.dequeueReusableCell(withIdentifier: cellIdentifiers.emptyCell, for: idxPath) as! LoadingPackageCell
                cell.startAnimation(delay: Double(idxPath.row)  * 0.5)
                return cell
            case let .state(status):
                let cell: StateCardTableViewCell = table.dequeueReusableCell(withIdentifier: cellIdentifiers.stateCell, for: idxPath) as! StateCardTableViewCell
                cell.status = status
                cell.stateCard.tableView = self?.packagesView
                return cell
            case let .package(package):
                let cell: PackageTableViewCell = table.dequeueReusableCell(withIdentifier: cellIdentifiers.packageCell, for: idxPath) as! PackageTableViewCell
                cell.package = package
                cell.packageCellContent.setLoading(false)
                return cell
            case let .loadingPackage(package):
                let cell: PackageTableViewCell = table.dequeueReusableCell(withIdentifier: cellIdentifiers.packageCell, for: idxPath) as! PackageTableViewCell
                cell.package = package
                cell.packageCellContent.setLoading(false)
                return cell
            }
        }
    }
    
    func bindPackageTableView(observable:Observable<[PackageTableViewSectionData]>,disposeBy disposeBag:DisposeBag) {
        observable.bind(to:packagesView.rx.items(dataSource: datasource)).disposed(by: disposeBag)
    }
}

//EXTENSION: All Height related Functions
extension PackageTableView {
    func setRowMinCount(yCord:CGFloat,height:CGFloat) {
        minCount = Int((height - yCord)/100.0)
        setHeightToDefault()
    }
    
    func setHeightOfListToContent(count:Int) {
        packagesViewHeight.constant = CGFloat((count)*100)
        tableViewUpdate()
    }
    
    func setHeightToDefault() {
        packagesViewHeight.constant = CGFloat((minCount + 1)*100)
        tableViewUpdate()
    }
    
    func determineHeight(count:Int) -> Bool {
        if count <= minCount {
            setHeightToDefault()
            return false
        } else {
            setHeightOfListToContent(count:count)
            return true
        }
    }
}
