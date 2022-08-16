//
//  FreeDrawingImageView.swift
//
//  Created by Besher on 2018-12-30.
//  Copyright © 2018 Besher Al Maleh. All rights reserved.
//

import UIKit

// Draw GPU
class FreeDrawingImageViewDrawLayer: UIView, Drawable {
    
    func clear() {
    }
    var spiralPoints: [CGPoint] = []
    

    var displayLink: CADisplayLink?
    var timer: Timer?
    var line = [CGPoint]()
    
    var brushImage: UIImage?
    override func didMoveToSuperview() {
        self.brushImage = UIImage(named: "roundSoft1")?.withTintColor(UIColor.blue, renderingMode: .alwaysOriginal)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        stopAutoDrawing()
        line.append(newTouchPoint)
        
        let lastTouchPoint: CGPoint = line.last ?? .zero
        
        //let rect = calculateRectBetween(lastPoint: lastTouchPoint, newPoint: newTouchPoint)
        
        //layer.setNeedsDisplay(rect)
        layer.setNeedsDisplay()
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        flattenImage()
//    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {

        guard
            let cg = self.brushImage?.cgImage,
            let size = self.brushImage?.size  else { return }
        
        for (index, point) in line.enumerated() {
//            self.brushImage?.draw(at: point, blendMode: CGBlendMode.normal, alpha: 0.5)
            
            //debug
            //print("point: \(point)")
                
            

            let rect = CGRect(x: point.x - size.width/2,
                              y: point.y - size.height/2,
                              width: size.width,
                              height: size.height)
            
//            ctx.setFillColor(UIColor.blue.cgColor)
            ctx.setAlpha(0.5)
            ctx.draw(cg, in: rect)
//            ctx.addEllipse(in: rect)
//            ctx.strokePath()

        }

    }
    
//    func checkIfTooManyPoints() {
//        let maxPoints = 25
//        if line.count > maxPoints {
//            updateFlattenedLayer()
//            // we leave two points to ensure no gaps or sharp angles
//            _ = line.removeFirst(maxPoints - 2)
//        }
//    }
    
//    func flattenImage() {
//        updateFlattenedLayer()
//        line.removeAll()
//    }
    
//    func updateFlattenedLayer() {
//        // 1
//        guard let drawingLayer = drawingLayer,
//            // 2
//            let optionalDrawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
//                NSKeyedArchiver.archivedData(withRootObject: drawingLayer, requiringSecureCoding: false))
//                as? CAShapeLayer,
//            // 3
//            let newDrawing = optionalDrawing else { return }
//        // 4
//        layer.addSublayer(newDrawing)
//    }
    
    func drawSpiralWithLink() {
        let link = CADisplayLink(target: self, selector: #selector(drawSpiral))
        link.add(to: .main, forMode: .default)
        displayLink = link
    }
    
    @objc func drawSpiral() {
//        if self.spiralPoints.isEmpty {
////            emptyFlattenedLayers()
//            drawingLayer?.removeFromSuperlayer()
//            drawingLayer = nil
//            line.removeAll()
//            spiralPoints.removeAll()
//            layer.setNeedsDisplay()
//            self.createSpiral()
//            self.flattenImage()
//        } else {
//            self.line.append(self.spiralPoints.removeFirst())
//            self.layer.setNeedsDisplay()
//            self.checkIfTooManyPoints()
//        }
    }
    
//    func clear() {
//        stopAutoDrawing()
////        emptyFlattenedLayers()
//        drawingLayer?.removeFromSuperlayer()
//        drawingLayer = nil
//        line.removeAll()
//        spiralPoints.removeAll()
//        layer.setNeedsDisplay()
//    }
    
//    func emptyFlattenedLayers() {
//        for case let layer as CAShapeLayer in sublayers {
//            layer.removeFromSuperlayer()
//        }
//    }
}
