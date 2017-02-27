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

class PackageTableView: UIView, UITableViewDelegate {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var packagesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var listTitle: TitleLabel!
    @IBOutlet weak var packagesView: UITableView!
    @IBOutlet var view: UIView!
    
    private var minContentHeight:CGFloat? {
        get {
            return UIScreen.main.bounds.height * 0.8
        }
    }
    
    var state: State = .empty {
        didSet {
            setUIForStatus(state: state)
        }
    }
    
    struct cellIdentifiers {
        static let packageCell="package"
        static let emptyCell="empty"
    }
    
    var title:String? {
        didSet {
            guard let title = title else { return }
            listTitle.text = title
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    func setHeightOfList() {
        packagesViewHeight.constant = packagesView.contentSize.height
        shadowViewHeight.constant = packagesView.contentSize.height
    }
    
    func commonInit() {
        UINib(nibName: "PackageTableView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        packagesView.backgroundColor = .clear
        packagesView.register(UINib(nibName: "PackageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.packageCell)
        packagesView.register(UINib(nibName: "EmptyPackageCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.emptyCell)
        packagesView.estimatedRowHeight = 100.0
        packagesView.rowHeight = UITableViewAutomaticDimension
        packagesView.separatorStyle = .none
        packagesView.isScrollEnabled = false
        self.backgroundColor = .clear
        packagesView.delegate = self
        //setUIForStatus(state: state)
    }
    
    func setUIForStatus(state:State) {
        switch state {
        case .empty: fallthrough;
        case .error:
            packagesView.alpha = 0;
            shadowViewHeight.constant = minContentHeight!
            packagesViewHeight.constant = minContentHeight!
            break;
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
