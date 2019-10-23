//
//  locationDetailsViewController.swift
//  HelpByDrone
//
//  Created by Focus on 12/10/19.
//  Copyright © 2019 Focus. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    print("To prove the formatter only runs once, not draining your phone battery")
    return formatter
}()

class LocationDetailsViewController: UITableViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addMediaLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var managedObjectContext: NSManagedObjectContext!
    var coordinates = CLLocationCoordinate2D (latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "I don't know"
    var date = Date()
    var editDescription = ""
    var image: UIImage?
    var observer: Any!
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                editDescription = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location = locationToEdit {
            title = "Edit Case"
            if location.hasPhoto {
                if let theImage = location.photoImage {
                    show(image: theImage)
                }
            }
        }
        descriptionTextView.text = editDescription
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinates.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinates.longitude)
        if let placemark = placemark {
            addressLabel.text = placeMarkString(from: placemark)
        } else {
            addressLabel.text = "Location Identity Not Found"
        }
        
        dateLabel.text = format(date: date)
        
        let gestureRegonizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboarD))
        gestureRegonizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRegonizer)
        
        listenForBackgroundNotification()
    }
    
    deinit {
        print("*** deinit \(self)")
        NotificationCenter.default.removeObserver(observer)
    }
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    //helper method
    func placeMarkString(from placemark: CLPlacemark) -> String {
        var line = ""
        line.add(text: placemark.subThoroughfare)
        line.add(text: placemark.thoroughfare, separatedBy: " ")
        line.add(text: placemark.locality, separatedBy: ", ")
        line.add(text: placemark.administrativeArea, separatedBy: ", ")
        line.add(text: placemark.postalCode, separatedBy: " ")
        
        return line
    }
    
    func format (date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    @objc func hideKeyboarD(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        addMediaLabel.text = ""
        imageHeight.constant = 300
        tableView.reloadData()
    }
    
    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: OperationQueue.main) {
            [weak self] _ in
            if let weakSelf = self {
                if weakSelf.presentedViewController != nil {
                    weakSelf.dismiss(animated: false, completion: nil)
                }
                weakSelf.descriptionTextView.resignFirstResponder()
            }
        }
    }
    //MARK:- Actions
    @IBAction func done() {
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        let location: Location
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
        }
        location.photoID = nil
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.date = date
        location.placemark = placemark
        //Save Image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
            //        navigationController?.popViewController(animated: true)
        } catch {
            fatalCoreDataError(error)
        }
        
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    
    
    //MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            //dismiss the grey selected area
            tableView.deselectRow(at: indexPath, animated: true)
            decideImageSource()
        }
    }
}

extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK:- Image Helper Methods
    func fromCamera () {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func fromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func decideImageSource() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showImageOptions()
        } else {
            fromLibrary()
        }
    }
    
    func showImageOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let fromCamera = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.fromCamera()})
        let fromLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: {_ in self.fromLibrary()})
        
        alert.addAction(cancel)
        alert.addAction(fromCamera)
        alert.addAction(fromLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    

}
