//
//  CalisanProfileViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class CalisanProfileViewController: UIViewController{

    @IBOutlet weak var calisanSicilLabel: UILabel!
    @IBOutlet weak var calisanAdSoyadLabel: UILabel!
    @IBOutlet weak var calisanRolLabel: UILabel!
    @IBOutlet weak var calisanAmirAdSoyAdLabel: UILabel!
    @IBOutlet weak var calisanKalanMazeretLabel: UILabel!
    @IBOutlet weak var calisanKalanYillikLabel: UILabel!
    var calisaniD = ""
    var calisanToken = ""
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    var kalanYillik = ""
    var kalanMazeret = ""
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(Logout))
        
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        if calisan.rol != "calisan"{
            let isim = calisan.isim
            let soyisim = calisan.soyisim
            let calisanAdSoyad = isim + " " + soyisim
            calisanAdSoyadLabel.text = calisanAdSoyad
            calisanRolLabel.text = calisan.rol
            calisanSicilLabel.text = calisan.id
            calisanAmirAdSoyAdLabel.text = ""
        }else{
            client.calisanBilgi(calisan_id: calisan.id)
        }
        client.kalanYillik(calisan: calisan)
        client.kalanMazeret(calisan: calisan)
        
    }

    @objc func Logout(){
        let logOutClient = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        logOutClient.delegate = self
        logOutClient.logOut()
    }
   
    func decode<T: Decodable>(json: Data, as clazz: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(T.self, from: json)
            
            return data
        } catch {
            print("An error occurred while parsing JSON")
        }
        
        return nil
    }

}

extension CalisanProfileViewController: HRClientDelegate{
    
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
            let isim = self.calisan.isim
            let soyisim = self.calisan.soyisim
            let calisanAdSoyad = isim + " " + soyisim
            self.calisanAdSoyadLabel.text = calisanAdSoyad
            self.calisanRolLabel.text = self.calisan.rol
            self.calisanSicilLabel.text = self.calisan.id
            if response.data.amir_adi != nil && response.data.amir_soyadi != nil{
                let amir_adi = response.data.amir_adi
                let amir_soyadi = response.data.amir_soyadi
                self.calisanAmirAdSoyAdLabel.text = amir_adi! + " " + amir_soyadi!
            }else{
                self.calisanAmirAdSoyAdLabel.text = ""

            }
        }
        
    }
    
    
    func isLogedOut(_ response: LogoutData) {
        DispatchQueue.main.async {
            if response.is_success == true{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "start")
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
            }else{
                print("Error")
            }
        }
    
    }
    
    func isLogin(_ response: LoginData) {
        DispatchQueue.main.async {
            if response.is_success == true{
                
            }
        }
        
    }
    
    func kalanYillik(_ response: KalanYillikData) {
        DispatchQueue.main.async {
            self.kalanYillik = String(response.data.kalan_yillik_izin)
            self.calisanKalanYillikLabel.text = self.kalanYillik
        }
    }
    
    func kalanMazeret(_ response: KalanMazeretData) {
        DispatchQueue.main.async {
            self.kalanMazeret = String(response.data.kalan_mazeret_izni)
            self.calisanKalanMazeretLabel.text = self.kalanMazeret
        }
    }
    func failedWithError(error: Error) {
        print(error)
    }
    
    
}
