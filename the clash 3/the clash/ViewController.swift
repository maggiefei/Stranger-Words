//
//  ViewController.swift
//  the clash
//
//  Created by Maggie Fei on 2018-01-27.
//  Copyright © 2018 Maggie Fei. All rights reserved.
//

import UIKit
import ARKit

@available(iOS 11.3, *)
class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let V1 : View1 = View1(nibName: "View1", bundle: nil)
        
        let V2 : View2 = View2(nibName: "View2", bundle: nil)
        
        let V3 : View3 = View3(nibName: "View3", bundle: nil)
        
        self.addChildViewController(V1)
        self.scrollView.addSubview(V1.view)
        V1.didMove(toParentViewController: self)
        
        self.addChildViewController(V2)
        self.scrollView.addSubview(V2.view)
        V2.didMove(toParentViewController: self)
        
        self.addChildViewController(V3)
        self.scrollView.addSubview(V3.view)
        
        //self.scrollView.center = CGPoint(x: 2*self.view.frame.width, y: 0)
        
        V3.didMove(toParentViewController: self)
        
        var V2Frame : CGRect = V2.view.frame
        V2Frame.origin.x = self.view.frame.width
        V2.view.frame = V2Frame
        
        var V3Frame : CGRect = V3.view.frame
        V3Frame.origin.x = 2 * self.view.frame.width
        V3.view.frame = V3Frame
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.size.height)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

