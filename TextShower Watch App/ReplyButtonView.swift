import SwiftUI

struct ReplyButtonView: View {
    @Binding var isReplyViewPresented: Bool
    
    var body: some View {
        Button(action: {
            isReplyViewPresented = true
        }) {
            Text("Reply")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom)
    }
}
