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
    
    public init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    
    public func greet() -> String {
        return "Hello from MySwiftFramework!"
    }
    
    public func openScanningByCamera() -> Void {
        cameraScanner.startDocumentScanning();
        cameraScanner.completeHandler = {
            let images = self.cameraScanner.images
            if images.isEmpty == false {
                self.pushToImageListView(images: images)
            }
            
        }
    }
    
    public func pushToImageListView(images: [UIImage]?) -> Void {
        var imageListViewController = ImageListViewController()
        imageListViewController.delegate = self
        imageListViewController.images = images ?? []
        navigationController?.pushViewController(imageListViewController, animated: true)
    }
    
    public func didFinishConvertingToPDF(pdfPaths: [String]) {
        print("DocumentScanner: didFinishConvertingToPDF")
        delegate?.didFinishConvertingToPDF(urlPaths: pdfPaths)
    }
}

