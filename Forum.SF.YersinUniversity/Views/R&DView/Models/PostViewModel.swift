//
//  PostViewModel.swift
//  Forum_GroupChat_Yersin
//
//  Created by Huynh Trần on 12/28/24.
//

import Firebase

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var filteredPosts: [Post] = [] // Danh sách bài đăng đã lọc

    init() {
        fetchPosts()
    }

    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("Upload Tài Liệu").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self.posts = documents.map { document -> Post in
                let data = document.data()
                let id = document.documentID
                let uploadfile = data["uploadfile"] as? String ?? ""
                let fileURL = data["fileURL"] as? String ?? "" // Lấy fileURL
                let time = (data["time"] as? Timestamp)?.dateValue() ?? Date()

                return Post(id: id, uploadfile: uploadfile, fileURL: fileURL, time: time)
            }
           
            // hien thi tat ca bai dang ban dau
            self.filteredPosts = self.posts
        }
    }

    // Thêm hàm lọc
    func applyFilter(for date: Date) {
        let calendar = Calendar.current
        self.filteredPosts = posts.filter { post in
            calendar.isDate(post.time, inSameDayAs: date)
        }
    }
}


struct Post: Identifiable {
    var id: String
    var uploadfile: String
    var fileURL: String
    var time: Date
}
