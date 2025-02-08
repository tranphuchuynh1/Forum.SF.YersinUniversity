//
//  ContentView.swift
//  App_GroupChat_IOS
//
//  Created by Tran Phuc Huynh on 24/11/24.
//

import SwiftUI

enum MenuPage {
    case generalChat
    case foRum
    case reDocument
    case rulesReward
    case settings
}


struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor?
    var textColor: UIColor?

    init(backgroundColor: UIColor?, textColor: UIColor?) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: textColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor ?? .white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = textColor
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(false)
        }
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor?, textColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, textColor: textColor))
    }
}

struct SideMenuView: View {
    @Binding var selectedPage: MenuPage
    @Binding var showSideMenu: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer().frame(height: 100)
            
            Button(action: {
                withAnimation {
                    selectedPage = .generalChat
                    showSideMenu = false
                }
            }) {
                HStack {
                    Image(systemName: "house")
                        .foregroundColor(.white)
                    Text("TRÒ CHUYỆN CHUNG")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
            }

            Button(action: {
                withAnimation {
                    selectedPage = .reDocument
                    showSideMenu = false
                }
            }) {
                
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.white)
                    Text("TÀI LIỆU DỰ ÁN")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
            }

            Button(action: {
                withAnimation {
                    selectedPage = .foRum
                    showSideMenu = false
                }
            }) {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.white)
                    Text("DIỄN ĐÀN")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
            }

            Button(action: {
                withAnimation {
                    selectedPage = .rulesReward
                    showSideMenu = false
                }
            }) {
                HStack {
                    Image(systemName: "star")
                        .foregroundColor(.white)
                    Text("THỂ LỆ VÀ GIẢI THƯỞNG")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
            }

            Button(action: {
                withAnimation {
                    selectedPage = .settings
                    showSideMenu = false
                }
            }) {
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                    Text("CÀI ĐẶT")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width / 1.5)
        .background(Color(red: 0.53, green: 0.13, blue: 0.11))
        .edgesIgnoringSafeArea(.all)
    }
}



struct ContentView: View {
    @State private var showSignIn: Bool = false
    @State private var showSideMenu: Bool = false
    @State private var selectedPage: MenuPage = .generalChat
    
 
    
    init() {
           // Tạo một giá trị tạm để kiểm tra trạng thái người dùng
         let isUserSignedIn = AuthManager.shared.getCurrentUser() != nil
          _showSignIn = State(initialValue: !isUserSignedIn) // Gán giá trị cho @State
     }
    

    var body: some View {
        if showSignIn {
            SignInView(showSignIn: $showSignIn)
        } else {
            NavigationStack {
                ZStack(alignment: .leading) {
                    VStack {
                        if selectedPage == .generalChat {
                            ChatView()
                                .navigationTitle("TRÒ CHUYỆN CHUNG")
                        } else if selectedPage == .reDocument {
                            ReDocumentView()
                                .navigationTitle("TÀI LIỆU DỰ ÁN")
                        } else if selectedPage == .foRum {
                            ForumView()
                                .navigationTitle("DIỄN ĐÀN")
                        } else if selectedPage == .rulesReward {
                            Rules_RewardView()
                                .navigationTitle("THỂ LỆ VÀ GIẢI THƯỞNG")
                        } else if selectedPage == .settings {
                            SettingView()  // Truyền Binding showSignIn
                                .navigationTitle("CÀI ĐẶT")
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarColor(backgroundColor: UIColor(red: 0.53, green: 0.13, blue: 0.11, alpha: 1.0), textColor: .white)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                withAnimation {
                                    showSideMenu.toggle()
                                }
                            } label: {
                                Image(systemName: "line.horizontal.3")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        //
                    }
                    
                    if showSideMenu {
                        ZStack(alignment: .leading) {
                            Color.black.opacity(0.3)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    withAnimation {
                                        showSideMenu = false
                                    }
                                }
                            
                            SideMenuView(selectedPage: $selectedPage, showSideMenu: $showSideMenu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.move(edge: .leading))
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
