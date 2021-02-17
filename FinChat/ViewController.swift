//
//  ViewController.swift
//  FinChat
//
//  Created by Артём Мурашко on 17.02.2021.
//

import UIKit

// logSwitch variable of type Bool is responsible for enabling / disabling logs.
// If you want to enable logging, set the variable to true, otherwise false
var logSwitch : Bool = true

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logPrint(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logPrint(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        logPrint(#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logPrint(#function)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logPrint(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logPrint(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logPrint(#function)
    }
    
    func logPrint(_ methodName : String) {
        if (logSwitch) {
            print(methodName)
        }
    }
}

