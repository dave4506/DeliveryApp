//
//  Test.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/28/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class DetailDropDownContent: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectionsTableView: UITableView!
    @IBOutlet weak var descriptionLabel: BodyLabel!
    @IBOutlet weak var toggleButton: LinkButton!
    @IBOutlet weak var titleLabel: BodyLabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet var view: UIView!
    
    var openStatus = false {
        didSet {
            setTableViewHeight(status: openStatus)
        }
    }
    
    var selections:[SimpleTableData] = [] {
        didSet {
            selectionsTableView.reloadData()
        }
    }
    
    var defaultSelection:Int = 0

    var currentSelection:Int? = 0 {
        didSet {
            guard let _ = currentSelection else {
                currentSelection = defaultSelection
                return
            }
            descriptionLabel.text = selections[currentSelection!].title
        }
    }
    
    struct buttonToggles {
        static var on="HIDE"
        static var off="SHOW"
    }
    
    weak var tableView: UITableView?
    
    var indexPath: IndexPath?

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    @IBAction func toggleTapped(_ sender: Any) {
        openStatus = !openStatus
    }
    
    func commonInit() {
        UINib(nibName: "DetailDropDownContent", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        selectionsTableView.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "simple")
        self.backgroundColor = .clear
        self.backgroundView.backgroundColor = Color.background
        self.sendSubview(toBack: backgroundView)
        self.backgroundView.layer.zPosition = -1
        setTableViewHeight(status: false)
        selectionsTableView.delegate = self
        selectionsTableView.dataSource = self
        selectionsTableView.separatorStyle = .none
        selectionsTableView.estimatedRowHeight = 50.0
        selectionsTableView.rowHeight = UITableViewAutomaticDimension
        let spacerView = UIView(frame:CGRect(origin:.zero,size:CGSize(width:10,height:10)));
        selectionsTableView.tableHeaderView = spacerView;
        selectionsTableView.tableFooterView = spacerView;
        self.bringSubview(toFront: selectionsTableView)
        self.layoutIfNeeded()
    }
    
    
    
    func tableViewUpdate() {
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
    
    func setTableViewHeight(status: Bool) {
        if openStatus {
            toggleButton.setTitle(buttonToggles.on, for: .normal)
            heightConstraint.constant = CGFloat(50*selections.count + 20);
        } else {
            toggleButton.setTitle(buttonToggles.off, for: .normal)
            heightConstraint.constant = CGFloat(0)
        }
        tableViewUpdate()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectionsTableView.dequeueReusableCell(withIdentifier: "simple", for: indexPath) as! SimpleTableViewCell
        let data = selections[indexPath.row]
        cell.titleLabel.text = data.title!
        cell.descriptorLabel.text = data.description ?? ""
        cell.layoutIfNeeded();
        cell.backgroundColor = .clear;
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelection = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
