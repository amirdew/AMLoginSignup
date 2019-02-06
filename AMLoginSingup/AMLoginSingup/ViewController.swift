//
//  ViewController.swift
//  AMLoginSingup
//
//  Created by amir on 10/11/16.
//  Copyright © 2016 amirs.eu. All rights reserved.
//

import UIKit

enum AMLoginSignupViewMode {
    case login
    case signup
}

class ViewController: UIViewController {
    
    
    let animationDuration = 0.25
    var mode:AMLoginSignupViewMode = .signup
    
    
    //MARK: - background image constraints
    @IBOutlet weak var backImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - login views and constrains
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    
    //MARK: - signup views and constrains
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
   
    
    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    
    
    //MARK: - input views
    @IBOutlet weak var loginEmailInputView: AMInputView!
    @IBOutlet weak var loginPasswordInputView: AMInputView!
    @IBOutlet weak var signupEmailInputView: AMInputView!
    @IBOutlet weak var signupPasswordInputView: AMInputView!
    @IBOutlet weak var signupPasswordConfirmInputView: AMInputView!
    
    
    
    //MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set view to login mode
        toggleViewMode(animated: false)
        
        //add keyboard notification
         NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    
    //MARK: - button actions
    @IBAction func loginButtonTouchUpInside(_ sender: AnyObject) {
   
        if mode == .signup {
             toggleViewMode(animated: true)
        
        }else{
        
            //TODO: login by this data
            NSLog("Email:\(String(describing: loginEmailInputView.textFieldView.text)) Password:\(String(describing: loginPasswordInputView.textFieldView.text))")
            print("is valid login: " + isValidInput(.login).description)
            
        }
    }
    
    @IBAction func signupButtonTouchUpInside(_ sender: AnyObject) {
   
        if mode == .login {
            toggleViewMode(animated: true)
        }else{
            
            //TODO: signup by this data
            NSLog("Email:\(String(describing: signupEmailInputView.textFieldView.text)) Password:\(String(describing: signupPasswordInputView.textFieldView.text)), PasswordConfirm:\(String(describing: signupPasswordConfirmInputView.textFieldView.text))")
            print("is valid signup: " + isValidInput(.signup).description)        }
    }
    
    
    
    //MARK: - toggle view
    func toggleViewMode(animated:Bool){
    
        // toggle mode
        mode = mode == .login ? .signup:.login
        
        
        // set constraints changes
        backImageLeftConstraint.constant = mode == .login ? 0:-self.view.frame.size.width
        
        
        loginWidthConstraint.isActive = mode == .signup ? true:false
        logoCenterConstraint.constant = (mode == .login ? -1:1) * (loginWidthConstraint.multiplier * self.view.frame.size.width)/2
        loginButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: (mode == .login ? 300.0:900.0))
        signupButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: (mode == .signup ? 300.0:900.0))
        
        
        //animate
        self.view.endEditing(true)
        
        UIView.animate(withDuration:animated ? animationDuration:0) {
            
            //animate constraints
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = self.mode == .login ? 1:0
            self.signupContentView.alpha = self.mode == .signup ? 1:0
            
            
            // rotate and scale login button
            let scaleLogin:CGFloat = self.mode == .login ? 1:0.4
            let rotateAngleLogin:CGFloat = self.mode == .login ? 0:CGFloat(-Double.pi/2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLogin, y: scaleLogin)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            
            // rotate and scale signup button
            let scaleSignup:CGFloat = self.mode == .signup ? 1:0.4
            let rotateAngleSignup:CGFloat = self.mode == .signup ? 0:CGFloat(-Double.pi/2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignup, y: scaleSignup)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
        }
        
    }
    
    
    //MARK: - keyboard
    @objc func keyboarFrameChange(notification:NSNotification){
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        
        // get top of keyboard in view
        let topOfKetboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        
        // get animation curve for animate view like keyboard animation
        var animationDuration:TimeInterval = 0.25
        var animationCurve:UIView.AnimationCurve = .easeOut
        if let animDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve =  UIView.AnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        
        // check keyboard is showing
        let keyboardShow = topOfKetboard != self.view.frame.size.height
        
        
        //hide logo in little devices
        let hideLogo = self.view.frame.size.height < 667
        
        // set constraints
        backImageBottomConstraint.constant = self.view.frame.size.height - topOfKetboard
        
        logoTopConstraint.constant = keyboardShow ? (hideLogo ? 0:20):50
        logoHeightConstraint.constant = keyboardShow ? (hideLogo ? 0:40):60
        logoBottomConstraint.constant = keyboardShow ? 20:32
        logoButtomInSingupConstraint.constant = keyboardShow ? 20:32
        
        forgotPassTopConstraint.constant = keyboardShow ? 30:45
        
        loginButtonTopConstraint.constant = keyboardShow ? 25:30
        signupButtonTopConstraint.constant = keyboardShow ? 23:35
        
        loginButton.alpha = keyboardShow ? 1:0.7
        signupButton.alpha = keyboardShow ? 1:0.7
        
        
        
        // animate constraints changes
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
        
    }
    
    //MARK: - hide status bar in swift3
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //shows alert form for invalid input
    func showAlertForFalseValidInput(_ validationOptions: ValidationOptions){
        
        let alertControlerTitle: String
        let alertControllerMessage: String
        
        switch validationOptions {
        case .email:
             alertControlerTitle = "Email Address in invalid format"
             alertControllerMessage = "pleace enter a valid email"
        case .password:
            alertControlerTitle = "Password in invalid format"
            alertControllerMessage = "pleace enter a valid password"
        case .rePassword:
            alertControlerTitle = "Password does not match"
            alertControllerMessage = "pleace enter a valid password"
        }
        
        let alertController = UIAlertController(title: alertControlerTitle , message: alertControllerMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    //input validation
    private func isValidInput(_ amLoginSignupViewMode: AMLoginSignupViewMode) -> Bool{
        
        switch amLoginSignupViewMode {
        case .login:
            guard IsValid.email(loginEmailInputView.textFieldView.text!) else {
                showAlertForFalseValidInput(.email)
                return false
            }
            guard IsValid.password(loginPasswordInputView.textFieldView.text!) else {
                showAlertForFalseValidInput(.password)
                return false
            }
            return true
       
        case .signup:
            guard IsValid.email(signupEmailInputView.textFieldView.text!) else {
                showAlertForFalseValidInput(.email)
                return false
            }
            guard IsValid.password(signupPasswordInputView.textFieldView.text!) else {
                showAlertForFalseValidInput(.password)
                return false
            }
            
            guard IsValid.rePassword(signupPasswordInputView.textFieldView.text!, signupPasswordConfirmInputView.textFieldView.text!) else {
                showAlertForFalseValidInput(.rePassword)
                return false
            }
            return true
        }
    }
}

