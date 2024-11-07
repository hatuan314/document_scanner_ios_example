//
//  PhotosScannerModel.swift
//  DocumentScanner
//
//  Created by Tuan Hoang on 6/11/24.
//

import UIKit

class PhotoScannerModel: NSObject, ImageScannerControllerDelegate {
    var image: UIImage?
    var completeHandler:(() -> Void)?
    
    func detectDocumentEdges(image: UIImage) {
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        if let windowScene = UIApplication.shared.connectedScenes.first(
            where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(scannerViewController, animated: true, completion: nil)
            }
        }
    }
    
    func imageScannerController(
        _ scanner: ImageScannerController,
        didFinishScanningWithResults results: ImageScannerResults) {
        // Xử lý ảnh quét đã cắt (croppedScan) hoặc ảnh gốc (originalImage)
        image = results.croppedScan.image
        
        scanner.dismiss(animated: true, completion: completeHandler)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
//        result?(FlutterError(code: "SCAN_CANCELLED", message: "User cancelled the scan", details: nil))
        print("[SCAN_CANCELLED] -----> User")
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: any Error) {
        scanner.dismiss(animated: true, completion: nil)
//        result?(FlutterError(code: "SCAN_ERROR", message: "An error occurred during scanning", details: error.localizedDescription))
        print("[SCAN_ERROR] -----> An error occurred during scanning - \(error.localizedDescription)")
    }
    
    
}
