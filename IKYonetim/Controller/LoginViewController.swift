//
//  LoginViewController.swift
//  IKYonetim
//
//  Created by Volkan on 15.06.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    var rol = ""
    var calisanid = ""
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toApp{
            let tabBarVC = segue.destination as! UITabBarController
            let vc = tabBarVC.viewControllers![0] as! CalisanProfileViewController
            vc.calisan = calisan
        }else{
            let tabBarVC = segue.destination as! UITabBarController
            let vc = tabBarVC.viewControllers![0] as! AdminProflieViewController
            vc.calisan = calisan
        }
        
    }
    
    func performAlert(){
        let alert = UIAlertController(title: "Sign In Error", message: "Please check your email and password !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }

}

extension LoginViewController : HRClientDelegate{
    func isLogin(_ response: LoginData) {
        DispatchQueue.main.async {
            self.calisanid = response.data.id!
            self.rol = response.data.rol!
            self.calisan = Calisan(id: response.data.id!, isim: response.data.isim!, sifre: "", soyisim: response.data.soyisim!, rol: response.data.rol!, amir_id: "", token: "")
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
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sign In Error", message: "Please check your email and password !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            print(error)
        }
        
    }
   
}
