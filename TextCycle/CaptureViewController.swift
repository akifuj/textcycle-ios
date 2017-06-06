//
//  CaptureViewController.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/25.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import AVFoundation
import Bond
import ReactiveKit

class CaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var barcodeLabel: UILabel!
    
    var captureSession: AVCaptureSession?
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var isbn = Observable("")
    
    var captureViewModel = CaptureViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "バーコードリーダーにかざす"
        bindViewModel()
        
        let horizontalAlignment = self.view.center.x
        let verticalAlignment = self.view.center.y
        captureView.frame = CGRect(x:horizontalAlignment - 150, y:verticalAlignment - 240, width:300, height:120)
        barcodeLabel.frame = CGRect(x:horizontalAlignment - 110, y:verticalAlignment - 80, width:220, height:60)
        
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
    }
    
    private func bindViewModel() {
        isbn.bind(to: captureViewModel.isbn)
        
        // indicator
        captureViewModel.isLoading.bind(to: loadingIndicator.reactive.isAnimating)
        captureViewModel.isLoading.map { !$0 }.bind(to: loadingIndicator.reactive.isHidden)
        
        // alert
        _ = captureViewModel.alertMessages.observeNext {
            [weak self] message in
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in return }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
            }.dispose(in: bag)
        
        _ = captureViewModel.requestState
            .filter { $0 == .Found }
            .observeNext {[weak self] state in
                self?.performSegue(withIdentifier: "toExhibitForm", sender: nil)
            }
            .dispose(in: bag)
    }
    
    // 画面が開かれるときにカメラを起動させる
    override func viewWillAppear(_ animated: Bool) {
        captureSession?.startRunning()
    }
    
    // segueの設定
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExhibitForm" {
            let exhibitFormVC = segue.destination as! ExhibitFormTableViewController
            exhibitFormVC.exhibitFormViewModel = ExhibitFormViewModel(post: captureViewModel.newPost!)
        }
    }
    
    // カメラの設定
    func configureVideoCapture() {
        do {
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            
            captureSession  = AVCaptureSession()
            captureSession?.addInput(deviceInput as AVCaptureInput)
            let metadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        } catch let error as NSError {
            captureViewModel.alertMessages.next(error.localizedDescription)
        }
    }
    
    func addVideoPreviewLayer() {
        captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureVideoPreviewLayer?.frame = self.captureView?.bounds ?? CGRect.zero
        captureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureVideoPreviewLayer?.frame = captureView.bounds
        captureView?.layer.addSublayer(captureVideoPreviewLayer!)
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard let objects = metadataObjects as? [AVMetadataObject] else { return }
        for metadataObject in objects {
            guard let objMetadataMachineReadableCodeObject = metadataObject as? AVMetadataMachineReadableCodeObject else { continue }
            isbn.value = objMetadataMachineReadableCodeObject.stringValue
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
