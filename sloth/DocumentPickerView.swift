//
//  DocumentPickerView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/19.
//

import SwiftUI

struct DocumentPickerView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return DocumentPickerView.Coordinator()
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.epub], asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            for url in urls {
                let p = Preference.documentPath + "/" + url.lastPathComponent
                let u = URL(fileURLWithPath: p)
                try? FileManager.default.copyItem(at: url, to: u)
                print(u)
                print("exist \(FileManager.default.fileExists(atPath: u.path))")
            }
            

        }
    }
}
