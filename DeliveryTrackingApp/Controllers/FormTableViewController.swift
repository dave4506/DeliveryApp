//
//  FormTableViewController.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 8/24/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ESPullToRefresh
import AssistantKit


class FormTableViewController: UITableViewController {
    
    var listView:ListTableView?
    let disposeBag = DisposeBag()
    let throttleInterval = 0.1

    enum Push {
        case dismiss
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func push(_ p:Push) {
        switch p {
        case .dismiss:
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension FormTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if Device.type != .pad {
            listView?.toggleStatusBar(UIDevice.current.orientation.isLandscape)
        }
    }
}

extension FormTableViewController {
    func configureNavButton() {
        var image = Assets.logo.cross.gray
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.push(.dismiss)
        }).disposed(by: disposeBag)
    }
    
    func configureTableView() {
        let gradientView = GradientView(frame:CGRect(origin:.zero,size:self.view.bounds.size))
        let coloredView = ColoredView()
        coloredView.backgroundColor = Color.secondary
        coloredView.alpha = 0.2
        gradientView.addSubview(coloredView)
        generateColoredViewConstraints(view: coloredView,parent: gradientView)
        tableView.backgroundView = gradientView
        tableView.delegate = self
        listView = tableView as! ListTableView?
        listView?.setSectionHeader(height: 20)
        listView?.setSectionFooter(height: 20)
        listView?.generateNavBarOpacity(offset: 80, navigationController: self.navigationController, statusBar: Device.type != .pad)
    }
}
