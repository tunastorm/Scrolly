//
//  FileManager.swift
//  Scrolly
//
//  Created by 유철원 on 8/17/24.
//

import UIKit
import Kingfisher
import PDFKit

// 더미 PDF파일 및 이미지 업로드용

enum FileType {
    case image
    case pdf
}

final class LocalFileManager: FileManager {
    
    static let shared = LocalFileManager()
    
    private var documentDirectory: URL?
    
    private var assetDirectory: URL?
    
    private override init() {
        self.documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        self.assetDirectory = URL(string: "/Users/ucheol/dev/SeSAC/assignment/Scrolly/Scrolly/Assets.xcassets/novel")
    }
    
    private func getSendable(_ filename: String, fileType: FileType) -> Sendable? {
        
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent(filename)
        //이 경로에 실제로 파일이 존재하는 지 확인
        var path: String?
        if #available(iOS 16.0, *) {
            path = fileURL.path()
        } else {
            path = fileURL.path
        }
        
        if let path, FileManager.default.fileExists(atPath: path) {
            return switch fileType {
            case .image: UIImage(contentsOfFile: path)
            case .pdf: fileURL
            }
        } else {
            return nil
        }
        
    }
    
    private func getDataFromUIImage(_ file: NSObject) -> Data? {
        guard let image = file as? UIImage else { return nil }
        return image.jpegData(compressionQuality: 0.5)
    }
    
    private func getDataFromPDF(_ file: NSObject) -> Data? {
        guard let document = file as? PDFDocument else { return nil }
        var options: [PDFDocumentWriteOption : Bool] = [:]
        if #available(iOS 16.4, *) {
            options[ PDFDocumentWriteOption.optimizeImagesForScreenOption ] = true
        }
        return document.dataRepresentation(options: options)
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        return getSendable("\(filename).jpg", fileType: .image) as? UIImage
    }
    
    func loadPDFFromDocument(filename: String) -> PDFDocument? {
        guard let fileURL = getSendable("\(filename).pdf", fileType: .pdf) as? URL else {
            return nil
        }
        return PDFDocument(url: fileURL)
    }
    
    func loadPDFFromAsset(filename: String) -> Data? {
        guard let assetDirectory else { return nil }
        
        let fileURL = assetDirectory.appendingPathComponent("/\(filename).imageset/\(filename).pdf")
        print(#function, "fileURL: ", fileURL)
        
        var path: String?
        if #available(iOS 16.0, *) {
            path = fileURL.path()
        } else {
            path = fileURL.path
        }
        
        if let path, FileManager.default.fileExists(atPath: path) {
            print(#function, "\(filename).pdf 존재", fileURL)
            return FileManager.default.contents(atPath: path)
        } else {
            return nil
        }
        
    }
    
    func saveFileToDocument(file: NSObject, filename: String, fileType: FileType) {
        guard let documentDirectory else { return }
        
        var combinedfilename: String
        switch fileType {
        case .image: combinedfilename = "\(filename).jpg"
        case .pdf: combinedfilename = "\(filename).pdf"
        }
        
        //이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent(combinedfilename)
        
        var data: Data?
        switch fileType {
        case .image: data = getDataFromUIImage(file)
        case .pdf: data = getDataFromPDF(file)
        }
        
        guard let data else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func downloadImageToDocument(url: String, filename: String) -> Bool {
        guard let url = URL(string: url) else {
            return false
        }
        var isSuccess: Bool = false
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.saveFileToDocument(file: image.image, filename: "\(filename).jpg", fileType: .image)
                isSuccess = true
            case .failure(let error):
                dump(error)
            }
        }
        return isSuccess
    }
    
    func downloadPDFToDocument(url: String, filename: String)  -> Bool {
        guard let url = URL(string: url) else {
            return false
        }
        if let document = PDFDocument(url: url) {
            self.saveFileToDocument(file: document, filename: "\(filename).pdf", fileType: .pdf)
            return true
        } else {
            return false
        }
    }
    
    func removeFileFromDocument(filename: String, fileType: FileType) -> Bool? {
        guard let documentDirectory else { return nil }
        
        var combinedfilename: String
        switch fileType {
        case .image: combinedfilename = "\(filename).jpg"
        case .pdf: combinedfilename = "\(filename).pdf"
        }
        
        let fileURL = documentDirectory.appendingPathComponent(combinedfilename)
        var path: String?
        if #available(iOS 16, *) {
            path = fileURL.path()
        } else {
            path = fileURL.path
        }
        
        if let path, FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                return true
            } catch {
                print(#function, "file remove error", error)
                return false
            }
        } else {
            print("file no exist")
            return nil
        }
    }

}
