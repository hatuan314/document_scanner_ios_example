//
//  ViewController.swift
//  Example
//
//  Created by Tuan Hoang on 5/11/24.
//

import UIKit
import PhotosUI
import DocumentScanner

class ViewController: UIViewController, PHPickerViewControllerDelegate, DocumentScannerDelegate {
    func didFinishConvertingToPDF(urlPaths: [String]) {
        for (_, path) in urlPaths.enumerated() {
            print("didFinishConvertingToPDF: \(path)")
        }
        
    }
    
    var documentScanner = DocumentScanner()
    var selectedImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Thiết lập màu nền để dễ nhận biết
        view.backgroundColor = .systemBackground
        // Thêm một label hoặc button để kiểm tra xem ViewController có hiển thị không
        navigationItem.title = "Document Scanner Example"
        // Thêm nút "Camera"
        let cameraButton = UIButton(type: .system)
        cameraButton.setTitle("Camera", for: .normal)
        cameraButton.addTarget(self, action: #selector(onPressedCameraBtn), for: .touchUpInside)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraButton)
        
        // Thêm nút "Photos"
        let photosButton = UIButton(type: .system)
        photosButton.setTitle("Photos", for: .normal)
        photosButton.addTarget(self, action: #selector(onPressedPhotosBtn), for: .touchUpInside)
        photosButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photosButton)
        
        // Thiết lập vị trí của các nút
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            photosButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photosButton.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 20)
        ])
        
        let output = DocumentScanner().greet()
        documentScanner.delegate = self
        documentScanner.navigationController = navigationController
        print(output)

    }

    @IBAction func onPressedCameraBtn(_ sender: UIButton) {
        documentScanner.openScanningByCamera()
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
        
//        // Tạo một Dispatch Group
//        let dispatchGroup = DispatchGroup()
//
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                // Bắt đầu một công việc trong Dispatch Group
//                dispatchGroup.enter()
                
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
//                    // Kết thúc công việc khi tải xong ảnh (thành công hoặc thất bại)
//                    dispatchGroup.leave()
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
        documentScanner.pushToImageListView(images: selectedImages)
    }
}

