//
//  GradientView.swift
//  Dexcom Follower
//
//  Created by James Furlong on 11/11/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class GradientView: UIView {
    public enum GradientType {
        case linear
        case radial
    }
    
    // MARK: - Styling
    
    private var oldFrame: CGRect = .zero
    public var gradientType: GradientType = .linear
    public var colors: [UIColor] = [] { didSet { setNeedsDisplay() } }
    public var locations: [CGFloat] = [0, 1] { didSet { setNeedsDisplay() } }
    public var startPoint: CGPoint = CGPoint(x: 0, y: 0) { didSet { setNeedsDisplay() } }
    public var endPoint: CGPoint = CGPoint(x: 0, y: 0) { didSet { setNeedsDisplay() } }
    override public var alpha: CGFloat { didSet { setNeedsDisplay() } }
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = .clear
    }
    
    // Mark: - Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if frame != oldFrame {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Drawing
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard self.alpha > 0 else { return }
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        guard locations.count == colors.count else { return }
        
        let drawBeforeStartValue = CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue
        let drawAfterEndValue = CGGradientDrawingOptions.drawsAfterEndLocation.rawValue
        let options: CGGradientDrawingOptions = CGGradientDrawingOptions(
            rawValue: drawBeforeStartValue + drawAfterEndValue)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let cfColors = colors.map { $0.cgColor } as CFArray
        guard let gradient: CGGradient = CGGradient(
            colorsSpace: colorSpace,
            colors: cfColors,
            locations: locations) else {
                return
        }
        
        context.saveGState()
        
        switch gradientType {
            case .linear:
                UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).addClip()
                context.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: startPoint.x * rect.width, y: startPoint.y * rect.height),
                    end: CGPoint(x: endPoint.x * rect.width, y: endPoint.y * rect.height),
                    options: options
                )
            case .radial:
                let centerPoint: CGPoint = CGPoint(x: startPoint.x * rect.width, y: startPoint.y * rect.height)
                context.drawRadialGradient(
                    gradient,
                    startCenter: centerPoint,
                    startRadius: 0,
                    endCenter: centerPoint,
                    endRadius: min(rect.height, rect.width) * fmin(endPoint.x, endPoint.y),
                    options: options
                )
        }
        context.restoreGState()
    }
}

// MARK: - Rx

public extension Reactive where Base: GradientView {
    public var colors: Binder<[UIColor]> {
        return Binder(self.base) { view, colors in
            view.colors = colors
        }
    }
    
    public var locations: Binder<[CGFloat]> {
        return Binder(self.base) { view, locations in
            view.locations = locations
        }
    }
    
    public var startPoint: Binder<CGPoint> {
        return Binder(self.base) { view, startPoint in
            view.startPoint = startPoint
        }
    }
    
    public var endPoint: Binder<CGPoint> {
        return Binder(self.base) { view, endPoint in
            view.endPoint = endPoint
        }
    }
}
