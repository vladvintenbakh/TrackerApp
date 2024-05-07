//
//  UIView+addGradientBorder.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 26/4/24.
//

import UIKit

extension UIView {
    func addGradientBorder(startPoint: CGPoint,
                           endPoint: CGPoint,
                           width: CGFloat,
                           gradientColors: [UIColor],
                           cornerRadius: CGFloat) {
        let layerName = "CustomGradientBorder"
        
        let border = (layer.sublayers?.first { $0.name == layerName } as? CAGradientLayer) ?? CAGradientLayer()
        border.name = layerName
        border.startPoint = startPoint
        border.endPoint = endPoint
        border.frame = bounds.insetBy(dx: -width / 2, dy: -width / 2)
        border.colors = gradientColors.map { $0.cgColor }
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.lineWidth = width
        mask.strokeColor = UIColor.black.cgColor
        
        border.mask = mask
        
        if border.superlayer == nil {
            layer.addSublayer(border)
        }
    }
}
