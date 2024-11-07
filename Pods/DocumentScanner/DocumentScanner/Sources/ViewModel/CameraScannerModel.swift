//
//  CameraScannerModel.swift
//  DocumentScanner
//
//  Created by Tuan Hoang on 6/11/24.
//

import Foundation
import VisionKit

class CameraScannerModel: NSObject, VNDocumentCameraViewControllerDelegate {
    
    var images: [UIImage] = []
    var completeHandler:(() -> Void)?
    
    func startDocumentScanning() {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        documentCameraViewController.modalPresentationStyle = .fullScreen
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(documentCameraViewController, animated: true)
        }
    }
    
    public func documentCameraViewController(
        _ controller: VNDocumentCameraViewController,
        didFinishWith scan: VNDocumentCameraScan) {
        var imagePaths: [String] = []

        for pageIndex in 0..<scan.pageCount  {
            let scannedImage = scan.imageOfPage(at: pageIndex)
            images.append(scannedImage)
            if let imageData = scannedImage.pngData() {
                let filePath = NSTemporaryDirectory() + "\(UUID().uuidString).png"
                let url = URL(fileURLWithPath: filePath)
                try? imageData.write(to: url)
                imagePaths.append(filePath)
            }
        }
        
        controller.dismiss(animated: true, completion: completeHandler)
    }
}
