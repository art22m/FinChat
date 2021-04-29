//
//  TinkoffLogoSnowEffect.swift
//  FinChat
//
//  Created by Артём Мурашко on 29.04.2021.
//

import UIKit

class TinkoffLogoSnowEffect {
    var window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
  
    lazy var logoCell: CAEmitterCell = {
        var logoCell = CAEmitterCell()
        logoCell.contents = UIImage(named: "tinkoffLogo")?.cgImage
        logoCell.scale = 0.04
        logoCell.scaleRange = 0.1
        logoCell.scaleSpeed = 0.03
        logoCell.emissionRange = .pi
        logoCell.lifetime = 2.5
        logoCell.lifetimeRange = 1.5
        logoCell.birthRate = 20
        logoCell.velocity = -30
        logoCell.velocityRange = -20
        logoCell.alphaSpeed = -0.4
        logoCell.xAcceleration = 10
        logoCell.yAcceleration = 45
        logoCell.spin = 1
        logoCell.spinRange = 1.0
        return logoCell
    }()
  
    lazy var logoLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: window.bounds.width / 2.0, y: 200)
        layer.emitterSize = CGSize(width: 100, height: 100)
        layer.emitterShape = .circle
        layer.beginTime = CACurrentMediaTime()
        layer.emitterCells = [logoCell]
        layer.lifetime = 0
        self.window.layer.addSublayer(layer)
        return layer
    }()
  
    public func animate(gesture: UIGestureRecognizer) {
        let location = gesture.location(in: window)
        self.logoLayer.emitterPosition = CGPoint(x: location.x, y: location.y )
        
        switch gesture.state {
            case .began:
                logoLayer.lifetime = 1
            case .changed:
                logoLayer.lifetime = 0.5
            default:
                logoLayer.lifetime = 0
        }
    }
}
