import SwiftUI

struct Rules_RewardView: View {
    @State private var selectedAccordion: Int? = nil
    @State private var showSideMenu: Bool = false
    let awards = [
        ("Giải 3 nghiên cứu khoa học Euréka 2024", "giai3-nckh-euréka"),
        ("Á quân Sinh viên toàn quốc 2020-2021", "aquansv"),
        ("Giải 1 cuộc thi Yersin Talent 2024 ", "giainhat-eclipphair-nano"),
        ("Thanh Hằng - đạt giải tấm gương sáng", "thanhhang"),
        ("Khoa dược đạt giải 1 Yersin Talent 2023", "khoaduoc")
    ]
    
    let awards2 = [
        ("Đề tài lọt vào chung kết Euréka 2024", "eurekalist"),
        ("Giải thưởng Yersin Talent lần VII", "cuocthilan7"),
        ("Giải thưởng Yersin Talent lần VIII ", "cuocthilan8"),
        ("Khen thưởng các sinh viên nổi trội", "khenthuong"),
        ("Đạt giải quán quân với đề tài về Nano", "giainhat-eclipphair-nano")
    ]
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .leading) {
                VStack {
                    ScrollView {
                        VStack(spacing: 10) {
                            Spacer().frame(height: 80)
                            
                            AccordionButton(id: 1, title: "MỤC ĐÍCH VÀ YÊU CẦU", content: """
                            - Mục đích: Khuyến khích học sinh, sinh viên áp dụng những kiến thức, kỹ năng đã được giảng dạy vào cuộc thi; qua đó, giúp học sinh, sinh viên rèn luyện, phát triển các nhóm năng lực thiết yếu.
                            
                            - Yêu cầu: Sinh viên hệ chính quy đang học tập tại Trường Đại học Yersin Đà Lạt.
                            """, selectedAccordion: $selectedAccordion)
                            
                            AccordionButton(id: 2, title: "NỘI DUNG", content: """
                            - Các nhóm chọn dự án liên quan đến chuyên môn, kỹ năng được học tại Trường để nghiên cứu và thực hiện.
                            
                            - Học sinh, sinh viên tham gia cuộc thi theo nhóm; mỗi nhóm gồm có 3-5 thành viên
                            (có thể đến từ các ngành, các lớp, các khóa khác nhau).
                            
                            - Mỗi nhóm tự tìm ít nhất 01 cố vấn (mentor) cho dự án của nhóm mình: Mentor có thể là giáo viên, giảng viên hoặc người có chuyên môn phù hợp với dự án.
                            
                            Lưu ý: Nội dung và hình thức cụ thể theo format cuộc thi kèm theo.
                            """, selectedAccordion: $selectedAccordion)
                            
                            AccordionButton(id: 3, title: "TIÊU CHÍ CHẤM ĐIỂM", content: """
                            - CÓ 4 TIÊU CHÍ CHẤM ĐIỂM :
                            1. SỰ CẦN THIẾT CỦA DỰ ÁN (15 ĐIỂM) :
                            Lợi ích của dự án mang lại cho khách hàng, cộng đồng hoặc xã hội; Dự án sẽ hỗ trợ giải quyết được vấn đề nào của cộng đồng, xã hội.
                            
                            2. TÍNH ĐỘC ĐÁO, SÁNG TẠO, GIÁ TRỊ KHÁC KHÁC BIỆT CỦA DỰ ÁN (15 ĐIỂM)
                            
                            3. TÍNH KHẢ THI CỦA DỰ ÁN (15 ĐIỂM) :
                            Khả năng về tài chính; đối với dự án kinh doanh thì cần tính hiệu quả bao gồm cơ cấu chi phí, giá thành phù hợp cạnh tranh so với các loại sản phẩm, dịch vụ đã có trên thị trường. Khả năng về sản phẩm (có thể tạo ra sản phẩm, có thể triển khai trong thực tế…)
                           
                            4. KẾT QUẢ TIỀM NĂNG CỦA DỰ ÁN (15 ĐIỂM) :
                            Sản phẩm, doanh thu, lợi nhuận dự kiến, khả năng tăng trưởng, tác động xã hội của dự án.
                           """, selectedAccordion: $selectedAccordion)
                            
                            AccordionButton(id: 4, title: "CÁCH THỨC THAM GIA", content: """
                            - Bước 01: Sinh viên đăng ký tham gia (theo mẫu đính kèm): Trước ngày 05/12/2024.
                            - Bước 02: Tập huấn cho các nhóm dự án tham gia: Từ ngày 06-17/12/2024 (Ban Tổ
                            chức sẽ có thông báo cụ thể sau khi nhận được bản đăng ký).
                            - Bước 03: Các nhóm dự thi triển khai dự án và nộp dự án cho Ban Tổ chức: Trước
                            17h00 ngày 28/02/2025.
                            - Bước 04: Vòng Bán kết cuộc thi: Dự kiến tháng 03/2025.
                            - Bước 05: Tập huấn các nhóm vào vòng Chung kết: Cuối tháng 3/2025.
                            - Bước 06: Vòng Chung kết cuộc thi: Tháng 4/2025.
                            
                            Ban Thư ký cuộc thi: Phòng CTSV :
                            Cô Võ Huỳnh Anh Thu - 0878 844 445  Email: sa.dept@yersin.edu.vn
                            """, selectedAccordion: $selectedAccordion)
                            
                            AccordionButton(id: 5, title: "GIẢI THƯỞNG", content: """
                            - 01 giải Nhất: Giấy khen, kỷ niệm chương và tiền thưởng 35.000.000đ/giải;
                            - 02 giải Nhì: Giấy khen, kỷ niệm chương và tiền thưởng 20.000.000đ/giải;
                            - 03 giải Ba: Giấy khen, kỷ niệm chương và tiền thưởng 10.000.000đ/giải;
                            - 05 giải Khuyến khích: Giấy khen và tiền thưởng 2.000.000đ/giải.
                            
                            Các nhóm thí sinh xuất sắc nhất lọt vào vòng chung kết được trao Giấy chứng nhận
                            tham gia cuộc thi.
                            """, selectedAccordion: $selectedAccordion)
                            
                            Spacer().frame(height: 1)
                            
                            Text("---------- THÀNH TÍCH NỔI BẬT ----------")
                                .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))
                                .font(.system(size: 17, weight: .bold))
                            
                            // Slider for awards
                            VStack {
                                TabView {
                                    ForEach(awards, id: \.0) { award in
                                        VStack {
                                            Image(award.1)
                                                .resizable()
                                                .cornerRadius(10)
                                                .frame(height: 320)
                                            Text(award.0)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        .padding()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .frame(height: 410)
                                .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                                .cornerRadius(10)
                            }
                            
                            // Slider for awards2
                            VStack {
                                TabView {
                                    ForEach(awards2, id: \.0) { award in
                                        VStack {
                                            Image(award.1)
                                                .resizable()
                                                .cornerRadius(10)
                                                .frame(height: 320)
                                            Text(award.0)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        .padding()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .frame(height: 410)
                                .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                                .cornerRadius(10)
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
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
                        
                        
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.move(edge: .leading))
                    }
                }
            }
        }
        
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct AccordionButton: View {
    var id: Int
    var title: String
    var content: String
    @Binding var selectedAccordion: Int?
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    if selectedAccordion == id {
                        selectedAccordion = nil
                    } else {
                        selectedAccordion = id
                    }
                }
            }) {
                HStack {
                    Text("\(id)")
                        .foregroundColor(Color(red: 0.53, green: 0.13, blue: 0.11))
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                    
                    Text(title)
                        .foregroundColor(.white)
                        .font(.headline)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    
                    Image(systemName: selectedAccordion == id ? "minus" : "plus")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                .cornerRadius(10)
            }
            
            if selectedAccordion == id {
                Text(content)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.53, green: 0.13, blue: 0.11))
                    .cornerRadius(10)
                    .transition(.slide)
            }
        }
    }
}

struct Rules_RewardView_Previews: PreviewProvider {
    static var previews: some View {
        Rules_RewardView()
    }
}
