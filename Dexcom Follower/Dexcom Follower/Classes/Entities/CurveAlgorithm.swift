//
//  CurveAlgorithm.swift
//  Dexcom Follower
//
//  Created by James Furlong on 17/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit
import RxSwift

struct CurvedSegment {
    var controlPointOne: CGPoint
    var controlPointTwo: CGPoint
    let originalPoint: CGPoint
}

class CurveAlgorithm {
    static let shared = CurveAlgorithm()
    
    func controlPoints(from points: [CGPoint]) -> [CurvedSegment] {
        var result: [CurvedSegment] = []
        
        let delta: CGFloat = 0.3
        
        // Temporary control points for the bezier path
        for i in 1..<points.count {
            let A = points[i - 1]
            let B = points[i]
            let controlPointOne = CGPoint(x: A.x + delta * (B.x - A.x), y: A.y + delta * (B.y - A.y))
            let controlPointTwo = CGPoint(x: B.x + delta * (B.x - A.x), y: B.y + delta * (B.y - A.y))
            let curvedSegment: CurvedSegment = CurvedSegment(
                controlPointOne: controlPointOne,
                controlPointTwo: controlPointTwo,
                originalPoint: points[i]
            )
            result.append(curvedSegment)
        }
        
        // Calculate better control points
        for i in 1..<points.count - 1 {
            let tmpControlPointOne = result[i - 1].controlPointTwo
            let tmpControlPointTwo = result[i].controlPointOne
            let centralPoint = points[i]
            
            let pointReflectionA = CGPoint(
                x: 2 * centralPoint.x - tmpControlPointOne.x,
                y: 2 * centralPoint.y - tmpControlPointOne.y
            )
            
            let pointReflectionB = CGPoint(
                x: 2 * centralPoint.x - tmpControlPointTwo.x,
                y: 2 * centralPoint.y - tmpControlPointTwo.y
            )
            
            result[i].controlPointOne = CGPoint(
                x: (pointReflectionA.x + tmpControlPointTwo.x) / 2 ,
                y: (pointReflectionA.y + tmpControlPointTwo.y / 2)
            )
            
            result[i - 1].controlPointTwo = CGPoint(
                x: (pointReflectionB.x + tmpControlPointOne.x) / 2,
                y: (pointReflectionB.y + tmpControlPointOne.y) / 2
            )
        }
        
        return result
    }
    
    func createCurvedPath(dataPoints: [CGPoint]) -> UIBezierPath? {
        guard !dataPoints.isEmpty else { return nil }
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: dataPoints[0])
        
        var curveSegments: [CurvedSegment] = []
        curveSegments = controlPoints(from: dataPoints)
        
        for i in 1..<dataPoints.count {
            path.addCurve(
                to: dataPoints[i],
                controlPoint1: curveSegments[i - 1].controlPointOne,
                controlPoint2: curveSegments[i - 1].controlPointTwo
            )
        }
        return path
    }
}
