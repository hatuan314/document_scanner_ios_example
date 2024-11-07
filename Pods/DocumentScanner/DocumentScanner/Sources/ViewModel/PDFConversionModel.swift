//
//  PDFConversionModel.swift
//  DocumentScanner
//
//  Created by Tuan Hoang on 6/11/24.
//

import UIKit
import CoreGraphics

class PDFConversionModel: NSObject {
    func createPDF(from image: UIImage, fileName: String) async throws -> String? {
        // Đường dẫn nơi file PDF sẽ được lưu
        let pdfURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(fileName).pdf")

        // Kích thước trang PDF sẽ tương ứng với kích thước của ảnh
        var pdfPageBounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        // Tạo context PDF
        guard let pdfContext = CGContext(pdfURL as CFURL, mediaBox: &pdfPageBounds, nil) else {
            print("Không thể tạo PDF context.")
            return nil
        }
        
        // Bắt đầu trang PDF
        pdfContext.beginPDFPage(nil)
        
        // Vẽ ảnh vào trang PDF
        if let cgImage = image.cgImage {
            pdfContext.draw(cgImage, in: pdfPageBounds)
        }
        
        // Kết thúc trang PDF
        pdfContext.endPDFPage()
        
        // Đóng file PDF
        pdfContext.closePDF()
        
        print("PDF đã được tạo và lưu tại: \(pdfURL.path)")
        return pdfURL.path
    }
}
