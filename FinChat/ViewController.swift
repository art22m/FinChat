//
//  ViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 17.02.2021.
//

import UIKit

// logSwitch variable of type Bool is responsible for enabling / disabling logs for AppDelegate (previous HW).
// If you want to enable logging, set the variable to true, otherwise false
var logSwitch : Bool = false

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // The init will be constantly displayed "none", because the view has not even loaded yet
        if let frame = buttonEdit?.frame {
            print("\(#function) \(frame)")
        } else {
             print("\(#function) none")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let frame = buttonEdit?.frame {
            print("\(#function) \(frame)")
        } else {
             print("\(#function) none")
        }
        
        // Make the avatar round
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width / 2
        imageAvatar.clipsToBounds = true
        
        // Make the button rounded
        buttonEdit.layer.cornerRadius = 15
        
        // Make avatar clickable
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatarImage(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        
        imageAvatar.addGestureRecognizer(gestureRecognizer)
        imageAvatar.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* The original ViewController is loaded from the storyboard.
        Then this View will change to fit the simulator screen.
            
        Since the iPhone SE is selected in the strodyboard, and in the simulator we
        select the iPhone 11 Pro, which is larger in size, the button resizes.
         */
        if let frame = buttonEdit?.frame {
            print("\(#function) \(frame)")
        } else {
             print("\(#function) none")
        }
    }
    
    @objc func tapOnAvatarImage(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.view)
        let centerPoint = imageAvatar.center
        let radius = imageAvatar.frame.size.width / 2
            
        // Check if the click coordinates is inside the circle ((x-x0)^2 + (y - y0)^2 <= r^2)
        guard pow((tapPoint.x - centerPoint.x), 2) + pow((tapPoint.y - centerPoint.y), 2) <= pow(radius, 2) else {return}
        
        showActionSheet()
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Change avatar", message: "Choose a source to change the avatar", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showImagePickerController(sourceType: .camera)
            } else {
                // We can show alert if the camera is not available
                print("Camera is not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
    
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageAvatar.image = editedImage
            labelInitials.isHidden = true
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageAvatar.image = originalImage
            labelInitials.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}
