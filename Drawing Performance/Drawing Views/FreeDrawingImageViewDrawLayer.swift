//
//  FreeDrawingImageView.swift
//
//  Created by Besher on 2018-12-30.
//  Copyright © 2018 Besher Al Maleh. All rights reserved.
//

import UIKit

class LayerDelegate: NSObject, CALayerDelegate {
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
    }
}

// Draw GPU
class FreeDrawingImageViewDrawLayer: UIView, Drawable {
    
    func clear() {
    }
    
    var spiralPoints: [CGPoint] = []
    
    let delegate = LayerDelegate()
    lazy var sublayer: CALayer = {
        
        let layer = CALayer()
        
        layer.delegate = self.delegate
        
        return layer
    }()
    

    var displayLink: CADisplayLink?
    var timer: Timer?
    var line = [CGPoint]()
    
    var brushImage: UIImage?
    override func didMoveToSuperview() {
        self.brushImage = UIImage(named: "brush1")?.withTintColor(UIColor.blue, renderingMode: .alwaysOriginal)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        stopAutoDrawing()
        line.append(newTouchPoint)

        let lastTouchPoint: CGPoint = line.last ?? .zero

        //let rect = calculateRectBetween(lastPoint: lastTouchPoint, newPoint: newTouchPoint)
        //layer.setNeedsDisplay(rect)

        //debug
        print("line.count: \(line.count)")

        layer.setNeedsDisplay()
        
        if line.count > 400 {
            
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, 0)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let layerImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            layer.contents = layerImage?.cgImage
            layer.sublayers = nil
            
            line.removeAll()
        }
    }
    
