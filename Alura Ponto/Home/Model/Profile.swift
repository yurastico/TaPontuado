//
//  Profile.swift
//  Alura Ponto
//
//  Created by Yuri Cunha on 18/12/23.
//

import UIKit

final class Profile {
    private let photoName = "profile.png"
    func saveImage(_ image: UIImage) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = directory.appendingPathComponent(photoName)
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            deleteImage(fileUrl.path)
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        do {
            try imageData.write(to: fileUrl)
        } catch {
            print(error)
        }
        
    }
    private func deleteImage(_ url: String) {
        do {
            try FileManager.default.removeItem(atPath: url)
        } catch {
            print(error)
        }
    }
    
    func loadImage() -> UIImage? {
        
        let directory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let imageUrl = NSSearchPathForDirectoriesInDomains(directory, userDomainMask, true)
        guard let path = imageUrl.first else { return nil }
        let url = URL(fileURLWithPath: path).appendingPathComponent(photoName)
        let image = UIImage(contentsOfFile: url.path)
        return image
    }
}
