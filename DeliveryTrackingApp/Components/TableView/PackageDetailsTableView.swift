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

enum PackageDetailsListViewCellData {
    case trackingTitle(LocationTrackingHistory), trackingContent(TrackingHistory)
}

struct PackageDetailsTableViewSectionData {
    var header: String
    var items: [Item]
}

extension PackageDetailsTableViewSectionData: SectionModelType {
    typealias Item = PackageDetailsListViewCellData
    
    init(original: PackageDetailsTableViewSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}

class PackageDetailsTableView: UIView {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var packagesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var packagesView: UITableView!
    @IBOutlet var view: UIView!
    
    weak var tableView: UITableView?
        
    var indexPath: IndexPath?
    var minCount = 3
    
    struct cellIdentifiers {
        static let titleCell="title"
        static let contentCell="content"
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
        UINib(nibName: "PackageDetailsTableView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        packagesView.backgroundColor = .clear
        packagesView.register(UINib(nibName: "TrackingHistoryTitleContent", bundle: nil), forCellReuseIdentifier: cellIdentifiers.titleCell)
        packagesView.register(UINib(nibName: "TrackingHistoryDetailsContent", bundle: nil), forCellReuseIdentifier: cellIdentifiers.contentCell)
        packagesView.separatorStyle = .none
        packagesView.isScrollEnabled = false
        packagesView.layer.cornerRadius = 10
        packagesView.clipsToBounds = true
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        packagesView.estimatedRowHeight = 100.0
        packagesView.rowHeight = UITableViewAutomaticDimension
        packagesView.autoresizesSubviews = true
    }
    
    func generateDatasource() -> RxTableViewSectionedReloadDataSource<PackageDetailsTableViewSectionData> {
       return RxTableViewSectionedReloadDataSource<PackageDetailsTableViewSectionData>(configureCell: { (dataSource, table, idxPath, item) in
            switch item {
            case let .trackingTitle(history):
                let cell: TrackingHistoryTitleContent = table.dequeueReusableCell(withIdentifier: cellIdentifiers.titleCell, for: idxPath) as! TrackingHistoryTitleContent
                cell.titleLabel.text = "@\(history.location.city ?? "") \(history.location.state ?? "") \(history.location.country ?? "")"
                if Date().since(history.time, in: .day) < 2 {
                    cell.captionLabel.text = history.time.toStringWithRelativeTime().capitalized
                } else {
                    cell.captionLabel.text = history.time.toString(dateStyle: .short, timeStyle: .none)
                }
                return cell
            case let .trackingContent(history):
                let cell: TrackingHistoryDetailsContent = table.dequeueReusableCell(withIdentifier: cellIdentifiers.contentCell, for: idxPath) as! TrackingHistoryDetailsContent
                cell.bodyLabel.text = history.details
                cell.descriptionLabel.text = history.time.toString(dateStyle: .none, timeStyle: .short)
                cell.tableView = table
                return cell
            }
        })
    }
    
    func bindPackageTableView(observable:Observable<[PackageDetailsTableViewSectionData]>,disposeBy disposeBag:DisposeBag) {
        observable.bind(to:packagesView.rx.items(dataSource: generateDatasource())).disposed(by: disposeBag)
    }
}

//EXTENSION: All Height related Functions
extension PackageDetailsTableView {
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
    
    func determineHeight(count:Int) {
        setHeightOfListToContent(count:count)
    }
}
