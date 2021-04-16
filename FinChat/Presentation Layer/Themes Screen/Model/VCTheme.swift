//
//  VCTheme.swift
//  FinChat
//
//  Created by Артём Мурашко on 11.03.2021.
//

import UIKit

public class VCTheme {
    enum Theme {
        case classic
        case day
        case night
    }
    
    var currentTheme: Theme
    
    // Classic colors
    let classicBackgroundColor: UIColor = .white
    let classicFontColor: UIColor = .black
    let classicIncomeColor: UIColor = UIColor(red: 220.0/255.0, green: 225.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    let classicOutcomeColor: UIColor = UIColor(red: 213.0/255.0, green: 249.0/255.0, blue: 192.0/255.0, alpha: 1.0)
    
    // Day colors
    let dayBackgroundColor: UIColor = .white
    let dayFontColor: UIColor = .black
    let dayIncomeColor: UIColor = UIColor(red: 234.0/255.0, green: 235.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    let dayOutcomeColor: UIColor = UIColor(red: 38.0/255.0, green: 136.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    // Night colors
    let nightBackgroundColor: UIColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    let nightFontColor: UIColor = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 190.0/255.0, alpha: 1.0)
    let nightIncomeColor: UIColor = UIColor(red: 46.0/255.0, green: 46.0/255.0, blue: 46.0/255.0, alpha: 1.0)
    let nightOutcomeColor: UIColor = UIColor(red: 92.0/255.0, green: 92.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
    func getCurrentBackgroundColor() -> UIColor {
        switch currentTheme {
            case .classic:
                return classicBackgroundColor
            case .day:
                return dayBackgroundColor
            case .night:
                return nightBackgroundColor
        }
    }
    
    func getCurrentFontColor() -> UIColor {
        switch currentTheme {
            case .classic:
                return classicFontColor
            case .day:
                return dayFontColor
            case .night:
                return nightFontColor
        }
    }
    
    func getCurrentIncomeColor() -> UIColor {
        switch currentTheme {
            case .classic:
                return classicIncomeColor
            case .day:
                return dayIncomeColor
            case .night:
                return nightIncomeColor
        }
    }
    
    func getCurrentOutcomeColor() -> UIColor {
        switch currentTheme {
            case .classic:
                return classicOutcomeColor
            case .day:
                return dayOutcomeColor
            case .night:
                return nightOutcomeColor
        }
    }
    
    init() {
        currentTheme = .classic
    }
}
