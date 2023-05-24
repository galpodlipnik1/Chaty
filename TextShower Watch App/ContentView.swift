import SwiftUI

struct ContentView: View {
    @StateObject private var dataStore = DataStore()
    @State private var isReplyViewPresented = false

    var body: some View {
        VStack {
            
            MessageView(apiResponse: dataStore.apiResponse)
            
            Spacer()
            
            ReplyButtonView(isReplyViewPresented: $isReplyViewPresented)
        }
        .padding()
        .sheet(isPresented: $isReplyViewPresented) {
            ReplyView(isReplyViewPresented: $isReplyViewPresented)
        }
        .onAppear {
            dataStore.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
