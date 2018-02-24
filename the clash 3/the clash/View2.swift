//
//  View2.swift
//  the clash
//
//  Created by Maggie Fei on 2018-01-27.
//  Copyright © 2018 Maggie Fei. All rights reserved.
//

import UIKit
import ARKit

class VirtualPlane: SCNNode {
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!
    
    func initializePlaneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.50)
        return material
    }
    
    func updatePlaneMaterialDimensions() {
        // get material or recreate
        let material = self.planeGeometry.materials.first!
        
        // scale material to width and height of the updated plane
        let width = Float(self.planeGeometry.width)
        let height = Float(self.planeGeometry.height)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1.0)
    }
    
    func updateWithNewAnchor(_ anchor: ARPlaneAnchor) {
        // first, we update the extent of the plane, because it might have changed
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        // now we should update the position (remember the transform applied)
        self.position = position
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        // update the material representation for this plane
        updatePlaneMaterialDimensions()
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        //let material = initializePlaneMaterial()
        //self.planeGeometry!.materials = [material]
        
        // (2) create the SceneKit plane node. As planes in SceneKit are vertical, we need to initialize the y coordinate to 0,
        // use the z coordinate, and rotate it 90º.
        let planeNode = SCNNode(geometry: self.planeGeometry)
        //planeNode.position = position
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0)
        
        // (3) update the material representation for this plane
        updatePlaneMaterialDimensions()
        
        // (4) add this node to our hierarchy.
        self.addChildNode(planeNode)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}

@available(iOS 11.3, *)
class View2: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    var planes = [UUID: VirtualPlane]()
    let scene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        //addSwipeGestureToSceneView()
        sceneView.delegate = self
        sceneView.scene = scene
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    /*override func didMove() {
        
    }*/

    
    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   // }
    let material = SCNMaterial()
    
    func createLight(at position: SCNVector3) -> SCNNode {
        let plane = SCNPlane(width: 1.7, height: 1.7)
        let node = SCNNode(geometry: plane)
    
        node.position = position
        //node.rotation = SCNVector4(x: 0.2, y: 0, z: 0, w: Float(M_PI / 2))
        //node.pivot = SCNMatrix4MakeRotation(Float(CGFloat(M_PI_2)), 1, 1, 0)
        plane.firstMaterial = material

        return node
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        sceneView.session.run(configuration)
        //print("hi")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(View2.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /*func addSwipeGestureToSceneView() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(View2.didSwipe(withGestureRecognizer:)))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        sceneView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc func didSwipe(withGestureRecognizer recognizer: UIGestureRecognizer) {
        print("hihihihihihi")
    }*/
    
    var timer = Timer()
    var tap = 0
    var light: SCNNode!
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        //sleep(4)
        if tap == 1 {
            light.removeFromParentNode()
            tap = 0
            return
        }
        
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        
        tap = 1
        let translation = hitTestResult.worldTransform
        let x = translation.columns.3.x
        let y = translation.columns.3.y
        let z = translation.columns.3.z
        
        //guard let shipScene = SCNScene(named: "ship.scn"),
        //    let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
        //    else { return }
        
        let position = SCNVector3(x,y,z)
        //sceneView.scene.rootNode.addChildNode(shipNode)
        
        material.diffuse.contents = #imageLiteral(resourceName: "sthings_blank.png")
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        //let position = SCNVector3(0, 0, -1)
        light = createLight(at: position)
        scene.rootNode.addChildNode(light)
    }
    
    var counter = 0
    
    @objc func timerAction() {
        let image = "sthings_" + String(Array(message.lowercased())[counter]) + ".png"
        print(image)
        material.diffuse.contents = #imageLiteral(resourceName: image)
        
        if counter < Array(message.lowercased()).count - 1 {
            counter += 1
        }
        else {
            counter = 0
            timer.invalidate()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor {
            //let plane = VirtualPlane(anchor: arPlaneAnchor)
            //self.planes[arPlaneAnchor.identifier] = plane
            //node.addChildNode(plane)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = planes[arPlaneAnchor.identifier] {
            plane.updateWithNewAnchor(arPlaneAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: arPlaneAnchor.identifier) {
            planes.remove(at: index)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
