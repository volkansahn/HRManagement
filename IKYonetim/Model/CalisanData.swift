//
//  CalisanData.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct CalisanData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: CalisanBilgi
}

struct CalisanBilgi: Decodable {
    let id: String
    let isim: String
    let soyisim: String
    let rol: String
    let bazMaas: Int
    let yanOdeme: Int
    let amir: String
}
