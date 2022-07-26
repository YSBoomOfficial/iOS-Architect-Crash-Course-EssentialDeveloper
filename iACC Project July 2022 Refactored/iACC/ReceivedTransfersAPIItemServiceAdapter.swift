//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct ReceivedTransfersAPIItemServiceAdapter: ItemService {
	let api: TransfersAPI
	let select: (Transfer) -> Void

	func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
		api.loadTransfers { result in
			DispatchQueue.mainAsyncIfNeeded {
				completion(
					result.map { items in
						items
							.filter { !$0.isSender }
							.map { item in
								ItemViewModel(transfer: item, longDateStyle: false) { select(item) }
							}
					}
				)
			}
		}
	}
}
