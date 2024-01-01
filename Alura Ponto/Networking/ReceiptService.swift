//
//  ReceiptService.swift
//  Alura Ponto
//
//  Created by Yuri Cunha on 01/01/24.
//

import Foundation
import Alamofire
class ReceiptService {
    
    func get(completion: @escaping (_ receipts: [Recibo]?, _ error: Error?) -> Void) {
        AF.request("http://localhost:8080/recibos",method: .get,headers: ["Accept": "application/json"]).responseJSON { response in
            switch response.result {
            case .success(let json):
                var receipts: [Recibo] = []
                guard let receiptList = json as? [[String: Any]] else { return }
                for receiptDict in receiptList {
                    guard let newReceipt = Recibo.serialize(receiptDict) else { return }
                    receipts.append(newReceipt)
                }
                completion(receipts,nil)
                break
            case .failure(let error):
                completion(nil,error)
                
            }
        }
        
    }
    
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
