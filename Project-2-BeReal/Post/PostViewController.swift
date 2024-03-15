//
//  PostViewController.swift
//  Project-2-BeReal
//
//  Created by Muskan Mankikar on 3/8/24.
//

import UIKit
import PhotosUI
import ParseSwift


class PostViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    
    private var pickedImage: UIImage?
    private var location: CLLocationCoordinate2D?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 
    @IBAction func onPickedImageTapped(_ sender: Any) {
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images

        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current

        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker
        present(picker, animated: true)
    }
    
    
    @IBAction func onShareTapped(_ sender: Any) {
        view.endEditing(true)

        // TODO: Pt 1 - Create and save Post
        // Unwrap optional pickedImage
        guard let image = pickedImage,
              // Create and compress image data (jpeg) from UIImage
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        print(imageData)
        // Create a Parse File by providing a name and passing in the image data
        let imageFile = ParseFile(name: "image.jpg", data: imageData)
        
        // unwrap location
//        guard let loc = location,
//              let lat = loc.latitude,
//              let lon = loc.longitude else {
//            return
//        }
        guard let lat = location?.latitude else { return }
        guard let lon = location?.longitude else { return }
       
           
            
        // create GeoPoint
//        var geoLocation = ParseGeoPoint(latitude: lat, longitude: lon)

        // Create Post object
        var post = Post()

        // Set properties
        post.imageFile = imageFile
        post.caption = captionTextField.text

        // Set the user as the current user
        post.user = User.current
        
        // set geoPoint
        do {
            var geoLocation = try ParseGeoPoint(latitude: lat, longitude: lon)
            post.location = geoLocation
        } catch {
            print("error")
        }
        

        // Save object in background (async)
        post.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")

                    // Return to previous view controller
                    if var currentUser = User.current {

                        currentUser.lastPostedDate = Date()

                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")

                                DispatchQueue.main.async {
                                    self?.navigationController?.popViewController(animated: true)
                                }

                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func onTakePhotoTapped(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Dismiss the picker
        picker.dismiss(animated: true)
        
        let result = results.first
//        print(result?.assetIdentifier)
        if let assetId = result?.assetIdentifier {
            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            print("here2")
            DispatchQueue.main.async {
                self.location = assetResults.firstObject?.location?.coordinate
                print("📍 Image location coordinate: \(String(describing: self.location))")
            }
        }
        
        print("📍 Image location coordinate2: \(String(describing: location))")
//        print(result?.itemProvider)

        // Make sure we have a non-nil item provider
        guard let provider = result?.itemProvider,
           // Make sure the provider can load a UIImage
           provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

           // Make sure we can cast the returned object to a UIImage
           guard let image = object as? UIImage else {

              // ❌ Unable to cast to UIImage
              self?.showAlert()
              return
           }

           // Check for and handle any errors
           if let error = error {
              print(error)
              return
           } else {

              // UI updates (like setting image on image view) should be done on main thread
              DispatchQueue.main.async {

                 // Set image on preview image view
                 self?.previewImageView.image = image

                 // Set image to use when saving post
                 self?.pickedImage = image
              }
           }
        }
        
    }
    

}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        picker.dismiss(animated: true)

        
        guard let image = info[.editedImage] as? UIImage else {
            print("❌📷 Unable to get image")
            return
        }

        previewImageView.image = image

        pickedImage = image
       
//        print("HEREEEEE")
//        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
//                print("============> \(asset.location?.coordinate.longitude ?? 0) \(asset.location?.coordinate.latitude ?? 0)")
//            }
    }

}
