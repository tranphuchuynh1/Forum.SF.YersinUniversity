//
//  ForumView.swift
//  Forum_GroupChat_Yersin
//
//  Created by Huynh Trần on 1/5/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import PhotosUI

struct ForumView: View {
    @State private var showCreatePostSheet = false
    @State private var posts: [PostBV] = []

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showCreatePostSheet = true
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

                ScrollView {
                    ForEach(posts) { post in
                        PostView(post: post)
                            .padding(.bottom, 16)
                    }
                }
                .onAppear {
                    fetchPosts()
                }
            }
            .sheet(isPresented: $showCreatePostSheet) {
                CreatePostView {
                    fetchPosts()
                }
            }
        }
    }

    func fetchPosts() {
        Firestore.firestore().collection("Upload Bài Viết")
            .order(by: "Time", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Lỗi khi lấy bài viết: \(error.localizedDescription)")
                    return
                }

                let currentUserUID = Auth.auth().currentUser?.uid ?? ""
                posts = snapshot?.documents.compactMap { doc -> PostBV? in
                    let data = doc.data()
                    let likedBy = data["likedBy"] as? [String] ?? []
                    return PostBV(
                        id: doc.documentID,
                        title: data["Tiêu đề"] as? String ?? "",
                        imageBase64: data["ảnh bài đăng"] as? String ?? "",
                        author: data["người đăng"] as? String ?? "",
                        authorPhotoURL: data["photoURL"] as? String ?? "",
                        time: (data["Time"] as? Timestamp)?.dateValue() ?? Date(),
                        likes: data["lượt like"] as? Int ?? 0,
                        isLiked: likedBy.contains(currentUserUID)
                    )
                } ?? []
            }
    }
}


// ...
struct CommentView: View {
    @State private var comments: [Comment] = []
    @State private var newComment: String = ""
    let postID: String

    var body: some View {
        VStack(spacing: 0) {
            // Header title
            HStack {
                Spacer()
                Text("Bình Luận")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(red: 0.53, green: 0.13, blue: 0.11))
            .foregroundColor(.white)

            // Scrollable comments list
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(comments) { comment in
                        HStack(alignment: .top, spacing: 12) {
                            // Avatar
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)

                            // Comment content
                            VStack(alignment: .leading, spacing: 4) {
                                Text(comment.author)
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))

                                Text(comment.text)
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))

                                Text(comment.time, formatter: DateFormatter.postDateFormatter)
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal)
            }
            

            // nhập vào một bình luận chạy với biến text
            HStack(spacing: 8) {
                TextField("Viết bình luận công khai...", text: $newComment)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)

                Button(action: {
                    addComment()
                }) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                }
            }
            .padding(.all)
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: -2)
        }
        .onAppear {
            fetchComments()
        }
        .background(Color.gray.opacity(0.1))
    }

    func fetchComments() {
        Firestore.firestore().collection("Upload Bài Viết").document(postID)
            .collection("Comments")
            .order(by: "Time", descending: true)
            .getDocuments { snapshot, error in
                if error == nil {
                    comments = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        return Comment(
                            id: doc.documentID,
                            text: data["text"] as? String ?? "",
                            author: data["author"] as? String ?? "",
                            time: (data["Time"] as? Timestamp)?.dateValue() ?? Date()
                        )
                    } ?? []
                }
            }
    }

    func addComment() {
        guard !newComment.isEmpty else { return }
        let db = Firestore.firestore()
        let newCommentData: [String: Any] = [
            "text": newComment,
            "author": Auth.auth().currentUser?.displayName ?? "Anonymous",
            "Time": Timestamp()
        ]
        db.collection("Upload Bài Viết").document(postID).collection("Comments")
            .addDocument(data: newCommentData) { error in
                if error == nil {
                    newComment = ""
                    fetchComments()
                }
            }
    }
}

struct Comment: Identifiable {
    let id: String
    let text: String
    let author: String
    let time: Date
}



struct PostView: View {
    @State private var showCommentView = false
    @State private var showDeleteConfirmation = false
    @State var post: PostBV

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let url = URL(string: post.authorPhotoURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(width: 40, height: 40)
                        case .success(let image):
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text(post.author)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(post.time, formatter: DateFormatter.postDateFormatter)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
                
                // Menu nhỏ khi nhấn vào dấu 3 chấm
                Menu {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Xóa bài viết", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.white)
                }
            }

