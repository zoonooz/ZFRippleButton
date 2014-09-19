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
class ZFRippleButton: UIButton {
  
  @IBInspectable var ripplePercent: Float = 0.8 {
    didSet {
      setupRippleView()
    }
  }
  
  @IBInspectable var rippleOverBounds: Bool = false {
    didSet {
      if rippleOverBounds {
        rippleBackgroundView.layer.mask = nil
      } else {
        var maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds,
          cornerRadius: layer.cornerRadius).CGPath
        rippleBackgroundView.layer.mask = maskLayer
      }
    }
  }
  
  @IBInspectable var rippleColor: UIColor = UIColor(white: 0.9, alpha: 1) {
    didSet {
      rippleView.backgroundColor = rippleColor
    }
  }
  
  @IBInspectable var rippleBackgroundColor: UIColor = UIColor(white: 0.95,
    alpha: 1) {
    didSet {
      rippleBackgroundView.backgroundColor = rippleBackgroundColor
    }
  }
  
  @IBInspectable var buttonCornerRadius: Float = 0 {
    didSet{
      layer.mask = cornerRadiusMask
    }
  }

  @IBInspectable var shadowRippleRadius: Float = 1
  @IBInspectable var shadowRippleEnable: Bool = true
  @IBInspectable var trackTouchLocation: Bool = false
  
  let rippleView = UIView()
  let rippleBackgroundView = UIView()
  private var tempShadowRadius: CGFloat = 0
  private var tempShadowOpacity: Float = 0
    
  private var cornerRadiusMask:CAShapeLayer{
    get{
      let maskLayer = CAShapeLayer()
      maskLayer.backgroundColor = UIColor.blackColor().CGColor
      maskLayer.path = UIBezierPath(roundedRect: bounds,
        cornerRadius:CGFloat(buttonCornerRadius)).CGPath
      return maskLayer
    }
  }
  
  required init(coder aDecoder: NSCoder)  {
    super.init(coder: aDecoder)
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  private func setup() {
    setupRippleView()
    
    rippleBackgroundView.backgroundColor = rippleBackgroundColor
    rippleBackgroundView.frame = bounds
    rippleBackgroundView.alpha = 0
    
    rippleOverBounds = false
    
    layer.addSublayer(rippleBackgroundView.layer)
    rippleBackgroundView.layer.addSublayer(rippleView.layer)
    
    layer.shadowRadius = 0
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).CGColor
  }
  
  private func setupRippleView() {
    var size: CGFloat = CGRectGetWidth(bounds) * CGFloat(ripplePercent)
    var x: CGFloat = (CGRectGetWidth(bounds)/2) - (size/2)
    var y: CGFloat = (CGRectGetHeight(bounds)/2) - (size/2)
    var corner: CGFloat = size/2
    
    rippleView.backgroundColor = rippleColor
    rippleView.frame = CGRectMake(x, y, size, size)
    rippleView.layer.cornerRadius = corner
  }
  
  override func beginTrackingWithTouch(touch: UITouch,
    withEvent event: UIEvent) -> Bool {
    if trackTouchLocation {
      rippleView.center = touch.locationInView(self)
    }
    
    UIView.animateWithDuration(0.1, animations: {
      self.rippleBackgroundView.alpha = 1
    }, completion: nil)
    
    rippleView.transform = CGAffineTransformMakeScale(0.5, 0.5)
    UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut,
      animations: {
      self.rippleView.transform = CGAffineTransformIdentity
    }, completion: nil)
    
    if shadowRippleEnable {
      tempShadowRadius = layer.shadowRadius
      tempShadowOpacity = layer.shadowOpacity
      
      var shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
      shadowAnim.toValue = shadowRippleRadius
      
      var opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
      opacityAnim.toValue = 1
      
      var groupAnim = CAAnimationGroup()
      groupAnim.duration = 0.7
      groupAnim.fillMode = kCAFillModeForwards
      groupAnim.removedOnCompletion = true
      groupAnim.animations = [shadowAnim, opacityAnim]
      
      layer.addAnimation(groupAnim, forKey:"shadow")
    }
    return super.beginTrackingWithTouch(touch, withEvent: event)
  }
  
  override func endTrackingWithTouch(touch: UITouch,
    withEvent event: UIEvent) {
    super.endTrackingWithTouch(touch, withEvent: event)
    
    UIView.animateWithDuration(0.1, animations: {
      self.rippleBackgroundView.alpha = 1
    }, completion: {(success: Bool) -> () in
      UIView.animateWithDuration(0.6 , animations: {
        self.rippleBackgroundView.alpha = 0
      }, completion: nil)
    })
    
    UIView.animateWithDuration(0.7, delay: 0,
      options: .CurveEaseOut | .BeginFromCurrentState, animations: {
      self.rippleView.transform = CGAffineTransformIdentity
      
      var shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
      shadowAnim.toValue = self.tempShadowRadius
      
      var opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
      opacityAnim.toValue = self.tempShadowOpacity
      
      var groupAnim = CAAnimationGroup()
      groupAnim.duration = 0.7
      groupAnim.fillMode = kCAFillModeForwards
      groupAnim.removedOnCompletion = true
      groupAnim.animations = [shadowAnim, opacityAnim]
      
      self.layer.addAnimation(groupAnim, forKey:"shadowBack")
    }, completion: nil)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.rippleBackgroundView.frame = bounds
    layer.mask = cornerRadiusMask
    setupRippleView()
  }

}
