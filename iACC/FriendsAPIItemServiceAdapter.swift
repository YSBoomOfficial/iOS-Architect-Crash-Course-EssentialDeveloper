//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct FriendsAPIItemServiceAdapter: ItemService {
	let api: FriendsAPI
	let cache: FriendsCache
	let select: (Friend) -> Void
	
	func loadFriends(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
		api.loadFriends { result in
			DispatchQueue.mainAsyncIfNeeded {
				completion(
					result.map { items in
						cache.save(items)
						
						return items.map { item in
							ItemViewModel(friend: item) { select(item) }
						}
					}
				)
			}
		}
	}
}
