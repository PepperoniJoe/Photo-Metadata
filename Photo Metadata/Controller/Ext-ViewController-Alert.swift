//
//  Ext-ViewController-Alert.swift
//  Photo Metadata
//
//  Created by Marcy Vernon on 8/7/20.
//  Copyright © 2020 com.MarcyVernon. All rights reserved.
//

import UIKit

extension ViewController {
    
    func presentAlert(viewController: UIViewController, title: String, message: String) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      
      // add an action (button)
        alert.addAction(UIAlertAction(title: Title.ok.rawValue, style: UIAlertAction.Style.default, handler: nil))
      
      // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
