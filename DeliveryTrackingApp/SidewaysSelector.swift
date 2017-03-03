//
//  SidewaysSelector.swift
//  DeliveryTrackingApp
//
//  Created by Dav Sun on 2/12/17.
//  Copyright © 2017 Download Horizons. All rights reserved.
//

import UIKit

class SidewaysSelector: UIScrollView, UIScrollViewDelegate {
    
    var selections:[String]? {
        didSet {
            generateLabels()
        }
    }
    
    var padding:CGFloat = 15.0 {
        didSet {
            generateLabels()
        }
    }
    
    var staticWidth:CGFloat = 100.0 {
        didSet {
            generateLabels()
        }
    }
    var isStaticWidth = false {
        didSet {
            generateLabels()
        }
    }
    
    var labels:[UIView]? = []
    
    var activeIndex = 0 {
        didSet {
            setActiveLabel(index: activeIndex,oldIndex: oldValue)
        }
    }
    
    var defaultIndex = 0 {
        didSet {
            guard let labels = labels else { return }
            guard defaultIndex < labels.count  else { return }
            setActiveLabel(index: defaultIndex,oldIndex: oldValue)
            centerView(view:labels[defaultIndex])
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func commonInit() {
        self.backgroundColor = .white
        self.delegate = self
        generateLabels()
    }
    
    func generateLabels() {
        labels?.forEach { label in
            label.removeFromSuperview()
        }
        labels?.removeAll()
        let fullPadding = self.bounds.width / 2 * 0.6
        var horizontalPosition:CGFloat = fullPadding;
        selections?.forEach { selection in
            let view = UIView()
            view.frame.origin = CGPoint(x:horizontalPosition,y:0)
            
            let label = BodyLabel(frame: CGRect(origin:CGPoint(x:padding,y:0),size:CGSize(width:staticWidth,height:self.bounds.height)))
            label.textFocus = .muted
            label.text = selection
            label.textAlignment = .center
            view.addSubview(label)
            if !isStaticWidth {
                label.sizeToFit()
                label.frame.size.height = self.bounds.height
            }
            view.frame.size = CGSize(width:padding*2+label.frame.size.width,height:self.bounds.height)
            let oneTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(oneTap)
            self.addSubview(view)
            horizontalPosition += (view.bounds.width)
            labels?.append(view)
        }
        self.bounces = true
        self.alwaysBounceVertical = false
        self.showsVerticalScrollIndicator = false
        self.contentSize = CGSize(width: horizontalPosition + fullPadding, height: self.bounds.height)
        setActiveLabel(index: activeIndex,oldIndex: activeIndex)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        let v = sender.view!
        centerView(view: v)
    }
    
    func centerView(view: UIView) {
        let center = self.bounds.size.width / 2
        self.setContentOffset(CGPoint(x:-(center - view.center.x),y:0), animated: true)
    }
    
    func setActiveLabel(index:Int,oldIndex:Int) {
        guard let labels = labels else { return }
        guard index < labels.count && oldIndex < labels.count else { return }
        let labelWrapper = labels[index]
        let oldlabelWrapper = labels[oldIndex]
        if let label = oldlabelWrapper.subviews[0] as? BodyLabel {
            label.textFocus = .muted
        }
        if let label = labelWrapper.subviews[0] as? BodyLabel {
            label.textFocus = .prominent
        }
    }
    
    func closestToCenter() {
        let closest = labels?.reduce(nil,{ closest,view -> UIView? in
            let parentCenter = self.bounds.size.width / 2
            let viewCenter = view.center.x - self.contentOffset.x
            let closestCenter = (closest?.center.x ?? 100000000.0) - self.contentOffset.x
            let viewDistanceFromCenter = abs(parentCenter - viewCenter)
            let closestDistanceFromCenter = abs(parentCenter - closestCenter)
            print("close index: \(labels?.index(of: closest ?? view))")
            print("contentOffSet:\(self.contentOffset.x) \(view.center.x) \(closest?.center.x)")
            print("distance: \(viewDistanceFromCenter) closest: \(closestDistanceFromCenter)")
            print()
            return viewDistanceFromCenter < closestDistanceFromCenter ? view:closest
        })
        print("\(closest?.center) \(labels?.index(of: closest!))")
        if let closest = closest {
            centerView(view: closest)
        }
    }
    
    func viewInCenter() {
        let active = labels?.reduce(nil,{ inRange,view -> UIView? in
            let parentCenter = self.bounds.size.width / 2
            let viewLeft = view.frame.origin.x - self.contentOffset.x
            let viewRight = view.frame.origin.x + view.bounds.width - self.contentOffset.x
            return viewLeft < parentCenter && parentCenter < viewRight ? view:inRange
        })
        if let active = active {
            activeIndex = (labels?.index(of: active))!
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewInCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("end: \(decelerate)")
        closestToCenter()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("decelerate")
        closestToCenter()
    }
}
