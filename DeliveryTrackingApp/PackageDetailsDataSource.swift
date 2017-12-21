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
    case topCap
    case bottomCap
    case trackingTitle(LocationTrackingHistory)
    case trackingContent(TrackingHistory)
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

class PackageDetailsDataSourceModel: CapCellDataSource {
    
    
    struct cellIdentifiers {
        static let titleCell="title"
        static let contentCell="content"
        static let emptyCell = "empty"
    }
    
    weak var tableView:UITableView?
    
    init(tableView _tableView:UITableView) {
        tableView = _tableView
    }
    
    func registerCells() {
        guard let tableView = tableView else { return }
        super.registerCells(tableView: tableView)
        tableView.register(UINib(nibName: "SmallStateCardTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.emptyCell)
        tableView.register(UINib(nibName: "TrackingHistoryTitleContent", bundle: nil), forCellReuseIdentifier: cellIdentifiers.titleCell)
        tableView.register(UINib(nibName: "TrackingHistoryDetailsContent", bundle: nil), forCellReuseIdentifier: cellIdentifiers.contentCell)
    }
    
    func generateDatasource() -> RxTableViewSectionedReloadDataSource<DetailsListViewSectionData> {
        return RxTableViewSectionedReloadDataSource<DetailsListViewSectionData>(configureCell: { (dataSource, table, idxPath, item) in
            switch item {
            case .topCap:
                let cell: TopCapCell = table.dequeueReusableCell(withIdentifier: capIdentifiers.top, for: idxPath) as! TopCapCell
                return cell
            case .bottomCap:
                let cell: BottomCapCell = table.dequeueReusableCell(withIdentifier: capIdentifiers.bottom, for: idxPath) as! BottomCapCell
                cell.shadowView.backgroundColor = Color.background
                return cell
            case .empty:
                let cell: SmallStateCardTableViewCell = table.dequeueReusableCell(withIdentifier: cellIdentifiers.emptyCell, for: idxPath) as! SmallStateCardTableViewCell
                cell.status = Statuses.emptyDetails
                cell.tableView = table
                return cell
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
    
    func bindTableView(observable:Observable<[DetailsListViewSectionData]>,disposeBy disposeBag:DisposeBag) {
        guard let tableView = tableView else { return }
        observable.bind(to:tableView.rx.items(dataSource: generateDatasource())).disposed(by: disposeBag)
    }
    
}
