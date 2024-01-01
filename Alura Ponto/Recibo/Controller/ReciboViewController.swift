//
//  ReciboViewController.swift
//  Alura Ponto
//
//  Created by Ândriu Felipe Coelho on 22/09/21.
//

import UIKit
import CoreData
class ReciboViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var escolhaFotoView: UIView!
    @IBOutlet weak var reciboTableView: UITableView!
    @IBOutlet weak var fotoPerfilImageView: UIImageView!
    @IBOutlet weak var escolhaFotoButton: UIButton!
    
    // MARK: - Atributos
    private lazy var camera = Camera()
    private lazy var imagePickerController = UIImagePickerController()
    private lazy var receiptService = ReceiptService()
    private var receipts: [Recibo] = []
    

    
 
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraTableView()
        configuraViewFoto()
      
        
    }
    
    func getProfileImage() {
        guard let profile = Profile().loadImage() else { return }
        fotoPerfilImageView.image = profile
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRecibos()
        getProfileImage()
        reciboTableView.reloadData()
    }
    
    func getRecibos() {
       
        receiptService.get() { [weak self] response, error in
            if error == nil {
                guard let receips = response else { return }
                self?.receipts = receips
                self?.reciboTableView.reloadData()
            }
        }
    }
    
    // MARK: - Class methods
    
    func configuraViewFoto() {
        escolhaFotoView.layer.borderWidth = 1
        escolhaFotoView.layer.borderColor = UIColor.systemGray2.cgColor
        escolhaFotoView.layer.cornerRadius = escolhaFotoView.frame.width/2
        escolhaFotoButton.setTitle("", for: .normal)
    }
    
    func configuraTableView() {
        reciboTableView.dataSource = self
        reciboTableView.delegate = self
        reciboTableView.register(UINib(nibName: "ReciboTableViewCell", bundle: nil), forCellReuseIdentifier: "ReciboTableViewCell")
    }
    
    func showImagePickerMenu() {
        let alert = UIAlertController(title: "Selecao de foto", message: "Escolha uma foto da biblioteca", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Biblioteca de fotos", style: .default,handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.camera.delegate = self
                self.camera.openPhotosLibrary(self, self.imagePickerController)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(alert,animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func escolherFotoButton(_ sender: UIButton) {
        showImagePickerMenu()
    }
}

extension ReciboViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReciboTableViewCell", for: indexPath) as? ReciboTableViewCell else {
            fatalError("erro ao criar ReciboTableViewCell")
        }
        
        let receipt = receipts[indexPath.row]
        cell.configuraCelula(receipt)
        cell.delegate = self
        cell.deletarButton.tag = indexPath.row
        
        return cell
    }
}

extension ReciboViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let receipt = receipts[indexPath.row]
        let mapViewController = MapViewController.instantiate(receipt)
        mapViewController.modalPresentationStyle = .automatic
        present(mapViewController,animated: true)
    }
    
}

extension ReciboViewController: ReciboTableViewCellDelegate {
    func deletarRecibo(_ index: Int) {
        
       
       
        LocalAuthentication().authorizeUser { [weak self] authenticated in
            if authenticated {
                let receipt = self?.receipts[index]
                self?.receiptService.delete(id: "\(receipt?.id)", completion: {
                    self?.receipts.remove(at: index)
                    self?.reciboTableView.reloadData()
                })
               // receipt.delete(context)
            }
        }
        //  receipt.delete(context)
        
       
        //searcher.fetchedObjects?.remove(at: index)
        //reciboTableView.reloadData()
    }
}

extension ReciboViewController: CameraDelegate {
    func didSelectPhoto(_ image: UIImage) {
        escolhaFotoButton.setImage(UIImage(named: ""), for: .normal)
        Profile().saveImage(image)
        escolhaFotoButton.isHidden = true
        fotoPerfilImageView.image = image
    }
    
    
}

