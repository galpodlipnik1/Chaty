import SwiftUI

struct ReplyView: View {
    @State private var replyText: String = ""
    @State private var replyEmoji: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @Binding var isReplyViewPresented: Bool

    var body: some View {
        VStack {
            TextField("Enter text", text: $replyText)
                .padding()
                .textFieldStyle(PlainTextFieldStyle())

            TextField("Enter emoji", text: $replyEmoji)
                .onReceive(replyEmoji.publisher.collect()) {
                    replyEmoji = String($0.prefix(1))
                }
                .padding()
                .textFieldStyle(PlainTextFieldStyle())

            Button(action: {
                sendReply()
            }) {
                Text("Send")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Reply Sent"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func sendReply() {
        guard let url = URL(string: "http://localhost:5001/text") else {
            return
        }

        let body: [String: Any] = [
            "text": replyText,
            "emoji": replyEmoji,
            "creator": "watch-\(getDeviceIdentifier())"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let apiReply = try decoder.decode(APIReply.self, from: data)
                    DispatchQueue.main.async {
                        alertMessage = apiReply.message
                        isShowingAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isReplyViewPresented = false
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
