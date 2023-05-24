import Foundation

class DataStore: ObservableObject {
    @Published var apiResponse: APIResponse?

    init() {
        fetchData()
        Timer.scheduledTimer(withTimeInterval: 180, repeats: true) { _ in
            self.fetchData()
        }
    }

    func fetchData() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "sl_SI")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        guard let url = URL(string: "http://localhost:5001/text") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], json.isEmpty {

                    let formattedDate = dateFormatter.string(from: Date())
                    let defaultResponse = APIResponse(text: "No messages yet!", emoji: "😢", createdAt: formattedDate, creator: "nobody")
                    DispatchQueue.main.async {
                        self.apiResponse = defaultResponse
                    }
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(APIResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.apiResponse = response

                        if let dateFromResponse = dateFormatter.date(from: response.createdAt) {
                            self.apiResponse?.createdAt = dateFormatter.string(from: dateFromResponse)
                        } else {
                            self.apiResponse?.createdAt = response.createdAt
                        }
                    }

                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }

}
