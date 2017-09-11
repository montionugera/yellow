//
//  FloatingView.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/10/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
@IBDesignable
class TopCurveFloatingView : UIView {
    private  let beginingYPoint : CGFloat = 40
    lazy var maskLayer = CAShapeLayer()
    lazy var maskPath : UIBezierPath = {
        let b = UIBezierPath()
        return b
    }()
    @IBInspectable
    var topCurveColor : UIColor = UIColor.black {
        didSet{
            topEdgeCurveLayer.strokeColor = topCurveColor.cgColor
        }
    }
    lazy var topEdgeCurveLayer : CAShapeLayer = {
        let c = CAShapeLayer()
        c.fillColor = UIColor.clear.cgColor
        c.lineWidth = 7.0
        c.lineCap = kCALineCapRound
        return c
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitilization()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitilization()
    }
    func sharedInitilization()  {
        topEdgeCurveLayer.strokeColor = topCurveColor.cgColor
        self.layer.mask = maskLayer
        self.layer.addSublayer(topEdgeCurveLayer)
    }
    func buildCurveOnTop(isStrokeLine : Bool = false) -> UIBezierPath {
        let b = UIBezierPath()
        let ratio : CGFloat = 3.5/4
        let additionalPlus : CGFloat = isStrokeLine == true ? 0 : 0
        b.move(to: CGPoint(x: 0 + (additionalPlus * -1) , y: beginingYPoint))
        b.addQuadCurve(to: CGPoint(x: self.bounds.width / 2 , y: 0)
            , controlPoint: CGPoint(x:  self.bounds.width * (1 - ratio) , y: 0))
        b.addQuadCurve(to: CGPoint(x: self.bounds.width + additionalPlus  , y: beginingYPoint)
            , controlPoint: CGPoint(x: self.bounds.width * ratio, y: 0))
        return b
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topEdgeCurveLayer.path = buildCurveOnTop(isStrokeLine: true).cgPath
        maskPath.append(buildCurveOnTop())
        maskPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        maskPath.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        maskPath.close()
        maskLayer.path = maskPath.cgPath
    }
    lazy var centerBound : CGPoint = CGPoint(x:  self.bounds.width / 2 , y:  self.bounds.height / 2)
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let centerLinePath = UIBezierPath()
        let centerRect =  CGPoint(x:  rect.width / 2 , y:  rect.height / 2)
        let size : CGFloat = rect.width * 0.15
        centerLinePath.move(to: CGPoint(x: centerRect.x - size / 2 , y: 20 ))
        centerLinePath.addLine(to: CGPoint(x: centerRect.x + size / 2 , y: 20 ))
        centerLinePath.lineWidth = 5
        UIColor.black.setStroke()
        centerLinePath.stroke()
    }
}
