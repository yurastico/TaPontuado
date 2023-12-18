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
    let searcher: NSFetchedResultsController<Recibo> = {
        let fetchRequest: NSFetchRequest<Recibo> = Recibo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    var context: NSManagedObjectContext = {
        let context = UIApplication.shared.delegate as! AppDelegate
        return context.persistentContainer.viewContext
    }()
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraTableView()
        configuraViewFoto()
        searcher.delegate = self
        
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
        Recibo.load(searcher)
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
        return searcher.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReciboTableViewCell", for: indexPath) as? ReciboTableViewCell else {
            fatalError("erro ao criar ReciboTableViewCell")
        }
        
        let recibo = searcher.fetchedObjects?[indexPath.row]
        cell.configuraCelula(recibo)
        cell.delegate = self
        cell.deletarButton.tag = indexPath.row
        
        return cell
    }
}

extension ReciboViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ReciboViewController: ReciboTableViewCellDelegate {
    func deletarRecibo(_ index: Int) {
        
       
        guard let receipt = searcher.fetchedObjects?[index] else { return }
        LocalAuthentication().authorizeUser { [weak self] authenticated in
            if authenticated {
                guard let receipt = self?.searcher.fetchedObjects?[index] else { return }
                guard let context = self?.context else { return }
                receipt.delete(context)
            }
        }
        receipt.delete(context)
        
       
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

extension ReciboViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .delete:
            if let indexPath {
                reciboTableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            reciboTableView.reloadData()
        }
    }
}
