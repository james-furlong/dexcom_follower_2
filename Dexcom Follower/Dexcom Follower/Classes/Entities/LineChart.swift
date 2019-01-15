//
//  LineChart.swift
//  Dexcom Follower
//
//  Created by James Furlong on 16/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit

class LineChart: UIView {
    
    let lineLayer: CAShapeLayer = CAShapeLayer()
    let pointLayer: CAShapeLayer = CAShapeLayer()
    
    var chartTransform: CGAffineTransform = CGAffineTransform()
    
    var lineColor: UIColor = .green {
        didSet {
            lineLayer.strokeColor = lineColor.cgColor
        }
    }
    
    let lineWidth: CGFloat = 1.0
    
    var showPoints: Bool = true {
        didSet {
            pointLayer.isHidden = !showPoints
        }
    }
    
    var pointColor: UIColor = .blue {
        didSet {
            pointLayer.strokeColor = pointColor.cgColor
        }
    }
    
    let pointSizeMultiplier: CGFloat = 3.0
    var axisColor: UIColor = .white
    var showInnerLines: Bool = true
    var labelFontSize: CGFloat = 10.0
    var axisLineWidth: CGFloat = 1.0
    var deltaX: CGFloat = 10.0
    var deltaY: CGFloat = 10.0
    var xMax: CGFloat = 100.0
    var yMax: CGFloat = 100.0
    var xMin: CGFloat = 0.0
    var yMin: CGFloat = 0.0
    
    var data: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        combinedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        combinedInit()
    }
    
    func combinedInit() {
        layer.addSublayer(lineLayer)
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        
        layer.addSublayer(pointLayer)
        pointLayer.fillColor = UIColor.clear.cgColor
        
        layer.borderWidth = 1.0
        layer.borderColor = axisColor.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineLayer.frame = bounds
        pointLayer.frame = bounds
        
        if let useableData = data {
            setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
            plot(from:useableData)
        }
    }
    
    func setAxisRange(forPoints points: [CGPoint]) {
        guard !points.isEmpty else { return }
        
        let xArray = points.map { $0.x }
        let yArray = points.map { $0.y }
        
        self.xMax = ceil((xArray.max() ?? 24.00) / deltaX) * deltaX
        self.yMax = ceil((yArray.max() ?? 200.00) / deltaY) * deltaY
        self.xMin = 0.0
        self.yMin = 0.0
        
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    func setAxisRange(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        self.xMax = maxX
        self.yMax = maxY
        self.xMin = minX
        self.yMin = minY
        
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        let xOffset = xLabelSize.height + 2
        let yOffset = yLabelSize.height + 5
        let xScale = (bounds.width - yOffset - xLabelSize.width/2 - 2)/(maxX - minY)
        let yScale = (bounds.width - xOffset - yLabelSize.width/2 - 2)/(maxX - minY)
        
        chartTransform = CGAffineTransform(
            a: xScale,
            b: 0,
            c: 0,
            d: -yScale,
            tx: yOffset,
            ty: bounds.height - xOffset
        )
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawAxis(in: context, usingTransform: chartTransform)
    }
    
    private func drawAxis(in context: CGContext, usingTransform trans: CGAffineTransform) {
        context.saveGState()
        
        let thickerLines: CGMutablePath = CGMutablePath()
        let thinnerLines: CGMutablePath = CGMutablePath()
        let xAxisPoints = [CGPoint(x: xMin, y: 0), CGPoint(x: xMax, y: 0)]
        let yAxisPoints = [CGPoint(x: 0, y: yMin), CGPoint(x: 0, y: yMax)]
        thickerLines.addLines(between: xAxisPoints, transform: trans)
        thinnerLines.addLines(between: yAxisPoints, transform: trans)
        for x in stride(from: xMin, through: xMax, by: deltaX) {
            let tickPoints = showInnerLines ?
                [CGPoint(x: x, y: yMin).applying(trans), CGPoint(x: x, y: yMax).applying(trans)] :
                [CGPoint(x: x, y: 0).applying(trans), CGPoint(x: x, y: 0).applying(trans).adding(y: -5)]
            thinnerLines.addLines(between: tickPoints)
            
            if x != xMin {
                let label = "\(Int(x))" as NSString
                let labelSize = "\(Int(x))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: x, y: 0).applying(trans)
                    .adding(x: -labelSize.width/2)
                    .adding(y: 1)
                
                label.draw(
                    at: labelDrawPoint,
                    withAttributes:
                        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: labelFontSize),
                         NSAttributedString.Key.foregroundColor: axisColor]
                    )
            }
        }
        for y in stride(from: yMin, through: yMax, by: deltaY) {
            
            let tickPoints = showInnerLines ?
                [CGPoint(x: xMin, y: y).applying(trans), CGPoint(x: xMax, y: y).applying(trans)] :
                [CGPoint(x: 0, y: y).applying(trans), CGPoint(x: 0, y: y).applying(trans).adding(x: 5)]
            
            
            thinnerLines.addLines(between: tickPoints)
            
            if y != yMin {
                let label = "\(Int(y))" as NSString
                let labelSize = "\(Int(y))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: 0, y: y).applying(trans)
                    .adding(x: -labelSize.width - 1)
                    .adding(y: -labelSize.height/2)
                
                label.draw(
                    at: labelDrawPoint,
                    withAttributes:
                        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: labelFontSize),
                        NSAttributedString.Key.foregroundColor: axisColor])
            }
        }
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(axisLineWidth)
        context.addPath(thickerLines)
        context.strokePath()
        
        context.setStrokeColor(axisColor.withAlphaComponent(0.5).cgColor)
        context.setLineWidth(axisLineWidth/2)
        context.addPath(thinnerLines)
        context.strokePath()
        
        context.restoreGState()
    }
    
    func plot(from points: [CGPoint]) {
        self.lineLayer.path = nil
        self.pointLayer.path = nil
        self.data = nil
        
        guard !points.isEmpty else { return }
        
        self.data = points
        
        setAxisRange(forPoints: points)
        
        let linePath = CGMutablePath()
        linePath.addLines(between: points, transform: chartTransform)
        
        lineLayer.path = linePath
        
        if showPoints {
            pointLayer.path = circles(atPoints: points, withTransform: chartTransform)
        }
    }
    
    func circles(atPoints points: [CGPoint], withTransform t: CGAffineTransform) -> CGPath {
        
        let path = CGMutablePath()
        let radius = lineLayer.lineWidth * pointSizeMultiplier/2
        for i in points {
            let p = i.applying(t)
            let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
            path.addEllipse(in: rect)
            
        }
        
        return path
    }
}
