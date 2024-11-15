//
//  ViewController.swift
//  Example
//
//  Created by Tuan Hoang on 5/11/24.
//

import UIKit
import PhotosUI
import DocumentScanner
import PDFKit

class ViewController: UIViewController {
    
    var documentScanner = DocumentScanner()
    var selectedImages: [UIImage] = []
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Tạo Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .gray
        } // Màu sắc tùy chỉnh
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true // Tự ẩn khi dừng
        
        // Thêm Indicator vào View
        view.addSubview(activityIndicator)
    }

    @IBAction func onPressedCameraBtn(_ sender: UIButton) {
        documentScanner.openScannerCamera(from: self) {pdfUrl in
            print("pdfPath: \(pdfUrl?.path)")
            

            // Kiểm tra và hiển thị file PDF
            if pdfUrl != nil {
                // Thiết lập PDFView
                let pdfView = PDFView(frame: self.view.bounds)
                pdfView.autoScales = true
                self.view.addSubview(pdfView)
                pdfView.document = PDFDocument(url: pdfUrl!)
            } else {
                print("PDF URL is nil")
            }
        }
    }
    
    @IBAction func onPressedPhotosBtn(_ sender: UIButton) {
        DocumentScanner.shared.openScannerPhotosLibrary(images: nil, from: self) {pdfUrl in
            print("ViewController.onPushToImageListView")
            print("pdfPath: \(pdfUrl?.path)")
            

            // Kiểm tra và hiển thị file PDF
            if pdfUrl != nil {
                // Thiết lập PDFView
                let pdfView = PDFView(frame: self.view.bounds)
                pdfView.autoScales = true
                self.view.addSubview(pdfView)
                pdfView.document = PDFDocument(url: pdfUrl!)
            } else {
                print("PDF URL is nil")
            }
        }
    }
}

