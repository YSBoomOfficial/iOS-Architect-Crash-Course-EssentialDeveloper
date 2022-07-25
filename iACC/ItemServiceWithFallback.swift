//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

// Composite Pattern
struct ItemServiceWithFallback: ItemService {
	let primary: ItemService
	let fallback: ItemService

	func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
		primary.loadItems { result in
			switch result {
				case .success: completion(result)
				case .failure: fallback.loadItems(completion: completion)
			}
		}
	}
}
