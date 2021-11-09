//
//  ViewController.swift
//  CoreAnimationExample
//
//  Created by Tabish on 5/23/21.
//

import UIKit
import TheAnimation

class ViewController: UIViewController {
    
    // Can Also Add View Instead of layer
    let subView = UIView()
    var imageVu = UIImageView()
    
    let layer = CALayer()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.black
        
        addImageView()
        enlargeAnimation()
        
        // Add SubLayer to superview
        addSubLayer()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.animateMovement()
            self.rotate()
            self.animateOpacity()
        }
    }
}

// MARK: - UIView.animate Animation
extension ViewController {
    
    func addImageView() {
        // Set subView Position and Size
        subView.frame.size = CGSize(width: 120, height: 120)
        subView.center.x = view.center.x
        subView.center.y = view.center.y
        view.addSubview(subView)
        imageVu = UIImageView(image: UIImage(named: "ghost-image"))
        // imageView will have the same frame as subView
        imageVu.frame = subView.bounds
        subView.addSubview(imageVu)
    }
    
    func enlargeAnimation() {
        UIView.animate(withDuration: 2, animations: {
            self.setSizeAndPosition(width: 200, height: 200)
        }) { (done) in
            if done {
                self.squezeAnimation()
            }
        }
    }
    
    func squezeAnimation() {
        UIView.animate(withDuration: 2, animations: {
            self.setSizeAndPosition(width: 120, height: 120)
        }) { (done) in
            if done {
                self.enlargeAnimation()
            }
        }
    }
    
    func setSizeAndPosition(width: Int, height: Int) {
        self.subView.frame.size = CGSize(width: width, height: height)
        self.subView.center.x = self.view.center.x
        self.subView.center.y = self.view.center.y
        self.imageVu.frame.size = CGSize(width: width, height: height)
    }
}

// MARK: - Basic Animation
extension ViewController {
    
    func addSubLayer() {
        layer.contents = UIImage(named: "ghost-image")?.cgImage
        layer.frame = CGRect(x: 100, y: 100, width: 120, height: 120)
        view.layer.addSublayer(layer)
    }
    
    func animateMovement() {
        // Create Animation ofType
        let animation = BasicAnimation(keyPath: .position)
        // Specify Start Position
        animation.fromValue = CGPoint(x: layer.frame.origin.x + (layer.frame.size.width/2),
                                      y: layer.frame.origin.y + (layer.frame.size.height/2))
        
        let layerTrailing = view.frame.size.width - (100 + 120)
        let layerBottom = view.frame.size.height - (100 + 120)
        
        // Specify End Position
        animation.byValue = CGPoint(x: layerTrailing, y: layerBottom)
        // Duration
        animation.duration = 2
        // Define the pace of the animation
        animation.timingFunction = .easeInEaseOut
        // OnCompletion
        animation.fillMode = .forwards
        // Remove animation on complete
        animation.isRemovedOnCompletion = false
        // Begin Time
        animation.beginTime = 0
        // Add Animation
        animation.animate(in: layer)
    }
    
    func rotate() {
        let animation = BasicAnimation(keyPath: .transformRotationZ)
        animation.fromValue = 0
        animation.toValue = 2 * (.pi * 2) // 2 * (180 * 2)
        animation.duration = 1.5
        animation.timingFunction = .linear
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = 0
        animation.animate(in: layer)
    }
    
    func animateOpacity() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = 0
        layer.add(animation, forKey: nil)
    }
}

// MARK: - Animation Delegate
extension ViewController: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        print("animation did start")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation did finish")
    }
}
