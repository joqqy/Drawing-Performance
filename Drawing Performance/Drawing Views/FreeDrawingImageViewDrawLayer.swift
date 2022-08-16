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
        self.brushImage = UIImage(named: "brush1")?.withTintColor(UIColor.blue, renderingMode: .alwaysOriginal)
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

    override func draw(_ layer: CALayer, in ctx: CGContext) {

        guard
            let cg = self.brushImage?.cgImage,
            let size = self.brushImage?.size  else { return }
        
        for (index, point) in line.enumerated() {

            let rect = CGRect(x: point.x - size.width/2,
                              y: point.y - size.height/2,
                              width: size.width,
                              height: size.height)
            
//            ctx.setFillColor(UIColor.blue.cgColor)
            ctx.setAlpha(0.2)
            ctx.draw(cg, in: rect)
//            ctx.addEllipse(in: rect)
//            ctx.strokePath()
        }
    }

    func drawSpiralWithLink() {
        let link = CADisplayLink(target: self, selector: #selector(drawSpiral))
        link.add(to: .main, forMode: .default)
        displayLink = link
    }
    
    @objc func drawSpiral() {

    }

}
