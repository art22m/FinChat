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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - @IBOutlet
    @IBOutlet weak var labelInitials: UILabel!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonClose: UIBarButtonItem!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSaveGCD: UIButton!
    
    enum EditingMode {
        case image
        case textFields
    }
    
    // Use to make save button active / not active
    var initialTextFieldName: String? = ""
    var initialTextFieldDescription: String? = ""
    var initialAvatarImage: UIImage? = UIImage(named: "avatarPlaceholder")
    
    let alertSuccess = UIAlertController(title: "Data", message: "Data saved successfully", preferredStyle: .alert)
    let alertError = UIAlertController(title: "Data", message: "Data didn't saved", preferredStyle: .alert)
    
    private var dataManagerGCD: DataManager = GCDDataManager()
    
    // Used to send data for saving
    private var dataFromProfile: WorkingData = WorkingData()
    
    // MARK: - @IBActions
    @IBAction func saveGCDTapped(_ sender: Any) {
        dataFromProfile.nameFromProfile = textFieldName.text
        dataFromProfile.descriptionFromProfile = textFieldDescription.text
        if imageAvatar.image == UIImage(named: "avatarPlaceholder") {
            dataFromProfile.imageFromProfile = nil
        } else {
            dataFromProfile.imageFromProfile = imageAvatar.image
        }
    
        var statusGCD: SuccessStatus = .success
        
        dataManagerGCD.saveData(dataToSave: dataFromProfile, isSuccessful: { status in
                statusGCD = status
        })
        
        if statusGCD == .success {
            self.present(alertSuccess, animated: true)
        } else {
            self.present(alertError, animated: true)
        }
        
        editMode(.textFields)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        textFieldName.text = initialTextFieldName
        textFieldDescription.text = initialTextFieldDescription
        imageAvatar.image = initialAvatarImage
        
        displayInitials()
        
        self.normalMode()
    }
    
    @IBAction func editTapped(_ sender: Any) {
        editMode(.textFields)
    }
    
    @IBAction func buttonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Initialize variable theme of class VCTheme() to change the theme of the screen
    var theme = VCTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        normalMode()
        updateData()
        
        alertSuccess.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        alertError.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        alertError.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [self] action in
            saveGCDTapped((Any).self)
        }))
        
        textFieldName.returnKeyType = .continue
        textFieldName.autocapitalizationType = .words
        textFieldName.autocorrectionType = .no
        textFieldName.delegate = self
        textFieldName.attributedPlaceholder = NSAttributedString(string: "Name Surname", attributes: [NSAttributedString.Key.foregroundColor: theme.getCurrentFontColor().withAlphaComponent(0.5)])

        textFieldDescription.returnKeyType = .done
        textFieldDescription.autocorrectionType = .no
        textFieldDescription.delegate = self
        textFieldDescription.attributedPlaceholder = NSAttributedString(string: "A few words about you", attributes: [NSAttributedString.Key.foregroundColor: theme.getCurrentFontColor().withAlphaComponent(0.5)])
        
        self.hideKeyboardWhenTappedAround()
        
        // Set the current appearence
        view.backgroundColor = theme.getCurrentBackgroundColor()
        textFieldName.textColor = theme.getCurrentFontColor()
        textFieldDescription.textColor = theme.getCurrentFontColor()
        
        // Make the avatar round
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width / 2
        imageAvatar.clipsToBounds = true
        imageAvatar.layer.borderWidth = 1
        
        // Make buttons and TextFields rounded
        buttonEdit.layer.cornerRadius = 15
        buttonCancel.layer.cornerRadius = 15
        buttonSaveGCD.layer.cornerRadius = 15
        textFieldName.layer.cornerRadius = 15
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
    
    private func normalMode() {
        textFieldName.backgroundColor = .clear
        textFieldDescription.backgroundColor = .clear
        textFieldName.isUserInteractionEnabled = false
        textFieldDescription.isUserInteractionEnabled = false
        textFieldName.borderStyle = .none
        textFieldDescription.borderStyle = .none
        
        buttonEdit.isHidden = false
        buttonCancel.isHidden = true
        buttonSaveGCD.isHidden = true
    }
    
    private func editMode(_ mode: EditingMode) {
        if (mode == .textFields) {
            textFieldName.backgroundColor = theme.getCurrentBackgroundColor()
            textFieldDescription.backgroundColor = theme.getCurrentBackgroundColor()
            textFieldName.isUserInteractionEnabled = true
            textFieldDescription.isUserInteractionEnabled = true
            textFieldName.becomeFirstResponder()
            textFieldName.borderStyle = .roundedRect
            textFieldDescription.borderStyle = .roundedRect
            
            initialTextFieldName = textFieldName.text
            initialTextFieldDescription = textFieldDescription.text
            initialAvatarImage = imageAvatar.image
        } else if (mode == .image) {
            displayInitials()
        }
        
        checkForDifference()
        
        buttonEdit.isHidden = true
        buttonCancel.isHidden = false
        buttonSaveGCD.isHidden = false
    }
    
    // Check if UILabelField or UIImage was changed. If yes -> make save button available.
    private func checkForDifference() {
        if (initialTextFieldName == textFieldName.text && initialTextFieldDescription == textFieldDescription.text && initialAvatarImage == imageAvatar.image) {
            buttonSaveGCD.alpha = 0.3
            buttonSaveGCD.isEnabled = false
        } else {
            if (textFieldName.text?.isEmpty == false) {
                labelInitials.text = textFieldName.text?.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
            }
            
            buttonSaveGCD.alpha = 0.7
            buttonSaveGCD.isEnabled = true
        }
    }
    
    private func displayInitials() {
        if imageAvatar.image == UIImage(named: "avatarPlaceholder")  {
            self.labelInitials.isHidden = false
        } else {
            self.labelInitials.isHidden = true
        }
    }
    
    private func updateData() {
        dataManagerGCD.readData(isSuccessful: { (profile, responce) in
            if responce == SuccessStatus.success {
                DispatchQueue.main.async(execute: {
                    self.textFieldName.text = profile.nameFromFile
                    self.textFieldDescription.text = profile.descriptionFromFile
                    self.imageAvatar.image = profile.imageFromFile
                    
                    self.initialTextFieldName = self.textFieldName.text
                    self.initialTextFieldDescription = self.textFieldDescription.text
                    self.initialAvatarImage = self.imageAvatar.image
                    
                    self.labelInitials.text = self.textFieldName.text?.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                    
                    self.displayInitials()
                })
            }
        })
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField) {
            case textFieldName:
                textField.resignFirstResponder()
                textFieldDescription.becomeFirstResponder()
                break
            case textFieldDescription:
                textField.resignFirstResponder()
            default:
                break
        }
        checkForDifference()
        return true
    }
}

// Hide the keyboard then we tapped outside UITextField
extension ProfileViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        checkForDifference()
        view.endEditing(true)
    }
}

// MARK: - Avatar
extension ProfileViewController {
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
        
        if initialAvatarImage != UIImage(named: "avatarPlaceholder") {
            actionSheet.addAction(UIAlertAction(title: "Delete photo", style: .default, handler: { [self] (UIAlertAction) in
                    imageAvatar.image = UIImage(named: "avatarPlaceholder")
                    editMode(.image)
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

        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageAvatar.image = originalImage
        }
        
        editMode(.image)
        
        dismiss(animated: true, completion: nil)
    }
}