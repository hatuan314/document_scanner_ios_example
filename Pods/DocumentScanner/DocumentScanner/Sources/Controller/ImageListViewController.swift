//
//  ImageListViewController.swift
//  DocumentScanner
//
//  Created by Tuan Hoang on 6/11/24.
//

import UIKit

protocol ImageListViewControllerDelegate: AnyObject {
    func didFinishConvertingToPDF(pdfPaths: [String])
}

class ImageListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var images: [UIImage] = []
    
    weak var delegate: ImageListViewControllerDelegate? // Biến delegate
    
    private let photosScanner = PhotoScannerModel()
    private let pdfConversion = PDFConversionModel()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Document Photos"
        print("Document Photos.images.count: \(images.count)")
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Convert",
            style: .plain,
            target: self,
            action: #selector(onPressedConvertButton)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func onPressedConvertButton() {
        var pdfUrls:[String] = []
        // Bắt đầu hiển thị loading indicator
        loadingIndicator.startAnimating()
        Task<Void, Never> {
            do {
                for (index, image) in self.images.enumerated() {
                    let fileName = UUID().uuidString
                    var urlPath = try await self.pdfConversion.createPDF(from: image, fileName: fileName)
                    if urlPath != nil {
                        pdfUrls.append(urlPath!)
                    }
                }
            } catch {
                print("Lỗi khi tạo PDF: \(error)")
            }
            print("pdfUrls: \(String(describing: pdfUrls.count))")
            print("delegate: \(delegate)")
            delegate?.didFinishConvertingToPDF(pdfPaths: pdfUrls)
            // Dừng loading indicator
            loadingIndicator.stopAnimating()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("ImageListViewController.collectionView.images.count: '\(images.count)'")
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as! PhotosCollectionViewCell

        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (view.frame.size.width/3) - 3,
            height: (view.frame.size.width/3) - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let image = images[indexPath.row]
        photosScanner.detectDocumentEdges(image: image);
        photosScanner.completeHandler = {
            self.images[indexPath.row] = self.photosScanner.image ?? image
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
}
