//
//  AMInputView.swift
//  AMLoginSingup
//
//  Created by amir on 10/11/16.
//  Copyright © 2016 amirs.eu. All rights reserved.
//

import UIKit

@IBDesignable class AMInputView: UIView,UITextFieldDelegate {
    
    
    
    let animationDuration = 0.25
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var backWhiteView: UIView!
    @IBOutlet weak var labelView: UILabel!
    
    
    //MARK: - IBInspectable properties
    @IBInspectable var Title:String = ""{
        didSet{
            if labelView != nil{
                labelView.text = Title
            }
        }
    }
    
    @IBInspectable var KeyboardType:Int = UIKeyboardType.default.rawValue{
        didSet{
            if textFieldView != nil{
                textFieldView.keyboardType = UIKeyboardType(rawValue: KeyboardType)!
            }
        }
    }
    
    
    @IBInspectable var isSecureTextEntry:Bool = false{
        didSet{
            if textFieldView != nil{
                textFieldView.isSecureTextEntry = isSecureTextEntry
            }
        }
    }
    
    
    
    //MARK: - constraints
    @IBOutlet weak var backViewHeightExpandConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelViewRightExpandConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelViewLeftExpandConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelViewHTopExpandConstraint: NSLayoutConstraint!
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
       
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    
    private func setup(){
    
         loadNib()
        
        self.addSubview(contentView)
        
        self.addConstraints([
            
            NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            
            ])
        
        
        
        textFieldView.tintColor = UIColor.white
        textFieldView.delegate = self
        textFieldView.returnKeyType = .done
        textFieldView.keyboardAppearance = .dark
        backgroundColor = UIColor.clear
    }
    
    
    private func loadNib() {
        let bundle = Bundle(for: AMInputView.classForCoder())
        bundle.loadNibNamed("AMInputView", owner: self, options: nil)
    }
    
    
    //MARK: - textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField.text?.lengthOfBytes(using: .utf8))! < 1 {
            setViewExpandMode(expand:true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text?.lengthOfBytes(using: .utf8))! < 1 {
            setViewExpandMode(expand:false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.endEditing(true)
        return true
    }
    
    
    
    //MARK: - change view
    private func setViewExpandMode(expand:Bool){
    
        backViewHeightExpandConstraint.priority = expand ? 500:200
        labelViewHTopExpandConstraint.priority = expand ? 500:200
        labelViewRightExpandConstraint.priority = expand ? 500:300
        labelViewLeftExpandConstraint.priority = expand ? 999:300
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
            self.backWhiteView.alpha = expand ? 0.6:0.08
            
            let scale:CGFloat = expand ? 0.7:1
            
            self.labelView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            if expand {
            
                let leftMargin = (-1 * ((1-scale)*(self.labelView.layer.bounds.size.width))/2 ) - 11;
                self.labelView.transform = self.labelView.transform.translatedBy(x: leftMargin, y: 0)
            }
        }
    }
    
    
}
