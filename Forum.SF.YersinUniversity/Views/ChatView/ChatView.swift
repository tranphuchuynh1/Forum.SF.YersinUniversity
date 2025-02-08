//
//  ChatView.swift
//  App_GroupChat_IOS
//
//  Created by Tran Phuc Huynh on 24/11/24.
//

import SwiftUI


@available(iOS 16.0, *)
struct ChatView: View {
    @StateObject var chatViewModel = ChatViewModel()
    @State var text = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    VStack(spacing:10){
                        ForEach(Array(chatViewModel.messages.enumerated()), id: \.element ) { idx, message in
                            MessageView(message: message)
                                .id(idx)
                        }
                        .onChange(of: chatViewModel.messages) {
                            newValue in scrollView .scrollTo(chatViewModel.messages.count - 1, anchor: .bottom)
                        }
                    }
                }
            }
            // css doan chat
            HStack {
                TextField("Nhập tin nhắn.......", text: $text,axis: .vertical)
                    .padding()
            ZStack {
                Button {
                    if text.count > 2 {
                        chatViewModel.sendMessage(text: text) { success in
                            if success {
                                
                            } else {
                                print("lỗi khi gửi tin nhắn, vui lòng thử lại!")
                            }
                        }
                        text = ""
                    }
                } label: {
                    // css for button send o day nhe
                    Text("Gửi")
                        .padding()
                        .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                        .foregroundColor(.white) // color text button
                        .cornerRadius(50)
                        .padding(.trailing)
                    }
                }
            .padding(.top)
            .shadow(radius: 3)
                
            }
            .background(Color(uiColor:.systemGray6))
        }
    }
}


#Preview {
        ChatView()
}
