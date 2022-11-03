//
//  OProgressView.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/21.
//

import UIKit
// This is a UIView subclass for the circle countdown progress view in the home page
class OProgressView: UIView {
    let progressLayer = CAShapeLayer()
    let grayProgressLayer = CAShapeLayer()
    let digitLabel = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        digitLabel.frame = bounds
        digitLabel.textColor = UIColor.systemMint
        digitLabel.font = UIFont(name: "DIN Alternate", size: 36.0) ?? .systemFont(ofSize: 36.0)
        digitLabel.textAlignment = .center
        addSubview(digitLabel)

        grayProgressLayer.frame = bounds
        grayProgressLayer.fillColor = UIColor.clear.cgColor
        grayProgressLayer.strokeColor = UIColor.lightGray.cgColor
        grayProgressLayer.opacity = 1.0
        grayProgressLayer.lineCap = .round
        grayProgressLayer.lineWidth = 10.0
        layer.addSublayer(grayProgressLayer)

        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemMint.cgColor
        progressLayer.opacity = 1.0
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        layer.addSublayer(progressLayer)

        drawProgressCircle(with: -(Double.pi / 2) + Double.pi * 2.0, isGrayCircle: true)
    }
    
    
    func drawCountDownProgress(seconds: Int) {
        let progress = Double(seconds) / 60.0
        digitLabel.text = " " + String(60 - seconds) + "\""
        drawProgressCircle(with: -(Double.pi / 2) + Double.pi * 2.0 * progress, isGrayCircle: false)
    }
    
    func drawProgressCircle(with endAngle: CGFloat, isGrayCircle: Bool) {
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let radius = frame.size.width / 2.0
        let startA = -(Double.pi / 2)
        let endA = endAngle
        
        var layer: CAShapeLayer?
        if isGrayCircle {
            layer = self.grayProgressLayer
        } else {
            layer = self.progressLayer
        }
        
        guard let shapeLayer = layer else { return }
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
        shapeLayer.path = path.cgPath
    }
}
