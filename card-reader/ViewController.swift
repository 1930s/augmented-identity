//
//  ViewController.swift
//  card-reader
//
//  Created by Edward on 2/1/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import Firebase
import Foundation

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let textRecognizer = Vision.vision().onDeviceTextRecognizer()
    var imageFromArkitScene: UIImage?
    var foundCard: Bool = false
    let spriteKitScene: SKScene = SKScene(fileNamed: "card-info")!
    var name: String = ""
    var num: String = ""
    
    let fadeDuration: TimeInterval = 1
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
        
        sceneView.delegate = self
        sceneView.session.delegate = self

        configureLighting()
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage

        let infoPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        infoPlane.cornerRadius = infoPlane.width / 25

        infoPlane.firstMaterial?.diffuse.contents = spriteKitScene
        infoPlane.firstMaterial?.isDoubleSided = true
        infoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)

        let infoPlaneNode = SCNNode(geometry: infoPlane)
        infoPlaneNode.eulerAngles.x = -.pi / 2
        infoPlaneNode.opacity = 0.10
        infoPlaneNode.position.z = -0.06

        infoPlaneNode.runAction(self.fadeInAction)

        node.addChildNode(infoPlaneNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if (!self.foundCard) {
            let imageFromArkitScene: UIImage? = sceneView.snapshot()
            self.getText(image: imageFromArkitScene!)
        }
        else {
            if let nameLabel = spriteKitScene.childNode(withName: "name") as? SKLabelNode {
                nameLabel.text = self.name
            }
            if let descripLabel = spriteKitScene.childNode(withName: "description") as? SKLabelNode {
                descripLabel.text = "Identity Card"
            }
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
            guard error == nil, let result = result else {
                print("---------------ERROR---------------")
                return
            }
            
//            for block in result.blocks {
//                for line in block.lines {
//                    print(line.text)
//                }
//            }
            if (result.text.contains("University") || result.text.contains("Student") || result.text.contains("UserID")){
                self.foundCard = true
                if let lowerRange = result.text.range(of: "University"),
                   let upperRange = result.text.range(of: " Student") {
                    let name = result.text[lowerRange.upperBound...upperRange.lowerBound]
                    self.name = String(name)
                    print(self.name)
                }
            }
        }
    }
}
