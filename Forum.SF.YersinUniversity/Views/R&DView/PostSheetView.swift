//
//  PostSheetView.swift
//  Forum_GroupChat_Yersin
//
//  Created by Huynh Trần on 12/28/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PostSheetView: View {
    @Binding var fileName: String
    @Binding var selectedDate: Date
    @State private var showFilePicker = false
    @State private var selectedFileURL: URL?
    @ObservedObject var postViewModel: PostViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Thêm bài đăng")
                .font(.headline)
                .padding()

            HStack {
                Text("Upload file:")
                TextField("Tên file sau khi được upload", text: $fileName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)

                Button(action: {
                    showFilePicker.toggle()
                }) {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding()

            HStack {
                Text("Time:")
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .labelsHidden()
            }
            .padding()

            HStack {
                Button(action: {
                    uploadPost()
                }) {
                    Text("Thêm")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Button(action: {
                    dismiss() // Close the sheet when canceling
                }) {
                    Text("Hủy bỏ")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .shadow(radius: 10)
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.item],
            onCompletion: { result in
                switch result {
                case .success(let url):
                    selectedFileURL = url
                    fileName = url.lastPathComponent
                case .failure(let error):
                    print("Error selecting file: \(error.localizedDescription)")
                }
            }
        )
    }

    private func uploadPost() {
        guard let selectedFileURL = selectedFileURL else {
            print("No file selected")
            return
        }

        let uploadedFileURL = selectedFileURL.absoluteString // Lấy URL file từ file picker

        // Lưu thông tin vào Firestore
        let db = Firestore.firestore()
        db.collection("Upload Tài Liệu").addDocument(data: [
            "uploadfile": fileName,   // Lưu tên file
            "fileURL": uploadedFileURL,  // Lưu URL của file
            "time": selectedDate
        ]) { error in
            if let error = error {
                print("Error saving post to Firestore: \(error.localizedDescription)")
            } else {
                print("Post successfully saved to Firestore")
                postViewModel.fetchPosts()
                dismiss()  // Đóng sheet khi tải lên xong
            }
        }
    }
}

