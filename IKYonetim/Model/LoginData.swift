//
//  LoginData.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct LoginData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: User
}

struct User: Decodable {
    let id: Int
    let authToken: String
    let isim: String
    let soyisim: String
    let rol: String
    let bazMaas: Int
    let yanOdeme: Int

}
