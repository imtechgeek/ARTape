//
//  ViewController.swift
//  ARTape
//
//  Created by Usman on 17/12/2019.
//  Copyright © 2019 Usman. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView){
            let hitTestResult = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTestResult.first {
                addDot(at: hitResult)
            }
        }
    }
    func addDot(at hitResult: ARHitTestResult){
        if dotNodes.count >= 2{
            for dots in dotNodes{
            dots.removeFromParentNode()
        }
            dotNodes.removeAll()

        }
        let dotGeometry = SCNSphere(radius: 0.003)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2{
            calculate()
        }
    }
    func calculate(){
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
        
        updateText(text: "\(abs(distance))", atPosition: end.position)

        
    }
    func updateText(text: String, atPosition: SCNVector3){
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.5)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
         textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(atPosition.x, atPosition.y + 0.02, atPosition.z - 0.03)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
}
