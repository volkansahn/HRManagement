//
//  AdminManageUserViewController.swift
//  IKYonetim
//
//  Created by Volkan on 16.06.2021.
//

import UIKit

class AdminManageUserViewController: UIViewController {

    @IBOutlet weak var calisanidTextField: UITextField!
    @IBOutlet weak var calisanSifreTextField: UITextField!
    @IBOutlet weak var calisanAdiTextField: UITextField!
    @IBOutlet weak var calisanSoyadiTextField: UITextField!
    @IBOutlet weak var calisanRolTextField: UITextField!
    @IBOutlet weak var amirAdiTextField: UITextField!
    @IBOutlet weak var amirSoyadiTextField: UITextField!
    @IBOutlet weak var calisanSicilAraTextField: UITextField!
    
    @IBOutlet weak var calisanidResponseLabel: UILabel!
    @IBOutlet weak var calisanAdiResponseLabel: UILabel!
    @IBOutlet weak var calisanSoyadiResponseLabel: UILabel!
    @IBOutlet weak var calisanRoluResponseLabel: UILabel!
    @IBOutlet weak var calisanAmirResponseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //Create
    @IBAction func kisiOlusturPressed(_ sender: UIButton) {
    }
    //Update
    @IBAction func calisanAraPressed(_ sender: UIButton) {
    }
    @IBAction func calisanSicilEditPressed(_ sender: UIButton) {
    }
    @IBAction func calisanAdiEditPressed(_ sender: UIButton) {
    }
    @IBAction func calisanSoyadiEditPressed(_ sender: UIButton) {
    }
    @IBAction func calisanRoluEditPressed(_ sender: UIButton) {
    }
    @IBAction func calisanAmirEditPressed(_ sender: UIButton) {
    }
    //Delete
    @IBAction func kullaniciSilPressed(_ sender: UIButton) {
    }
    
    
}
