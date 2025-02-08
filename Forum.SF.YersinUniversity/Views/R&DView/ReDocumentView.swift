//
//  ReDocumentView.swift
//  Forum_GroupChat_Yersin
//
//  Created by Huynh Trần on 12/28/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Foundation
import SDWebImageSwiftUI

struct ReDocumentView: View {
    @State private var showSideMenu: Bool = false
    @State private var selectedDate = Date() // Ngày được chọn từ DatePicker
    @State private var showPostSheet = false
    @State private var fileName = ""
    @StateObject private var postViewModel = PostViewModel() // Khởi tạo PostViewModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                VStack {
                    HStack {
                        // Date Picker
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .padding(.leading, 16)
                        
                        // Lọc Button
                        Button(action: {
                            // Khi bấm nút "Lọc", gọi hàm applyFilter để lọc các bài đăng theo ngày đã chọn
                            postViewModel.applyFilter(for: selectedDate)
                        }) {
                            Text("Lọc")
                                .padding(.vertical, 7)
                                .padding(.horizontal, 16)
                                .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        // Thêm tài liệu Button
                        Button(action: {
                            showPostSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 17, height: 17)
                                .padding(10)
                                .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.vertical, 8)
                    
                    // Hiển thị danh sách bài đăng đã lọc
                    ScrollView {
                        ForEach(postViewModel.filteredPosts) { post in
                            PostView(post: post)
                        }
                    }
                    .onAppear {
                        postViewModel.fetchPosts() // Lấy dữ liệu bài đăng khi view xuất hiện
                    }
                    
                    Spacer()
                }
                
                .sheet(isPresented: $showPostSheet) {
                    PostSheetView(fileName: $fileName, selectedDate: $selectedDate, postViewModel: postViewModel) // Pass the PostViewModel
                }
            }
        }
    }
    
    
    struct PostView: View {
        var post: Post
        @State private var downloadStatus: String? = nil // Thêm biến trạng thái cho thông báo
        @State private var showAlert: Bool = false // Thêm biến trạng thái cho Alert
        @State private var displayName: String = ""
        @State private var photoURL: URL? = nil
        
        var body: some View {
            VStack {
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            // hiện tên người đăng tài liệu ở đây
                            Text(displayName)
                                   .font(.title2)
                                   .fontWeight(.bold)
                                   .foregroundColor(.white)
                                   .onAppear {
                                       // Lấy thông tin người dùng từ Firebase Auth
                                       if let user = Auth.auth().currentUser {
                                           displayName = user.displayName ?? user.email ?? "Người dùng không xác định"
                                       }
                                   }
                           }
                        
                        .padding(.top, 8)
                        
                        HStack {
                            Image(systemName: "doc.fill")
                                .foregroundColor(.white)
                            Text(post.uploadfile)
                                .foregroundColor(.blue)
                                .frame(width: 200)
                                .underline()
                            
                            // Download Button
                            Button(action: {
                                let fileManager = FileManager.default
                                let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                let destinationURL = documentsDirectory.appendingPathComponent(post.uploadfile)
                                
                                // Trigger file download when the download button is pressed
                                downloadFile(from: post.fileURL, to: destinationURL)
                            }) {
                                Image(systemName: "arrow.down.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                            Text(DateFormatter.localizedString(from: post.time, dateStyle: .medium, timeStyle: .none))
                        }
                        .foregroundColor(.white)
                        .padding(.top, 4)
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                .cornerRadius(8)
                .shadow(radius: 2)
                .padding(.horizontal, 16)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(downloadStatus ?? "Thông báo"),
                    message: Text("Tải file hoàn tất."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
        func downloadFile(from urlString: String, to destinationURL: URL) {
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            // Tải file từ URL
            let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
                if let error = error {
                    print("Error downloading file: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        downloadStatus = "Ban da tai file nay roi"
                        showAlert = true // Hiển thị Alert khi có lỗi
                    }
                    return
                }
                
                guard let location = location else {
                    print("No file location found")
                    DispatchQueue.main.async {
                        downloadStatus = ""
                        showAlert = true // Hiển thị Alert khi không tìm thấy file
                    }
                    return
                }
                
                let fileManager = FileManager.default
                do {
                    // Di chuyển file từ location tới thư mục Documents
                    try fileManager.moveItem(at: location, to: destinationURL)
                    print("File downloaded to \(destinationURL.path)")
                    
                    DispatchQueue.main.async {
                        downloadStatus = "Tải file thành công"
                        showAlert = true // Hiển thị Alert khi tải file thành công
                    }
                } catch {
                    print("Error saving file: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        downloadStatus = "Thông Báo"
                        showAlert = true // Hiển thị Alert khi có lỗi khi lưu file
                    }
                }
            }
            
            task.resume()
        }
    }

}
 
#Preview {
    ReDocumentView()
}

