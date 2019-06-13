//
//  SignUpSecondVC.swift
//  oomph
//
//  Created by Appuno Solutions on 05/06/19.
//  Copyright © 2019 Ecosmob. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class SignUpSecondVC: UIViewController {
    
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    
    var aryCountryList : [Country]? {
        didSet{
            txtCountry.isEnabled = true
        }
    }
    var selectedCountry : Country? {
        didSet{
            if let country = selectedCountry{
                txtCountry.text = country.name
                if country.id != nil{
                    self.callCityStateCountry(url: WebAPI.getState)
                }
                txtCode.text = country.phonecode
                SignUPVC.selCountry  = country
            }
        }
    }
    var aryStateList : [State]? {
        didSet{
            txtState.isEnabled = true
        }
    }
    var selectedState : State? {
        didSet{
            if let state = selectedState{
                txtState.text = state.name
                if state.id != nil{
                    self.callCityStateCountry(url: WebAPI.getCity)
                }
                SignUPVC.selState  = state
            }
        }
    }
    var aryCityList : [City]? {
        didSet{
            txtCity.isEnabled = true
        }
    }
    var selectedCity : City? {
        didSet{
            if let city = selectedCity{
                txtCity.text = city.name
                SignUPVC.selCity  = city
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doInitialise()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let item = selectedCountry {
            SignUPVC.selCountry = item
        }
        if let item = selectedState {
            SignUPVC.selState = item
        }
        if let item = selectedCity {
            SignUPVC.selCity = item
        }
        if let item = txtMobile.text {
            SignUPVC.contact = item
        }
    }
    
    //MARK:- Class Function
    private func doInitialise(){
        
        //Get Address from current location and save in SignUp objects
        self.autofetchAddress()
        
        //Fill Selected Data
        self.fillAllData()
        
        //Webservice call
        self.callCityStateCountry(url: WebAPI.getCountry)
    }
    private func autofetchAddress(){
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            guard let _ = location else {
                print("Unable to fetch location")
                return
            }
            //We get the complete placemark and can fetch anything from CLPlacemark
            //print(placemark?.addressDictionary?.description)
            if let item = placemark?.country{ ///Country
                let selCounrty = Country(json: JSON())
                selCounrty.name = item
                SignUPVC.selCountry = selCounrty
                self.txtCountry.isEnabled = false
            }
            if let item = placemark?.administrativeArea{ //State
                let selState = State(json: JSON())
                selState.name = item
                SignUPVC.selState = selState
                self.txtState.isEnabled = false
            }
            if let item = placemark?.locality{ //City
                let selCity = City(json: JSON())
                selCity.name = item
                SignUPVC.selCity = selCity
                self.txtCity.isEnabled = false
            }
            
            self.fillAllData()
        }
    }
    private func fillAllData(){
        if let item = SignUPVC.selCountry{
            selectedCountry = item
        }
        if let item = SignUPVC.selState{
            selectedState = item
        }
        if let item = SignUPVC.selCity{
            selectedCity = item
        }
        if let item = SignUPVC.contact{
            txtMobile.text = item
        }
    }
    
    private func isValidate() -> Bool{
        if selectedCountry == nil{
            self.showAlertWithCompletion(pTitle: "", pStrMessage: Localized("kSelectCountry"), completionBlock: nil)
        }
        else if selectedState == nil{
            self.showAlertWithCompletion(pTitle: "", pStrMessage: Localized("kSelectState"), completionBlock: nil)
        }
        else if selectedCity == nil{
            self.showAlertWithCompletion(pTitle: "", pStrMessage: Localized("kSelectCity"), completionBlock: nil)
        }
        else if !(txtMobile.text?.isValidaPhone)!{
            self.showAlertWithCompletion(pTitle: "", pStrMessage: Localized(LocaleKey.kValidPhoneNumber), completionBlock: nil)
        } else{
            return true
        }
        return false
    }
    
    //MARK: - Button Actions
    @IBAction func btnNextPressed(_ sender: UIButton) {
        if isValidate(){
            
            self.performSegue(withIdentifier: "SegueToSignupThirdVC", sender: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToCSCListVC" {
            let txt = sender as! UITextField
            let destVc = segue.destination as! SimpleListVC
            if txt == txtCountry{
                destVc.aryList  = aryCountryList!
                destVc.strTitle = "Country"
            } else if txt == txtState{
                destVc.aryList  = aryStateList!
                destVc.strTitle = "State"
            } else if txt == txtCity{
                destVc.aryList  = aryCityList!
                destVc.strTitle = "City"
            }
            destVc.callBackSelected = { obj in
                if let aObj = obj as? Country { self.selectedCountry = aObj }
                else if let aObj = obj as? State{ self.selectedState = aObj }
                else if let aObj = obj as? City{ self.selectedCity = aObj }
            }
        }
    }
    

}

//MARK: - UItextField delegate
extension SignUpSecondVC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txtCountry || textField == txtState || textField == txtCity){
            self.performSegue(withIdentifier: "SegueToCSCListVC", sender: textField)
            return false
        }
        return true
    }
}

//MARK: - Webservice
extension SignUpSecondVC {
    
    func callCityStateCountry(url : String){
        
        var param = [
            APIKeys.kKey : APIKeys.kKeyValue
        ]
        if url == WebAPI.getCountry{
            param.updateValue(APIKeys.tagCountry, forKey: APIKeys.tag)
        }else if url == WebAPI.getState{
            param.updateValue(APIKeys.tagState, forKey: APIKeys.tag)
            param.updateValue((self.selectedCountry?.id)!, forKey: APIKeys.countryId)
        }else if url == WebAPI.getCity{
            param.updateValue(APIKeys.tagCity, forKey: APIKeys.tag)
            param.updateValue((self.selectedState?.id)!, forKey: APIKeys.stateId)
        }
        
        WebServiceHelper.postWebServiceCall(url,params: param, isShowLoader:true, success: { (resJSON) in
            if CommonFunction.Instance.isCodeSuccess(jsonResp: resJSON){
                
                if let aryItem = resJSON[APIKeys.data].array{
                    if url  == WebAPI.getCountry{
                        self.aryCountryList = aryItem.map{Country(json: $0)}
                    }else if url  == WebAPI.getState{
                        self.aryStateList = aryItem.map{State(json: $0)}
                    }else if url  == WebAPI.getCity{
                        self.aryCityList = aryItem.map{City(json: $0)}
                    }
                }
                
            }else{
                self.showAlertWithCompletion(pTitle: "", pStrMessage: resJSON[APIKeys.message].stringValue, completionBlock: nil)
            }
        }) { (error) in
            print("API Failure : ",error.localizedDescription)
        }
    }
}
