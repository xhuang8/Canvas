//
//  CanvasViewController.swift
//  Canvas
//
//  Created by XiaoQian Huang on 10/5/18.
//  Copyright © 2018 XiaoQian Huang. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Here we use the method didPan(sender:), which we defined in the previous step, as the action.
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanTray(_:)))
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        trayView.isUserInteractionEnabled = true
        trayView.addGestureRecognizer(panGestureRecognizer)
        
        trayDownOffset = 300
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down

        // Do any additional setup after loading the view.
    }
    
    
    // User can use a pan gesture to move the position of the tray
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
       // let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed
        {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended
        {
            if velocity.y > 0
            {
                //spring animation
                UIView.animate(withDuration:0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            }
            else
            {
                UIView.animate(withDuration:0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            }
           print("Gesture ended")
        }
    }
    
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
       // let location = sender.location(in: view)
        //let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        // Gesture Recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(facePan(_: )))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didFacePinch(_: )))
        let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didFaceRotate(_:)))
        let deleteGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didFaceDetele(_:)))
        
        if sender.state == .began{
            print("Gesture began")
            let imageView = sender.view as! UIImageView
            
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            view.addSubview(newlyCreatedFace)
            
            newlyCreatedFace.center = imageView.center
            
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            
            newlyCreatedFace.addGestureRecognizer(deleteGestureRecognizer)
            
        }
        else if sender.state == .changed{
           print("Gesture is changing")
           newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
            UIView.animate(withDuration: 0.2) {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }
        }
        else if sender.state == .ended{
           print("Gesture ended")
           UIView.animate(withDuration:0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    

    @objc func facePan(_ sender: UIPanGestureRecognizer){
        
        //let location = sender.location(in: view)
        //let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            
            newlyCreatedFace = sender.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        }
        else if sender.state == .changed {
            
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
            UIView.animate(withDuration: 0.2) {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }
        }
        else if sender.state == .ended {
            
            print("Gesture ended")
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
        }
    }
    
    @objc func didFacePinch(_ sender: UIPinchGestureRecognizer){
        
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
        
    }
    
    @objc func didFaceRotate(_ sender: UIRotationGestureRecognizer){
        
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    @objc func didFaceDetele(_ sender: UITapGestureRecognizer)
    {
        newlyCreatedFace.removeFromSuperview()
    }
}

