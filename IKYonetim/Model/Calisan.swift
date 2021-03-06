//
//  Calisan.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct Calisan: Codable {
    let id: String
    let isim: String
    let sifre: String
    let soyisim: String
    let rol: String
    let amir_id: String
    let token: String
    let bazMaas: Int?
    let yanOdeme: Int?
}
