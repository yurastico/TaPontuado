//
//  Camera.swift
//  Alura Ponto
//
//  Created by Yuri Cunha on 17/12/23.
//

import UIKit

protocol CameraDelegate: AnyObject {
    func didSelectPhoto(_ image: UIImage)
}

final class Camera: NSObject {
    
    weak var delegate: CameraDelegate?
    
    func openCamera(_ controller: UIViewController, _ imagePicker: UIImagePickerController) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
        
        controller.present(imagePicker, animated: true)
    }
    
    func openPhotosLibrary(_ controller: UIViewController,_ imagePicker: UIImagePickerController) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        controller.present(imagePicker, animated: true)
    }
    
}

extension Camera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let photo = info[.editedImage] as? UIImage else { return }
        
        delegate?.didSelectPhoto(photo)
        
    }
}

