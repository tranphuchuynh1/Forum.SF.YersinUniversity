import SwiftUI
import AVKit

// Khai báo extension cho Color để sử dụng mã màu hex
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.hasPrefix("#") ? hex.index(hex.startIndex, offsetBy: 1) : hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}



struct SignInView: View {
    @Binding var showSignIn: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Image("cnttk19")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 400, maxHeight: 450, alignment: .top)
                .clipped()
            
            // Logo hình ảnh tại đây
            Image("logo-app")
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 230) // Điều chỉnh kích thước theo nhu cầu của bạn
            
        
            
            VStack(spacing: 20) {
                Button {
                    AuthManager.shared.signInWithApple { result in
                        switch result {
                        case .success(_):
                            showSignIn = false
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Sign in with Apple")
                        .padding()
                        .font(.system(size: 18, weight: .bold))                        .frame(maxWidth: .infinity)                  .foregroundColor(.white)
                        .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                        .cornerRadius(28)
                        
                        .overlay {
                            RoundedRectangle(cornerRadius: 28)
                                .stroke()
                                .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))
                                .frame(width: 300)
                                }
                            }
                .frame(width: 300)
                
                Button {
                    AuthManager.shared.signInWithGoogle { result in
                        switch result {
                        case .success(_):
                            showSignIn = false
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Sign in with Google")
                        .padding()
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))
                        .overlay {
                            RoundedRectangle(cornerRadius: 28)
                                .stroke()
                                .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))
                                .frame(width: 300)
                        }
                                  }
                .frame(width: 300)
            }
            Spacer()
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.top)
        }
}

#Preview {
    SignInView(showSignIn: .constant(true))
}


