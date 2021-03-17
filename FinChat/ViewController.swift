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
    
    // MARK: - @IBOutlet
    @IBOutlet weak var labelInitials: UILabel!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonClose: UIBarButtonItem!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSaveGCD: UIButton!
    @IBOutlet weak var buttonSaveOperations: UIButton!
    
    // MARK: - @IBActions
    @IBAction func saveOperationsTapped(_ sender: Any) {
        print("Right")
    }
    @IBAction func saveGCDTapped(_ sender: Any) {
        print("Left")
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.normalMode()
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.editMode()
    }
    
    @IBAction func buttonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Initialize variable theme of class VCTheme() to change the theme of the screen
    var theme = VCTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        normalMode()
        
        textFieldName.returnKeyType = .continue
        textFieldName.autocapitalizationType = .words
        textFieldName.autocorrectionType = .no
        textFieldName.delegate = self
        
        textFieldDescription.returnKeyType = .continue
        textFieldDescription.autocorrectionType = .no
        textFieldDescription.delegate = self
        
        textFieldLocation.returnKeyType = .done
        textFieldLocation.autocapitalizationType = .words
        textFieldLocation.autocorrectionType = .no
        textFieldLocation.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        // Set the current appearence
        view.backgroundColor = theme.getCurrentBackgroundColor()
        textFieldName.textColor = theme.getCurrentFontColor()
        textFieldDescription.textColor = theme.getCurrentFontColor()
        textFieldLocation.textColor = theme.getCurrentFontColor()
        
        // Make the avatar round
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width / 2
        imageAvatar.clipsToBounds = true
        imageAvatar.layer.borderWidth = 1
        
        // Make buttons and TextFields rounded
        buttonEdit.layer.cornerRadius = 15
        buttonCancel.layer.cornerRadius = 15
        buttonSaveOperations.layer.cornerRadius = 15
        buttonSaveGCD.layer.cornerRadius = 15
        textFieldName.layer.cornerRadius = 15
        textFieldLocation.layer.cornerRadius = 15
        textFieldDescription.layer.cornerRadius = 15
        
        // Make avatar clickable
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatarImage(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        
        imageAvatar.addGestureRecognizer(gestureRecognizer)
        imageAvatar.isUserInteractionEnabled = true
    }

    @objc func tapOnAvatarImage(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.view)
        let centerPoint = imageAvatar.center
        let radius = imageAvatar.frame.size.width / 2
            
        // Check if the click coordinates is inside the circle ((x-x0)^2 + (y - y0)^2 <= r^2)
        guard pow((tapPoint.x - centerPoint.x), 2) + pow((tapPoint.y - centerPoint.y), 2) <= pow(radius, 2) else {return}
        
        showActionSheet()
    }
    
    
    func normalMode() {
        textFieldName.isUserInteractionEnabled = false
        textFieldDescription.isUserInteractionEnabled = false
        textFieldLocation.isUserInteractionEnabled = false
        
        textFieldName.borderStyle = .none
        textFieldDescription.borderStyle = .none
        textFieldLocation.borderStyle = .none
        
        buttonEdit.isHidden = false
        buttonCancel.isHidden = true
        buttonSaveGCD.isHidden = true
        buttonSaveOperations.isHidden = true
    }
    
    func editMode() {
        textFieldName.isUserInteractionEnabled = true
        textFieldDescription.isUserInteractionEnabled = true
        textFieldLocation.isUserInteractionEnabled = true
        textFieldName.becomeFirstResponder()
        
        textFieldName.borderStyle = .roundedRect
        textFieldDescription.borderStyle = .roundedRect
        textFieldLocation.borderStyle = .roundedRect
        
        buttonEdit.isHidden = true
        buttonCancel.isHidden = false
        buttonSaveGCD.isHidden = false
        buttonSaveOperations.isHidden = false
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Change avatar", message: "Choose a source to change the avatar", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
                    self.showImagePickerController(sourceType: .camera)
            }))
        }
        
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

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField) {
            case textFieldName:
                textField.resignFirstResponder()
                textFieldDescription.becomeFirstResponder()
                break
            case textFieldDescription:
                textField.resignFirstResponder()
                textFieldLocation.becomeFirstResponder()
                break
            case textFieldLocation:
                textFieldLocation.resignFirstResponder()
                break
            default:
                break
        }
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
