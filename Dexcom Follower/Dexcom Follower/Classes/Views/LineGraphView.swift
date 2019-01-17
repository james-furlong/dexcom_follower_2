//
//  LineGraphView.swift
//  Dexcom Follower
//
//  Created by James Furlong on 18/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import RxSwift
import RxCocoa

class LineGraphView: UIView {
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    var colors: [UIColor] = [UIColor]()
    var data: [CGPoint] = [CGPoint]()
    var showInnerLines: Bool = true
    let labelFontSize: CGFloat = 10.0
    var axisColor: UIColor = .white
    let axisLineWidth: CGFloat = 1.0
    let deltaX: CGFloat = 1.0
    let deltaY: CGFloat = 2.0
    var minX: CGFloat = 0.0
    var minY: CGFloat = 0.0
    var maxX: CGFloat = 24.0
    var maxY: CGFloat = 22.0
    
    override func draw(_ rect: CGRect) {
        let height = rect.height
        let width = rect.width
        
        // Clipping path for graph border
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        // Draw the gradient background
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let cfColors = colors.map { $0.cgColor } as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: cfColors,
            locations: colorLocations
        )
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0.0, y: bounds.height)
        guard let gradientDraw = gradient else { return }
        context.drawLinearGradient(gradientDraw,
                                   start: startPoint,
                                   end: endPoint,
                                   options: []
        )
        
        // Calculate points
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.data.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }

        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue: CGFloat = 22.00
        
        let columnYPoint = { (graphPoint: CGFloat) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }

        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // Draw the graph path
        let graphPath = UIBezierPath()
        var p1 = CGPoint(x: columnXPoint(0), y: columnYPoint(data[0].y))
        graphPath.move(to: p1)
        
        var pointData: [CGPoint] = [CGPoint]()
        for i in 1..<data.count {
            let point = CGPoint(x: columnXPoint(i), y: columnYPoint(data[i].y))
            pointData.append(point)
        }
        
        for i in 0..<pointData.count {
            let mid = midPoint(for: (p1, pointData[i]))
            graphPath.addQuadCurve(to: mid, controlPoint: controlPoint(for: (mid, p1)))
            graphPath.addQuadCurve(to: pointData[i], controlPoint: controlPoint(for: (mid, pointData[i])))
            p1 = pointData[i]
        }
        
        // Create clipping path for graph gradient
        context.saveGState()
        
        guard let clippingPath: UIBezierPath = graphPath.copy() as? UIBezierPath else { return }
        clippingPath.addLine(to: CGPoint(x: columnXPoint(data.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        clippingPath.addClip()
        
        // Gradient for clipped area
        let graphStartPoint = CGPoint(x: margin, y: bounds.height / 2)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(gradientDraw,
                                   start: graphStartPoint,
                                   end: graphEndPoint,
                                   options: []
        )
        context.restoreGState()
        
        // Draw the circles on top of the graph stroke
        for i in 0..<data.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(data[i].y))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }
        
        // Draw horizontal graph lines on the top of everything
        for i in 1...11 {
            let multi = Double(i) / 11.0
            let movePoint = CGPoint(x: margin, y: (height * CGFloat(multi)))
            let linePoint = CGPoint(x: width - margin, y: (height * CGFloat(multi)))
            graphPath.move(to: movePoint)
            graphPath.addLine(to: linePoint)
        }

        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
//        let trans = setTransform(minX: self.minX, maxX: self.maxX, minY: self.minY, maxY: self.maxY)
//        setNeedsDisplay()
//        drawAxis(in: context, usingTransform: trans)
    }
    
    private func midPoint(for points: (CGPoint, CGPoint)) -> CGPoint {
        return CGPoint(x: (points.0.x + points.1.x) / 2 , y: (points.0.y + points.1.y) / 2)
    }
    
    private func controlPoint(for points: (CGPoint, CGPoint)) -> CGPoint {
        var controlPoint = midPoint(for: points)
        let diffY = abs(points.1.y - controlPoint.y)
        
        if points.0.y < points.1.y {
            controlPoint.y += diffY
        } else if points.0.y > points.1.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) -> CGAffineTransform {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        let xOffset = xLabelSize.height + 2
        let yOffset = yLabelSize.height + 5
        let xScale = (bounds.width - yOffset - xLabelSize.width/2 - 2)/(maxX - minY)
        let yScale = (bounds.width - xOffset - yLabelSize.width/2 - 2)/(maxX - minY)
        
        let chartTransform = CGAffineTransform(
            a: xScale,
            b: 0,
            c: 0,
            d: -yScale,
            tx: yOffset,
            ty: bounds.height - xOffset
        )
        
        return chartTransform
    }
    
    func drawAxis(in context: CGContext, usingTransform trans: CGAffineTransform) {
        
        
        let thickerLines: CGMutablePath = CGMutablePath()
        let thinnerLines: CGMutablePath = CGMutablePath()
        let xAxisPoints = [CGPoint(x: self.minX, y: 0), CGPoint(x: self.maxX, y: 0)]
        let yAxisPoints = [CGPoint(x: 0, y: self.minY), CGPoint(x: 0, y: self.maxY)]
        thickerLines.addLines(between: xAxisPoints, transform: trans)
        thinnerLines.addLines(between: yAxisPoints, transform: trans)
        for x in stride(from: self.minX, through: self.maxX, by: deltaX) {
            let tickPoints = showInnerLines ?
                [CGPoint(x: x, y: self.minY).applying(trans), CGPoint(x: x, y: self.maxY).applying(trans)] :
                [CGPoint(x: x, y: 0).applying(trans), CGPoint(x: x, y: 0).applying(trans).adding(y: -5)]
            thinnerLines.addLines(between: tickPoints)
            
            if x != self.minX {
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
        for y in stride(from: self.minY, through: self.minX, by: deltaY) {
            
            let tickPoints = showInnerLines ?
                [CGPoint(x: self.minX, y: y).applying(trans), CGPoint(x: self.maxX, y: y).applying(trans)] :
                [CGPoint(x: 0, y: y).applying(trans), CGPoint(x: 0, y: y).applying(trans).adding(x: 5)]
            
            
            thinnerLines.addLines(between: tickPoints)
            
            if y != self.minY {
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
    }
}