//    // ///////////////////////////////////////////////////////////////////////////////
//
//    var useForceAlpha: Bool = true
//    var brushUserSize: CGFloat = 40.0
//
//    private func setBrushColor(_ color: UIColor) {
//        self.brushImage = self.brushImage?.withTintColor(color)
//    }
//
//    struct Sample {
//
//        var previousLocation: CGPoint = CGPoint.zero
//        var location: CGPoint = CGPoint.zero
//        var force: CGFloat = 1.0
//        var altitude: CGFloat = CGFloat.zero
//        var azimuth: CGFloat = CGFloat.zero
//    }
//
//    var touches: [UITouch] = [UITouch]()
//    var interpolatedPoints: Array<Sample> = []
//    let kBrushPixelStep = 1.0 // :n amount of pixels between any two points, 1 means 1 pixel between points
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        guard let touch: UITouch = touches.first else { return }
//
//        // Trim arrays using the last touch point,
//        // so that the next segment starts where the last one ended.
//
//        if let lastPoint = self.interpolatedPoints.last {
//
//            var sample = Sample()
//            sample.location = lastPoint.location
//            sample.force = lastPoint.force
//            sample.previousLocation = lastPoint.previousLocation
//            sample.azimuth = lastPoint.azimuth
//            sample.altitude = lastPoint.altitude
//            self.interpolatedPoints = [sample]
//
//        } else {
//            self.interpolatedPoints = []
//        }
//        if let lastTouch = self.touches.last {
//            self.touches = [lastTouch]
//        } else {
//            self.touches.removeAll()
//        }
//
//        if let coalescedTouches: [UITouch] = event?.coalescedTouches(for: touch) {
//            for touch in coalescedTouches {
//                self.touches.append(touch)
//            }
//        } else {
//            self.touches.append(touch)
//        }
//
//
//        // Loop a pair of touches
//        for i in 0 ..< self.touches.count - 1 {
//
//            var sample: Sample = Sample()
//
//            sample.previousLocation = touch.previousLocation(in: self)
//            sample.location = touch.location(in: self)
//            sample.force = touch.force
//            sample.altitude = touch.altitudeAngle
//            sample.azimuth = touch.azimuthAngle(in: self)
//
//            let p0: CGPoint = self.touches[i].location(in: self)
//            let p1: CGPoint = self.touches[i + 1].location(in: self)
//            let force0: CGFloat = self.touches[i].force
//            let force1: CGFloat = self.touches[i+1].force
//
//            // How many points do we need to distribute between each pair of points to satisfy the option to get n xpixes between each point
//            let spacingCount: Int = max(Int(ceil(CGPoint.length(p0 - p1) / self.kBrushPixelStep)), 1)
//
//            //debug
//            //print("spacingCount: \(spacingCount)")
//
//            // Interpolate linearly between the two points
//            for n in 0 ..< spacingCount {
//
//                let s: CGFloat = (CGFloat(n) / CGFloat(spacingCount))
//
//                //debug
//                //print("s: \(s)")
//
//                let location: CGPoint = s * (p1 - p0) + p0
//                sample.location = location
//                sample.force = max((force0 + force1) / 2.0, 0.5)
//
//                self.interpolatedPoints.append(sample)
//            }
//        }
//
//        layer.setNeedsDisplay()
//    }
//
//    // ///////////////////////////////////////////////////////////////////////////////

    override func draw(_ layer: CALayer, in ctx: CGContext) {

        guard
            let cg = self.brushImage?.cgImage,
            let size = self.brushImage?.size else { return }
        
        for (index, point) in line.enumerated() {

            let rect = CGRect(x: point.x - size.width/2,
                              y: point.y - size.height/2,
                              width: size.width,
                              height: size.height)

            //ctx.setFillColor(UIColor.blue.cgColor)
            ctx.setAlpha(0.2)
            ctx.draw(cg, in: rect)
            /*
            ctx.addEllipse(in: rect)
            ctx.strokePath()
             */
        }
        
//        guard self.interpolatedPoints.count > 0 else { return }
//
//        //debug
//        //print(self.interpolatedPoints.count)
//
//        for i in 1 ..< self.interpolatedPoints.count {
//
//            let sample = self.interpolatedPoints[i]
//
//            let touchPos: CGPoint = CGPoint(x: sample.location.x,
//                                            y: sample.location.y)
//
//            // self.brushSize is a varying and can set to desired size
//            let size: CGSize = CGSize(width: self.brushUserSize * sample.force,
//                                      height: self.brushUserSize * sample.force)// brush.size
//
//            let origin = CGPoint(x: touchPos.x - size.width/2.0,
//                                 y: touchPos.y - size.height/2.0)
//
//            var alpha: CGFloat = 0.2
//            if self.useForceAlpha && sample.force > 0 {
//                alpha = sample.force/10
//            }
//
//            // Alt 1, This is best, becaue here we can set size., Here is the most effective way of changing size
//            let rect: CGRect = CGRect(origin: origin, size: size)
//
//            ctx.setAlpha(alpha)
//            ctx.draw(cg, in: rect)
//        }
    }

    func drawSpiralWithLink() {
        let link = CADisplayLink(target: self, selector: #selector(drawSpiral))
        link.add(to: .main, forMode: .default)
        displayLink = link
    }
    
    @objc func drawSpiral() {

    }

}


extension CGPoint {
    
    static func * (_ lhs: CGFloat, _ rhs: CGPoint) -> CGPoint {
        
        let x = lhs * rhs.x
        let y = lhs * rhs.y
        return CGPoint(x: x, y: y)
    }
    
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        return CGPoint(x: x, y: y)
    }
    
    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        return CGPoint(x: x, y: y)
    }
    
    static func length(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
        
        let v = lhs - rhs
        
        let magnitude = sqrt(v.x * v.x + v.y * v.y)
        return abs(magnitude)
    }
    
    static func length(_ p: CGPoint) -> CGFloat {

        let magnitude = sqrt(p.x * p.x + p.y * p.y)
        return abs(magnitude)
    }
    
    public var length: CGFloat {

        let magnitude: CGFloat = sqrt(self.x * self.x + self.y * self.y)
        return abs(magnitude)
    }
}
