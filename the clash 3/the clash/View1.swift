//
//  View1.swift
//  the clash
//
//  Created by Maggie Fei on 2018-01-27.
//  Copyright © 2018 Maggie Fei. All rights reserved.
//

import UIKit
import ARKit

var message: String = ""

class View1: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    //@IBOutlet weak var sceneView: ARSCNView!
    //static let view1 = View1()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        textField.returnKeyType = .done
        
        // Get notified every time the text changes, so we can save it
        //let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self,
                                //selector: #selector(textFieldDidChange(_:)),
                                  //     name: Notification.Name.UITextFieldTextDidChange,
                                    //   object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        message = textField.text!
    }
    
    func textFieldDidChange(_ sender: Any) {
        if let notification = sender as? Notification,
            let textFieldChanged = notification.object as? UITextField,
            textFieldChanged == self.textField {
            message = textField.text!
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
