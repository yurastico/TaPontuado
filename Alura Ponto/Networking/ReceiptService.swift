//
//  ReceiptService.swift
//  Alura Ponto
//
//  Created by Yuri Cunha on 01/01/24.
//

import Foundation

class ReceiptService {
    func post(_ receipt: Recibo,completion: @escaping (_ isSaved: Bool) -> Void) {
        let baseUrl = "http://localhost:8080/"
        let path = "recibos"
        
        let parameters: [String: Any] = [
            "data": FormatadorDeData().getData(receipt.data),
            "status":receipt.status,
            "localizacao": [
                "latitude": receipt.latitude,
                "longitude": receipt.longitude
            ]
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters,options: []) else { return}
        
        guard let url = URL(string: baseUrl + path) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data,response, error in
            if let response {
                print(response)
            }
            if error == nil {
                completion(true)
                return
            }
            
            completion(false)
            
            
            
            
            
        }.resume()
    }
}
