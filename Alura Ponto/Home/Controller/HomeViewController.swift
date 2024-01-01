//
//  HomeViewController.swift
//  Alura Ponto
//
//  Created by Ândriu Felipe Coelho on 22/09/21.
//

import UIKit
import CoreData
import CoreLocation
class HomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var horarioView: UIView!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var registrarButton: UIButton!

    // MARK: - Attributes
    
    var context: NSManagedObjectContext = {
        let context = UIApplication.shared.delegate as! AppDelegate
        return context.persistentContainer.viewContext
    }()
    
    private var timer: Timer?
    private lazy var camera = Camera()
    private lazy var imagePickerController = UIImagePickerController()
    private lazy var receiptService = ReceiptService()
    
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    lazy var locationManager = CLLocationManager()
    private lazy var location = Location()
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraView()
        atualizaHorario()
        camera.delegate = self
        userLocationRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configuraTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // MARK: - Class methods
    
    func configuraView() {
        configuraBotaoRegistrar()
        configuraHorarioView()
    }
    
    func configuraBotaoRegistrar() {
        registrarButton.layer.cornerRadius = 5
    }
    
    func configuraHorarioView() {
        horarioView.backgroundColor = .white
        horarioView.layer.borderWidth = 3
        horarioView.layer.borderColor = UIColor.systemGray.cgColor
        horarioView.layer.cornerRadius = horarioView.layer.frame.height/2
    }
    
    func configuraTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(atualizaHorario), userInfo: nil, repeats: true)
    }
    
    @objc func atualizaHorario() {
        let horarioAtual = FormatadorDeData().getHorario(Date())
        horarioLabel.text = horarioAtual
    }
    
    func userLocationRequest() {
        location.delegate = self
        location.permition(locationManager)
    }
    
    // MARK: - IBActions
    
    func tryOpenCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            camera.openCamera(self, imagePickerController)
        }
    }
    
    @IBAction func registrarButton(_ sender: UIButton) {
        tryOpenCamera()
        
    }
}

extension HomeViewController: CameraDelegate {
    func didSelectPhoto(_ image: UIImage) {
        let receipt = Recibo(status: false, data: Date(), foto: image,latidude: latitude ?? 0.0 ,longitude: longitude ?? 0.0)
        receipt.save(context)
        
        receiptService.post(receipt) { [weak self] isSaved in
            if !isSaved {
                guard let context = self?.context else { return }
                receipt.save(context)
            }
        }
    }
    
}

extension HomeViewController: LocationDelegate {
    func updateUserLocation(latitude: Double?, longitude: Double?) {
        self.latitude = latitude ?? 0
        self.longitude = longitude ?? 0
    }
    
    
}
