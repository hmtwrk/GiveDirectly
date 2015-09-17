//
//  RefreshView.swift
//  GiveDirectly
//
//  Created by Sean Moriarity on 9/17/15.
//  Copyright (c) 2015 GiveDirectly. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(resfreshView: RefreshView)
}

private let sceneHeight: CGFloat = 120

class RefreshView: UIView {
    
    private unowned var scrollView: UIScrollView
    var progressPercentage: CGFloat = 0
    
    weak var delegate: RefreshViewDelegate?
    
    var isRefreshing = false
    
    required init(coder aDecoder: NSCoder) {
        scrollView = UIScrollView()
        assert(false, "user init(frame:scrollView:)")
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        
        updateBackgroundColor()

    }
    
    func updateBackgroundColor() {
        let value = progressPercentage * 0.7 + 0.2
        backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1.0)
    }
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top += sceneHeight
            }, completion: { (_) -> Void in
        })
    }
    
    func endRefreshing() {

        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top -= sceneHeight
            }, completion: { (_) -> Void in
                self.isRefreshing = false
        })
    }
}

extension RefreshView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progressPercentage == 1 {
            beginRefreshing()
            targetContentOffset.memory.y = -scrollView.contentInset.top
            // if there's a delegate, then refresh
            delegate?.refreshViewDidRefresh(self)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        
        let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
        progressPercentage = min(1, refreshViewVisibleHeight / sceneHeight)
        NSLog("progressPercentage = \(progressPercentage)")
        
        updateBackgroundColor()
    }
}
