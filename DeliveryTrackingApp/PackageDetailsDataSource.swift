//
//  PackageDetailsDataSource.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 9/16/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum DetailsListViewCellData {
    case empty
    case tracking(TrackingLocationHistory)
    //case loading
}

struct DetailsListViewSectionData {
    var header: String
    var items: [Item]
}

extension DetailsListViewSectionData: SectionModelType {
    typealias Item = DetailsListViewCellData
    
    init(original: DetailsListViewSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}

class PackageDetailsDataSourceModel {
    
    let datasource = RxTableViewSectionedReloadDataSource<DetailsListViewSectionData>()
    
    struct cellIdentifiers {
        static let trackingCell="tracking"
        static let emptyCell="empty"
        static let loadingCell="loading"
    }
    
    init() {
        
    }
    
    func generateDatasource() {
        datasource.configureCell = { (dataSource, table, idxPath, item) in
            switch item {
            case .empty:
                let cell: SmallStateCardTableViewCell = table.dequeueReusableCell(withIdentifier: cellIdentifiers.loadingCell, for: idxPath) as! SmallStateCardTableViewCell
                cell.status = Statuses.emptyDetails
                cell.tableView = table
                return cell
            case let .tracking(history):
                let cell: PackageViewCell = table.dequeueReusableCell(withIdentifier: cellIdentifiers.trackingCell, for: idxPath) as! PackageViewCell
                if Date().since(history.time, in: .day) < 2 {
                    cell.detailContent.titleLabel.text = history.time.toStringWithRelativeTime().capitalized
                } else {
                    cell.detailContent.titleLabel.text = history.time.toString(dateStyle: .short, timeStyle: .none)
                }
                cell.detailContent.descriptionLabel.text = "@\(history.location?.city ?? "") \(history.location?.state ?? "") \(history.location?.country ?? "")"
                cell.detailContent.selections = history.trackingHistory.map {
                    SimpleTableData(title:$0.details,description: $0.time.toString(dateStyle: .none, timeStyle: .short))
                }
                cell.detailContent.tableView = table
                cell.detailContent.indexPath = idxPath
                return cell
            }
        }
    }
    
    func bind(observable:Observable<[DetailsListViewSectionData]>,disposeBy disposeBag:DisposeBag,tableView:UITableView) {
        observable.bind(to:tableView.rx.items(dataSource: datasource)).disposed(by: disposeBag)
    }
}
