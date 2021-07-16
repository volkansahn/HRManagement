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
    let kullanici_id: String
    let adi: String
    let soyadi: String
    let sifre : String
    let rol_id: String
    var amir_adi: String? = ""
    var amir_soyadi: String? = ""
}

