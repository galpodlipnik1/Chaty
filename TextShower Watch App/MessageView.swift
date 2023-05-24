import SwiftUI

struct MessageView: View {
    let apiResponse: APIResponse?
    
    var body: some View {
        VStack {
            Text(apiResponse?.emoji ?? "")
                .font(.title)
            
            Text(apiResponse?.text ?? "")
                .font(.headline)
                .padding(.horizontal)
            
            Text(apiResponse?.createdAt ?? "")
                .font(.system(size: 10))
                .padding(.horizontal)
        }
    }
}