            Text(post.title)
                .font(.body)
                .foregroundColor(.white)

            if let imageData = Data(base64Encoded: post.imageBase64),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .cornerRadius(8)
            }

            HStack(spacing: 120) {
                Button(action: {
                    toggleLike()
                }) {
                    HStack {
                        Image(systemName: post.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(post.isLiked ? .red : .white)
                        Text("\(post.likes)")
                            .foregroundColor(.white)
                    }
                }

                Button(action: {
                    showCommentView.toggle()
                }) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                Button(action: {
                }) {
                    Image(systemName: "arrowshape.turn.up.forward")
                        .foregroundColor(.white)
                }
            }
            .padding(5)
            .sheet(isPresented: $showCommentView) {
                CommentView(postID: post.id)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Xóa bài viết"),
                    message: Text("Bạn có chắc chắn muốn xóa bài viết này không?"),
                    primaryButton: .destructive(Text("Xóa")) {
                        deletePost()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
        .background(Color(red: 0.53, green: 0.13, blue: 0.11))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }

    func toggleLike() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let postRef = db.collection("Upload Bài Viết").document(post.id)

        if post.isLiked {
            postRef.updateData([
                "lượt like": FieldValue.increment(Int64(-1)),
                "likedBy": FieldValue.arrayRemove([currentUser.uid])
            ]) { error in
                if error == nil {
                    post.isLiked = false
                    post.likes -= 1
                }
            }
        } else {
            postRef.updateData([
                "lượt like": FieldValue.increment(Int64(1)),
                "likedBy": FieldValue.arrayUnion([currentUser.uid])
            ]) { error in
                if error == nil {
                    post.isLiked = true
                    post.likes += 1
                }
            }
        }
    }

    func deletePost() {
        let db = Firestore.firestore()
        db.collection("Upload Bài Viết").document(post.id).delete { error in
            if let error = error {
                print("Lỗi khi xóa bài viết: \(error.localizedDescription)")
            } else {
                print("Bài viết đã được xóa thành công.")
            }
        }
    }
}


// Định dạng thời gian
extension DateFormatter {
    static let postDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss - dd/MM/yyyy"
        return formatter
    }()
}


// Model bài viết
struct PostBV: Identifiable {
    let id: String
    let title: String
    let imageBase64: String
    let author: String
    let authorPhotoURL: String
    let time: Date
    var likes: Int
    var isLiked: Bool // Kiểm tra người dùng đã like hay chưa
}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else { return }
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let uiImage = image as? UIImage, let data = uiImage.jpegData(compressionQuality: 0.8) else { return }
                    DispatchQueue.main.async {
                        self.parent.imageData = data
                    }
                }
            }
        }
    }
}



struct CreatePostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var imageData: Data? = nil
    @State private var isImagePickerPresented = false
    let onPostCreated: () -> Void // Callback khi tạo bài viết
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Nhập tiêu đề", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("+ Chọn ảnh")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding()
                }

                Button(action: {
                    savePostToFirestore()
                }) {
                    Text("➤  Đăng bài viết")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
            
            .navigationTitle("Tạo Bài Viết")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(imageData: $imageData)
            }
        }
    }

    func savePostToFirestore() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let imageData = imageData else { return }

        let base64String = imageData.base64EncodedString()

        let post: [String: Any] = [
            "Tiêu đề": title,
            "ảnh bài đăng": base64String,
            "người đăng": currentUser.displayName ?? "Người dùng",
            "photoURL": currentUser.photoURL?.absoluteString ?? "", // Lưu ảnh đại diện Gmail
            "Time": Timestamp(),
            "lượt like": 0
        ]

        Firestore.firestore().collection("Upload Bài Viết").addDocument(data: post) { error in
            if let error = error {
                print("Lỗi khi đăng bài viết: \(error.localizedDescription)")
            } else {
                presentationMode.wrappedValue.dismiss()
                onPostCreated()
            }
        }
    }

}

#Preview {
    ForumView()
}
