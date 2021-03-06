//
//  LoginViewController.swift
//  IKYonetim
//
//  Created by Volkan on 15.06.2021.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var rol = ""
    var calisanid = ""
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    let keychain = KeychainSwift()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        loginButton.isEnabled = false
        loginButton.backgroundColor = .gray
        loginButton.tintColor = .white
        if let id = userIdTextField.text, let password = userPasswordTextField.text{
            
            //Client object to make request
            let client = HRHttpClient(kullanici_id: id, sifre: password)
            client.delegate = self
            client.login()
            
        }else{
            DispatchQueue.main.async {
                self.performAlert()
                
            }
        }
        
    }
    
    func encode<T: Codable>(object: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(object)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func performAlert(){
        let alert = UIAlertController(title: "Hata", message: "Sicil ve Sifrenizi kontrol ediniz!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }

}

extension LoginViewController : HRClientDelegate{
    func isLogin(_ response: LoginData) {
        DispatchQueue.main.async {
            self.calisanid = response.data.id!
            self.rol = response.data.rol!
            self.calisan = Calisan(id: response.data.id!, isim: response.data.isim!, sifre: "", soyisim: response.data.soyisim!, rol: response.data.rol!, amir_id: "", token: "", bazMaas: response.data.bazMaas, yanOdeme: response.data.yanOdeme)
            let encodedUser = self.encode(object: self.calisan)
            self.keychain.set(encodedUser!, forKey: "calisan")
            switch self.rol{
            case "calisan" :
                self.performSegue(withIdentifier: Constants.toApp, sender: nil)
            case "amir":
                self.performSegue(withIdentifier: Constants.toAmir, sender: nil)
            case "ik" :
                self.performSegue(withIdentifier: Constants.toHR, sender: nil)
            case "doktor":
                self.performSegue(withIdentifier: Constants.toDoctor, sender: nil)
            case "admin":
                self.performSegue(withIdentifier: Constants.toAdmin, sender: nil)
            default:
                print("error")
            }
        }
    }
    
    
    
    func failedWithError(error: Error) {
        loginButton.isEnabled = true
        loginButton.backgroundColor = .orange
        loginButton.tintColor = .black
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Giris Hata", message: "Sicil ve Sifrenizi Kontrol edin !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            print(error)
        }
        
    }
   
}
