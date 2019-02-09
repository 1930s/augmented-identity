//
//  ViewController.swift
//  augmented-identity
//
//  Created by Edward on 2/9/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import Foundation
import Firebase

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var directionsLabel: UILabel!
    
    let textRecognizer = Vision.vision().onDeviceTextRecognizer()
    var imageFromArkitScene: UIImage?
    
    let cardInfoScene: SKScene = SKScene(fileNamed: "card-info")!
    let gitScene: SKScene = SKScene(fileNamed: "github")!
    let FBScene: SKScene = SKScene(fileNamed: "facebook")!
    let LIScene: SKScene = SKScene(fileNamed: "linkedIn")!
    let personalScene: SKScene = SKScene(fileNamed: "personal")!
    
    var gitLink: String = "https://github.com/EdwardLu2018/augmented-identity"
    var FBLink: String = "https://www.facebook.com/zuck"
    var LInk: String = "https://www.linkedin.com/in/edwardllu"
    var personalLink: String = "https://www.google.com/imgres?imgurl=http://www.gstatic.com/tv/thumb/v22vodart/27575/p27575_v_v8_aa.jpg&imgrefurl=http://google.com/search?tbm%3Disch%26q%3DShrek&h=1440&w=960&tbnid=sQODbxTLi36s2M:&q=shrek&tbnh=186&tbnw=124&usg=AI4_-kSZ8mfpphwn7-oeUlXHj9c0XuqM0g&vet=12ahUKEwjNqvKquq7gAhULtlkKHb1-D2IQ_B0wIXoECAEQBg..i&docid=iFY1YbgDJQohPM&itg=1&sa=X&ved=2ahUKEwjNqvKquq7gAhULtlkKHb1-D2IQ_B0wIXoECAEQBg"
    
    var foundCard: Bool = false
    var foundAnchor: Bool = false
    var name: String = "[name]"
    
    let fadeDuration: TimeInterval = 5
    let waitDuration: TimeInterval = 1
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.5, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var fadeInAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.9, duration: fadeDuration)
            ])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.directionsLabel.center.x  -= view.bounds.width
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        configureLighting()
        
        UIView.animate(withDuration: 2.5) {
            self.directionsLabel.center.x += self.view.bounds.width
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        self.foundAnchor = true
        
        // Card Information Label
        if let nameLabel = cardInfoScene.childNode(withName: "name") as? SKLabelNode {
            nameLabel.text = self.name
        }
        
        let infoPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height/2)
        infoPlane.cornerRadius = infoPlane.width / 25
        
        infoPlane.firstMaterial?.diffuse.contents = cardInfoScene
        infoPlane.firstMaterial?.isDoubleSided = true
        infoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        
        let infoPlaneNode = SCNNode(geometry: infoPlane)
        infoPlaneNode.name = "infoPlaneNode"
        infoPlaneNode.eulerAngles.x = -.pi / 2
        infoPlaneNode.opacity = 0.10
        infoPlaneNode.position.z = -0.046
        
        infoPlaneNode.runAction(self.fadeInAction)
        
        node.addChildNode(infoPlaneNode)
        
        if (self.foundCard) {
            let gitPlane = SCNPlane(width: 0.015, height: 0.015)
            gitPlane.cornerRadius = 4.5
            
            gitPlane.firstMaterial?.diffuse.contents = gitScene
            gitPlane.firstMaterial?.isDoubleSided = true
            gitPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let gitPlaneNode = SCNNode(geometry: gitPlane)
            gitPlaneNode.name = "gitNode"
            gitPlaneNode.eulerAngles.x = -.pi / 2
            gitPlaneNode.opacity = 0.10
            gitPlaneNode.position.x = -0.034
            gitPlaneNode.position.z = 0.040
            
            gitPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(gitPlaneNode)
            
            let FBPlane = SCNPlane(width: 0.015, height: 0.015)
            FBPlane.cornerRadius = 4.5
            
            FBPlane.firstMaterial?.diffuse.contents = FBScene
            FBPlane.firstMaterial?.isDoubleSided = true
            FBPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let FBPlaneNode = SCNNode(geometry: FBPlane)
            FBPlaneNode.name = "FBNode"
            FBPlaneNode.eulerAngles.x = -.pi / 2
            FBPlaneNode.opacity = 0.10
            FBPlaneNode.position.x = -0.012
            FBPlaneNode.position.z = 0.040
            
            FBPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(FBPlaneNode)
            
            let LIPlane = SCNPlane(width: 0.015, height: 0.015)
            LIPlane.cornerRadius = 4.5
            
            LIPlane.firstMaterial?.diffuse.contents = LIScene
            LIPlane.firstMaterial?.isDoubleSided = true
            LIPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let LIPlaneNode = SCNNode(geometry: LIPlane)
            LIPlaneNode.name = "LINode"
            LIPlaneNode.eulerAngles.x = -.pi / 2
            LIPlaneNode.opacity = 0.10
            LIPlaneNode.position.x = 0.009
            LIPlaneNode.position.z = 0.040
            
            LIPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(LIPlaneNode)
            
            let personalPlane = SCNPlane(width: 0.015, height: 0.015)
            personalPlane.cornerRadius = 4.5
            
            personalPlane.firstMaterial?.diffuse.contents = personalScene
            personalPlane.firstMaterial?.isDoubleSided = true
            personalPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let personalPlaneNode = SCNNode(geometry: personalPlane)
            personalPlaneNode.name = "personalNode"
            personalPlaneNode.eulerAngles.x = -.pi / 2
            personalPlaneNode.opacity = 0.10
            personalPlaneNode.position.x = 0.031
            personalPlaneNode.position.z = 0.040
            
            personalPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(personalPlaneNode)
        }
    }
    
    func resetTrackingConfiguration() {
        let configuration = ARImageTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.trackingImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
    
    func getText(image: UIImage) {
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else { return }
            
            if (result.text.contains("University") || result.text.contains("Student") || result.text.contains("UserID")) {
                if let lowerRange = result.text.range(of: "University"),
                    let upperRange = result.text.range(of: " Student") {
                    let name = result.text[lowerRange.upperBound...upperRange.lowerBound]
                    self.name = String(name)
                    self.foundCard = true
                    self.directionsLabel.text = "Name Recognized!"
                }
            }
        }
    }
    
    @IBAction func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            self.directionsLabel.text = "Scanning..."
            if (self.foundAnchor) {
                self.foundCard = false
                let imageFromArkitScene: UIImage? = sceneView.snapshot()
                self.getText(image: imageFromArkitScene!)
            }
        }
        if gestureRecognizer.state == .ended {
            self.directionsLabel.text = "Hold ID In Front Of Camera & Press"
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {let location = gestureRecognize.location(in: self.sceneView)
        let hitResults = self.sceneView.hitTest(location, options: [:])
        
        if hitResults.count > 0 {
            let tappedNode = hitResults[0].node
            print(tappedNode.name!)
            if (tappedNode.name == "gitNode") {
                UIApplication.shared.openURL(NSURL(string: gitLink)! as URL)
            }
            else if (tappedNode.name == "FBNode") {
                UIApplication.shared.openURL(NSURL(string: FBLink)! as URL)
            }
            else if (tappedNode.name == "LINode") {
                UIApplication.shared.openURL(NSURL(string: LInk)! as URL)
            }
            else if (tappedNode.name == "PersonalNode") {
                UIApplication.shared.openURL(NSURL(string: LInk)! as URL)
            }
        }
    }
    
}

