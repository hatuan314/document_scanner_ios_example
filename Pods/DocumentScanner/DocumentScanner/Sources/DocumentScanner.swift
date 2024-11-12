//
//  DocumentScanner.swift
//  
//
//  Created by Tuan Hoang on 5/11/24.
//
import UIKit

public protocol DocumentScannerDelegate: AnyObject {
    func didFinishConvertingToPDF(urlPaths: [String])
}


public class DocumentScanner: ImageListViewControllerDelegate {
    public weak var delegate: DocumentScannerDelegate?
    
    public var navigationController: UINavigationController?
    
    private let cameraScanner = CameraScannerModel()
    private let imageListViewController = ImageListViewController()
    
    public init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    
    public func greet() -> String {
        return "Hello from MySwiftFramework!"
    }
    
    public func openScannerCamera() -> Void {
        imageListViewController.delegate = self
        cameraScanner.startDocumentScanning();
        cameraScanner.completeHandler = {
            let images = self.cameraScanner.images
            if images.isEmpty == false {
                self.pushToImageListView(images: images)
            }
            
        }
    }
    
    public func pushToImageListView(images: [UIImage]?) -> Void {
        if imageListViewController.delegate == nil {
            imageListViewController.delegate = self
        }
        imageListViewController.images = images ?? []
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(imageListViewController, animated: true)
        }
//        navigationController?.pushViewController(imageListViewController, animated: true)
    }
    
    public func didFinishConvertingToPDF(pdfPaths: [String]) {
        print("DocumentScanner: didFinishConvertingToPDF")
        delegate?.didFinishConvertingToPDF(urlPaths: pdfPaths)
    }
}

