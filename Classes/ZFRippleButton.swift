//
//  ZFRippleButton.swift
//  ZFRippleButtonDemo
//
//  Created by Amornchai Kanokpullwad on 6/26/14.
//  Copyright (c) 2014 zoonref. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
public class ZFRippleButton: UIButton {
    
    @IBInspectable public var ripplePercent: Float = 0.8 {
        didSet {
            setupRippleView()
        }
    }
    
    @IBInspectable public var rippleColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    
    @IBInspectable public var rippleBackgroundColor: UIColor = UIColor(white: 0.95, alpha: 1) {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    
    @IBInspectable public var buttonCornerRadius: Float = 0 {
        didSet{
            layer.cornerRadius = CGFloat(buttonCornerRadius)
        }
    }
    
    @IBInspectable public var rippleOverBounds: Bool = false
    @IBInspectable public var shadowRippleRadius: Float = 1
    @IBInspectable public var shadowRippleEnable: Bool = true
    @IBInspectable public var trackTouchLocation: Bool = false
    @IBInspectable public var touchUpAnimationTime: Double = 0.6
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    
    private var tempShadowRadius: CGFloat = 0
    private var tempShadowOpacity: Float = 0
    private var touchCenterLocation: CGPoint?
    
    private var rippleMask: CAShapeLayer? {
        get {
            if !rippleOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds,
                    cornerRadius: layer.cornerRadius).CGPath
                return maskLayer
            } else {
                return nil
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        layer.addSublayer(rippleBackgroundView.layer)
        rippleBackgroundView.layer.addSublayer(rippleView.layer)
        rippleBackgroundView.alpha = 0
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).CGColor
    }
    
    private func setupRippleView() {
        let size: CGFloat = CGRectGetWidth(bounds) * CGFloat(ripplePercent)
        let x: CGFloat = (CGRectGetWidth(bounds)/2) - (size/2)
        let y: CGFloat = (CGRectGetHeight(bounds)/2) - (size/2)
        let corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRectMake(x, y, size, size)
        rippleView.layer.cornerRadius = corner
    }
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if trackTouchLocation {
            touchCenterLocation = touch.locationInView(self)
        } else {
            touchCenterLocation = nil
        }
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: nil)
        
        rippleView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        
        UIView.animateWithDuration(0.7, delay: 0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.rippleView.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        if shadowRippleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowOpacity = layer.shadowOpacity
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = shadowRippleRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = 1
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.removedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            layer.addAnimation(groupAnim, forKey:"shadow")
        }
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override public func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)
        animateToNormal()
    }
    
    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        animateToNormal()
    }
    
    private func animateToNormal() {
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: {(success: Bool) -> () in
                UIView.animateWithDuration(self.touchUpAnimationTime, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.rippleBackgroundView.alpha = 0
                    }, completion: nil)
        })
        
        
        UIView.animateWithDuration(0.7, delay: 0,
            options: [.CurveEaseOut, .BeginFromCurrentState, .AllowUserInteraction],
            animations: {
                self.rippleView.transform = CGAffineTransformIdentity
                
                let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
                shadowAnim.toValue = self.tempShadowRadius
                
                let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
                opacityAnim.toValue = self.tempShadowOpacity
                
                let groupAnim = CAAnimationGroup()
                groupAnim.duration = 0.7
                groupAnim.fillMode = kCAFillModeForwards
                groupAnim.removedOnCompletion = false
                groupAnim.animations = [shadowAnim, opacityAnim]
                
                self.layer.addAnimation(groupAnim, forKey:"shadowBack")
            }, completion: nil)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setupRippleView()
        if let knownTouchCenterLocation = touchCenterLocation {
            rippleView.center = knownTouchCenterLocation
        }
        
        rippleBackgroundView.layer.frame = bounds
        rippleBackgroundView.layer.mask = rippleMask
    }
    
}