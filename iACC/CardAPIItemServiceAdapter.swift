//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct CardAPIItemServiceAdapter: ItemService {
	let api: CardAPI
	let select: (Card) -> Void

	func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
		api.loadCards { result in
			DispatchQueue.mainAsyncIfNeeded {
				completion(
					result.map { items in
						items.map { item in
							ItemViewModel(card: item) { select(item) }
						}
					}
				)
			}
		}
	}
}
