//
//  AnimatedTransition.swift
//  FinChat
//
//  Created by Артём Мурашко on 29.04.2021.
//

import Foundation
import UIKit


private class Presenter: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
 
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView

        containerView.addSubview(toView)
        toView.alpha = 0.0
        
        UIView.animate(withDuration: 1.5, animations: {
            toView.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
 
private class Dismisser: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
 
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        let containerView = transitionContext.containerView

        containerView.addSubview(fromView)
        fromView.alpha = 1.0
        
        UIView.animate(withDuration: 1.5, animations: {
            fromView.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

class BottomCardSegue: UIStoryboardSegue {
    private var selfRetainer: BottomCardSegue? = nil
    override func perform() {
        destination.transitioningDelegate = self
        selfRetainer = self
        destination.modalPresentationStyle = .overCurrentContext
        source.present(destination, animated: true, completion: nil)
    }
}

extension BottomCardSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Presenter()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Dismisser()
    }
    
}
