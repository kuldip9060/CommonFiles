//
//  AnimatedTextField.swift
//  ShopSnapIt
//
//  Created by Moveo Apps on 22/06/17.
//  Copyright © 2017 Moveo Apps. All rights reserved.
//

import UIKit

class AnimatedTextField: TextField,UITextFieldDelegate {

    weak var newdelegate: UITextFieldDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.delegate = self
    }
    
    
    //MARK: - Textfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        for view in (textField.superview?.subviews)!{
            if view is UILabel && view.tag == 0{
                let lbl = view as! UILabel
                lbl.isHidden = false
                textField.placeholder = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if newdelegate != nil{
            newdelegate?.textFieldDidEndEditing!(textField)
        }
        if textField.text?.length == 0{
            for view in (textField.superview?.subviews)!{
                if view is UILabel && view.tag == 0{
                    let lbl = view as! UILabel
                    lbl.isHidden = true
                    textField.placeholder = lbl.text
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /***************************************
        --------- TAG : DESCRIPRTIONS ---------
        // 1001 : Contact Number Validation  Used in ; Used in : (Contact,)
        // 1002 : Alpha bet validaiton (allow only character & punctual character) ; Used in : (CITY,)
        // 1003 : Only Alphabat Charachter are allow ; Used in : (NAME,)
        // 1004 : Credit/Debit card 16 digits validation and formation
        // 1005 : CVC Code for credit/Debit Card (max 4 chracter) validation
        // 1006 : Decimal value validatin (allow max one ".") in string; Used in Product price , (Ex : 5.15)
        // 1007 : Allow Alphabat and Numeric character  Used in : (UserName), (Ex :  test123)
        ****************************************/
        
        if newdelegate != nil{
            return (newdelegate?.textField!(textField, shouldChangeCharactersIn: range, replacementString: string))!
        }
        switch textField.tag {
        case 1001:
            if (textField.text!.characters.count > 13 && range.length == 0)
            {
                return false // return NO to not change text
            }
            textField.phoneFormater(range: range, string: string) //Set Formate : xxx-xxx-xxxx
            return false
        case 1002:
            let characterSetAlpha = CharacterSet.letters
            let characterSetSymbol = CharacterSet.punctuationCharacters
            let characterSetSpace = CharacterSet.whitespaces
            if string.rangeOfCharacter(from: characterSetAlpha.inverted) != nil && string.rangeOfCharacter(from: characterSetSymbol.inverted) != nil && string.rangeOfCharacter(from: characterSetSpace.inverted) != nil{
                return false
            }
            return true
        case 1003:
            let characterSetAlpha = CharacterSet.letters
            let characterSetSpace = CharacterSet.whitespaces
            if (string.rangeOfCharacter(from: characterSetAlpha.inverted) != nil) && string.rangeOfCharacter(from: characterSetSpace.inverted) != nil{
                return false
            }
            return true
        case 1004:
            // Only the 16 digits + 3 spaces
            if range.location == 19 {
                return false
            }
            // Backspace
            if string.length == 0 {
                return true
            }
            if (range.location == 4) || (range.location == 9) || (range.location == 14) {
                let str: String = "\(String(describing: textField.text!)) "
                textField.text = str
            }
            return true
        case 1005:
            if range.location == 4{
                return false
            }
            return true
        case 1006:
            if string == ""{
                return true
            }
            if textField.text?.length == 0 && Int(string)! == 0{
                return false
            }
            let textFieldString = textField.text! as NSString
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            return floatExPredicate.evaluate(with: newString)
        case 1007:
            let characterSetAlpha = CharacterSet.letters
            let characterSetNumber = CharacterSet.alphanumerics
            let characterSetDotUnder = CharacterSet(charactersIn: "_.")
            if string.rangeOfCharacter(from: characterSetAlpha.inverted) != nil && string.rangeOfCharacter(from: characterSetNumber.inverted) != nil && string.rangeOfCharacter(from: characterSetDotUnder.inverted) != nil{
                return false
            }
            return true
        default:
            break
        }
        return true
    }

}
