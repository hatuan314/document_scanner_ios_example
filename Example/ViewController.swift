//
//  ViewController.swift
//  Example
//
//  Created by Tuan Hoang on 5/11/24.
//

import UIKit
import PhotosUI
import DocumentScanner

class ViewController: UIViewController, PHPickerViewControllerDelegate {
    
    var documentScanner = DocumentScanner()
    var selectedImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onPressedCameraBtn(_ sender: UIButton) {
        documentScanner.openScannerCamera(from: self) {pdfPaths in
            for path in pdfPaths {
                print("pdfPath: \(path)")
            }
            
        }
    }
    
    @IBAction func onPressedPhotosBtn(_ sender: UIButton) {
        openImagePicker()
    }
    
    func openImagePicker() {
        // Cấu hình PHPicker cho phép chọn nhiều ảnh
        var config = PHPickerConfiguration()
        config.filter = .images // Chỉ hiển thị ảnh
        config.selectionLimit = 0 // Cho phép chọn không giới hạn ảnh
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: {
                print("Open Image Picker, complete")
        })
    }

    // Hàm delegate được gọi khi người dùng chọn xong ảnh
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        selectedImages.removeAll() // Làm rỗng danh sách trước khi thêm ảnh mới
        
        // Tạo biến để theo dõi số lượng ảnh đã tải
        var loadedImageCount = 0
        let totalImages = results.count
    
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.selectedImages.append(image) // Thêm ảnh vào mảng
                            loadedImageCount += 1 // Tăng số lượng ảnh đã tải xong

                            // Kiểm tra nếu tất cả ảnh đã tải xong
                            if loadedImageCount == totalImages {
                                picker.dismiss(animated: true) {
                                    self?.onPushToImageListView()
                                }
                            }
                        }
                        
                    } else {
                        // Nếu gặp lỗi khi tải ảnh, vẫn tăng loadedImageCount để tránh treo
                        DispatchQueue.main.async {
                            loadedImageCount += 1
                            if loadedImageCount == totalImages {
                                picker.dismiss(animated: true) {
                                    self?.onPushToImageListView()
                                }
                            }
                        }
                    }
                }
            } else {
                loadedImageCount += 1
            }
        }
        
        // Nếu results rỗng, đóng picker ngay lập tức
        if results.isEmpty {
            picker.dismiss(animated: true) {
                self.onPushToImageListView()
            }
        }
    }
    
    func onPushToImageListView() {
        documentScanner.pushToImageListView(images: selectedImages, from: self) {pdfPaths in
            print("ViewController.onPushToImageListView")
            for path in pdfPaths {
                print("pdfPath: \(path)")
            }
        }
    }
}

