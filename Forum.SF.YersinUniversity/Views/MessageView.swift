//
//  MessageView.swift
//  App_GroupChat_IOS
//
//  Created by Tran Phuc Huynh on 24/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        if message.isFromCurrentUser() {
            HStack {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .frame(maxWidth: 260, alignment: .trailing)
                
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 30, maxHeight: 30)
                        .cornerRadius(16)
                        .padding(.bottom, 19)
                        .padding(.leading, 4)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 30, maxHeight: 30)
                        .cornerRadius(16)
                        .padding(.bottom, 19)
                        .padding(.leading, 4)
                        .foregroundColor(.gray)
                }
            }
            .padding(.trailing)
        } else {
            HStack {
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 30, maxHeight: 30)
                        .cornerRadius(16)
                        .padding(.bottom, 19)
                        .padding(.leading, 4)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 30, maxHeight: 30)
                        .cornerRadius(16)
                        .padding(.bottom, 19)
                        .padding(.leading, 4)
                        .foregroundColor(.gray)
                }
                
                Text(message.text)
                    .padding()
                    .background(Color(uiColor: .systemGray5))
                    .cornerRadius(20)
                    .frame(maxWidth: 260, alignment: .leading)
                
                Spacer()
            }
            .padding(.leading)
        }
    }
}


#Preview {
    MessageView(message: Message(userUid: "123", text: "hi mn minh la huynh, hom nay minh code ", photoURL: "", createdAt: Date()))
    
}
