//
//  ViewController.swift
//  ImageApp
//
//  Created by Alanda Syla on 11/4/17.
//  Copyright © 2017 Alanda Syla. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Variables
    var images = [UIImage]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Functions
    func collectionViewInit() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerImageCollectionCell()
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAPicture = UIAlertAction(title: "Take a Picture", style: .default) { (_) in
            //Open Camera
            self.openCamera(self)
        }
        let chooseFromGalery = UIAlertAction(title: "Choose From Galery", style: .default) { (_) in
            //Open Galery
            self.checkPhotoLibraryPermission()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(takeAPicture)
        alert.addAction(chooseFromGalery)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "Permission not granted!", message: "Please go to settings to allow permission for using this feature.", preferredStyle: .alert)
        
        let settings = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(settings)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func addImagePressed(_ sender: UIBarButtonItem) {
        self.showActionSheet()
    }
}

//Mark - UICollectionView DataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Image in Full Screen
        let image = images[indexPath.item]
        
        let cell = collectionView.dequeueImageCollectionCell(indexPath: indexPath)
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        let fullScreenVC = FullScreenViewController.create()
        fullScreenVC.image = image
        self.present(fullScreenVC, animated: true, completion: nil)
        
    }
    //Size of Collection Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 24) / 3
        let height = width * 1.3
        return CGSize(width: width, height: height)
    }
}
//Mark: - Image Picker Delegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.images.append(image)
                
                if self.images.count > 0 {
                    self.infoLabel.isHidden = true
                }else {
                    self.infoLabel.isHidden = false
                }
                self.collectionView.reloadData()
            })
        }
    }
    
    func openCamera(_ sender: AnyObject) {
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            //Open Camera
            self.openImagePickerController(sourceType: UIImagePickerControllerSourceType.camera)
            }
        else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                self.openImagePickerController(sourceType: UIImagePickerControllerSourceType.camera)
        } else {
                self.showPermissionAlert()
            }
        })
        }
    }
        
    func openPhotoLibrary(_ sender: AnyObject) {
            self.openImagePickerController(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func openImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            self.openPhotoLibrary(self)
        case .denied, .restricted:
            self.showPermissionAlert()
        case .notDetermined:
            //ask for permission
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    self.openPhotoLibrary(self)
                case .denied, .restricted:
                    self.showPermissionAlert()
                case .notDetermined:
                    //show alert
                    self.showPermissionAlert()
                }
            })
        }
    }
}

