//
//  ThemesViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 10.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var classicLabel: UILabel!
    @IBOutlet weak var classicView: UIView!
    @IBOutlet weak var classicLeftView: UIView!
    @IBOutlet weak var classicRightView: UIView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayLeftView: UIView!
    @IBOutlet weak var dayRightView: UIView!
    
    @IBOutlet weak var nightLabel: UILabel!
    @IBOutlet weak var nightView: UIView!
    @IBOutlet weak var nightLeftView: UIView!
    @IBOutlet weak var nightRightView: UIView!
    
    // Initialize variable theme of class VCTheme() to change the theme of the screen
    var theme = VCTheme()
    
    weak var themeDelegate: ThemesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 15.0/255.0, green: 54.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        
        // Top button
        classicView.layer.cornerRadius = 16
        classicView.layer.borderColor = UIColor(red: 87.0/255.0, green: 118.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor
        classicLeftView.layer.cornerRadius = 14
        classicRightView.layer.cornerRadius = 14
    
        classicView.backgroundColor = theme.classicBackgroundColor
        classicLeftView.backgroundColor = theme.classicIncomeColor
        classicRightView.backgroundColor = theme.classicOutcomeColor
        classicLabel.textColor = .white
        
        // Middle button
        dayView.layer.cornerRadius = 16
        dayView.layer.borderColor = UIColor(red: 87.0/255.0, green: 118.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor
        dayLeftView.layer.cornerRadius = 14
        dayRightView.layer.cornerRadius = 14
        
        dayView.backgroundColor = theme.dayBackgroundColor
        dayLeftView.backgroundColor = theme.dayIncomeColor
        dayRightView.backgroundColor = theme.dayOutcomeColor
        dayLabel.textColor = .white
        
        // Bottom button
        nightView.layer.cornerRadius = 16
        nightView.layer.borderColor = UIColor(red: 87.0/255.0, green: 118.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor
        nightLeftView.layer.cornerRadius = 14
        nightRightView.layer.cornerRadius = 14
        
        nightView.backgroundColor = theme.nightBackgroundColor
        nightLeftView.backgroundColor = theme.nightIncomeColor
        nightRightView.backgroundColor = theme.nightOutcomeColor
        nightLabel.textColor = .white
        
        // Determine the border of button for current theme
        changeBorder()
        
        // Make Classic View tapable
        var gestureRecognizerTop: UITapGestureRecognizer {
               get {
                   return UITapGestureRecognizer(target: self, action: #selector(tapOnClassicView(_:)))
               }
        }
        
        classicView.addGestureRecognizer(gestureRecognizerTop)
        classicView.isUserInteractionEnabled = true
        classicLabel.addGestureRecognizer(gestureRecognizerTop)
        classicLabel.isUserInteractionEnabled = true
        
        
        // Make Day View tapable
        var gestureRecognizerMiddle: UITapGestureRecognizer {
               get {
                   return UITapGestureRecognizer(target: self, action: #selector(tapOnDayView(_:)))
               }
        }
        
        dayView.addGestureRecognizer(gestureRecognizerMiddle)
        dayView.isUserInteractionEnabled = true
        dayLabel.addGestureRecognizer(gestureRecognizerMiddle)
        dayLabel.isUserInteractionEnabled = true
        
        
        // Make Night View tapable
        var gestureRecognizerBottom: UITapGestureRecognizer {
               get {
                   return UITapGestureRecognizer(target: self, action: #selector(tapOnNightivView(_:)))
               }
        }
        
        nightView.addGestureRecognizer(gestureRecognizerBottom)
        nightView.isUserInteractionEnabled = true
        nightLabel.addGestureRecognizer(gestureRecognizerBottom)
        nightLabel.isUserInteractionEnabled = true
    }
    
    @objc func tapOnClassicView(_ sender: UITapGestureRecognizer) {
        theme.currentTheme = .classic
        changeBorder()
        themeDelegate?.updateTheme(theme.currentTheme)
    }
    
    
    @objc func tapOnDayView(_ sender: UITapGestureRecognizer) {
        theme.currentTheme = .day
        changeBorder()
        themeDelegate?.updateTheme(theme.currentTheme)
    }
    
    @objc func tapOnNightivView(_ sender: UITapGestureRecognizer) {
        theme.currentTheme = .night
        changeBorder()
        themeDelegate?.updateTheme(theme.currentTheme)
    }
    
    func changeBorder() {
        switch theme.currentTheme {
            case .classic:
                classicView.layer.borderWidth = 4
                dayView.layer.borderWidth = 0
                nightView.layer.borderWidth = 0
            case .day:
                classicView.layer.borderWidth = 0
                dayView.layer.borderWidth = 4
                nightView.layer.borderWidth = 0
            case .night:
                classicView.layer.borderWidth = 0
                dayView.layer.borderWidth = 0
                nightView.layer.borderWidth = 4
        }
    }
    
}
