//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

// MARK: ItemService Protocol
protocol ItemService {
	func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}

// MARK: ItemService Fallback
extension ItemService {
	func fallback(_ fallback: ItemService) -> ItemService {
		ItemServiceWithFallback(primary: self, fallback: fallback)
	}
}

// MARK: ItemService Retry
extension ItemService {
	func retry(_ retryCount: UInt) -> ItemService {
		var service: ItemService = self
		for _ in 0..<retryCount {
			service = service.fallback(self)
		}
		return service
	}
}
