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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
  }
  
  //MARK: - Choose a photo
  @IBAction func choosePhoto(_ sender: Any) {
    
    switch PHPhotoLibrary.authorizationStatus() {
    case PHAuthorizationStatus.notDetermined:
      PHPhotoLibrary.requestAuthorization({ (newStatus) in
        if (newStatus == PHAuthorizationStatus.authorized) {
          self.pickPhotoFromLibrary()
        }})
    case PHAuthorizationStatus.authorized:
      pickPhotoFromLibrary()
    default:
      createAlert()
    }
    
  }
  
  //MARK: Open image picker to select photo
  func pickPhotoFromLibrary() {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    present(self.imagePicker, animated: true, completion: nil)
  }
  
  //MARK: Alert = permission to photos not yet granted
  func createAlert() {
    
    let alert = UIAlertController(title: "Alert", message: "This app needs permission to access the photo library. Go to Settings > Privacy > Photos > PhotoMetadata.", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  
  //MARK: Get photo and metadata
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
    let asset = info[UIImagePickerControllerPHAsset] as? PHAsset
    
    imageView.image = pickedImage
    
    self.dismiss(animated:true) {
      
      // Get GPS location and map it
      if let loc = asset?.location {
        let imageLocation: CLLocation = loc
        self.latitudeLabel.text  = String(imageLocation.coordinate.latitude)
        self.longitudeLabel.text = String(imageLocation.coordinate.longitude)
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let theLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(imageLocation.coordinate.latitude, imageLocation.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(theLocation, span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        // self.mapView.mapType = .hybrid
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        let newPin = MKPointAnnotation()
        newPin.coordinate = theLocation
        self.mapView.addAnnotation(newPin)
      } else {
        self.latitudeLabel.text  = "latitude unavailable on this photo"
        self.longitudeLabel.text = "longitude unavailable on this photo"
      }
      
      // Get creation date
      if let creation = asset?.creationDate {
        self.dateLabel.text = String(describing: creation)
      } else {
        self.dateLabel.text = "date unavailable on this photo"
      }
    }
  }
  
  //MARK: Dismiss on Cancel
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    imagePicker.dismiss(animated: true, completion: nil)
  }
}


