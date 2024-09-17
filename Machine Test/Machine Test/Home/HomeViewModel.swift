//
//  HomeViewModel.swift
//  Machine Test
//
//  Created by Alen C James on 16/09/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var apiData: [Json4Swift_Base] = [] // The data to bind to the view
    @Published var errorMessage: String? // Optional error message if something goes wrong
    
    let apiClient = NetworkCall()
    
    init() {
        callAPI()
    }
    
    // Call the API and handle success or error
    func callAPI() {
        apiClient.performAPICall { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.apiData = data // Update the data on success
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription // Capture the error message
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
    
    // Helper methods to extract specific sections
    func getMostPopular() -> [Contents]? {
        return apiData.first(where: { $0.type == "most_popular" })?.contents
    }
    
    func getCategories() -> [Contents]? {
        return apiData.first(where: { $0.type == "categories" })?.contents
    }
    
    func getFeaturedProducts() -> [Contents]? {
        return apiData.first(where: { $0.type == "featured" })?.contents
    }
}


struct Contents : Codable {
    let title : String?
    let image_url : String?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case image_url = "image_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
    }

}

struct Json4Swift_Base : Codable {
    let type : String?
    let title : String?
    let contents : [Contents]?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case title = "title"
        case contents = "contents"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        contents = try values.decodeIfPresent([Contents].self, forKey: .contents)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}
