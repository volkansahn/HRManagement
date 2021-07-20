//
//  AdminProflieViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit
import KeychainSwift

class AdminProflieViewController: UIViewController {
    
    @IBOutlet weak var calisanSicilLabel: UILabel!
    @IBOutlet weak var calisanAdSoyadLabel: UILabel!
    @IBOutlet weak var calisanRolLabel: UILabel!
    @IBOutlet weak var calisanAmirAdSoyAdLabel: UILabel!
    @IBOutlet weak var calisanKalanMazeretLabel: UILabel!
    @IBOutlet weak var calisanKalanYillikLabel: UILabel!
    @IBOutlet weak var kisileriYonetButton: UIButton!
    var calisaniD = ""
    var calisanToken = ""
    var calisan = Calisan(id: "", isim: "", sifre: "", soyisim: "", rol: "", amir_id: "", token: "", bazMaas: 1, yanOdeme: 1)
    var kalanYillik = ""
    var kalanMazeret = ""
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(Logout))
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = keychain.getData("calisan")
        calisan = decode(json: userData!, as: Calisan.self)!
        let client = HRHttpClient(kullanici_id: calisan.id, authToken: calisan.token)
        client.delegate = self
        client.calisanBilgi(calisan_id: calisan.id)
        client.kalanYillik(calisan: calisan)
        client.kalanMazeret(calisan: calisan)
        
        kisileriYonetButton.isEnabled = true
        kisileriYonetButton.backgroundColor = .orange
        kisileriYonetButton.tintColor = .white
        
    }

    @IBAction func manageUserPressed(_ sender: UIButton) {
        kisileriYonetButton.isEnabled = false
        kisileriYonetButton.backgroundColor = .gray
        kisileriYonetButton.tintColor = .black
        performSegue(withIdentifier: "toManageUser", sender: self)
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

extension AdminProflieViewController: HRClientDelegate{
    
    func isLogedOut(_ response: LogoutData) {
        DispatchQueue.main.async {
            if response.is_success == true{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
            }else{
                print("Error")
            }
        }
    
    }
    func calisanBilgi(_ response: CalisanData) {
        DispatchQueue.main.async {
            let isim = response.data.adi
            let soyisim = response.data.soyadi
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
    func calisanAraError(error: Error) {
        let alert = UIAlertController(title: "Calisan Hata", message: "Calisan Bulunamadı !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
