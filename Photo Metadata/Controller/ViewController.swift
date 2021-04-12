//
//  ViewController.swift
//  Photo Metadata
//
//  Created by Marcy Vernon on 1/29/18.
//  Copyright © 2018 com.MarcyVernon. All rights reserved.
//

import UIKit
import Photos
import MapKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView      : UIImageView!
    @IBOutlet weak var dateLabel      : UILabel!
    @IBOutlet weak var latitudeLabel  : UILabel!
    @IBOutlet weak var longitudeLabel : UILabel!
    @IBOutlet weak var mapView        : MKMapView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    //MARK: - Choose a photo
    @IBAction func choosePhoto(_ sender: Any) {
        checkAuthorization()
    }
    
    func checkAuthorization() {
        switch PHPhotoLibrary.authorizationStatus() {
            case PHAuthorizationStatus.notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                                                        if (newStatus == PHAuthorizationStatus.authorized) {
                                                            self.pickPhotoFromLibrary()
                                                        }})
            case PHAuthorizationStatus.authorized:
                pickPhotoFromLibrary()
            default:
                presentAlert(viewController: self, title: Title.alert.rawValue, message: K.photoPolicy)
        }
    }
    
    //MARK: Open image picker to select photo
    func pickPhotoFromLibrary() {
        DispatchQueue.main.async {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType    = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }

    }
} // end of ViewController


extension ViewController: UIImagePickerControllerDelegate {
    
    //MARK: Dismiss on Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Get photo and metadata
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        imageView.image = pickedImage
        
        let asset = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.phAsset)] as? PHAsset
    
        dismiss(animated:true) {
            self.updateUI(viewController: self, asset: asset)
       }
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
   
    //MARK: - Get GPS location and map it
    func updateUI(viewController: UIViewController, asset: PHAsset?) {
        
        //MARK: Map location if available
        if let loc = asset?.location {
            mapPhoto(location: loc)
        } else {
            latitudeLabel.text  = Error.latitude.rawValue
            longitudeLabel.text = Error.longitude.rawValue
        }
        
        //MARK: Get creation date if available
        if let creation = asset?.creationDate {
            dateLabel.text = String(describing: creation)
        } else {
            dateLabel.text = Error.data.rawValue
        }
    }
    
    //MARK: Map Photo, Set Map Pin
    func mapPhoto(location: CLLocation) {
        let imageLocation = location
        latitudeLabel.text  = String(imageLocation.coordinate.latitude)
        longitudeLabel.text = String(imageLocation.coordinate.longitude)
        
        let span: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let theLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(imageLocation.coordinate.latitude, imageLocation.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion.init(center: theLocation, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = false
        mapView.mapType           = .hybridFlyover
        mapView.showsCompass      = true
        mapView.showsScale        = true
        
        let newPin        = MKPointAnnotation()
        newPin.coordinate = theLocation
        
        mapView.addAnnotation(newPin)
    }
  }
